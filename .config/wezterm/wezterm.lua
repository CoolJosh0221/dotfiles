-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 14
config.color_scheme = "tokyonight_moon"
config.window_decorations = "RESIZE"

local emoji_font = "Noto Color Emoji"
local chinese_font = "Noto Sans TC"

config.font = wezterm.font_with_fallback({
	{
		family = "IosevkaKanade Nerd Font",
		weight = 500,
	},
	emoji_font,
	chinese_font,
})

config.window_background_opacity = 0.96
config.macos_window_background_blur = 10
config.enable_scroll_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.colors = {
	cursor_bg = "#7aa2f7",
	cursor_border = "#7aa2f7",
}

config.keys = {
	{
		key = "E",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

--- SSH
config.ssh_domains = {
	{
		name = "eos4090",
		remote_address = "eos4090.tail8b6ee8.ts.net",
		username = "hosh",
	},
}

return config
