# latex-templates
This repository includes a latex package with templates.

## Personal Beamer class

`baybeamer.cls` extends Beamer with a 16:9 layout, the Bay theme, Java/Haskell/Python
listings from Florian Sihler's **xlistings**, and four kinds of colored boxes.

```text
stylesheets/baybeamer.cls       Class: options, packages, code, and boxes
stylesheets/beamerthemeBay.sty  Theme: colors and slide furniture
import/beamer.tex           Complete presentation: metadata and all slides
Makefile                       Selects the input folder and build target
scripts/build.py               Discovers documents and invokes latexmk
vendor/xlistings/              Unmodified upstream package and license
vendor/firacode/               Fira Code Regular/Bold fonts and license
THIRD_PARTY_NOTICES.md         Attribution and pinned source revision
```

## Build a folder of documents

Requirements: Python 3.9+, Make, latexmk, and a TeX installation with LuaLaTeX,
fontspec, Fira Sans/Mono (`fira`), Beamer, tcolorbox, listings, listingsutf8, and
lstautogobble. On Debian/Ubuntu, install `texlive-luatex`, `texlive-latex-extra`,
and `texlive-fonts-extra` alongside `latexmk`. The LuaLaTeX binary alone is not
enough: its `luaotfload` font loader must also be installed. xlistings and Fira
Code are bundled. No external syntax highlighter or shell escape is needed.

Put your standalone `.tex` documents in `import/`, or choose another folder:

```sh
make                                      # Build everything in import/
make INPUT_DIR=/path/to/my-documents       # Build an external folder
make INPUT_DIR="/path/with spaces" OUTDIR=build/my-project
```

Run these commands from this repository's root. The input folder is scanned
recursively. Class names are read from literal `\documentclass` declarations:

- `baybeamer`: build animated and handout versions using LuaLaTeX.
- All other classes (such as `article`, `report`, or a future custom article
  class): compile once using the selected class and pdfLaTeX.
- `.tex` files without `\documentclass`: skip as included content.

Class detection handles ordinary comments and multiline declarations. It does
not evaluate TeX macros or conditionals; use one literal class declaration in
each standalone source. Custom presentation classes other than `baybeamer`
currently follow the single-PDF rule.

Choose a subset using these targets:

| Command | Builds |
| --- | --- |
| `make` | All documents and both presentation modes |
| `make presentation` | Both modes of all baybeamer presentations |
| `make animated` | Only animated presentations |
| `make handout` | Only presentation handouts |
| `make documents` | Only documents using other classes |

Every target accepts `INPUT_DIR` and `OUTDIR`. A missing folder, no matching
standalone documents, or a LaTeX failure causes the command to fail, including
in CI. The output directory is excluded from discovery if it is inside the
input folder.

Outputs are grouped by source path, so documents with the same filename in
different subfolders cannot overwrite each other:

```text
import/beamer.tex          -> build/beamer/beamer-animated.pdf
                          -> build/beamer/beamer-handout.pdf
import/report.tex         -> build/report/report.pdf
import/course/report.tex  -> build/course/report/report.pdf
```

The included presentation is `import/beamer.tex`; edit it or add more sources.
Each document is compiled from its own folder so relative images, bibliography
files, and `\input` paths work. The builder loads this repository's `.latexmkrc`
explicitly and supplies absolute template search paths; source-folder latexmk
configuration files are not loaded. Existing outputs are retained, and latexmk
checks whether they need rebuilding.

Without Make, use the same builder directly:

```sh
python3 scripts/build.py --input /path/to/my-documents --output build --target all
```

In GitHub Actions, check out this repository and run the same `make` command,
pointing `INPUT_DIR` at the checked-out document folder. Upload `build/**/*.pdf`
as the PDF artifacts.

## Class flags

```latex
\providecommand{\BayMode}{animated} % Default when compiled directly
\documentclass[\BayMode]{baybeamer}
```

For baybeamer sources, the builder defines `\BayMode` and passes the matching
class option before LaTeX reads
the file. `\providecommand` keeps that choice, or supplies the default for direct
compilation. There is no need to edit the source between builds.

For automatic dual builds, use the `\BayMode` pattern above or simply
`\documentclass{baybeamer}`. A hardcoded `[animated]` or `[handout]` option
conflicts with the opposite build; reserve those fixed flags for manual builds.
The two flags are mutually exclusive; using both raises an error. Other options
are forwarded to Beamer, e.g. `[animated,aspectratio=43,11pt]`.
Animated means Beamer overlays, not timed video or automatic transitions.
Use `\pause`, `\uncover<2->{...}`, or `\begin{itemize}[<+->]` to reveal content.
The handout includes all ordinary overlay steps **and solutions**, one frame
per page; it is not a version with answers hidden. For content alternatives,
use Beamer's explicit handout specifications to avoid overlapping alternatives:

```latex
\only<1|handout:0>{First explanation}
\only<2|handout:1>{Final explanation}
```

## Fonts

Fira Sans is the default text font. Listings use the bundled Fira Code, while
regular monospace text uses Fira Mono:

```latex
Normal text uses Fira Sans.
\texttt{Inline identifiers use Fira Mono.}
{\BayCodeFont Inline text explicitly using Fira Code.}
```

`make` selects LuaLaTeX automatically for `baybeamer`; select LuaLaTeX explicitly
in an editor or when using latexmk directly. Math keeps Beamer's math fonts.
Fira Code's italic styles are synthesized from the regular/bold fonts because
the upstream family has no italic files. Listing rendering is still controlled
by xlistings; selecting the font does not promise editor-style code ligatures.
Generated LuaLaTeX font caches are stored under the output folder's `.tex-cache/`.

## Title page

The title page uses a large, bold, left-aligned title with a short coral accent
line and generous whitespace. The author and a smaller, muted date sit below.
It displays only the title, author, and date:

```latex
\title{Programming with clarity}
\author[Short name]{Your full name}
\date{\today}

\begin{document}
\begin{frame}[plain]
  \titlepage
\end{frame}
```

## Sections, slide headers, and footer

Set the author in your `.tex` file using `\author{Your name}`. To show a shorter
name in the footer, use `\author[Short name]{Full name}`.

Sections organize navigation without adding section slides or section headings.
The current subsection supplies a text-only header (no background box) on every
non-plain frame, prefixed with its section and subsection number (e.g. `1.1`).
The number uses the light blue `BayNumber` (`#7DB7DC`) defined in
`stylesheets/beamerthemeBay.sty`:

```latex
\section[Basics]{Programming fundamentals}
\subsection{Pure functions}
\begin{frame}
  Same input, same output, no observable side effects.
\end{frame}

\subsection{Python example}
\begin{frame}[fragile]
\begin{python}
def square(x):
    return x * x
\end{python}
\end{frame}
```

Several frames can share a subsection. Its name takes precedence over an explicit
frame title; before any subsection is selected, an explicit frame title still
works. A new section clears the previous subsection. `[plain]` frames, such as
the title page, omit the header/footer layout.

`itemize` uses small, flat charcoal dots at every nesting level. `enumerate`
uses plain numbers in the same `BayNumber` light blue as the subsection headers.
Both list environments support Beamer overlays such as `[<+->]`.

The footer spans the full page width, has square corners, and sits flush with
the bottom edge. It uses the primary color `#E06666`, with the
author on the left and closely spaced, clickable section numbers and names on
the right (e.g. `1. Concepts`).
Section links have fixed `1.25em` gaps instead of stretching across the footer.
Footer text is 12pt with 1.5mm vertical padding, approximately 1.5 times the
previous size.
The current section
uses white `BaySelectedText` (`#FFFFFF`) to match the slide background, without a separate
background highlight or font-weight change. Links go to the first slide of
each section in either build mode. Use short section names via
`\section[Short name]{Full section name}` to keep the horizontal navigation compact.
Beamer navigation is scoped to the current part if you use `\part`.
`latexmk` performs the extra compilation passes needed to resolve the links.

## Code listings

Frames containing literal code must have the `fragile` option. Use the
`java`, `haskell`, or `python` environment provided by xlistings:

```latex
\begin{frame}[fragile]{Python example}
\begin{python}
def square(x):
    return x * x
\end{python}
\end{frame}
```

Use `\begin{java} ... \end{java}` and `\begin{haskell} ... \end{haskell}` the
same way. Optional listings keys work, e.g. `\begin{python}[numbers=none]`.
Each listing has a language header (`Code: Java`, `Code: Haskell`, or
`Code: Python`) and the same rounded box shape as the other colored boxes.
The header and outline use gray `BayCode` (`#B6B6B6`); the body uses
`BayCodeLight` (`#E7E7E7`). Syntax colors are independent of these box colors.
Type keywords such as `int` and `float` use `BayCodeType` (`#5CF708`).
Other keywords use the original red (`BayPrimary!65!black`), with bold primary keywords.
Numeric values and their prefixes use the lighter red `BayPrimary` (`#E06666`).
Variable and function names are black. Strings and italic comments use darker
purple shades; line numbers use dark gray. The base colors are defined in the theme `.sty`.
These environments are verbatim: keep their closing commands on separate lines.
See `import/beamer.tex` for complete examples of all three languages.

## Colored boxes

Each box accepts a required title and optional tcolorbox settings:

```latex
\begin{definitionbox}{Pure function}
  Same input, same output, no observable side effects.
\end{definitionbox}

\begin{examplebox}{Square}
  $f(4)=16$.
\end{examplebox}

\begin{hintbox}{First step}
  Multiply the input by itself.
\end{hintbox}

\pause
\begin{solutionbox}{Worked answer}
  $4\cdot4=16$.
\end{solutionbox}
```

The palette is defined centrally in `stylesheets/beamerthemeBay.sty`:

| Element | Outline and header fill | Body fill |
| --- | --- | --- |
| Definitions | `#E06666` (primary) | `#EA9999` (accent) |
| Hints | `#FFD22E` | `#FFE599` |
| Solutions | `#6AA84F` | `#B6D7A8` |
| Examples | `#2EA8FF` | `#B8E1FF` |

These are the base colors. To soften the boxes, their outlines and headers mix
80% of the darker color with 20% gray; bodies mix 80% of the lighter color with
20% light gray. Box text is black. Slide headers are charcoal text on the
white slide, with no background box. The footer uses the exact primary color.
Code highlighting uses darker tints of the palette for small text.
For example, `\begin{hintbox}[colback=yellow!10]{Remember}` overrides one box's
body background.
Boxes must fit on the slide; split longer content into multiple frames.

## Use in another project

Copy `stylesheets/`, `vendor/`, and `THIRD_PARTY_NOTICES.md` into your
project. Add these paths to that project's `.latexmkrc`:

```perl
$ENV{'TEXINPUTS'} = './stylesheets//:./vendor/xlistings//:' . ($ENV{'TEXINPUTS'} // '');
$ENV{'TTFONTS'} = './vendor/firacode//:' . ($ENV{'TTFONTS'} // '');
$pdf_mode = 4; # LuaLaTeX
```

Then use `\documentclass[animated]{baybeamer}` (or `[handout]`) in your main
`.tex` file. Compile with LuaLaTeX from that project's root. The trailing colon preserves
TeX's standard search paths. With editors or Overleaf, ensure their build uses
these same paths. Alternatively install the class, theme, and xlistings into
your personal TeX tree; locate it with `kpsewhich -var-value=TEXMFHOME`.

## Credits and licenses

See [LICENSE.md](LICENSE.md) for the scope of the bundled third-party licenses.

Florian Sihler's [xlistings](https://github.com/EagleoutIce/xlistings) is included
under **LPPL 1.3c or later**, with its full upstream license and original notices.
See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the exact revision and
redistribution details. Customizations live in our class, not upstream files.

## Check the template

With Python 3 and Poppler's `pdftotext`, `pdftohtml`, and `pdffonts` installed, run:

```sh
python3 tests/check_template.py
```

This checks discovery of mixed classes in an external folder, nested filenames,
relative inputs, target selection, missing folders, both presentation modes,
solution visibility, page counts, subsection headers, author footer, clickable
section destinations, embedded Fira fonts in both PDFs, and conflicting class flags.
