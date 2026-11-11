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
