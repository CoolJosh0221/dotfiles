# Neovim

This is a modular LazyVim configuration with one main control panel:

```text
lua/config/preferences.lua
```

Press `<leader>uP` inside Neovim to open it.

## Customization map

| What | Where |
| --- | --- |
| LazyVim globals and editor options | `lua/config/preferences.lua` |
| Theme, transparency, floats and lualine | `preferences.appearance` |
| Hidden files, picker and explorer | `preferences.files` |
| Completion | `preferences.completion` |
| Diagnostics and LSP UI | `preferences.diagnostics` |
| Formatters | `preferences.formatting` |
| Indentation by language | `preferences.languages.filetype_options` |
| LSP server overrides | `preferences.languages.servers` |
| Mason tools | `preferences.tools.ensure_installed` |
| Personal mappings | `preferences.keymaps` |
| Enabled LazyVim extras | `lazyvim.json` or `:LazyExtras` |

Values set to `nil` inherit the current LazyVim default. This is intentional:
upstream improvements continue to apply unless a preference is explicitly pinned.

## Background and transparency

The main controls are:

```lua
appearance = {
  transparent = false,
  background = nil,
  transparent_floats = false,
  popup_blend = 10,
  float_blend = 0,
}
```

Terminal Neovim can request the terminal's default background (`transparent =
true`) or an explicit RGB background (`transparent = false`). It cannot send a
custom alpha value for the main editor surface. `popup_blend` and `float_blend`
do support intermediate blending for popup menus and floating windows.

Use `background = "#rrggbb"` to force a particular solid background color. Leave
it `nil` to use the colorscheme's background.

## Indentation

The global default is two spaces. Python and C-family buffers use four spaces;
Lua, shell, web, data, Markdown and LaTeX buffers use two. Project-local
`.editorconfig` settings take precedence when present.

## Local-only settings

Copy `lua/config/local.lua.example` to `lua/config/local.lua`. The local file is
ignored by Git and deep-merged over the shared preferences:

```lua
return {
  appearance = { transparent = true },
}
```

## Advanced plugin customization

The files under `lua/plugins/` are ordinary lazy.nvim specs:

- `appearance.lua`: TokyoNight and lualine
- `editor.lua`: Snacks and Noice
- `coding.lua`: Blink, diagnostics and Conform
- `languages.lua`: LSP and Treesitter
- `tooling.lua`: Mason

Add a focused override there when a plugin option does not deserve a top-level
preference. LazyVim extras remain managed through `:LazyExtras`.

## Maintenance

- `:Lazy` manages plugins.
- `:LazyExtras` manages LazyVim extras.
- `:Mason` shows installed language tools.
- `:ConformInfo` shows the formatter selected for the current buffer.
- `:LspInfo` shows language servers attached to the current buffer.

Plugin versions remain pinned by `lazy-lock.json`. Updating dependencies is a
separate, explicit operation from editing this configuration.
