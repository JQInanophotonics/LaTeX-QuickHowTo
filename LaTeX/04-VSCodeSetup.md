# 04 — VS Code setup

## Install the LaTeX Workshop extension

**Extension:** `James-yu.latex-workshop` — this is the one, and it's the only one you need.

1. Open the Extensions view: `Cmd+Shift+X` (macOS) / `Ctrl+Shift+X` (Windows/Linux) — or click the squares icon in the left sidebar.
2. Search **LaTeX Workshop** (or paste the ID `James-yu.latex-workshop` straight into the search box).
3. Click **Install**.

That's the whole install — no other extension is needed. LaTeX Workshop handles compiling on save, inline error highlighting (a squiggly underline on the exact `.tex` line an error is on, not just a raw log dump), autocomplete for commands/citations/labels, and PDF preview with SyncTeX.

## First compile

Open any `.tex` file — with a distribution installed ([01](01-Installing.md)), LaTeX Workshop compiles automatically on save using plain `pdflatex`, with zero configuration. This is what a paper needs; nothing further in this page is required for that case.

Watch the bottom status bar: a spinning icon while it compiles, then a checkmark. The PDF opens automatically in a new tab the first time you save.

**If nothing happens, or you see "recipe terminated with fatal error" / a command-not-found message:** on macOS in particular, VS Code launched from Finder/Dock/Spotlight doesn't always inherit the `PATH` your terminal has, so it can fail to find `pdflatex` right after a fresh MacTeX install even though `pdflatex --version` works fine in a terminal. Fully quit and reopen VS Code once — this fixes it most of the time. If it still can't find the binary, check the **Output** panel (View → Output, select "LaTeX Workshop" from the dropdown) for the exact command it tried to run, and confirm that binary exists at `which pdflatex`.

## Only for Beamer talks: add a LuaLaTeX recipe

Skip this section unless you're compiling something built from [JqiNanoBeamerTemplate](https://github.com/JQInanophotonics/JqiNanoBeamerTemplate) — papers compile fine with the default `pdflatex` recipe above. The Beamer template specifically needs LuaLaTeX (see [02](02-Compiling.md)), so add an **extra** recipe rather than replacing the default:

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
Put this in that Beamer project's **workspace** settings (`.vscode/settings.json` inside the project folder) rather than your global user settings — that way your paper projects keep using plain `pdflatex` by default, and only this one project offers the LuaLaTeX recipe. Pick it from the recipe dropdown next to the compile button (or `Cmd+Shift+P` → "LaTeX Workshop: Select the recipe to compile"); LaTeX Workshop remembers the last recipe chosen per project, so you only need to select it once.

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
