# 06 — Syntax cheat sheet

Just enough syntax to write a real document and confirm your setup ([01](01-Installing.md)–[05](05-NeovimSetup.md)) actually works — not a guide to writing a good paper (that's a future `ScientificWriting`).

## A minimal document

```latex
\documentclass{article}
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

\bibliographystyle{plain}
\bibliography{references}
\end{document}
```
Compile with `latexmk -pdf file.tex` — plain `pdflatex` is all this needs (no `fontspec`, so no LuaLaTeX; see [02](02-Compiling.md)). This uses classic BibTeX (`\bibliography{references}` pulls in `references.bib`), the same system REVTeX-based papers use — see [03](03-BibliographyAndCitations.md) for the `.bib` entry format and citekey convention. It needs a `references.bib` with a `BraschScience2016` entry to resolve the citation; delete the two `\bibliography...` lines to compile without one.

## Quick reference

| Syntax | Does |
|---|---|
| `\section{...}` / `\subsection{...}` | Numbered headings |
| `$...$` | Inline math |
| `\[...\]` | Display (centered, own line) math |
| `\begin{itemize}...\end{itemize}` | Bulleted list (`\begin{enumerate}` for numbered) |
| `\includegraphics[width=...]{file}` | Insert a figure (PDF/PNG/JPG) |
| `\cite{key}` | Citation, key format per [03](03-BibliographyAndCitations.md) |
| `\bibliographystyle{style}` / `\bibliography{file}` | Set the reference style and pull in `file.bib` (classic BibTeX — see [03](03-BibliographyAndCitations.md)) |
| `\label{...}` / `\ref{...}` | Tag something, then refer to it by number elsewhere |
| `%` | Comment — rest of the line is ignored |
