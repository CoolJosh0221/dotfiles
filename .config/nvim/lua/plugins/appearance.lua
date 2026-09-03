local preferences = require("config.preferences")
local appearance = preferences.appearance

return {
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = appearance.colorscheme
      opts.defaults = {
        autocmds = preferences.lazyvim.load_default_autocmds,
        keymaps = preferences.lazyvim.load_default_keymaps,
      }
      opts.news = {
        lazyvim = preferences.lazyvim.news_lazyvim,
        neovim = preferences.lazyvim.news_neovim,
      }
      opts.icons = vim.tbl_deep_extend("force", opts.icons or {}, preferences.lazyvim.icons)
      if preferences.lazyvim.kind_filter ~= nil then
        opts.kind_filter = preferences.lazyvim.kind_filter
      end
    end,
  },

  {
    "folke/tokyonight.nvim",
    opts = function(_, opts)
      opts.style = appearance.theme_style
      opts.transparent = appearance.transparent
      opts.terminal_colors = appearance.terminal_colors
      opts.dim_inactive = appearance.dim_inactive

      if appearance.transparent then
        opts.styles = vim.tbl_deep_extend("force", opts.styles or {}, {
          sidebars = "transparent",
          floats = appearance.transparent_floats and "transparent" or "dark",
        })
      end
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local config = appearance.lualine
      opts.options = opts.options or {}
      opts.sections = opts.sections or {}
      opts.options.component_separators = config.component_separators

      if config.rounded_sections then
        opts.options.section_separators = { left = "", right = "" }
        opts.sections.lualine_a = {
          { "mode", separator = { left = "" }, right_padding = 2 },
        }
        opts.sections.lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        }
      end

      if config.clock then
        opts.sections.lualine_z = {
          {
            function()
              return " " .. os.date(config.clock_format)
            end,
            separator = config.rounded_sections and { right = "" } or nil,
          },
        }
      else
        opts.sections.lualine_z = {}
      end
    end,
  },
}
