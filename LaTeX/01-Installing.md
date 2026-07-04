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
