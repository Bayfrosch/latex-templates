# Third-party software

## xlistings by Florian Sihler

- Upstream: https://github.com/EagleoutIce/xlistings
- Revision: `6e320bde355ef4e59788840eb6b5b1edf8d33c64`
- Package version: 1.1.1 (2026-11-11)
- Copyright (C) 2024–2026 Florian Sihler
- License: LaTeX Project Public License (LPPL), version 1.3c or later.
- Full license: [vendor/xlistings/LICENSE](vendor/xlistings/LICENSE)
- Upstream licensing statement: [xlistings.sty at the pinned revision](https://github.com/EagleoutIce/xlistings/blob/6e320bde355ef4e59788840eb6b5b1edf8d33c64/xlistings.sty).
- License reference: [LPPL version 1.3c](https://www.latex-project.org/lppl/lppl-1-3c/).

`vendor/xlistings/` is a complete, unmodified snapshot of the tracked upstream
repository at the revision above, including its language definitions, manuals,
tests, copyright notices, and license. Git history is not included. Local
presentation customization lives in `stylesheets/baybeamer.cls`; upstream
sources have not been changed. The bundled code-link package is not loaded.

When redistributing the bundled dependency, retain this notice and the complete
`vendor/xlistings/` directory, including its license and original notices.

### code-link bundled with xlistings

- Copyright (C) 2026 Florian Sihler
- License: LaTeX Project Public License (LPPL), version 1.3c or later.
- Full license: [vendor/xlistings/code-link/LICENSE](vendor/xlistings/code-link/LICENSE)
- Upstream licensing statement: [code-link.sty at the pinned revision](https://github.com/EagleoutIce/xlistings/blob/6e320bde355ef4e59788840eb6b5b1edf8d33c64/code-link.sty).

This separate package and its documentation are included in the same upstream
snapshot, even though the template does not load it. Preserve its original
copyright and licensing notices along with the rest of the snapshot.

## Fira Code

- Upstream: https://github.com/tonsky/FiraCode
- Release: 6.2, https://github.com/tonsky/FiraCode/releases/tag/6.2
- Copyright (c) 2014, The Fira Code Project Authors
- License: SIL Open Font License, version 1.1.
- Full license: [vendor/firacode/LICENSE](vendor/firacode/LICENSE)

`vendor/firacode/` contains the unmodified Regular and Bold TrueType fonts from
the official `Fira_Code_v6.2.zip` release, plus its matching upstream license.
Retain the license when redistributing the fonts. Fira Sans and Fira Mono come
from the TeX distribution's `fira` package and are not bundled here.

## TeX distribution dependencies

Beamer, tcolorbox, listings, and the other packages loaded by them or xlistings
are supplied by your TeX distribution, rather than copied into this repository.
Their licenses and notices remain in that distribution. This notice does not
relicense those packages or assign a license to the original template files.
