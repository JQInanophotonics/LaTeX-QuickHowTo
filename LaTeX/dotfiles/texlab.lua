return {
  {
    "neovim/nvim-lspconfig",
    ft = { "tex", "plaintex", "bib", "python" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      local exe = vim.fn.exepath("texlab")
      if exe == "" then
        exe = "/opt/homebrew/bin/texlab"
      end
      vim.lsp.config("texlab", {
        cmd = { exe },
        capabilities = capabilities,
      })
      vim.lsp.enable("texlab")

      local python_server
      if vim.fn.executable("basedpyright-langserver") == 1 then
        python_server = "basedpyright"
      elseif vim.fn.executable("pyright-langserver") == 1 then
        python_server = "pyright"
      elseif vim.fn.executable("pylsp") == 1 then
        python_server = "pylsp"
      end

      if python_server then
        local opts = { capabilities = capabilities }
        if python_server == "pyright" or python_server == "basedpyright" then
          opts.settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                typeCheckingMode = "basic",
              },
            },
          }
        end
        vim.lsp.config(python_server, opts)
        vim.lsp.enable(python_server)
      else
        local message =
          "No Python LSP found. Install one: `brew install pyright`, `npm i -g pyright`, or `pip install python-lsp-server`."
        if vim.bo.filetype == "python" then
          vim.notify(message, vim.log.levels.WARN)
        else
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "python",
            once = true,
            callback = function()
              vim.notify(message, vim.log.levels.WARN)
            end,
            desc = "Warn if Python LSP is missing",
          })
        end
      end
    end,
  },
}
