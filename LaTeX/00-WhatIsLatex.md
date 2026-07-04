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
