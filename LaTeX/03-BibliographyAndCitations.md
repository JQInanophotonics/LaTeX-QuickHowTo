# 03 — Bibliography and citations

## Papers: use the journal's template as-is (usually REVTeX)

Group papers are written against a journal's own class — usually **REVTeX** (`revtex4-2`, for Physical Review/APS journals) or whatever class the target journal provides. **Don't touch the template's bibliography setup** — the class already defines the style; the one thing YOU add is the line pointing at your `.bib` file:

```latex
\documentclass[aps,prl,reprint]{revtex4-2}
...
\begin{document}
...
As shown by \cite{BraschScience2016}.
...
\bibliography{references}   % <- THIS is the line that points to references.bib. Add it, don't touch anything else.
\end{document}
```
`\bibliography{references}` (no `.bib` extension) goes near the end of the document, after your text and before `\end{document}` — that's it, that's the whole bibliography setup for a paper. `\cite{key}` anywhere in the text is what actually pulls each entry in; `\bibliography{...}` just tells the class which `.bib` file to pull from.

Under the hood this runs the classic `bibtex` tool, not `biblatex`/`biber` (see [02](02-Compiling.md) for the raw pdflatex → bibtex → pdflatex → pdflatex sequence). You don't run any of it by hand — recompile with `latexmk -pdf file.tex` and it detects `\bibliography{...}` and reruns `bibtex` automatically until everything settles.

## What a `.bib` entry looks like

```bibtex
@article{BraschScience2016,
  author  = {Brasch, Victor and Geiselmann, Michael and Herr, Tobias and Lihachev, Grigory
             and Pfeiffer, Martin H. P. and Gorodetsky, Michael L. and Kippenberg, Tobias J.},
  title   = {Photonic chip-based optical frequency comb using soliton Cherenkov radiation},
  journal = {Science},
  year    = {2016},
  volume  = {351},
  number  = {6271},
  pages   = {357--360},
}
```
Entry type (`@article`, `@inproceedings`, `@book`, ...) comes first, then the citekey (`BraschScience2016` — see below), then `field = {value}` pairs, comma-separated. You'll rarely type one of these by hand — Zotero + Better BibTeX (below) generates it straight from a DOI.

## Citation keys: `<LastName><Journal><Year>`

Every entry in the group's `.bib` files uses one convention: first author's last name, the journal (or its common abbreviation), and the year, concatenated with no separators or spaces:

```
BraschScience2016      % Brasch et al., Science, 2016
ZhangNatPhys2020       % Zhang et al., Nature Physics, 2020
```
This makes a citekey guessable from the paper itself — no separate lookup table to keep in sync, and no `\cite{some_random_string}` that means nothing six months later.

## Generating it automatically: Zotero + Better BibTeX

Typing citekeys and entries by hand invites typos and inconsistency. [Zotero](https://www.zotero.org) plus the [Better BibTeX](https://retorque.re/zotero-better-bibtex/) plugin generates both for you from a DOI:

1. Install Zotero, then install Better BibTeX from its [releases page](https://retorque.re/zotero-better-bibtex/installation/) (download the `.xpi`, drag it into Zotero, or use Zotero's plugin manager).
2. Open **Zotero → Settings → Better BibTeX → Citation Keys**, and set the **Citation Key Formula** to combine author, journal, and year — e.g. a formula built from `auth` + `journal` + `year` components. Better BibTeX's formula language changes syntax occasionally between versions, so build it in the live preview pane there and check the result against a known reference (it should produce `BraschScience2016` for that paper) before trusting it across your whole library.
3. Right-click your library or a collection → **Export Library/Collection** → format **Better BibTeX** (plain BibTeX output — this is the one that matches REVTeX/papers) → check **Keep updated** so the `.bib` file regenerates automatically as you add references.
4. Point your paper's `\bibliography{...}` at that exported `.bib` file.

Once set up, adding a paper to Zotero is the entire workflow — the citekey and `.bib` entry are generated for you, matching the convention above.

## Beamer talks: `biblatex` + `biber` instead

This is specific to slides, not papers. [`JqiNanoBeamerTemplate`](https://github.com/JQInanophotonics/JqiNanoBeamerTemplate) uses `biblatex` with the `biber` backend rather than plain `bibtex`:

```latex
\usepackage[backend=biber, style=numeric]{biblatex}
\addbibresource{references.bib}
...
\printbibliography
```
Same citekey convention, same "just recompile with `latexmk` until it stabilizes" habit — `latexmk` detects `\addbibresource` and reruns `biber` instead of `bibtex` automatically. If exporting from Zotero for a Beamer talk specifically, use the **Better BibLaTeX** format instead of **Better BibTeX** in step 3 above.

Next: [04 — VS Code setup](04-VSCodeSetup.md)
