local list_contains = vim.list_contains or vim.tbl_contains

local function deprioritize_snippet(entry1, entry2)
  local types = require "cmp.types"

  if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then return false end
  if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then return true end
end

--- Select item next/prev, taking into account whether the cmp window is
--- top-down or bottoom-up so that the movement is always in the same direction.
local select_item_smart = function(dir, opts)
  return function(fallback)
    if require("cmp").visible() then
      opts = opts or { behavior = require("cmp").SelectBehavior.Select }
      if require("cmp").core.view.custom_entries_view:is_direction_top_down() then
        ({ next = require("cmp").select_next_item, prev = require("cmp").select_prev_item })[dir](opts)
      else
        ({ prev = require("cmp").select_next_item, next = require("cmp").select_prev_item })[dir](opts)
      end
    else
      fallback()
    end
  end
end

local function under(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find "^_+"
  local _, entry2_under = entry2.completion_item.label:find "^_+"
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local function limit_lsp_types(entry, ctx)
  local kind = entry:get_kind()
  local line = ctx.cursor.line
  local col = ctx.cursor.col
  local char_before_cursor = string.sub(line, col - 1, col - 1)
  local char_after_dot = string.sub(line, col, col)
  local types = require "cmp.types"

  if char_before_cursor == "." and char_after_dot:match "[a-zA-Z]" then
    return kind == types.lsp.CompletionItemKind.Method
      or kind == types.lsp.CompletionItemKind.Field
      or kind == types.lsp.CompletionItemKind.Property
  elseif string.match(line, "^%s+%w+$") then
    return kind == types.lsp.CompletionItemKind.Function or kind == types.lsp.CompletionItemKind.Variable
  elseif kind == require("cmp").lsp.CompletionItemKind.Text then
    return false
  end

  return true
end

local function has_words_before()
  local buftype = vim.api.nvim_buf_get_option(0, "buftype")
  if buftype == "prompt" then return false end

  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then return false end

  local line = vim.api.nvim_buf_get_lines(0, line - 1, line - 1, true)[1]
  return not line:match "^%s*$"
end

local function get_lsp_completion_context(completion, source)
  local source_name = source.source.client.config.name

  if source_name == "tsserver" or source_name == "typescript-tools" then
    return completion.detail
  elseif source_name == "pyright" and completion.labelDetails ~= nil then
    return completion.labelDetails.description
  end
end

local buffer_option = {
  get_bufnrs = function()
    local buf_size_limit = 1024 * 1024
    local bufs = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
      if byte_size <= buf_size_limit then bufs[buf] = true end
    end
    return vim.tbl_keys(bufs)
  end,
}

local is_dap_buffer = function(bufnr)
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr or 0 })
  if filetype == "dap-repl" or vim.startswith(filetype, "dapui_") then return true end
  return false
end

local disabled_buftypes = {
  "terminal",
  -- "nofile",
  "prompt",
}

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "ray-x/cmp-treesitter",
    { "jcdickinson/codeium.nvim", config = true },
  },
  opts = {
    enabled = function()
      local disabled = false
      disabled = disabled or is_dap_buffer(0)
      disabled = disabled or (list_contains(disabled_buftypes, vim.api.nvim_get_option_value("buftype", { buf = 0 })))
      disabled = disabled or (vim.fn.reg_recording() ~= "")
      disabled = disabled or (vim.fn.reg_executing() ~= "")
      disabled = disabled or (require("cmp.config.context").in_treesitter_capture "comment" == true)
      disabled = disabled or (require("cmp.config.context").in_syntax_group "Comment" == true)
      disabled = disabled or (vim.api.nvim_get_mode().mode == "c")

      if disabled then return not disabled end

      return true
    end,
    window = {
      completion = {
        scrolloff = 0,
        col_offset = 0,
        scrollbar = false,
      },
    },
    view = {
      entries = {
        follow_cursor = true,
      },
    },
    completion = {
      completeopt = "menu,menuone,noinsert,noselect",
      autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
      keyword_length = 2,
    },
    experimental = {
      ghost_text = {
        hl_group = "Comment",
      },
    },
    mapping = {
      ["<Left>"] = function(fallback)
        require("cmp").abort()
        fallback()
      end,
      ["<Right>"] = function(fallback)
        require("cmp").abort()
        fallback()
      end,
      ["<Tab>"] = require("cmp").mapping(function(fallback)
        if require("luasnip").expandable() then
          require("luasnip").expand()
        elseif require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        elseif require("neogen").jumpable() then
          require("neogen").jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-tab>"] = require("cmp").mapping(function(fallback)
        if require("neogen").jumpable(true) then
          require("neogen").jump_prev()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<CR>"] = require("cmp").mapping {
        i = function(fallback)
          if require("cmp").visible() and require("cmp").get_active_entry() then
            require("cmp").confirm { behavior = require("cmp").ConfirmBehavior.Replace, select = false }
          else
            fallback()
          end
        end,
        s = require("cmp").mapping.confirm { select = true },
        c = require("cmp").mapping.confirm { behavior = require("cmp").ConfirmBehavior.Replace, select = true },
      },
      ["<ESC>"] = require("cmp").mapping(function(fallback)
        if require("cmp").visible() then
          require("cmp").abort()
          require("cmp").close()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },
    performance = {
      debounce = 30,
      throttle = 20,
      async_budget = 0.8,
      max_view_entries = 10,
      fetching_timeout = 250,
    },
    formatting = {
      fields = { "abbr", "kind", "menu" },
    },
    snippet = {
      expand = function(args) require("luasnip").lsp_expand(args.body) end,
    },
    sources = {
      {
        name = "codeium",
        max_item_count = 6,
      },
      {
        name = "nvim_lsp",
        keyword_length = 2,
        max_item_count = 10,
        -- entry_filter = function(entry, ctx)
        --   return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
        -- end,
        entry_filter = limit_lsp_types,
      },
      { name = "treesitter" },
      { name = "nvim_lsp_document_symbol" },
      { name = "luasnip", max_item_count = 2 },
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        deprioritize_snippet,
        require("cmp").config.compare.exact,
        require("cmp").config.compare.locality,
        require("cmp").config.compare.recently_used,
        under,
        require("cmp").config.compare.score,
        require("cmp").config.compare.kind,
        require("cmp").config.compare.length,
        require("cmp").config.compare.order,
        require("cmp").config.compare.sort_text,
      },
    },
  },
}
