-- Keep ordinary application maximize requests from disrupting the tiling layout.
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fullscreen should be clean, opaque, idle-safe, and cheap to composite.
hl.window_rule({
	name = "clean-fullscreen",
	match = { fullscreen = true },
	border_size = 0,
	rounding = 0,
	no_shadow = true,
	no_blur = true,
	no_anim = true,
	opacity = "1.0 override 1.0 override 1.0 override",
	idle_inhibit = "fullscreen",
})

-- Tag only verified game classes. This lets vrr=3 and direct_scanout=2
-- activate for fullscreen game content without forcing either desktop-wide.
local game_classes = {
	"^osu!$", -- native Wayland app ID from osu-lazer-bin 2026.804.2
	"^steam_app_[0-9]+$",
	"^gamescope$",
}

for index, class in ipairs(game_classes) do
	hl.window_rule({
		name = "game-content-" .. index,
		match = { class = class },
		content = "game",
	})
end

-- Experimental tearing is intentionally opt-in. Add a verified game class
-- here only if latency matters more than tear-free presentation.
local tearing_games = {
	-- "^cs2$",
}

for index, class in ipairs(tearing_games) do
	hl.window_rule({
		name = "tearing-opt-in-" .. index,
		match = { class = class },
		immediate = true,
	})
end

-- Small control panels behave better as centered utility windows.
hl.window_rule({
	name = "float-control-panels",
	match = { class = "^(pavucontrol|nm-connection-editor|blueman-manager)$" },
	float = true,
	center = true,
	opacity = "0.98 override 0.95 override",
})

-- MEGAsync's app-owned tray popup receives unusable global coordinates on
-- Wayland. The Hyprland-only launcher makes it a regular window, and the
-- compositor anchors that window below the right side of the bar.
hl.window_rule({
	name = "place-megasync-panel",
	match = { class = "^(mega|megasync|MEGAsync|nz\\.mega\\.MEGAsync)$" },
	float = true,
	move = { "monitor_w-window_w-18", "52" },
})

-- Opaque utility surfaces get a restrained glass treatment. Development apps
-- with their own alpha (WezTerm and VS Code) are deliberately excluded.
hl.window_rule({
	name = "glass-file-manager",
	match = { class = "^thunar$" },
	opacity = "0.98 override 0.95 override",
})

hl.window_rule({
	name = "float-authentication",
	match = { title = "^(Authenticate|Authentication Required)$" },
	float = true,
	center = true,
})

-- Retain the workaround shipped by Hyprland 0.56 for empty XWayland drag windows.
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.layer_rule({
	name = "blur-waybar",
	match = { namespace = "^waybar$" },
	blur = true,
	ignore_alpha = 0.20,
	no_anim = true,
})

hl.layer_rule({
	name = "blur-fuzzel",
	match = { namespace = "^launcher$" },
	blur = true,
	ignore_alpha = 0.20,
	no_anim = true,
})

hl.layer_rule({
	name = "notification-motion-policy",
	match = { namespace = "^(notifications|mako|swaync-notification-window|swaync-control-center)$" },
	blur = true,
	ignore_alpha = 0.20,
	no_anim = true,
})
