hl.config({
	input = {
		kb_layout = "us",
		-- Keyboard focus changes only by click or explicit focus bindings.
		follow_mouse = 0,
		repeat_rate = 35,
		repeat_delay = 250,
		numlock_by_default = true,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},

	-- Native 0.56 scrolling columns: two useful columns on the ultrawide by
	-- default, with explicit thirds/full-width steps and vertical stacking.
	scrolling = {
		fullscreen_on_one_column = false,
		column_width = 0.5,
		focus_fit_method = 1,
		follow_focus = true,
		follow_min_visible = 0.35,
		explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
		direction = "right",
		wrap_focus = true,
		wrap_swapcol = false,
	},
})
