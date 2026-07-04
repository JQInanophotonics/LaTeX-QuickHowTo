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
