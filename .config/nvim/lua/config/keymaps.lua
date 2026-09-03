local preferences = require("config.preferences")

vim.keymap.set("n", "<leader>uP", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/lua/config/preferences.lua")
end, { desc = "Edit Neovim Preferences" })

for _, mapping in ipairs(preferences.keymaps) do
  local options = vim.deepcopy(mapping.opts or {})
  options.desc = mapping.desc or options.desc
  vim.keymap.set(mapping.mode, mapping.lhs, mapping.rhs, options)
end
