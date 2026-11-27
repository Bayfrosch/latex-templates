% Copyright (C) 2026 Bayfrosch.
% This file is part of Bay templates and may be distributed and/or modified
% under the LaTeX Project Public License, version 1.3c or (at your option)
% any later version. The complete work is listed in LICENSE.md.
% See LICENSE for the full license text.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{baysheet}[2026/11/11 Personal sheet class]

\newif\ifbay@linenumbers
\bay@linenumberstrue
\DeclareOption{linenumbers}{\bay@linenumberstrue}
\DeclareOption{nolinenumbers}{\bay@linenumbersfalse}
\PassOptionsToClass{a4paper,11pt,onecolumn}{article}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

\RequirePackage[left=20mm,right=20mm,top=27mm,bottom=20mm,
  headheight=15pt,headsep=5mm]{geometry}
\RequirePackage[skip=\baselineskip]{parskip}
\RequirePackage{baycontent}
\RequirePackage{amsmath}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage{hyperref}
\hypersetup{colorlinks=true,allcolors=blue}
\setlength{\columnsep}{12mm}

\newcommand{\bay@endtabular}{%
  \begingroup\nolinenumbers\par\endgroup}
\newcommand{\bay@unnumberedtabular}{%
  % Finish a standalone table's line without numbering it. Inline tables
  % stay in the surrounding paragraph.
  \ifLineNumbers
    \ifvmode\aftergroup\bay@endtabular\fi
  \fi
  \nolinenumbers}

\ifbay@linenumbers
  \RequirePackage{lineno}
  \renewcommand{\linenumberfont}{\normalfont\scriptsize\color{BayText!65!white}}
  \setlength{\linenumbersep}{3mm}
  \AtBeginDocument{\linenumbers}

  % Section titles are not prose; finish the preceding paragraph first.
  \AddToHook{cmd/@sect/before}{\nolinenumbers}
  \AddToHook{cmd/@sect/after}{\linenumbers}
  \AddToHook{cmd/@ssect/before}{\nolinenumbers}
  \AddToHook{cmd/@ssect/after}{\linenumbers}

  % The environment group restores numbering after each table.
  \AddToHook{env/table/begin}{\nolinenumbers}
  \AddToHook{env/table*/begin}{\nolinenumbers}
  \AddToHook{env/tabular/begin}{\bay@unnumberedtabular}
  \AddToHook{env/tabular*/begin}{\bay@unnumberedtabular}
  \AddToHook{env/tabularx/begin}{\bay@unnumberedtabular}
  \AddToHook{env/longtable/begin}{\par\nolinenumbers}

  % Box contents and their surrounding paragraphs are excluded from prose numbers.
  \newcommand{\bay@unnumberedbox}[1]{%
    \AddToHook{env/#1/before}[baysheet/lineno]{\par\nolinenumbers}%
    \AddToHook{env/#1/after}[baysheet/lineno]{\par\linenumbers}%
    \DeclareHookRule{env/#1/before}{baysheet/lineno}{before}{tcolorbox}%
    \DeclareHookRule{env/#1/after}{baysheet/lineno}{after}{tcolorbox}}
  \bay@unnumberedbox{definitionbox}
  \bay@unnumberedbox{examplebox}
  \bay@unnumberedbox{hintbox}
  \bay@unnumberedbox{solutionbox}
  \bay@unnumberedbox{codebox}
  \bay@unnumberedbox{java}
  \bay@unnumberedbox{haskell}
  \bay@unnumberedbox{python}
\fi

\newcommand{\sheetheader}[1]{\def\bay@sheetheader{#1}}
\sheetheader{\@title}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\small\color{BayText}\bay@sheetheader}
\fancyhead[R]{\small\color{BayText}\@author}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}
\fancypagestyle{plain}{\fancyhf{}\fancyfoot[C]{\thepage}%
  \renewcommand{\headrulewidth}{0pt}}

\renewcommand{\maketitle}{%
  \par\ifbay@linenumbers\nolinenumbers\fi
  \if@twocolumn
    \twocolumn[\bay@maketitle]%
  \else
    \bay@maketitle
  \fi
  \thispagestyle{plain}%
  \par\ifbay@linenumbers\linenumbers\fi}
\newcommand{\bay@maketitle}{%
  \noindent\begin{minipage}{\textwidth}
    \raggedright\color{BayText}
    {\color{BayPrimary}\rule{1.5cm}{3pt}\par}
    \vspace{1em}
    {\fontsize{28}{34}\selectfont\bfseries\@title\par}
    \vspace{1em}
    {\large\@author\par}
    \vspace{.4em}
    {\small\color{BayText!65!white}\@date\par}
    \vspace{2em}
  \end{minipage}\par}
