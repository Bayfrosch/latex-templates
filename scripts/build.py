"""Build standalone LaTeX documents discovered in an input directory."""
import argparse
import os
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def document_class(source):
    # Preserve escaped characters while removing ordinary TeX comments.
    text = re.sub(r"\\[^\n]|%[^\n]*",
                  lambda match: '' if match[0].startswith('%') else match[0],
                  source.read_text(encoding='utf-8'))
    preamble = text.split(r'\begin{document}', 1)[0]
    match = re.search(r'\\documentclass\s*(?:\[[^\]]*\]\s*)?\{([^{}]+)\}',
                      preamble)
    if not match:
        if r'\documentclass' in preamble:
            raise ValueError(f'{source}: use a literal document class name')
        return None
    name = match[1].strip()
    if not re.fullmatch(r'[\w./-]+', name):
        raise ValueError(f'{source}: use a literal document class name')
    return name


def build(input_dir, output_dir, target):
    input_dir, output_dir = input_dir.resolve(), output_dir.resolve()
    if not input_dir.is_dir():
        raise ValueError(f'Input folder does not exist: {input_dir}')
    if input_dir == output_dir or input_dir.is_relative_to(output_dir):
        raise ValueError('Output folder must not equal or contain the input folder')

    jobs = []
    for source in sorted(input_dir.rglob('*.tex')):
        if source.is_relative_to(output_dir):
            continue
        cls = document_class(source)
        if cls is None:
            print(f'Skipping included content: {source}', flush=True)
            continue
        if cls == 'baybeamer':
            modes = ['animated', 'handout'] if target in ('all', 'presentation') else (
                [target] if target in ('animated', 'handout') else [])
        else:
            modes = [None] if target in ('all', 'documents') else []
        for mode in modes:
            jobs.append((source, mode, cls))

    if not jobs:
        raise ValueError(f'No documents matching target "{target}" in {input_dir}')

    env = os.environ.copy()
    env.setdefault('BAY_TEMPLATES', str(ROOT))
    # Resolve before changing to the source directory for relative images/inputs.
    env['BAY_TEMPLATES'] = str(Path(env['BAY_TEMPLATES']).resolve())
    # Keep LuaLaTeX's generated font cache with the build artifacts.
    cache = output_dir / '.tex-cache'
    cache.mkdir(parents=True, exist_ok=True)
    env.setdefault('TEXMFCACHE', str(cache))
    env.setdefault('TEXMFVAR', str(cache))
    for source, mode, cls in jobs:
        destination = output_dir / source.relative_to(input_dir).with_suffix('')
        destination.mkdir(parents=True, exist_ok=True)
        jobname = source.stem + (f'-{mode}' if mode else '')
        command = ['latexmk', '-norc', '-r', str(ROOT / '.latexmkrc'),
                   '-lualatex' if mode or cls == 'baysheet' else '-pdf',
                   '-interaction=nonstopmode', '-halt-on-error',
                   f'-outdir={destination}', f'-jobname={jobname}']
        if mode:
            command.append(r'-usepretex=\def\BayMode{' + mode +
                           r'}\PassOptionsToClass{' + mode + r'}{baybeamer}')
        command.append(source.name)
        print(f'Building {source} -> {destination / (jobname + ".pdf")}', flush=True)
        subprocess.run(command, cwd=source.parent, env=env, check=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--input', type=Path, default=Path('import'))
    parser.add_argument('--output', type=Path, default=Path('build'))
    parser.add_argument('--target', default='all',
                        choices=('all', 'presentation', 'animated', 'handout', 'documents'))
    args = parser.parse_args()
    try:
        build(args.input, args.output, args.target)
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        print(f'Build failed: {error}', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
