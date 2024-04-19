---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"
    config.ensure_installed = nil
    config.automatic_installation = false
    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Common Code gitsigns
      null_ls.builtins.code_actions.gitsigns,
      -- null_ls.builtins.code_actions.shellcheck,
      -- Diagnostics
      null_ls.builtins.diagnostics.actionlint,
      null_ls.builtins.diagnostics.buf,
      null_ls.builtins.diagnostics.deadnix,
      -- Formatting
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.alejandra,
    }
    return config -- return final config table
  end,
}
