<!--
Copyright (C) 2026 Bayfrosch.
This file is part of Bay templates and may be distributed and/or modified
under the LaTeX Project Public License, version 1.3c or (at your option)
any later version. The complete work is listed in LICENSE.md.
See LICENSE for the full license text.
-->

# Bay templates
This repository provides latex classes which can be used as templates. At the moment there is one class for beamers and one for sheets.\
Both classes provide custom colorboxes for definitions, examples and hints. They extend the xlistings package for custom code blocks.\
`baybeamer` additionally provides automatic numeration and links in the footer for sections and the beamer format.\
`baysheet` provides a sheet layout.

## Preview

## Requirements
This repository uses a docker container to  build the pdf files. Therefore, the only required installation is Docker running with Linux containers enabled.

## Quick start
This repo provides two latex classes to use:
- baybeamer
- baysheet

Use `\documentclass{}` to select them in the .tex file.
To build them, open a terminal in the root folder of the repository and run:

```sh
docker compose run --rm latex
```

This builds every standalone document in `import/` into `build/`.

## Build PDFs

Start Docker Desktop with Linux containers enabled. From this folder, run:

```sh
docker compose run --rm latex
```

This builds every standalone document in `import/`. PDFs appear in
`build/docker/beamer/` and `build/docker/sheet/`. Container builds use a separate
folder so they do not reuse cached files from native MiKTeX builds.

The first run downloads the TeX Live image, which is several gigabytes.
Python, latexmk, LuaLaTeX, and the required TeX packages run inside the container.
You do not need a local Python or TeX installation.

To build only the handout, run:

```sh
docker compose run --rm latex --input import --output build/docker --target handout
```

Other targets are `all`, `presentation`, `animated`, and `documents`.
Input and output folders must be inside this repository. Use paths relative to
this folder in container commands.

If you have Make installed, `make` runs the same container build. On Windows,
use `mingw32-make.exe`. For example:

```sh
mingw32-make.exe handout
```

To build directly on the host, install Python 3.9+, latexmk, and a TeX
distribution with LuaLaTeX and the required packages, then run:

```sh
python3 scripts/build.py --input import --output build --target all
```
## Repository Structure
`import/` is the default folder which is selected to build the pdf files from\
`stylesheets/` is he folder where the templates are defined\
`build/` is an untracked folder where the resulting pdf are saved

## Customize your document
To declare the title, author and date in a document, use:

```latex
\title{Your title}
\author{Your name}
\date{\today}
```

For presentations, provide a shorter author name for the footer:

```latex
\author[Short name]{Your full name}
```

For sheets, set the running header with:

```latex
\sheetheader{Your header}
```

To change the sheet layout and choose from one or two columns, use:

```latex
\documentclass[onecolumn/twocolumn]{baysheet}
```

Use `definitionbox`, `examplebox`, `hintbox`, or `solutionbox`:

```latex
\begin{examplebox}{Your example title}
Your content goes here.
\end{examplebox}
```

### Code with terminal input and output

Use `codebox` with `plainhaskell`, `plainpython`, or `plainjava` for the code.
Add `terminal` inside the box to print commands and output below a divider:

```latex
\begin{codebox}{Haskell}
\begin{plainhaskell}
f x y = x + y
\end{plainhaskell}
\begin{terminal}
f 1 2
3
\end{terminal}
\end{codebox}
```

The argument `{Haskell}` sets the box title.\
Choose the matching `plain...` environment for syntax highlighting.\
In Beamer, put the box in a `\begin{frame}[fragile]` frame.\
Omit `terminal` for a code-only box.
Code lines are numbered. Each terminal line gets a `>` prefix automatically;
write the terminal text without adding the prefix yourself.

## License and credits

The original templates, theme, build scripts, and documentation are licensed
under the LaTeX Project Public License, version 1.3c or any later version.
Copyright (C) 2026 Bayfrosch.

Bundled third-party components retain their own licenses:

- **xlistings and code-link**, by Florian Sihler: LPPL 1.3c or later.
- **Fira Code**, by the Fira Code Project Authors: SIL Open Font License 1.1.

See [LICENSE.md](LICENSE.md) for license details and
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for sources and versions.
