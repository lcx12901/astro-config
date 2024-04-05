local M = {}

local function icon_multiple_filenames(filenames, opts)
  local overrides = {}
  for _, file in ipairs(filenames) do
    overrides[file] = opts
  end
  return overrides
end

local function filenames_list(filename, extensions)
  local filenames = {}
  for _, ext in ipairs(extensions) do
    table.insert(filenames, filename .. "." .. ext)
  end
  return filenames
end

M.devicons = {
  override_by_filename = vim.tbl_extend(
    "force",
    {
      ["yml"] = {
        icon = "",
        color = "#bbbbbb",
        name = "Yml",
      },
      ["yaml"] = {
        icon = "",
        color = "#bbbbbb",
        name = "Yaml",
      },
      ["scm"] = {
        icon = "",
        color = "#90a850",
        name = "Query",
      },
      ["makefile"] = {
        icon = "",
        color = "#f1502f",
        name = "Makefile",
      },
      ["mod"] = {
        icon = "󰟓",
        color = "#519aba",
        name = "Mod",
      },
      ["yarn.lock"] = {
        icon = "",
        color = "#0288D1",
        name = "Yarn",
      },
      ["sum"] = {
        icon = "󰟓",
        color = "#cbcb40",
        name = "Sum",
      },
      [".gitignore"] = {
        icon = "",
        color = "#e24329",
        name = "GitIgnore",
      },
      ["js"] = {
        icon = "",
        color = "#cbcb41",
        name = "Js",
      },
      ["lock"] = {
        icon = "",
        color = "#bbbbbb",
        name = "Lock",
      },
      ["package.json"] = {
        icon = "",
        color = "#e8274b",
        name = "PackageJson",
      },
      [".eslintignore"] = {
        icon = "󰱺",
        color = "#e8274b",
        name = "EslintIgnore",
      },
      ["tags"] = {
        icon = "",
        color = "#bbbbbb",
        name = "Tags",
      },
      ["http"] = {
        icon = "󰖟",
        color = "#519aba",
        name = "Http",
      },
      ["astro"] = {
        icon = "",
        color = "#f1502f",
        name = "Astro",
      },
    },
    icon_multiple_filenames(filenames_list("tailwind.config", { "js", "cjs", "ts", "cts" }), {
      icon = "󱏿",
      color = "#4DB6AC",
      name = "tailwind",
    }),
    icon_multiple_filenames(filenames_list("vite.config", { "js", "cjs", "ts", "cts" }), {
      icon = "󱐋",
      color = "#FFAB00",
      name = "ViteJS",
    }),
    icon_multiple_filenames(filenames_list(".eslintrc", { "js", "cjs", "yaml", "yml", "json" }), {
      icon = "",
      color = "#4b32c3",
      cterm_color = "56",
      name = "Eslintrc",
    })
  ),
}

M.colorizer = {
  filetypes = {
    "*",
    cmp_docs = { always_update = true },
    cmp_menu = { always_update = true },
  },
  user_default_options = {
    names = false,
    RRGGBBAA = true,
    rgb_fn = true,
    tailwind = true,
    RGB = true,
    RRGGBB = true,
    AARRGGBB = true,
    hsl_fn = true,
    css = true,
    css_fn = true,
    mode = "background",
    sass = { enable = true, parsers = { "css" } },
    mode = "background", -- Available methods are false / true / "normal" / "lsp" / "both"
    virtualtext = "■",
    always_update = true,
  },
}

return M