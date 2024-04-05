-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    {
      "windwp/nvim-ts-autotag",
      opts = { enable_close_on_slash = false },
    },
    -- 注释工具包
    "filNaj/tree-setter",
    "echasnovski/mini.ai",
    "piersolenski/telescope-import.nvim",
    "RRethy/nvim-treesitter-textsubjects",
    "danymat/neogen",
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      init = function()
        vim.g.skip_ts_context_commentstring_module = true
      end,
      config = function()
        require("ts_context_commentstring").setup {
          enable_autocmd = false,
        }
      end,
    },
  },
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "lua",
      "vim",
      -- frontend language
      "css",
      "scss",
      "typescript",
      "javascript",
      "vue",
      -- operation & cloud native
      "dockerfile",
      "jsonnet",
      "regex",
      "nix",
      "csv",
      -- other programming language
      "diff",
      "gitignore",
      "gitcommit",
      "latex",
      "sql",
    })
  end,
}
