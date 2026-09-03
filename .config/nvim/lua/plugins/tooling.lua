local preferences = require("config.preferences")

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = preferences.tools.ensure_installed,
    },
  },
}
