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
