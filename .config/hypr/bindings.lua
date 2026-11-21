local mainMod = "SUPER"

-- Core workflow.
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("wezterm"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/app-launcher"))
hl.bind(mainMod .. " + ALT + SPACE", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/clipboard-menu"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/power-menu"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/color-picker"))
hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/night-light"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + M", hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.workspace.toggle_special("minimized"))

-- Scrolling layout: C stacks/un-stacks a window in the adjacent column.
-- Width steps are thirds, halves, two-thirds, and full width.
hl.bind(mainMod .. " + C", hl.dsp.layout("consume_or_expel prev"))
hl.bind(mainMod .. " + MINUS", hl.dsp.layout("colresize -conf"))
hl.bind(mainMod .. " + EQUAL", hl.dsp.layout("colresize +conf"))
hl.bind(mainMod .. " + R", hl.dsp.layout("fit active"))
hl.bind(mainMod .. " + ALT + H", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + ALT + LEFT", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + ALT + RIGHT", hl.dsp.layout("swapcol r"))

-- Vim keys and arrows are exact mirrors; Super+L remains focus-right only.
local directions = {
	{ vim = "H", arrow = "LEFT", direction = "left" },
	{ vim = "J", arrow = "DOWN", direction = "down" },
	{ vim = "K", arrow = "UP", direction = "up" },
	{ vim = "L", arrow = "RIGHT", direction = "right" },
}

for _, item in ipairs(directions) do
	for _, key in ipairs({ item.vim, item.arrow }) do
		hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = item.direction }))
		hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = item.direction }))
	end
end

for workspace = 1, 9 do
	hl.bind(mainMod .. " + " .. workspace, hl.dsp.focus({ workspace = workspace }))
	hl.bind(mainMod .. " + SHIFT + " .. workspace, hl.dsp.window.move({ workspace = workspace }))
end

-- Create/switch to the next unused workspace; Shift moves the active window there.
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "emptynm" }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "emptynm" }))

-- Traverse existing workspaces without reaching for number keys.
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- One conventional terminal scratch workspace.
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratch"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratch" }))

-- Mouse movement and resizing.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots: keep quick capture simple; Super+Print opens annotation tools.
hl.bind("PRINT", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/screenshot region"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/screenshot full"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/screenshot annotate"))

-- SwayOSD adds feedback when installed; the helper falls back to wpctl/playerctl.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/osd-control volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/osd-control volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/osd-control volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/osd-control mic-mute"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/osd-control next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/osd-control play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/osd-control play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/osd-control previous"), { locked = true })

-- External-monitor brightness is on-demand DDC/CI, never a polling daemon.
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/monitor-brightness up"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/monitor-brightness down"), { repeating = true })
