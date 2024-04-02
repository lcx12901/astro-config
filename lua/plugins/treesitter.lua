if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "lua",
      "vim",
      -- frontend language
      "css",
      "scss",
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
