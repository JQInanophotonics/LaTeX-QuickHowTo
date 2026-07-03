# LaTeX-QuickHowTo Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the `LaTeX-QuickHowTo` tutorial repo — a zero-prior-experience, tooling-only prerequisite covering LaTeX install, compiling, and editor setup (VS Code + Neovim), following the `JQInanophotonics` org's established README/page pattern.

**Architecture:** Static Markdown only, no build step. One README.md at the repo root plus seven numbered pages in `LaTeX/`. Each page is self-contained Markdown with a "Next:" link to the following page (except the last, which has none).

**Tech Stack:** Markdown only. Referenced tooling (not built by this plan, only documented): TeX Live/MacTeX/MiKTeX, `latexmk`, VS Code's LaTeX Workshop extension, Neovim's `vimtex`/`texlab`, Zotero + Better BibTeX.

## Global Constraints

- Repo name stays `LaTeX-QuickHowTo`; README title is `# LaTeX Quick How-To`.
- Content subfolder is `LaTeX/` (topic name, not repo name), matching `QuickStartGit`'s `Git/` and `ScientificPresentations`' `Presentations/`.
- No `Example-*.md` page — explicit deviation from the org's usual pattern, per user request.
- Scope is tooling only: install, compile, editor setup, and a light syntax cheat sheet. No paper-writing craft (deferred to future `ScientificWriting`) and no Beamer slide-building (owned by `ScientificPresentations`/`JqiNanoBeamerTemplate`).
- The group's Beamer template (`JqiNanoBeamerTemplate`) requires LuaLaTeX — it loads `\RequirePackage{fontspec}` (confirmed at `beamerthemeJQInanophotonics.sty:13`), which only works under XeLaTeX/LuaLaTeX, never plain `pdflatex`. Every page that mentions compiling must get this right.
- Citation key convention is exactly `<LastName><Journal><Year>` with no separators, e.g. `BraschScience2016`.
- Overleaf gets a brief mention only (in page 00), pointing to `QuickStartGit`'s Overleaf page — no dedicated page here.
- Neovim page ships a distilled minimal config, not the full personal config; it links to `github.com/gregmoille/nvim_config` for the complete version.

---

## Task 1: Page 00 — What is LaTeX, and why do we use it?

**Files:**
- Create: `LaTeX/00-WhatIsLatex.md`

**Interfaces:**
- Consumes: nothing (first content page).
- Produces: link target `LaTeX/00-WhatIsLatex.md`, consumed by `README.md` (Task 8) and as the "Next" target has none pointing back; `01-Installing.md` (Task 2) links here is not required, only forward.

- [ ] **Step 1: Write the page**

Create `LaTeX/00-WhatIsLatex.md` with exactly this content:

```markdown
# 00 — What is LaTeX, and why do we use it?

## Markup, not WYSIWYG

Word and Google Docs are **WYSIWYG** ("what you see is what you get"): you drag text around and the formatting happens live, but two documents that "look the same" can differ underneath in messy, unpredictable ways — and a co-author's Word changes a paragraph's spacing three points and now a whole section reflows.

LaTeX is **markup**: you write plain-text `.tex` files describing structure and content (`\section{Introduction}`, `\begin{equation}...\end{equation}`), and a separate step — **compiling** — turns that text into a finished PDF. You don't see the final layout while typing; you compile, look at the PDF, and iterate. In exchange you get:

- **Consistent typesetting** — LaTeX's algorithms (line-breaking, math spacing, figure placement) are the same every time, on every machine, so equations and figures don't drift between drafts.
- **Plain text that version-controls properly** — a `.tex` file diffs line-by-line in Git, the same way code does; a `.docx` doesn't. See [QuickStartGit](https://github.com/JQInanophotonics/QuickStartGit) if Git itself is new.
- **A PDF that looks identical everywhere** — no "it looked fine on my machine," since PDF is a fixed standard.

## The two things LaTeX does for the group

1. **Papers** — every manuscript is written as a `.tex` file (often synced through Overleaf; see below), and this repo gets you to the point where you can install and compile one.
2. **Slides** — talks are built in **Beamer**, LaTeX's presentation format, starting from [JqiNanoBeamerTemplate](https://github.com/JQInanophotonics/JqiNanoBeamerTemplate). This repo doesn't teach slide-building — see [ScientificPresentations](https://github.com/JQInanophotonics/ScientificPresentations) for that — but the template needs LuaLaTeX specifically to compile, which is exactly the kind of thing covered here (see [02 — Compiling](02-Compiling.md)).

## What this repo is (and isn't)

This is a **tooling** repo: installing LaTeX, compiling it, and setting up an editor with error highlighting and PDF preview. It is **not** a guide to writing a good paper (structure, argument, citation style) — that's a future `ScientificWriting` — and it's not a Beamer slide-building guide — that's `ScientificPresentations`. Read this repo first, then those.

## Don't want to install anything yet?

[Overleaf](https://www.overleaf.com) is a browser-based LaTeX editor — no local install, compiles in the cloud. It's a fine way to get started or to collaborate on a paper without everyone installing LaTeX locally. If you use it, it syncs to GitHub over Git — see [QuickStartGit — 06 Overleaf](https://github.com/JQInanophotonics/QuickStartGit/blob/main/Git/06-Overleaf.md) for that workflow. Everything from here on assumes you want a **local** setup instead (faster compiles, works offline, use your own editor).

Next: [01 — Installing LaTeX](01-Installing.md)
```

- [ ] **Step 2: Verify**

Run:
```bash
test -f LaTeX/00-WhatIsLatex.md && head -1 LaTeX/00-WhatIsLatex.md && grep -n "Next: \[01" LaTeX/00-WhatIsLatex.md
```
Expected: prints `# 00 — What is LaTeX, and why do we use it?` and a line containing `Next: [01 — Installing LaTeX](01-Installing.md)`.

- [ ] **Step 3: Commit**

```bash
git add LaTeX/00-WhatIsLatex.md
git commit -m "Add page 00 — What is LaTeX, and why do we use it?"
```

---

## Task 2: Page 01 — Installing LaTeX

**Files:**
- Create: `LaTeX/01-Installing.md`

**Interfaces:**
- Consumes: link back-reference from `00-WhatIsLatex.md` (Task 1, already written).
- Produces: link target `LaTeX/01-Installing.md`, consumed by `README.md` (Task 8).

- [ ] **Step 1: Write the page**

Create `LaTeX/01-Installing.md` with exactly this content:

```markdown
# 01 — Installing LaTeX

A LaTeX **distribution** bundles the compiler engines (`pdflatex`, `xelatex`, `lualatex`), `latexmk`, and thousands of packages. Install one before anything else works.

## macOS — MacTeX

```bash
brew install --cask mactex
```
This is the full distribution (~5–7 GB) — simplest choice, nothing to configure later. If disk space matters, `brew install --cask mactex-no-gui` skips the bundled GUI apps (TeXShop, etc. — you won't need them, see [04](04-VSCodeSetup.md)/[05](05-NeovimSetup.md)) but keeps every engine and package. Either way, restart your terminal after install so the new `PATH` takes effect.

## Windows — MiKTeX

Install [MiKTeX](https://miktex.org/download). Its default mode installs packages **on the fly** the first time a document needs them — nothing to pre-select. When prompted during first use, choose "Install missing packages automatically: Yes."

TeX Live (below) works identically on Windows too, if you'd rather have everything up front instead of on-demand installs.

## Linux — TeX Live

```bash
sudo apt install texlive-full      # Debian/Ubuntu — large but complete
sudo pacman -S texlive-most        # Arch
```
`texlive-full`/`texlive-most` avoids the "missing package" scavenger hunt later. If your distro's version is old, install the latest directly from [tug.org/texlive](https://tug.org/texlive/acquire-netinstall.html) instead.

## Verify the install

```bash
pdflatex --version
lualatex --version
latexmk --version
```
Each should print a version banner, not "command not found." `latexmk` ships with all three distributions above — if it's missing, your install is incomplete rather than needing a separate install.

Next: [02 — Compiling](02-Compiling.md)
```

- [ ] **Step 2: Verify**

Run:
```bash
test -f LaTeX/01-Installing.md && head -1 LaTeX/01-Installing.md && grep -n "Next: \[02" LaTeX/01-Installing.md
```
Expected: prints `# 01 — Installing LaTeX` and a line containing `Next: [02 — Compiling](02-Compiling.md)`.

- [ ] **Step 3: Commit**

```bash
git add LaTeX/01-Installing.md
git commit -m "Add page 01 — Installing LaTeX"
```

---

## Task 3: Page 02 — Compiling

**Files:**
- Create: `LaTeX/02-Compiling.md`

**Interfaces:**
- Consumes: nothing beyond prior page's forward link.
- Produces: link target `LaTeX/02-Compiling.md`, and the engine-choice fact ("use `lualatex` for anything with `fontspec`") that pages 03–06 and the README reference.

- [ ] **Step 1: Write the page**

Create `LaTeX/02-Compiling.md` with exactly this content:

```markdown
# 02 — Compiling

## Three engines

| Engine | Fonts | When to use |
|---|---|---|
| `pdflatex` | Computer Modern / Latin Modern + a fixed set of Type1 fonts | Default for plain text-heavy documents that don't need system/custom fonts |
| `xelatex` | Any system font, via `fontspec` | Documents needing Unicode text or a specific typeface |
| `lualatex` | Any system font, via `fontspec`, plus Lua scripting | Same font support as `xelatex`, more actively developed — the group's default for anything beyond a trivial pdflatex document |

**The group's Beamer template needs LuaLaTeX.** [`JqiNanoBeamerTemplate`](https://github.com/JQInanophotonics/JqiNanoBeamerTemplate) loads `\RequirePackage{fontspec}` for its typography — `fontspec` only works under `xelatex` or `lualatex`, never plain `pdflatex`. Compiling it with the wrong engine fails immediately with an error about `fontspec` requiring XeTeX or LuaTeX. If you're not sure which engine a document needs, check its preamble for `fontspec` — if it's there, use `lualatex`.

## Compiling with `latexmk`

Don't call `pdflatex`/`lualatex` directly — a real document needs multiple passes (for a table of contents, cross-references, and bibliographies to resolve), and `latexmk` figures out how many and reruns the right tools automatically:

```bash
latexmk -pdf file.tex          # engine: pdflatex
latexmk -lualatex file.tex     # engine: lualatex — use this for JqiNanoBeamerTemplate
latexmk -xelatex file.tex      # engine: xelatex
```

Useful flags:
```bash
latexmk -pvc -lualatex file.tex   # "preview continuously" — recompiles on every save
latexmk -c                        # delete aux/log files, keep the PDF
latexmk -C                        # delete aux/log files AND the PDF
```

## Reading a compile error

A failed compile prints to the terminal and to `file.log`. Search for a line starting with `!` — that's the actual error, everything before it is usually noise:

```
! Undefined control sequence.
l.12 \sectoin{Introduction}
                            
```
This reads as: line 12, `\sectoin` isn't a real command (typo for `\section`). The `l.<N>` line is your line number — jump straight there. Two other common ones:

- `! Missing $ inserted.` — math-mode syntax (`_`, `^`, Greek letters) used outside `$...$` or `\[...\]`.
- `! LaTeX Error: File 'somefigure.pdf' not found.` — a `\includegraphics` path is wrong or the file hasn't been added yet.

An editor with inline error highlighting ([04](04-VSCodeSetup.md), [05](05-NeovimSetup.md)) surfaces these without reading the raw log by hand.

Next: [03 — Bibliography and citations](03-BibliographyAndCitations.md)
```

- [ ] **Step 2: Verify**

Run:
```bash
test -f LaTeX/02-Compiling.md && head -1 LaTeX/02-Compiling.md && grep -n "Next: \[03" LaTeX/02-Compiling.md && grep -c "fontspec" LaTeX/02-Compiling.md
```
Expected: prints `# 02 — Compiling`, a line containing `Next: [03 — Bibliography and citations](03-BibliographyAndCitations.md)`, and a nonzero count for `fontspec`.

- [ ] **Step 3: Commit**

```bash
git add LaTeX/02-Compiling.md
git commit -m "Add page 02 — Compiling"
```

---

## Task 4: Page 03 — Bibliography and citations

**Files:**
- Create: `LaTeX/03-BibliographyAndCitations.md`

**Interfaces:**
- Consumes: engine/`latexmk` facts from `02-Compiling.md` (Task 3, already written).
- Produces: link target `LaTeX/03-BibliographyAndCitations.md` and the citekey convention (`<LastName><Journal><Year>`), referenced by page 06 (Task 7) and the README (Task 8).

- [ ] **Step 1: Write the page**

Create `LaTeX/03-BibliographyAndCitations.md` with exactly this content:

````markdown
# 03 — Bibliography and citations

## biblatex + biber (the modern default)

```latex
\usepackage[backend=biber, style=numeric]{biblatex}
\addbibresource{references.bib}
...
As shown in \cite{BraschScience2016}.
...
\printbibliography
```
Compiling needs an extra tool pass beyond the engine itself — `biber` reads `references.bib` and resolves every `\cite`. Full sequence: engine → biber → engine → engine (two more passes to settle numbering and cross-references). **Don't run this by hand** — `latexmk -lualatex file.tex` (see [02](02-Compiling.md)) detects the `\addbibresource` and reruns `biber` automatically; just recompile with `latexmk` until it stabilizes.

The older `\bibliography{...}` + `bibtex` combo still works and follows the same idea (engine → bibtex → engine → engine), but `biblatex`/`biber` is the modern, more capable version — use it for anything new.

## Citation keys: `<LastName><Journal><Year>`

Every entry in the group's `.bib` files uses one convention: first author's last name, the journal (or its common abbreviation), and the year, concatenated with no separators or spaces:

```
BraschScience2016      % Brasch et al., Science, 2016
ZhangNatPhys2020       % Zhang et al., Nature Physics, 2020
```
This makes a citekey guessable from the paper itself — no separate lookup table to keep in sync, and no `\cite{some_random_string}` that means nothing six months later.

## Generating it automatically: Zotero + Better BibTeX

Typing citekeys by hand invites typos and inconsistency. [Zotero](https://www.zotero.org) plus the [Better BibTeX](https://retorque.re/zotero-better-bibtex/) plugin generates them for you:

1. Install Zotero, then install Better BibTeX from its [releases page](https://retorque.re/zotero-better-bibtex/installation/) (download the `.xpi`, drag it into Zotero, or use Zotero's plugin manager).
2. Open **Zotero → Settings → Better BibTeX → Citation Keys**, and set the **Citation Key Formula** to combine author, journal, and year — e.g. a formula built from `auth` + `journal` + `year` components. Better BibTeX's formula language changes syntax occasionally between versions, so build it in the live preview pane there and check the result against a known reference (it should produce `BraschScience2016` for that paper) before trusting it across your whole library.
3. Right-click your library or a collection → **Export Library/Collection** → format **Better BibLaTeX** (or **Better BibTeX**) → check **Keep updated** so the `.bib` file regenerates automatically as you add references.
4. Point `\addbibresource{...}` at that exported `.bib` file.

Once set up, adding a paper to Zotero is the entire workflow — the citekey and `.bib` entry are generated for you, matching the convention above.

Next: [04 — VS Code setup](04-VSCodeSetup.md)
````

- [ ] **Step 2: Verify**

Run:
```bash
test -f LaTeX/03-BibliographyAndCitations.md && head -1 LaTeX/03-BibliographyAndCitations.md && grep -n "Next: \[04" LaTeX/03-BibliographyAndCitations.md && grep -c "BraschScience2016" LaTeX/03-BibliographyAndCitations.md
```
Expected: prints `# 03 — Bibliography and citations`, a line containing `Next: [04 — VS Code setup](04-VSCodeSetup.md)`, and a count ≥ 2 for `BraschScience2016`.

- [ ] **Step 3: Commit**

```bash
git add LaTeX/03-BibliographyAndCitations.md
git commit -m "Add page 03 — Bibliography and citations"
```

---

## Task 5: Page 04 — VS Code setup

**Files:**
- Create: `LaTeX/04-VSCodeSetup.md`

**Interfaces:**
- Consumes: LuaLaTeX/latexmk facts from `02-Compiling.md` (Task 3).
- Produces: link target `LaTeX/04-VSCodeSetup.md`, referenced by the README (Task 8).

- [ ] **Step 1: Write the page**

Create `LaTeX/04-VSCodeSetup.md` with exactly this content:

````markdown
# 04 — VS Code setup

## Install LaTeX Workshop

Install the **LaTeX Workshop** extension (`James-yu.latex-workshop`) from the VS Code Extensions panel. It handles compiling on save, inline error highlighting, autocomplete, and PDF preview with SyncTeX — no other extension needed.

## Set the default recipe to LuaLaTeX

By default LaTeX Workshop tries a generic `pdflatex` recipe, which fails on anything needing `fontspec` (see [02](02-Compiling.md)). Add this to your `settings.json` (workspace or user):

```json
{
  "latex-workshop.latex.tools": [
    {
      "name": "latexmk-lualatex",
      "command": "latexmk",
      "args": [
        "-lualatex",
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
        "%DOC%"
      ]
    }
  ],
  "latex-workshop.latex.recipes": [
    { "name": "latexmk (lualatex)", "tools": ["latexmk-lualatex"] }
  ]
}
```
Compiling then happens automatically on save (default), or manually via the green play button / `Ctrl+Alt+B` (`Cmd+Option+B` on macOS).

## PDF preview and SyncTeX

**Built-in viewer (default, zero config):** LaTeX Workshop opens the PDF in a VS Code tab. `Ctrl`/`Cmd`-click text in the `.tex` file to jump to that spot in the PDF (forward search); `Ctrl`/`Cmd`-click in the PDF to jump back to the source (inverse search). This works out of the box on every OS.

**External viewer, if you prefer a separate window** (nicer continuous scroll/zoom than a VS Code tab):

*macOS — Skim* (`brew install --cask skim`):
```json
{
  "latex-workshop.view.pdf.viewer": "external",
  "latex-workshop.view.pdf.external.viewer.command": "/Applications/Skim.app/Contents/SharedSupport/displayline",
  "latex-workshop.view.pdf.external.viewer.args": ["-r", "%LINE%", "%PDF%", "%TEX%"]
}
```
For inverse search (clicking in Skim to jump back to VS Code), set Skim's **Preferences → Sync** to use VS Code's `code` CLI with arguments `-g "%file":%line`.

*Linux — Zathura* (`sudo apt install zathura` / your package manager):
```json
{
  "latex-workshop.view.pdf.viewer": "external",
  "latex-workshop.view.pdf.external.viewer.command": "zathura",
  "latex-workshop.view.pdf.external.viewer.args": ["--synctex-forward", "%LINE%:1:%TEX%", "%PDF%"]
}
```
Zathura supports inverse search directly via its `synctex-editor-command` config option, pointed at `code -g %{input}:%{line}`.

*Windows — SumatraPDF* (comes bundled with MiKTeX, or [download separately](https://www.sumatrapdfreader.org/)):
```json
{
  "latex-workshop.view.pdf.viewer": "external",
  "latex-workshop.view.pdf.external.viewer.command": "SumatraPDF.exe",
  "latex-workshop.view.pdf.external.viewer.args": ["-reuse-instance", "-forward-search", "%TEX%", "%LINE%", "%PDF%"]
}
```
SumatraPDF's inverse search is set in its own **Settings → Options**, with the inverse-search command pointed at VS Code's `code -g "%f":%l`.

Next: [05 — Neovim setup](05-NeovimSetup.md)
````

- [ ] **Step 2: Verify**

Run:
```bash
test -f LaTeX/04-VSCodeSetup.md && head -1 LaTeX/04-VSCodeSetup.md && grep -n "Next: \[05" LaTeX/04-VSCodeSetup.md && grep -c "James-yu.latex-workshop" LaTeX/04-VSCodeSetup.md
```
Expected: prints `# 04 — VS Code setup`, a line containing `Next: [05 — Neovim setup](05-NeovimSetup.md)`, and a nonzero count for `James-yu.latex-workshop`.

- [ ] **Step 3: Commit**

```bash
git add LaTeX/04-VSCodeSetup.md
git commit -m "Add page 04 — VS Code setup"
```

---

## Task 6: Page 05 — Neovim setup

**Files:**
- Create: `LaTeX/05-NeovimSetup.md`

**Interfaces:**
- Consumes: LuaLaTeX/latexmk facts from `02-Compiling.md` (Task 3).
- Produces: link target `LaTeX/05-NeovimSetup.md`, referenced by the README (Task 8).

- [ ] **Step 1: Write the page**

Create `LaTeX/05-NeovimSetup.md` with exactly this content:

````markdown
# 05 — Neovim setup

VS Code ([04](04-VSCodeSetup.md)) is the easiest path. This page is for anyone who already lives in Neovim and wants the same compile/preview/error-highlighting loop there, via [vimtex](https://github.com/lervag/vimtex) (compiling + SyncTeX + folding) and [texlab](https://github.com/latex-lsp/texlab) (autocomplete, diagnostics, go-to-definition, via the Language Server Protocol).

## Install texlab

```bash
brew install texlab       # macOS
cargo install texlab      # any OS, via Rust's package manager
```
Linux/Windows package managers may also carry `texlab` directly (e.g. `pacman -S texlab` on Arch).

## Minimal config (lazy.nvim)

```lua
-- lua/plugins/latex.lua
return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- macOS: "skim" · Linux: "zathura" · Windows: "sumatrapdf"
      vim.g.vimtex_view_method = "skim"

      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-lualatex",             -- see 02-Compiling.md — matches JqiNanoBeamerTemplate
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ft = { "tex", "plaintex", "bib" },
    config = function()
      vim.lsp.config("texlab", {})
      vim.lsp.enable("texlab")
    end,
  },
}
```

This gives you: `fontspec`-aware LuaLaTeX compiling on save, SyncTeX forward/inverse search through Skim/Zathura/SumatraPDF, and texlab-powered autocomplete/diagnostics.

## Everyday keys (vimtex defaults, `<localleader>` = `\` unless you've remapped it)

| Keys | Action |
|---|---|
| `\ll` | Compile (starts continuous `latexmk -pvc`) |
| `\lv` | Forward search — jump to this line in the PDF viewer |
| `\lk` | Stop compilation |
| `\lc` | Clean aux files |
| `\le` | Show errors in the quickfix list |

Inverse search (clicking in the PDF to jump back into Neovim) needs the viewer pointed at a running Neovim instance — the exact command depends on your vimtex version, so run `:help vimtex-view-skim` (or `-zathura`/`-sumatrapdf`) inside Neovim for the current syntax rather than copying a possibly-stale one from here.

## Want the full setup?

This is a deliberately minimal starting point. The author's actual config adds custom section folding, context-aware math/text snippets, and [TeXpresso](https://github.com/let-def/texpresso) live preview — see [gregmoille/nvim_config](https://github.com/gregmoille/nvim_config) (`lua/plugins/vimtex.lua`, `lua/plugins/texlab.lua`, `snippets/tex.lua`) for the complete version.

Next: [06 — Syntax cheat sheet](06-SyntaxCheatSheet.md)
````

- [ ] **Step 2: Verify**

Run:
```bash
test -f LaTeX/05-NeovimSetup.md && head -1 LaTeX/05-NeovimSetup.md && grep -n "Next: \[06" LaTeX/05-NeovimSetup.md && grep -c "gregmoille/nvim_config" LaTeX/05-NeovimSetup.md
```
Expected: prints `# 05 — Neovim setup`, a line containing `Next: [06 — Syntax cheat sheet](06-SyntaxCheatSheet.md)`, and a nonzero count for `gregmoille/nvim_config`.

- [ ] **Step 3: Commit**

```bash
git add LaTeX/05-NeovimSetup.md
git commit -m "Add page 05 — Neovim setup"
```

---

## Task 7: Page 06 — Syntax cheat sheet

**Files:**
- Create: `LaTeX/06-SyntaxCheatSheet.md`

**Interfaces:**
- Consumes: `latexmk -lualatex` command from `02-Compiling.md` (Task 3) and the `BraschScience2016` citekey example from `03-BibliographyAndCitations.md` (Task 4).
- Produces: link target `LaTeX/06-SyntaxCheatSheet.md`, the last content page (no "Next:" link), referenced by the README (Task 8).

- [ ] **Step 1: Write the page**

Create `LaTeX/06-SyntaxCheatSheet.md` with exactly this content:

````markdown
# 06 — Syntax cheat sheet

Just enough syntax to write a real document and confirm your setup ([01](01-Installing.md)–[05](05-NeovimSetup.md)) actually works — not a guide to writing a good paper (that's a future `ScientificWriting`).

## A minimal document

```latex
\documentclass{article}
\usepackage[backend=biber]{biblatex}
\addbibresource{references.bib}
\usepackage{graphicx}

\title{A Minimal Document}
\author{Your Name}

\begin{document}
\maketitle

\section{Introduction}
Plain text goes here. Inline math: $E = mc^2$. Display math:
\[
  \nabla \times \mathbf{B} = \mu_0 \mathbf{J} + \mu_0 \varepsilon_0 \frac{\partial \mathbf{E}}{\partial t}
\]

\subsection{A subsection}
\begin{itemize}
  \item First point
  \item Second point
\end{itemize}

As shown by \cite{BraschScience2016}.

\begin{figure}[t]
  \centering
  \includegraphics[width=0.6\linewidth]{figure1.pdf}
  \caption{A figure.}
  \label{fig:example}
\end{figure}

\printbibliography
\end{document}
```
Compile with `latexmk -lualatex file.tex` ([02](02-Compiling.md)) — this needs `references.bib` with a `BraschScience2016` entry to resolve the citation ([03](03-BibliographyAndCitations.md)); delete the bibliography lines to compile without one.

## Quick reference

| Syntax | Does |
|---|---|
| `\section{...}` / `\subsection{...}` | Numbered headings |
| `$...$` | Inline math |
| `\[...\]` | Display (centered, own line) math |
| `\begin{itemize}...\end{itemize}` | Bulleted list (`\begin{enumerate}` for numbered) |
| `\includegraphics[width=...]{file}` | Insert a figure (PDF/PNG/JPG) |
| `\cite{key}` | Citation, key format per [03](03-BibliographyAndCitations.md) |
| `\label{...}` / `\ref{...}` | Tag something, then refer to it by number elsewhere |
| `%` | Comment — rest of the line is ignored |
````

- [ ] **Step 2: Verify**

Run:
```bash
test -f LaTeX/06-SyntaxCheatSheet.md && head -1 LaTeX/06-SyntaxCheatSheet.md && grep -c "BraschScience2016" LaTeX/06-SyntaxCheatSheet.md
```
Expected: prints `# 06 — Syntax cheat sheet` and a nonzero count for `BraschScience2016`.

- [ ] **Step 3: Commit**

```bash
git add LaTeX/06-SyntaxCheatSheet.md
git commit -m "Add page 06 — Syntax cheat sheet"
```

---

## Task 8: README.md

**Files:**
- Create: `README.md`

**Interfaces:**
- Consumes: all seven page files and their headings/link targets (Tasks 1–7, all already written).
- Produces: the repo's entry point; no downstream task consumes it.

- [ ] **Step 1: Write the README**

Create `README.md` with exactly this content:

```markdown
# LaTeX Quick How-To

## Forewords

Every paper the group writes and every talk built in [JqiNanoBeamerTemplate](https://github.com/JQInanophotonics/JqiNanoBeamerTemplate) is LaTeX underneath. This repo assumes **zero prior LaTeX experience** and gets you to a working local setup: install a distribution, compile a document, and get an editor wired up with error highlighting and PDF preview. It does not teach you to write a good paper (structure, argument — that's a future `ScientificWriting`) or to build a good talk (that's [ScientificPresentations](https://github.com/JQInanophotonics/ScientificPresentations)) — both of those assume you can already do what's in this repo. If you'll sync a paper through Overleaf's Git integration, [QuickStartGit](https://github.com/JQInanophotonics/QuickStartGit) is the prerequisite for that part; Git itself isn't otherwise needed here.

Read the pages in order the first time — each builds on the last; use them, and the rules below, as a checklist afterwards — same spirit as [ScientificDataManagement](https://github.com/JQInanophotonics/ScientificDataManagement).

## Cheat sheet

| Command | What it does |
|---|---|
| `pdflatex --version` | Confirm a LaTeX distribution is installed |
| `latexmk -lualatex file.tex` | Compile with LuaLaTeX (needed for `fontspec`, incl. the group's Beamer template) |
| `latexmk -pdf file.tex` | Compile with plain pdflatex |
| `latexmk -pvc -lualatex file.tex` | Recompile automatically on every save |
| `latexmk -c` | Delete aux/log files, keep the PDF |
| `\cite{BraschScience2016}` | Citation — key format is `<LastName><Journal><Year>` |
| `Cmd`/`Ctrl`-click (VS Code PDF tab) | Jump between source and PDF (SyncTeX) |
| `\ll` / `\lv` (Neovim, vimtex) | Compile / forward-search to PDF |

## Everyday workflow

**Writing:**
```
edit .tex → save (auto-compiles) → check PDF preview → fix errors from the log → repeat
```

**Adding a reference:**
```
add the paper in Zotero → Better BibTeX generates the citekey → \cite{key} in the .tex → recompile
```

## The rules, in one screen

1. **LaTeX is markup, not WYSIWYG** — you write plain text, then compile it to PDF. See [00](LaTeX/00-WhatIsLatex.md).
2. **Install a full distribution once per machine** — MacTeX/MiKTeX/TeX Live. See [01](LaTeX/01-Installing.md).
3. **Match the engine to the document.** Anything using `fontspec` — including the group's Beamer template — needs `lualatex`, not plain `pdflatex`. See [02](LaTeX/02-Compiling.md).
4. **Always compile through `latexmk`**, never call the engine directly — it reruns the right passes for you (bibliography, cross-references). See [02](LaTeX/02-Compiling.md).
5. **Never hand-type a citekey.** Let Zotero + Better BibTeX generate `<LastName><Journal><Year>` for you. See [03](LaTeX/03-BibliographyAndCitations.md).
6. **VS Code + LaTeX Workshop is the easiest path** — one extension, SyncTeX built in. See [04](LaTeX/04-VSCodeSetup.md).
7. **Neovim works too**, via `vimtex` + `texlab`, if that's where you already live. See [05](LaTeX/05-NeovimSetup.md).

## Pages

| Page | What it covers |
|------|-----------------|
| [00 — What is LaTeX, and why do we use it?](LaTeX/00-WhatIsLatex.md) | Markup vs. WYSIWYG, why the group uses it, Overleaf as a no-install alternative |
| [01 — Installing LaTeX](LaTeX/01-Installing.md) | MacTeX, MiKTeX, TeX Live — per OS, verifying the install |
| [02 — Compiling](LaTeX/02-Compiling.md) | pdflatex vs. xelatex vs. lualatex, `latexmk`, reading a compile error |
| [03 — Bibliography and citations](LaTeX/03-BibliographyAndCitations.md) | biblatex/biber, the citekey convention, Zotero + Better BibTeX |
| [04 — VS Code setup](LaTeX/04-VSCodeSetup.md) | LaTeX Workshop, SyncTeX (built-in tab viewer, or Skim/Zathura/SumatraPDF) |
| [05 — Neovim setup](LaTeX/05-NeovimSetup.md) | vimtex + texlab, minimal config, link to the full personal dotfiles |
| [06 — Syntax cheat sheet](LaTeX/06-SyntaxCheatSheet.md) | A minimal working document and the syntax to test your setup |

## What's in this repo

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

No binary assets live here — same as [QuickStartGit](https://github.com/JQInanophotonics/QuickStartGit).

## See also

Prerequisite for [ScientificPresentations](https://github.com/JQInanophotonics/ScientificPresentations) (build a talk in [JqiNanoBeamerTemplate](https://github.com/JQInanophotonics/JqiNanoBeamerTemplate) once you can compile) and for the future `ScientificWriting` (paper composition and citation practices). If you'll sync a paper through Overleaf, see [QuickStartGit](https://github.com/JQInanophotonics/QuickStartGit) for the Git side of that.
```

- [ ] **Step 2: Verify**

Run:
```bash
test -f README.md && head -1 README.md && grep -c "LaTeX/0" README.md
```
Expected: prints `# LaTeX Quick How-To` and a count of 7+ for `LaTeX/0` (one link per page, several pages linked twice — cheat sheet reference is a plain command, not a link, so the count comes from the Pages table and Rules section).

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "Add README"
```

---

## Task 9: Full-repo link audit

**Files:**
- None created or modified — verification only.

**Interfaces:**
- Consumes: every file from Tasks 1–8.
- Produces: nothing; this is the final gate confirming the whole repo is internally consistent.

- [ ] **Step 1: Check every relative Markdown link resolves**

Run from the repo root:
```bash
grep -ohE '\]\(([A-Za-z0-9_./-]+\.md)[^)]*\)' -r --include='*.md' . \
  | sed -E 's/.*\(([^)#]+).*/\1/' \
  | sort -u \
  | while read -r f; do [ -f "$f" ] || echo "MISSING: $f"; done
```
Expected: no output (every linked `.md` file exists). This only checks paths relative to the repo root — links like `01-Installing.md` written from inside `LaTeX/00-WhatIsLatex.md` resolve relative to that file's own directory, so also spot-check from within `LaTeX/`:
```bash
cd LaTeX && grep -ohE '\]\(([A-Za-z0-9_./-]+\.md)[^)]*\)' *.md \
  | sed -E 's/.*\(([^)#]+).*/\1/' \
  | sort -u \
  | while read -r f; do [ -f "$f" ] || echo "MISSING: $f"; done
cd ..
```
Expected: no output.

- [ ] **Step 2: Confirm the page chain is unbroken**

Run:
```bash
for f in LaTeX/00-WhatIsLatex.md LaTeX/01-Installing.md LaTeX/02-Compiling.md LaTeX/03-BibliographyAndCitations.md LaTeX/04-VSCodeSetup.md LaTeX/05-NeovimSetup.md; do
  grep -q "^Next: \[" "$f" || echo "NO NEXT LINK: $f"
done
```
Expected: no output (pages 00–05 each have a "Next:" line; 06 is intentionally last and excluded from this loop).

- [ ] **Step 3: Confirm the README tree matches the actual files**

Run:
```bash
diff <(find LaTeX -name '*.md' | sort) <(printf 'LaTeX/00-WhatIsLatex.md\nLaTeX/01-Installing.md\nLaTeX/02-Compiling.md\nLaTeX/03-BibliographyAndCitations.md\nLaTeX/04-VSCodeSetup.md\nLaTeX/05-NeovimSetup.md\nLaTeX/06-SyntaxCheatSheet.md\n' | sort)
```
Expected: no output (the two lists are identical).

- [ ] **Step 4: Final status check**

Run:
```bash
git status
```
Expected: `nothing to commit, working tree clean` — every task already committed its own file, so this task adds no new commit, only confirms the repo is in a consistent, fully-linked state.
