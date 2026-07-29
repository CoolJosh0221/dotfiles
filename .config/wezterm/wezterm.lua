local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local config = wezterm.config_builder()

-- ---------------------------------------------------------------------------
-- Palette: Tokyo Night Moon, with a restrained glass UI layer.
-- ---------------------------------------------------------------------------
local palette = {
	background = "#222436",
	foreground = "#c8d3f5",
	muted = "#7a88cf",
	subtle = "#444a73",
	surface = "#1e2030",
	surface_alt = "#2f334d",
	blue = "#82aaff",
	cyan = "#86e1fc",
	purple = "#c099ff",
	yellow = "#ffc777",
	red = "#ff757f",
	green = "#c3e88d",
}

-- ---------------------------------------------------------------------------
-- Window and typography
-- ---------------------------------------------------------------------------
config.initial_cols = 120
config.initial_rows = 28

config.font = wezterm.font_with_fallback({
	{
		family = "IosevkaKanade Nerd Font",
		weight = 500,
	},
	"Noto Color Emoji",
	"Noto Sans TC",
})
config.font_size = 15
config.line_height = 1.15
config.color_scheme = "tokyonight_moon"

-- Borderless Linux-like window, but retain resize handles and the macOS shadow.
config.window_decorations = "RESIZE|MACOS_FORCE_ENABLE_SHADOW"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 35
config.window_padding = {
	left = 12,
	right = 14,
	top = 9,
	bottom = 8,
}

config.default_cursor_style = "SteadyBar"
config.hide_mouse_cursor_when_typing = true
config.inactive_pane_hsb = {
	saturation = 0.90,
	brightness = 0.82,
}

config.enable_scroll_bar = true
config.scrollback_lines = 50000
config.alternate_buffer_wheel_scroll_speed = 2
config.mouse_wheel_scrolls_tabs = false
config.adjust_window_size_when_changing_font_size = false
config.switch_to_last_active_tab_when_closing_tab = true
config.unzoom_on_switch_pane = true

-- Brief cursor flash instead of a sound.
config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_duration_ms = 60,
	fade_out_duration_ms = 80,
	fade_in_function = "EaseIn",
	fade_out_function = "EaseOut",
	target = "CursorColor",
}

config.colors = {
	cursor_bg = palette.blue,
	cursor_border = palette.blue,
	cursor_fg = palette.background,
	selection_bg = palette.subtle,
	selection_fg = palette.foreground,
	scrollbar_thumb = palette.subtle,
	split = palette.subtle,
	visual_bell = palette.yellow,
	compose_cursor = palette.yellow,

	copy_mode_active_highlight_bg = { Color = palette.blue },
	copy_mode_active_highlight_fg = { Color = palette.background },
	copy_mode_inactive_highlight_bg = { Color = palette.subtle },
	copy_mode_inactive_highlight_fg = { Color = palette.foreground },
	quick_select_label_bg = { Color = palette.yellow },
	quick_select_label_fg = { Color = palette.background },
	quick_select_match_bg = { Color = palette.purple },
	quick_select_match_fg = { Color = palette.background },

	tab_bar = {
		background = palette.surface,
		active_tab = {
			bg_color = palette.blue,
			fg_color = palette.background,
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = palette.surface_alt,
			fg_color = palette.foreground,
		},
		inactive_tab_hover = {
			bg_color = palette.subtle,
			fg_color = palette.foreground,
		},
		new_tab = {
			bg_color = palette.surface,
			fg_color = palette.muted,
		},
		new_tab_hover = {
			bg_color = palette.subtle,
			fg_color = palette.foreground,
		},
	},
}

config.command_palette_bg_color = palette.surface
config.command_palette_fg_color = palette.foreground
config.command_palette_rows = 18

-- ---------------------------------------------------------------------------
-- Tabs and status
-- ---------------------------------------------------------------------------
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.show_tab_index_in_tab_bar = false
config.tab_max_width = 34
config.status_update_interval = 1000

local function basename(path)
	if not path or path == "" then
		return nil
	end
	return path:gsub("(.*[/\\])(.*)", "%2")
end

local function uri_file_path(uri)
	if not uri then
		return nil
	end

	if type(uri) == "userdata" then
		return uri.file_path
	end

	local value = tostring(uri)
	return value:gsub("^file://[^/]*", "")
end

local function clean_domain_name(domain)
	if not domain or domain == "" then
		return nil
	end
	if domain == "local" or domain == "local-mux" then
		return "LOCAL"
	end
	domain = domain:gsub("^SSHMUX:", "SSH ")
	domain = domain:gsub("^SSH:", "SSH ")
	return domain
end

local function tab_title(tab)
	if tab.tab_title and #tab.tab_title > 0 then
		return tab.tab_title
	end

	local pane = tab.active_pane
	local domain = clean_domain_name(pane.domain_name)
	if domain and domain ~= "LOCAL" then
		return domain
	end

	local process = basename(pane.foreground_process_name)
	if process and process ~= "zsh" and process ~= "bash" and process ~= "fish" then
		return process
	end

	local cwd = basename(uri_file_path(pane.current_working_dir))
	if cwd and cwd ~= "" then
		return cwd
	end

	return pane.title or "shell"
end

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
	local title = tab_title(tab)
	local marker = tab.active_pane.has_unseen_output and "● " or ""
	local zoom = tab.active_pane.is_zoomed and "Z " or ""
	local index = tostring(tab.tab_index + 1)

	local text = string.format(" %s%s%s  %s ", marker, zoom, index, title)
	text = wezterm.truncate_right(text, math.max(8, max_width - 2))

	local bg
	local fg
	if tab.is_active then
		bg = palette.blue
		fg = palette.background
	elseif hover then
		bg = palette.subtle
		fg = palette.foreground
	else
		bg = palette.surface_alt
		fg = palette.foreground
	end

	return {
		{ Background = { Color = palette.surface } },
		{ Foreground = { Color = bg } },
		{ Text = "" },
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
		{ Text = text },
		{ Background = { Color = palette.surface } },
		{ Foreground = { Color = bg } },
		{ Text = "" },
	}
end)

wezterm.on("update-status", function(window, pane)
	local cells = {}

	if window:leader_is_active() then
		table.insert(cells, "LEADER")
	end

	local key_table = window:active_key_table()
	if key_table then
		table.insert(cells, string.upper(key_table))
	end

	table.insert(cells, string.upper(window:active_workspace()))

	local domain = clean_domain_name(pane:get_domain_name())
	if domain and domain ~= "LOCAL" then
		table.insert(cells, domain)
	end

	table.insert(cells, wezterm.strftime("%H:%M"))

	window:set_right_status(wezterm.format({
		{ Foreground = { Color = palette.muted } },
		{ Text = "  " .. table.concat(cells, "  •  ") .. "  " },
	}))
end)

-- ---------------------------------------------------------------------------
-- Hyperlinks and Quick Select
-- ---------------------------------------------------------------------------
config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
	regex = [[\b(localhost:\d{2,5})\b]],
	format = "http://$1",
})

table.insert(config.hyperlink_rules, {
	regex = [[\b(127\.0\.0\.1:\d{2,5})\b]],
	format = "http://$1",
})

config.quick_select_patterns = {
	-- Source locations such as src/main.cpp:42 or main.py:18:7
	[[\b[A-Za-z0-9_./~+%-]+\.(?:c|cc|cpp|cxx|h|hh|hpp|py|rs|go|java|kt|lua|sh|zsh|md|tex):\d+(?::\d+)?\b]],
	-- Git hashes
	[[\b[0-9a-f]{7,40}\b]],
	-- AtCoder-style problem identifiers
	[[\b(?:ABC|ARC|AGC)\d{3}_[A-Z]\b]],
	-- Codeforces-style identifiers
	[[\bCF\s*\d+[A-Z]\d?\b]],
}

config.quick_select_alphabet = "arstneioqwfpbjluyzxcdvkmgh"

-- ---------------------------------------------------------------------------
-- Persistent local mux and SSH domains
-- ---------------------------------------------------------------------------
config.unix_domains = {
	{
		name = "local-mux",
	},
}
config.default_workspace = "scratch"
config.default_gui_startup_args = { "connect", "local-mux" }

-- Do not set config.ssh_domains here. WezTerm will read ~/.ssh/config and
-- expose both SSH:<host> and SSHMUX:<host> domains automatically.

-- ---------------------------------------------------------------------------
-- Workspaces and project layouts
-- Layouts use the active pane's current directory, so they are project-agnostic.
-- ---------------------------------------------------------------------------
local function current_cwd(pane)
	return uri_file_path(pane:get_current_working_dir()) or wezterm.home_dir
end

local function workspace_exists(name)
	for _, existing in ipairs(mux.get_workspace_names()) do
		if existing == name then
			return true
		end
	end
	return false
end

local function switch_or_create_workspace(name, create)
	return wezterm.action_callback(function(window, pane)
		if workspace_exists(name) then
			window:perform_action(act.SwitchToWorkspace({ name = name }), pane)
			return
		end

		create(pane)
		mux.set_active_workspace(name)
	end)
end

local create_cp_workspace = switch_or_create_workspace("cp", function(source_pane)
	local cwd = current_cwd(source_pane)
	local domain = { DomainName = source_pane:get_domain_name() }
	local tab, editor, mux_window = mux.spawn_window({
		workspace = "cp",
		cwd = cwd,
		domain = domain,
	})
	tab:set_title("cp")

	local run = editor:split({
		direction = "Right",
		size = 0.34,
		cwd = cwd,
	})
	run:split({
		direction = "Bottom",
		size = 0.50,
		cwd = cwd,
	})
	editor:activate()
end)

local create_research_workspace = switch_or_create_workspace("research", function(source_pane)
	local cwd = current_cwd(source_pane)
	local domain = { DomainName = source_pane:get_domain_name() }
	local code_tab, code_pane, mux_window = mux.spawn_window({
		workspace = "research",
		cwd = cwd,
		domain = domain,
	})
	code_tab:set_title("code")

	local experiments_tab, experiments_pane = mux_window:spawn_tab({
		cwd = cwd,
		domain = domain,
	})
	experiments_tab:set_title("experiments")
	experiments_pane:split({
		direction = "Bottom",
		size = 0.35,
		cwd = cwd,
	})

	local notes_tab = mux_window:spawn_tab({
		cwd = cwd,
		domain = domain,
	})
	notes_tab:set_title("notes")
	code_pane:activate()
end)

local create_remote_workspace = switch_or_create_workspace("remote", function()
	local local_domain = { DomainName = "local-mux" }
	local shell_tab, shell_pane, mux_window = mux.spawn_window({
		workspace = "remote",
		domain = local_domain,
		cwd = wezterm.home_dir,
		args = { "ssh", "eos4090" },
	})
	shell_tab:set_title("eos4090")

	local monitor_tab = mux_window:spawn_tab({
		domain = local_domain,
		cwd = wezterm.home_dir,
		args = { "ssh", "eos4090" },
	})
	monitor_tab:set_title("monitor")
	shell_pane:activate()
end)

local rename_tab = act.PromptInputLine({
	description = "Rename current tab",
	action = wezterm.action_callback(function(window, pane, line)
		if line and line ~= "" then
			window:active_tab():set_title(line)
		end
	end),
})

local create_named_workspace = act.PromptInputLine({
	description = "Create or switch to workspace",
	action = wezterm.action_callback(function(window, pane, line)
		if line and line ~= "" then
			window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
		end
	end),
})

-- ---------------------------------------------------------------------------
-- Vim-oriented leader and modal controls
-- ---------------------------------------------------------------------------
config.leader = {
	key = "Space",
	mods = "CTRL|SHIFT",
	timeout_milliseconds = 1200,
}

config.keys = {
	-- Send the literal leader chord by pressing Leader then Space.
	{
		key = "Space",
		mods = "LEADER",
		action = act.SendKey({ key = "Space", mods = "CTRL|SHIFT" }),
	},

	-- Panes: Vim directions and Vim split vocabulary.
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{
		key = "s",
		mods = "LEADER",
		action = act.SplitPane({ direction = "Down", size = { Percent = 50 } }),
	},
	{
		key = "v",
		mods = "LEADER",
		action = act.SplitPane({ direction = "Right", size = { Percent = 50 } }),
	},
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
			timeout_milliseconds = 3000,
		}),
	},
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "X", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "p", mods = "LEADER", action = act.PaneSelect({ mode = "Activate" }) },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },

	-- Tabs.
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "e", mods = "LEADER", action = rename_tab },

	-- Search, copy mode, Quick Select, and the central fuzzy launcher.
	{ key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "y", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "f", mods = "LEADER", action = act.QuickSelect },
	{
		key = "Space",
		mods = "LEADER|SHIFT",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|TABS|WORKSPACES|DOMAINS|LAUNCH_MENU_ITEMS|COMMANDS|KEY_ASSIGNMENTS",
		}),
	},
	{
		key = "d",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "FUZZY|DOMAINS" }),
	},

	-- Workspaces.
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	{ key = "W", mods = "LEADER", action = create_named_workspace },
	{ key = "C", mods = "LEADER", action = create_cp_workspace },
	{ key = "R", mods = "LEADER", action = create_research_workspace },
	{ key = "M", mods = "LEADER", action = create_remote_workspace },

	-- Explicitly safe close behavior for familiar macOS shortcuts.
	{ key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = true }) },
}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 3 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 3 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 3 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 3 }) },
		{ key = "H", action = act.AdjustPaneSize({ "Left", 8 }) },
		{ key = "J", action = act.AdjustPaneSize({ "Down", 8 }) },
		{ key = "K", action = act.AdjustPaneSize({ "Up", 8 }) },
		{ key = "L", action = act.AdjustPaneSize({ "Right", 8 }) },
		{ key = "Enter", action = act.PopKeyTable },
		{ key = "Escape", action = act.PopKeyTable },
	},
}

config.window_close_confirmation = "AlwaysPrompt"
config.skip_close_confirmation_for_processes_named = {
	"bash",
	"sh",
	"zsh",
	"fish",
	"nu",
}

return config
