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
