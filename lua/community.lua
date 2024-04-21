-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- Language Support
  ---- Frontend & NodeJS
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.prisma" },
  { import = "astrocommunity.pack.vue" },
  ---- Configuration Language
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.toml" },
  ---- Backend / System
  { import = "astrocommunity.pack.lua" },
  ---- Operation & Cloud Native
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.docker" },
  -- colorscheme
  { import = "astrocommunity.colorscheme.catppuccin" },

  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },

  { import = "astrocommunity.git.git-blame-nvim" },
  -- { import = "astrocommunity.scrolling.mini-animate" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },

  -- motion
  { import = "astrocommunity.motion.mini-move" }, -- 视图模式，选中任意移动
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.motion.flash-nvim" },

  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  { import = "astrocommunity.recipes.neovide" },
}
