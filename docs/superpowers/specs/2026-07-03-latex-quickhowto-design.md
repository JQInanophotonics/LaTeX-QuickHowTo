# LaTeX-QuickHowTo — design

## Purpose

`LaTeX-QuickHowTo` is a new repo in the `JQInanophotonics` GitHub org: a zero-prior-experience,
tooling-focused prerequisite for LaTeX, in the same spirit as `QuickStartGit`. It teaches lab
members how to get a *working local LaTeX environment* — install, compile, and edit with
SyncTeX — not how to write a good paper or build Beamer slides.

## Scope

**In scope:**
- What LaTeX is, briefly (markup vs. WYSIWYG, compiled `.tex → .pdf` toolchain), and why the
  group uses it (reproducible papers, Beamer talks via `JqiNanoBeamerTemplate`).
- Installing a LaTeX distribution on macOS, Windows, and Linux, in full depth for all three.
- Compiling: engines (pdflatex vs. xelatex vs. lualatex), `latexmk`, and why the group's Beamer
  template specifically requires LuaLaTeX (it uses `fontspec`, confirmed via
  `beamerthemeJQInanophotonics.sty:13`, `\RequirePackage{fontspec}`).
- Bibliography compiling (bibtex/biblatex passes) and the group's citation-key convention:
  `<LastName><Journal><Year>` (e.g. `BraschScience2016`), generated automatically via Zotero +
  the Better BibTeX plugin (`auth+journal+year` citekey format).
- Editor setup: VS Code + LaTeX Workshop + a SyncTeX-capable PDF viewer per OS (Skim/macOS,
  Zathura or okular/Linux, SumatraPDF/Windows).
- Editor setup: Neovim — a distilled, copy-pasteable minimal config (vimtex + texlab LSP +
  SyncTeX + compiler switching for pdflatex/xelatex/lualatex), with a link to the user's full
  personal dotfiles (`github.com/gregmoille/nvim_config`) for anyone who wants the complete setup
  (custom folding, LuaSnip context-aware snippets, TeXpresso live preview) rather than
  reproducing all of it inline.
- A light syntax cheat-sheet page: minimal document skeleton, sections, `\cite`, figures/tables,
  math mode — enough to confirm a working environment compiles something real.
- A brief mention of Overleaf as a no-install alternative, pointing to `QuickStartGit`'s Overleaf
  page (git-sync) rather than re-covering it — no dedicated Overleaf page here.

**Explicitly out of scope:**
- Paper-writing craft/structure, citation practices as a discipline — deferred to a future
  `ScientificWriting` repo. That repo currently exists in the org but is empty/uninitialized;
  this repo does not become it and does not block on it.
- Beamer slide-building — already owned by `ScientificPresentations` and
  `JqiNanoBeamerTemplate`. This repo is a prerequisite to those (gets someone to "can compile
  LaTeX" so they can start `JqiNanoBeamerTemplate`), not a re-teaching of Beamer.
- No `Example-*.md` walkthrough page, unlike the org's usual pattern — the numbered pages
  themselves carry hands-on content (e.g., the compiling page walks through an actual compile).
  This is an intentional, explicit deviation per user request.

## Repo identity

- Repo name stays `LaTeX-QuickHowTo` (already registered in the org).
- README title: `# LaTeX Quick How-To`.
- Content subfolder: `LaTeX/` — topic name, not repo name, matching how `QuickStartGit` uses
  `Git/` and `ScientificPresentations` uses `Presentations/`.
- Role in the org: a `QuickStartGit`-style prerequisite. `ScientificPresentations` and the future
  `ScientificWriting` should eventually link back here for "get LaTeX compiling first," the same
  way they already link to `QuickStartGit` for Git — but editing those sibling repos is out of
  scope for this task unless requested separately.

## Pages (`LaTeX/00`–`06`)

| # | Page | Covers |
|---|------|--------|
| 00 | `WhatIsLatex.md` | Markup vs. WYSIWYG, why a compiled `.tex → .pdf` toolchain, why the group uses it, pointer to `QuickStartGit`'s Overleaf page as a no-install alternative |
| 01 | `Installing.md` | MacTeX (macOS), MiKTeX and TeX Live (Windows), TeX Live (Linux) — real install steps per OS, verifying the install (`pdflatex --version` etc.) |
| 02 | `Compiling.md` | Engines: pdflatex vs. xelatex vs. lualatex — why `fontspec` (used by `JqiNanoBeamerTemplate`) requires Lua/XeLaTeX; `latexmk`; reading a compile log for the first real error |
| 03 | `BibliographyAndCitations.md` | bibtex/biblatex compile passes (why 2-3 compiles); the citekey convention `<LastName><Journal><Year>`; Zotero + Better BibTeX setup (`auth+journal+year`) |
| 04 | `VSCodeSetup.md` | LaTeX Workshop extension, `latexmk`/lualatex settings, SyncTeX PDF viewer per OS, forward/inverse search |
| 05 | `NeovimSetup.md` | Distilled minimal config: vimtex + texlab (LSP) + SyncTeX + compiler switching. Link to `gregmoille/nvim_config` for the full personal setup |
| 06 | `SyntaxCheatSheet.md` | Minimal document skeleton, sections, `\cite`, figures/tables, math mode — light, not paper-writing craft |

## README structure

Follows the org's established pattern:

1. **Forewords** — zero prior experience assumed; tooling not paper-craft; `QuickStartGit` is a
   prerequisite only if syncing via Overleaf; future `ScientificWriting` and
   `ScientificPresentations` assume the reader already has a compiling LaTeX setup from here.
2. **Cheat sheet** — install-check commands, `latexmk -pdf`/`latexmk -lualatex file.tex`,
   `latexmk -c`, the citekey format, VS Code build/SyncTeX keybinds, Neovim vimtex leader
   mappings.
3. **Everyday workflow** — two arrow chains:
   - `edit .tex → compile → view PDF (SyncTeX jump) → fix errors from log → recompile`
   - `add source in Zotero → auto-generates citekey → \cite{key} in .tex → compile (pdflatex → bibtex → pdflatex ×2)`
4. **The rules, in one screen** — ~6-7 bold-led rules, each linking to its page, e.g. "Match the
   engine to the template" (lualatex for anything using `fontspec`) → 02; "Never hand-type a
   citekey" → 03; "SyncTeX both ways" → 04/05.
5. **Pages** — table as above.
6. **What's in this repo** — fenced tree diagram.
7. **See also** — `QuickStartGit` (Overleaf git-sync), `ScientificPresentations` /
   `JqiNanoBeamerTemplate` (once compiling works, here's how to build a talk), future
   `ScientificWriting`.

## Repo layout

```
LaTeX-QuickHowTo/
├── README.md
└── LaTeX/
    ├── 00-WhatIsLatex.md
    ├── 01-Installing.md
    ├── 02-Compiling.md
    ├── 03-BibliographyAndCitations.md
    ├── 04-VSCodeSetup.md
    ├── 05-NeovimSetup.md
    └── 06-SyntaxCheatSheet.md
```

No binary assets, matching `QuickStartGit`.
