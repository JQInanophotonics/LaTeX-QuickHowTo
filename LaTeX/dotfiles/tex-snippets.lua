local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta

-- Function to check if we are in Math Mode using VimTeX
local function in_mathzone() 
  if vim.fn.exists('*vimtex#syntax#in_mathzone') ~= 1 then return false end
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

-- Function to check if we are NOT in math mode (for text-only snippets)
local function not_in_mathzone()
  return not in_mathzone()
end

local snippets = {}

-- ==========================================
-- LATEX ENVIRONMENTS (Text Mode)
-- ==========================================
local environments = {
  -- Figure environment
  {
    trig = "BFI",
    exp = [[
\begin{figure}[<>]
  \centering
  \includegraphics[width=<>\textwidth]{<>}
  \caption{<>}
  \label{fig:<>}
\end{figure}]],
    nodes = { i(1, "htbp"), i(2, "0.8"), i(3, "path/to/image"), i(4, "caption"), i(5, "label") }
  },
  
  -- Itemize
  {
    trig = "BIT",
    exp = [[
\begin{itemize}
  \item <>
\end{itemize}]],
    nodes = { i(1) }
  },
  
  -- Enumerate
  {
    trig = "BEN",
    exp = [[
\begin{enumerate}
  \item <>
\end{enumerate}]],
    nodes = { i(1) }
  },
  
  -- Table
  {
    trig = "BTA",
    exp = [[
\begin{table}[<>]
  \centering
  \begin{tabular}{<>}
    \hline
    <>
    \hline
  \end{tabular}
  \caption{<>}
  \label{tab:<>}
\end{table}]],
    nodes = { i(1, "htbp"), i(2, "c|c|c"), i(3), i(4, "caption"), i(5, "label") }
  },
  
  -- Equation
  {
    trig = "BEQ",
    exp = [[
\begin{equation}
  <>
  \label{eq:<>}
\end{equation}]],
    nodes = { i(1), i(2, "label") }
  },
  
  -- Equation* (starred)
  {
    trig = "BSEQ",
    exp = [[
\begin{equation*}
  <>
\end{equation*}]],
    nodes = { i(1) }
  },
  
  -- Align
  {
    trig = "BAL",
    exp = [[
\begin{align}
  <>
\end{align}]],
    nodes = { i(1) }
  },
  
  -- Align* (starred)
  {
    trig = "BSAL",
    exp = [[
\begin{align*}
  <>
\end{align*}]],
    nodes = { i(1) }
  },
  
  -- Gather
  {
    trig = "BGA",
    exp = [[
\begin{gather}
  <>
\end{gather}]],
    nodes = { i(1) }
  },
  
  -- Gather* (starred)
  {
    trig = "BSGA",
    exp = [[
\begin{gather*}
  <>
\end{gather*}]],
    nodes = { i(1) }
  },
  
  -- Multline
  {
    trig = "BMU",
    exp = [[
\begin{multline}
  <>
\end{multline}]],
    nodes = { i(1) }
  },
  
  -- Multline* (starred)
  {
    trig = "BSMU",
    exp = [[
\begin{multline*}
  <>
\end{multline*}]],
    nodes = { i(1) }
  },
  
  -- Split
  {
    trig = "BSPL",
    exp = [[
\begin{split}
  <>
\end{split}]],
    nodes = { i(1) }
  },
  
  -- Cases
  {
    trig = "BCAS",
    exp = [[
\begin{cases}
  <>
\end{cases}]],
    nodes = { i(1) }
  },
  
  -- Frame (for Beamer)
  {
    trig = "BFR",
    exp = [[
\begin{frame}{<>}
  <>
\end{frame}]],
    nodes = { i(1, "Frame Title"), i(2) }
  },
  
  -- Center
  {
    trig = "BCE",
    exp = [[
\begin{center}
  <>
\end{center}]],
    nodes = { i(1) }
  },
}

-- Add environment snippets (text mode only)
for _, spec in ipairs(environments) do
  table.insert(snippets, 
    s({ trig = spec.trig, snippetType = "autosnippet" }, 
      fmta(spec.exp, spec.nodes),
      { condition = not_in_mathzone }
    )
  )
end

-- ==========================================
-- CUSTOM VSCODE SNIPPETS (Beamer & Colors)
-- ==========================================

-- Beamer Columns (two columns)
table.insert(snippets,
  s({ trig = ";columns", snippetType = "autosnippet" },
    fmta("\\twocol[<>]{<>}{<>}",
      { c(1, { t("T"), t("c") }), i(2, "0.5"), i(3, "0.5") }
    ),
    { condition = not_in_mathzone }
  )
)

-- Single Beamer Column
table.insert(snippets,
  s({ trig = ";column", snippetType = "autosnippet" },
    fmta([[
\begin{column}{<>\textwidth}
  <>
\end{column}]], 
      { i(1, "0.5"), i(2) }
    ),
    { condition = not_in_mathzone }
  )
)

-- Beamer Frame (alternative trigger to BFR)
table.insert(snippets,
  s({ trig = ";frame", snippetType = "autosnippet" },
    fmta([[
\begin{frame}{<>}
  <>
\end{frame}]], 
      { i(1, "Frame Title"), i(2) }
    ),
    { condition = not_in_mathzone }
  )
)

-- Text color commands
table.insert(snippets,
  s({ trig = "color" },
    fmta("\\textcolor{<>}{<>}", { i(1, "color"), i(2) })
  )
)

table.insert(snippets,
  s({ trig = "red" },
    fmta("\\textcolor{red}{<>}", { i(1) })
  )
)

table.insert(snippets,
  s({ trig = "orange" },
    fmta("\\textcolor{orange}{<>}", { i(1) })
  )
)

table.insert(snippets,
  s({ trig = "orangebf" },
    fmta("\\textcolor{orange}{\\textbf{<>}}", { i(1) })
  )
)

table.insert(snippets,
  s({ trig = "green" },
    fmta("\\textcolor{darkgreen}{<>}", { i(1) })
  )
)

table.insert(snippets,
  s({ trig = "greenbf" },
    fmta("\\textcolor{darkgreen}{\\textbf{<>}}", { i(1) })
  )
)

-- ==========================================
-- 1. COMPLEX STRUCTURES (Frac, Sqrt, etc.)
-- ==========================================
local structures = {
  -- 2 NODES: \frac{<>}{<>}
  { trig = "@/", exp = "\\frac{<>}{<>}", nodes = { i(1), i(2) } }, 
  { trig = "@B", exp = "\\binom{<>}{<>}", nodes = { i(1), i(2) } },

  -- 1 NODE: \sqrt{<>}
  { trig = "@2", exp = "\\sqrt{<>}", nodes = { i(1) } }, 
  { trig = "@(", exp = "\\left( <> \\right)", nodes = { i(1) } },
  { trig = "@[", exp = "\\left[ <> \\right]", nodes = { i(1) } },
  { trig = "@{", exp = "\\left\\{ <> \\right\\}", nodes = { i(1) } },
}

for _, spec in ipairs(structures) do
  table.insert(snippets, 
    s({ trig = spec.trig, snippetType = "autosnippet" }, 
      -- We pass the explicit nodes list here to avoid the "Unused argument" error
      fmta(spec.exp, spec.nodes), 
      { condition = in_mathzone }
    )
  )
end

-- ==========================================
-- 2. SYMBOLS (Greek & Operators)
-- ==========================================
local symbols = {
  -- Greek
  { trig = "@a", exp = "\\alpha" },
  { trig = "@b", exp = "\\beta" },
  { trig = "@g", exp = "\\gamma" },
  { trig = "@d", exp = "\\delta" },
  { trig = "@e", exp = "\\epsilon" },
  { trig = "@z", exp = "\\zeta" },
  { trig = "@h", exp = "\\eta" },
  { trig = "@q", exp = "\\theta" },
  { trig = "@i", exp = "\\iota" },
  { trig = "@k", exp = "\\kappa" },
  { trig = "@l", exp = "\\lambda" },
  { trig = "@m", exp = "\\mu" },
  { trig = "@n", exp = "\\nu" },
  { trig = "@x", exp = "\\xi" },
  { trig = "@p", exp = "\\pi" },
  { trig = "@r", exp = "\\rho" },
  { trig = "@s", exp = "\\sigma" },
  { trig = "@t", exp = "\\tau" },
  { trig = "@u", exp = "\\upsilon" },
  { trig = "@f", exp = "\\phi" },
  { trig = "@c", exp = "\\chi" },
  { trig = "@y", exp = "\\psi" },
  { trig = "@w", exp = "\\omega" },
  { trig = "@ve", exp = "\\varepsilon" },
  { trig = "@vf", exp = "\\varphi" },

  -- Uppercase Greek
  { trig = "@G", exp = "\\Gamma" },
  { trig = "@D", exp = "\\Delta" },
  { trig = "@Q", exp = "\\Theta" },
  { trig = "@L", exp = "\\Lambda" },
  { trig = "@X", exp = "\\Xi" },
  { trig = "@P", exp = "\\Pi" },
  { trig = "@S", exp = "\\Sigma" },
  { trig = "@F", exp = "\\Phi" },
  { trig = "@Y", exp = "\\Psi" },
  { trig = "@W", exp = "\\Omega" },

  -- Calculus / Sets
  { trig = "@8", exp = "\\infty" },
  { trig = "@6", exp = "\\partial" },
  { trig = "@I", exp = "\\int" },
  { trig = "@.", exp = "\\cdot" },
  { trig = "@A", exp = "\\forall" },
  { trig = "@E", exp = "\\exists" },
  { trig = "@<", exp = "\\le" },
  { trig = "@>", exp = "\\ge" },
}

for _, spec in ipairs(symbols) do
  table.insert(snippets, 
    s({ trig = spec.trig, snippetType = "autosnippet" }, 
      { t(spec.exp) },
      { condition = in_mathzone }
    )
  )
end

return snippets
