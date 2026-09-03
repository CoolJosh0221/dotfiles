-- Your Neovim control panel.
--
-- A value of nil means "inherit LazyVim's current default". This keeps upgrades
-- useful instead of freezing a copy of every upstream default in this repo.
-- Plugin-specific escape hatches live at the bottom of each relevant section.

local function spaces(width)
  return {
    expandtab = true,
    shiftwidth = width,
    softtabstop = width,
    tabstop = width,
  }
end

local preferences = {
  lazy = {
    -- lazy.nvim itself. These match the LazyVim starter defaults.
    custom_plugins_lazy = false,
    plugin_versions = false,
    update_checker = true,
    update_notify = true,
    install_colorschemes = { "tokyonight", "habamax" },
    disabled_runtime_plugins = {
      "gzip",
      "tarPlugin",
      "tohtml",
      "tutor",
      "zipPlugin",
    },
  },

  lazyvim = {
    -- LazyVim core globals.
    mapleader = " ",
    maplocalleader = "\\",
    autoformat = true,
    snacks_animate = true,
    picker = "snacks", -- "snacks", "telescope", "fzf", or "auto"
    completion = "blink.cmp", -- "blink.cmp", "nvim-cmp", or "auto"
    ai_cmp = true,
    root_spec = nil, -- LazyVim: { "lsp", { ".git", "lua" }, "cwd" }
    root_lsp_ignore = nil, -- LazyVim: { "copilot" }
    deprecation_warnings = false,
    trouble_lualine = true,
    markdown_recommended_style = 0,

    -- LazyVim/LazyVim setup options.
    load_default_autocmds = true,
    load_default_keymaps = true,
    news_lazyvim = true,
    news_neovim = false,
    icons = {}, -- Deep-merged over LazyVim's icon catalog.
    kind_filter = nil, -- Document-symbol filters by filetype.

    -- Globals exposed by the enabled extras.
    python_lsp = "pyright", -- or "basedpyright"
    python_ruff = "ruff", -- or "ruff_lsp"
    typescript_lsp = "vtsls", -- or "tsgo"
    prettier_needs_config = false,
    blink_main = false,
  },

  editor = {
    -- Explicit personal defaults.
    expandtab = true,
    shiftwidth = 2,
    softtabstop = 2,
    tabstop = 2,

    -- Complete LazyVim v16 option catalog. Change nil to override upstream.
    autowrite = nil, -- LazyVim: true
    clipboard = nil, -- LazyVim: unnamedplus locally, OSC 52 over SSH
    completeopt = nil, -- LazyVim: "menu,menuone,noselect"
    conceallevel = nil, -- LazyVim: 2
    confirm = nil, -- LazyVim: true
    cursorline = nil, -- LazyVim: true
    fillchars = nil,
    foldlevel = nil, -- LazyVim: 99
    foldmethod = nil, -- LazyVim: "indent"
    foldtext = nil, -- LazyVim: ""
    formatexpr = nil,
    formatoptions = nil, -- LazyVim: "jcroqlnt"
    grepformat = nil,
    grepprg = nil, -- LazyVim: "rg --vimgrep"
    ignorecase = nil, -- LazyVim: true
    inccommand = nil, -- LazyVim: "nosplit"
    jumpoptions = nil, -- LazyVim: "view"
    laststatus = nil, -- LazyVim: 3
    linebreak = nil, -- LazyVim: true
    list = nil, -- LazyVim: true
    mouse = nil, -- LazyVim: "a"
    number = nil, -- LazyVim: true
    pumheight = nil, -- LazyVim: 10
    relativenumber = nil, -- LazyVim: true
    ruler = nil, -- LazyVim: false
    scrolloff = nil, -- LazyVim: 4
    sessionoptions = nil,
    shiftround = nil, -- LazyVim: true
    shortmess = nil,
    showmode = nil, -- LazyVim: false
    sidescrolloff = nil, -- LazyVim: 8
    signcolumn = nil, -- LazyVim: "yes"
    smartcase = nil, -- LazyVim: true
    smartindent = nil, -- LazyVim: true
    smoothscroll = nil, -- LazyVim: true
    spelllang = nil, -- LazyVim: { "en" }
    splitbelow = nil, -- LazyVim: true
    splitkeep = nil, -- LazyVim: "screen"
    splitright = nil, -- LazyVim: true
    statuscolumn = nil,
    termguicolors = nil, -- LazyVim: true
    timeoutlen = nil, -- LazyVim: 300 outside VS Code
    undofile = nil, -- LazyVim: true
    undolevels = nil, -- LazyVim: 10000
    updatetime = nil, -- LazyVim: 200
    virtualedit = nil, -- LazyVim: "block"
    wildmode = nil, -- LazyVim: "longest:full,full"
    winminwidth = nil, -- LazyVim: 5
    wrap = nil, -- LazyVim: false
  },

  appearance = {
    colorscheme = "tokyonight",
    theme_style = "moon", -- TokyoNight: "storm", "moon", "night", or "day"

    -- Terminal Neovim has no per-cell alpha channel. `transparent = true`
    -- inherits terminal opacity; false uses the theme's opaque RGB background.
    transparent = false,
    background = nil, -- Optional solid color, for example "#1a1b26"
    transparent_floats = false,
    popup_blend = 10, -- Completion menu opacity: 0 (opaque) to 100 (invisible)
    float_blend = 0, -- Floating window opacity: 0 (opaque) to 100 (invisible)
    terminal_colors = true,
    dim_inactive = false,

    lualine = {
      rounded_sections = true,
      component_separators = "",
      clock = true,
      clock_format = "%R",
    },
  },

  files = {
    -- Dotfiles are a first-class use case here, so show hidden files by default.
    show_hidden = true,
    show_ignored = false,
    follow_symlinks = false,
    explorer_follow_file = true,
  },

  interface = {
    indent_guides = true,
    smooth_scroll = true,
    notifications = true,
    noice = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
  },

  completion = {
    keymap_preset = "enter", -- Blink: "default", "super-tab", "enter", or "none"
    documentation = true,
    documentation_delay_ms = 200,
    ghost_text = true,
    signature_help = false,
    auto_brackets = true,
  },

  diagnostics = {
    underline = true,
    update_in_insert = false,
    virtual_text = true,
    virtual_text_spacing = 4,
    virtual_text_source = "if_many",
    virtual_text_prefix = "●", -- Use "icons" for severity icons.
    severity_sort = true,
    inlay_hints = true,
    inlay_hint_exclude = { "vue" },
    codelens = false,
    lsp_folds = true,
  },

  formatting = {
    timeout_ms = 3000,
    -- These merge into Conform. Extras retain ownership of their defaults.
    formatters_by_ft = {},
    formatters = {},
  },

  languages = {
    -- Filetype-local values win over the two-space editor default. Built-in
    -- EditorConfig runs later and can still provide project-specific values.
    filetype_options = {
      c = spaces(4),
      cpp = spaces(4),
      cuda = spaces(4),
      objc = spaces(4),
      objcpp = spaces(4),
      python = spaces(4),

      bash = spaces(2),
      dockerfile = spaces(2),
      javascript = spaces(2),
      javascriptreact = spaces(2),
      json = spaces(2),
      jsonc = spaces(2),
      lua = spaces(2),
      markdown = spaces(2),
      ["markdown.mdx"] = spaces(2),
      sh = spaces(2),
      tex = spaces(2),
      toml = spaces(2),
      typescript = spaces(2),
      typescriptreact = spaces(2),
      yaml = spaces(2),
      zsh = spaces(2),
    },

    -- Advanced nvim-lspconfig overrides, keyed by server name.
    servers = {},

    -- Additional parsers beyond LazyVim core and enabled language extras.
    treesitter = {},

    python = {
      venv_cache_file = vim.fn.stdpath("cache") .. "/venv-selector/venvs.json",
    },

    vimtex = {
      view_method = nil, -- Examples: "skim", "zathura", "sioyek"
      compiler_method = nil,
    },
  },

  tools = {
    -- Language extras add their own tools to this list automatically.
    ensure_installed = { "shellcheck", "shfmt", "stylua" },
  },

  -- Add personal mappings as:
  -- { mode = "n", lhs = "<leader>x", rhs = "<cmd>...<cr>", desc = "..." }
  keymaps = {},
}

-- Optional, untracked machine-specific overrides. Tables are merged by key;
-- list values replace their matching list.
local function merge(base, override)
  for key, value in pairs(override) do
    if
      type(value) == "table"
      and not vim.islist(value)
      and type(base[key]) == "table"
      and not vim.islist(base[key])
    then
      merge(base[key], value)
    else
      base[key] = vim.deepcopy(value)
    end
  end
  return base
end

local ok, local_preferences = pcall(require, "config.local")
if ok then
  preferences = merge(preferences, local_preferences)
elseif not tostring(local_preferences):find("module 'config.local' not found", 1, true) then
  error(local_preferences)
end

return preferences
