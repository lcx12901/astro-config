-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    {
      "windwp/nvim-ts-autotag",
      opts = { enable = true },
    },
    "filNaj/tree-setter",
    "echasnovski/mini.ai",
    "piersolenski/telescope-import.nvim",
    "RRethy/nvim-treesitter-textsubjects",
    "danymat/neogen",
    "Wansmer/treesj",
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      opts = { enable_autocmd = false },
    },
    { "nvim-treesitter/nvim-treesitter-context" },
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
