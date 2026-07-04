# 05 — Neovim setup

VS Code ([04](04-VSCodeSetup.md)) is the easiest path. This page is for anyone who already lives in Neovim and wants the same compile/preview/error-highlighting loop there, via [vimtex](https://github.com/lervag/vimtex) (compiling + SyncTeX + folding) and [texlab](https://github.com/latex-lsp/texlab) (autocomplete, diagnostics, go-to-definition, via the Language Server Protocol).

## Install texlab

```bash
brew install texlab       # macOS
cargo install texlab      # any OS, via Rust's package manager
```
Linux/Windows package managers may also carry `texlab` directly (e.g. `pacman -S texlab` on Arch).

## Minimal config (lazy.nvim)

```lua
-- lua/plugins/latex.lua
return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- macOS: "skim" · Linux: "zathura" · Windows: "sumatrapdf"
      vim.g.vimtex_view_method = "skim"

      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-lualatex",             -- see 02-Compiling.md — matches JqiNanoBeamerTemplate
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ft = { "tex", "plaintex", "bib" },
    config = function()
      vim.lsp.config("texlab", {})
      vim.lsp.enable("texlab")
    end,
  },
}
```

This gives you: `fontspec`-aware LuaLaTeX compiling on save, SyncTeX forward/inverse search through Skim/Zathura/SumatraPDF, and texlab-powered autocomplete/diagnostics.

## Everyday keys (vimtex defaults, `<localleader>` = `\` unless you've remapped it)

| Keys | Action |
|---|---|
| `\ll` | Compile (starts continuous `latexmk -pvc`) |
| `\lv` | Forward search — jump to this line in the PDF viewer |
| `\lk` | Stop compilation |
| `\lc` | Clean aux files |
| `\le` | Show errors in the quickfix list |

Inverse search (clicking in the PDF to jump back into Neovim) needs the viewer pointed at a running Neovim instance — the exact command depends on your vimtex version, so run `:help vimtex-view-skim` (or `-zathura`/`-sumatrapdf`) inside Neovim for the current syntax rather than copying a possibly-stale one from here.

## Want the full setup?

This is a deliberately minimal starting point. The author's actual config adds custom section folding, context-aware math/text snippets, and [TeXpresso](https://github.com/let-def/texpresso) live preview — see [gregmoille/nvim_config](https://github.com/gregmoille/nvim_config) (`lua/plugins/vimtex.lua`, `lua/plugins/texlab.lua`, `snippets/tex.lua`) for the complete version.

Next: [06 — Syntax cheat sheet](06-SyntaxCheatSheet.md)
