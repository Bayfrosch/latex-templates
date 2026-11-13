% Copyright (C) 2026 Bayfrosch.
% This file is part of Bay templates and may be distributed and/or modified
% under the LaTeX Project Public License, version 1.3c or (at your option)
% any later version. The complete work is listed in LICENSE.md.
% See LICENSE for the full license text.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{baybeamer}[2026/11/11 Personal presentation class]

\newif\ifbay@animated
\newif\ifbay@handout
\PassOptionsToClass{aspectratio=169}{beamer}
\DeclareOption{animated}{\bay@animatedtrue}
\DeclareOption{handout}{\bay@handouttrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\ifbay@animated
  \ifbay@handout
    \ClassError{baybeamer}{Options animated and handout are mutually exclusive}
      {Select animated for overlays or handout for printable slides.}
  \fi
\fi
\ifbay@handout
  \PassOptionsToClass{handout}{beamer}
\fi
\LoadClass{beamer}
\usefonttheme{professionalfonts}
\usetheme{Bay}
\RequirePackage{baycontent}
