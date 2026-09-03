-- Loaded after LazyVim's defaults and before plugin setup.
local preferences = require("config.preferences")

local globals = {
  mapleader = "mapleader",
  maplocalleader = "maplocalleader",
  autoformat = "autoformat",
  snacks_animate = "snacks_animate",
  picker = "lazyvim_picker",
  completion = "lazyvim_cmp",
  ai_cmp = "ai_cmp",
  root_spec = "root_spec",
  root_lsp_ignore = "root_lsp_ignore",
  deprecation_warnings = "deprecation_warnings",
  trouble_lualine = "trouble_lualine",
  markdown_recommended_style = "markdown_recommended_style",
  python_lsp = "lazyvim_python_lsp",
  python_ruff = "lazyvim_python_ruff",
  typescript_lsp = "lazyvim_ts_lsp",
  prettier_needs_config = "lazyvim_prettier_needs_config",
  blink_main = "lazyvim_blink_main",
}

for preference, global in pairs(globals) do
  local value = preferences.lazyvim[preference]
  if value ~= nil then
    vim.g[global] = value
  end
end

for option, value in pairs(preferences.editor) do
  if value ~= nil then
    vim.opt[option] = value
  end
end

if preferences.appearance.popup_blend ~= nil then
  vim.opt.pumblend = preferences.appearance.popup_blend
end

if preferences.appearance.float_blend ~= nil then
  vim.opt.winblend = preferences.appearance.float_blend
end

local vimtex = preferences.languages.vimtex
if vimtex.view_method then
  vim.g.vimtex_view_method = vimtex.view_method
end
if vimtex.compiler_method then
  vim.g.vimtex_compiler_method = vimtex.compiler_method
end
