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
