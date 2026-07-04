if _G.vimtex_refcom_fold_text then
  vim.opt_local.foldtext = "v:lua.vimtex_refcom_fold_text()"
end

local ls = require("luasnip")

-- Check if we are in Math Zone
local function in_mathzone()
  if vim.fn.exists('*vimtex#syntax#in_mathzone') ~= 1 then return false end
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

-- Helper function: Selects command based on context, then Inserts or Toggles
local function map_snip(keys, math_cmd, text_cmd, desc)
  
  local function get_cmd()
    if in_mathzone() then return math_cmd else return text_cmd end
  end

  -- 1. INSERT MODE
  vim.keymap.set("i", keys, function()
    ls.lsp_expand(get_cmd())
  end, { buffer = true, desc = desc })

  -- 2. VISUAL MODE (Context-aware Toggle)
  vim.keymap.set("x", keys, function()
    -- Capture selection
    vim.cmd('normal! "zd')
    local selection = vim.fn.getreg("z")
    local content = get_cmd()

    -- EXTRACT PREFIX: e.g. "^{$1}" -> prefix is "^"
    -- We assume the snippet ends with {$1}
    local prefix = content:match("^(.*){%$1}")
    
    if prefix then
      -- ESCAPE MAGIC CHARS: This was likely the issue with "^"
      -- We must escape ^, $, (, ), %, ., [, ], *, +, -, ?
      local safe_prefix = prefix:gsub("([^%w])", "%%%1")
      
      -- Build pattern: ^ \cmd \s* { (content) } \s* $
      local pattern = "^" .. safe_prefix .. "%s*{(.*)}%s*$"
      
      -- Try to match the inner text
      local inner_text = selection:match(pattern)
      
      if inner_text then
        -- Unwrap!
        ls.lsp_expand(inner_text)
        return
      end
    end

    -- Wrap!
    local final_content = content:gsub("%$1", function() return selection end)
    ls.lsp_expand(final_content)
  end, { buffer = true, desc = desc })
end

-- ====================================================
--  MAPPINGS
-- ====================================================

-- BOLD
map_snip("<C-l><C-b>", "\\mathbf{$1}", "\\textbf{$1}", "Bold")

-- ITALIC
map_snip("<C-l><C-i>", "\\mathit{$1}", "\\textit{$1}", "Italic")

-- ROMAN
map_snip("<C-l><C-r>", "\\mathrm{$1}", "\\textrm{$1}", "Roman")

-- TYPEWRITER
map_snip("<C-l><C-t>", "\\mathtt{$1}", "\\texttt{$1}", "Typewriter")

-- SUPERSCRIPT (Corrected regex handling ensures this works)
map_snip("<C-l><C-p>", "^{$1}", "\\textsuperscript{$1}", "Superscript")

-- SUBSCRIPT
map_snip("<C-l><C-->", "_{$1}", "\\textsubscript{$1}", "Subscript")

-- UNDERLINE
map_snip("<C-l><C-u>", "\\underline{$1}", "\\underline{$1}", "Underline")

-- EMPHASIZE
map_snip("<C-l><C-e>", "\\emph{$1}", "\\emph{$1}", "Emphasize")

-- CALIGRAPHY
map_snip("<C-l><C-c>", "\\mathcal{$1}", "\\mathcal{$1}", "Caligraphy")
