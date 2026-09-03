local preferences = require("config.preferences")

return {
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = { preset = preferences.completion.keymap_preset },
      completion = {
        accept = {
          auto_brackets = { enabled = preferences.completion.auto_brackets },
        },
        documentation = {
          auto_show = preferences.completion.documentation,
          auto_show_delay_ms = preferences.completion.documentation_delay_ms,
        },
        ghost_text = { enabled = preferences.completion.ghost_text },
      },
      signature = { enabled = preferences.completion.signature_help },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = preferences.diagnostics.underline,
        update_in_insert = preferences.diagnostics.update_in_insert,
        virtual_text = preferences.diagnostics.virtual_text and {
          spacing = preferences.diagnostics.virtual_text_spacing,
          source = preferences.diagnostics.virtual_text_source,
          prefix = preferences.diagnostics.virtual_text_prefix,
        } or false,
        severity_sort = preferences.diagnostics.severity_sort,
      },
      inlay_hints = {
        enabled = preferences.diagnostics.inlay_hints,
        exclude = preferences.diagnostics.inlay_hint_exclude,
      },
      codelens = { enabled = preferences.diagnostics.codelens },
      folds = { enabled = preferences.diagnostics.lsp_folds },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.default_format_opts = opts.default_format_opts or {}
      opts.default_format_opts.timeout_ms = preferences.formatting.timeout_ms
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters = opts.formatters or {}

      for filetype, formatters in pairs(preferences.formatting.formatters_by_ft) do
        opts.formatters_by_ft[filetype] = formatters
      end
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters, preferences.formatting.formatters)
    end,
  },
}
