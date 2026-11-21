-- Tokyo Night Moon: restrained translucency for normal work, opaque fullscreen.
hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 10,
		border_size = 1,
		col = {
			active_border = {
				colors = { "rgba(82aaffff)", "rgba(c099ffff)" },
				angle = 45,
			},
			inactive_border = "rgba(444a7370)",
		},
		resize_on_border = true,
		-- This is only the master switch. No window tears without an explicit
		-- immediate=true rule in rules.lua.
		allow_tearing = true,
		layout = "scrolling",
	},

	decoration = {
		rounding = 12,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 0.98,
		fullscreen_opacity = 1.0,
		dim_inactive = true,
		dim_strength = 0.045,
		shadow = {
			enabled = true,
			range = 10,
			render_power = 2,
			color = "rgba(1e2030b3)",
			color_inactive = "rgba(1e203080)",
			offset = { 0, 3 },
		},
		blur = {
			enabled = true,
			size = 6,
			passes = 2,
			vibrancy = 0.10,
			noise = 0.01,
			popups = true,
			popups_ignorealpha = 0.20,
		},
	},

	animations = {
		enabled = true,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		background_color = "rgb(222436)",
		font_family = "Hyprland UI",
	},

	render = {
		-- Automatic and limited to game content; set to 0 if a game misbehaves.
		direct_scanout = 2,
	},

	binds = {
		workspace_back_and_forth = true,
	},
})

-- Fast cubic curves: responsive without springs, bounce, or wobble.
hl.curve("tn_fast", { type = "bezier", points = { { 0.22, 1 }, { 0.36, 1 } } })
hl.curve("tn_linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 8, bezier = "tn_fast" })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "tn_fast" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 7, bezier = "tn_fast", style = "popin 96%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "tn_linear", style = "popin 96%" })
hl.animation({ leaf = "fade", enabled = true, speed = 8, bezier = "tn_fast" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "tn_fast" })
hl.animation({ leaf = "layers", enabled = true, speed = 8, bezier = "tn_fast" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "tn_fast", style = "slide" })
