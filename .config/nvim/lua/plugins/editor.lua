local preferences = require("config.preferences")

return {
  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = preferences.interface.indent_guides },
      notifier = { enabled = preferences.interface.notifications },
      scroll = { enabled = preferences.interface.smooth_scroll },
      picker = {
        sources = {
          files = {
            hidden = preferences.files.show_hidden,
            ignored = preferences.files.show_ignored,
            follow = preferences.files.follow_symlinks,
          },
          explorer = {
            hidden = preferences.files.show_hidden,
            ignored = preferences.files.show_ignored,
            follow = preferences.files.follow_symlinks,
            follow_file = preferences.files.explorer_follow_file,
          },
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      presets = preferences.interface.noice,
    },
  },
}
