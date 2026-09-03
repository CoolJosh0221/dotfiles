local preferences = require("config.preferences")

local filetype_group = vim.api.nvim_create_augroup("user_filetype_options", { clear = true })

for filetype, options in pairs(preferences.languages.filetype_options) do
  vim.api.nvim_create_autocmd("FileType", {
    group = filetype_group,
    pattern = filetype,
    callback = function(event)
      for option, value in pairs(options) do
        vim.bo[event.buf][option] = value
      end
    end,
    desc = "Apply personal options for " .. filetype,
  })
end

local function apply_background()
  local appearance = preferences.appearance
  if not appearance.transparent and not appearance.background then
    return
  end

  local background = appearance.transparent and "NONE" or appearance.background
  for _, group in ipairs({ "Normal", "NormalNC", "SignColumn", "EndOfBuffer" }) do
    local highlight = vim.api.nvim_get_hl(0, { name = group, link = false })
    highlight.bg = background
    vim.api.nvim_set_hl(0, group, highlight)
  end

  if appearance.transparent_floats then
    for _, group in ipairs({ "NormalFloat", "FloatBorder" }) do
      local highlight = vim.api.nvim_get_hl(0, { name = group, link = false })
      highlight.bg = "NONE"
      vim.api.nvim_set_hl(0, group, highlight)
    end
  end
end

local background_group = vim.api.nvim_create_augroup("user_background", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = background_group,
  callback = apply_background,
  desc = "Reapply the configured editor background",
})

apply_background()
