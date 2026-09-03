local preferences = require("config.preferences")

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      for server, config in pairs(preferences.languages.servers) do
        opts.servers[server] = vim.tbl_deep_extend("force", opts.servers[server] or {}, config)
      end
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, preferences.languages.treesitter)
    end,
  },

  {
    "linux-cultist/venv-selector.nvim",
    optional = true,
    opts = {
      cache = {
        file = preferences.languages.python.venv_cache_file,
      },
    },
  },
}
