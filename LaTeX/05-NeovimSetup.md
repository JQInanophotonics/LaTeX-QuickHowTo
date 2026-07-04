# 05 — Neovim setup

VS Code ([04](04-VSCodeSetup.md)) is the easiest path. This page is for anyone who already lives in Neovim — it walks through this repo author's actual config, via [vimtex](https://github.com/lervag/vimtex) (compiling + SyncTeX + folding) and [texlab](https://github.com/latex-lsp/texlab) (autocomplete, diagnostics, via the Language Server Protocol). The real files are copied into [`dotfiles/`](dotfiles/) alongside this page — drop them into your own config and adjust paths/keymaps to taste.

## Install texlab

```bash
brew install texlab       # macOS
cargo install texlab      # any OS, via Rust's package manager
```
Linux/Windows package managers may also carry `texlab` directly (e.g. `pacman -S texlab` on Arch). Confirm it's on your `PATH`: `texlab --version`.

## vimtex — [`dotfiles/vimtex.lua`](dotfiles/vimtex.lua)

The parts that matter for any LaTeX setup:

```lua
vim.g.vimtex_view_method = "skim"   -- macOS; "zathura" on Linux, "sumatrapdf" on Windows

vim.g.vimtex_toc_config = {
  split_pos = 'topleft',
  split_width = 6,
}

vim.g.vimtex_fold_enabled = 1
vim.g.vimtex_fold_manual = 0

vim.g.vimtex_compiler_latexmk = {
  options = {
    '-verbose',
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode',
  },
}
```
Note there's no engine flag (`-lualatex`/`-xelatex`) in the default options — see [02](02-Compiling.md) for why the engine has to match the document. Instead, the full file defines a `switch_latex_compiler(engine)` helper and three commands to flip it per project:

```lua
vim.api.nvim_create_user_command('VimtexCompilerLuaLaTeX', function()
  switch_latex_compiler('lualatex')
end, {})

vim.api.nvim_create_user_command('VimtexCompilerPDFLaTeX', function()
  switch_latex_compiler('pdflatex')
end, {})

vim.api.nvim_create_user_command('VimtexCompilerXeLaTeX', function()
  switch_latex_compiler('xelatex')
end, {})
```
Run `:VimtexCompilerLuaLaTeX` once per project that needs it (anything built from [JqiNanoBeamerTemplate](https://github.com/JQInanophotonics/JqiNanoBeamerTemplate) does) before your first `\ll`.

The rest of [`dotfiles/vimtex.lua`](dotfiles/vimtex.lua) is a custom folding display for a personal `\refcom` macro (not a standard LaTeX command — it's from the author's own preamble) — safe to delete if you don't use that macro; it doesn't affect compiling, SyncTeX, or the compiler-switch commands above.

## texlab — [`dotfiles/texlab.lua`](dotfiles/texlab.lua)

The LaTeX-relevant part:

```lua
vim.lsp.config("texlab", {
  cmd = { exe },  -- exe resolved via vim.fn.exepath("texlab"), falling back to a known install path
  capabilities = capabilities,
})
vim.lsp.enable("texlab")
```
The full file also wires up completion capabilities via `cmp_nvim_lsp` (optional — only if you use `nvim-cmp`) and, in the same plugin spec, configures a Python language server (`basedpyright`/`pyright`/`pylsp`) for unrelated Python work — that block is incidental to this file's history, not part of the LaTeX setup; delete it if you don't want Python LSP tagging along.

## Snippets — [`dotfiles/tex-snippets.lua`](dotfiles/tex-snippets.lua)

LuaSnip environment templates and math shortcuts, loaded only for `.tex`/`.bib` buffers. A couple of representative entries:

```lua
-- BEQ -> \begin{equation}...\end{equation}, autotriggered outside math mode
{ trig = "BEQ", exp = [[
\begin{equation}
  <>
  \label{eq:<>}
\end{equation}]] }

-- Greek letters, math mode only: @a -> \alpha, @D -> \Delta, @8 -> \infty
{ trig = "@a", exp = "\\alpha" }
```
The full file ([`dotfiles/tex-snippets.lua`](dotfiles/tex-snippets.lua), ~370 lines) covers every Greek letter, structures like `\frac`/`\sqrt`/bracket pairs (`@/`, `@2`, `@(`...), figure/table/equation environment skeletons (`BFI`, `BTA`, `BEQ`...), and Beamer-specific snippets (`;frame`, `;columns`).

## Format-toggle keymaps — [`dotfiles/tex-ftplugin.lua`](dotfiles/tex-ftplugin.lua)

Context-aware shortcuts that expand or wrap-selection differently depending on whether the cursor is in math mode:

| Keys | Text mode | Math mode |
|---|---|---|
| `<C-l><C-b>` | `\textbf{}` | `\mathbf{}` |
| `<C-l><C-i>` | `\textit{}` | `\mathit{}` |
| `<C-l><C-e>` | `\emph{}` | `\emph{}` |
| `<C-l><C-p>` | `\textsuperscript{}` | `^{}` |
| `<C-l><C-->` | `\textsubscript{}` | `_{}` |

In insert mode these expand at the cursor; in visual mode they wrap the current selection (and toggle back to plain text if the selection is already wrapped). The full file also sets the buffer-local foldtext for the `\refcom` macro mentioned above.

## Syntax tweak — [`dotfiles/tex-syntax.vim`](dotfiles/tex-syntax.vim)

A small patch so `siunitx`'s `\qty`/`\SI` number arguments still get math-mode syntax highlighting/concealment inside text mode. Optional — only relevant if you use `siunitx`.

## Everyday keys (vimtex defaults, `<localleader>` = `\` unless you've remapped it)

| Keys | Action |
|---|---|
| `\ll` | Compile (starts continuous `latexmk -pvc`) |
| `\lv` | Forward search — jump to this line in the PDF viewer |
| `\lk` | Stop compilation |
| `\lc` | Clean aux files |
| `\le` | Show errors in the quickfix list |

Inverse search (clicking in the PDF to jump back into Neovim) needs the viewer pointed at a running Neovim instance — the exact command depends on your vimtex version, so run `:help vimtex-view-skim` (or `-zathura`/`-sumatrapdf`) inside Neovim for the current syntax rather than copying a possibly-stale one from here.

Next: [06 — Syntax cheat sheet](06-SyntaxCheatSheet.md)
