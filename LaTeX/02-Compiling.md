# 02 — Compiling

## Three engines

| Engine | Fonts | When to use |
|---|---|---|
| `pdflatex` | Computer Modern / Latin Modern + a fixed set of Type1 fonts | **Default — this is what papers use.** Anything that doesn't need custom system fonts |
| `xelatex` | Any system font, via `fontspec` | Documents needing Unicode text or a specific typeface |
| `lualatex` | Any system font, via `fontspec`, plus Lua scripting | **Only needed for the group's Beamer talks** — not for papers |

**Only Beamer talks need LuaLaTeX — papers don't.** [`JqiNanoBeamerTemplate`](https://github.com/JQInanophotonics/JqiNanoBeamerTemplate) loads `\RequirePackage{fontspec}` for its typography, and `fontspec` only works under `xelatex`/`lualatex`, never plain `pdflatex`. That requirement is specific to the Beamer template — nothing about paper writing needs it, so if you're drafting a paper, plain `pdflatex` (the default below) is almost always what you want. Only reach for `lualatex` when compiling a talk built from that template. If you're ever unsure whether a specific document needs it, check its preamble for `fontspec` — if it's there, use `lualatex`; if not, stick with `pdflatex`.

## Compiling with `latexmk`

Don't call `pdflatex`/`lualatex` directly — a real document needs multiple passes (for a table of contents, cross-references, and bibliographies to resolve), and `latexmk` figures out how many and reruns the right tools automatically:

```bash
latexmk -pdf file.tex          # engine: pdflatex — default, use this for papers
latexmk -lualatex file.tex     # engine: lualatex — only for JqiNanoBeamerTemplate Beamer talks
latexmk -xelatex file.tex      # engine: xelatex
```

Useful flags:
```bash
latexmk -pvc -pdf file.tex   # "preview continuously" — recompiles on every save
latexmk -c                   # delete aux/log files, keep the PDF
latexmk -C                   # delete aux/log files AND the PDF
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
