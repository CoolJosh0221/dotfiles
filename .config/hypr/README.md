# Hyprland workstation baseline

This is a Hyprland 0.56 Lua configuration for the BenQ EX3410R and RTX 4090.
It coexists with the existing KDE Plasma/SDDM environment and does not replace
any KDE service or portal selector.

## Layout

- `hyprland.lua` — root config and session-only environment
- `fontconfig-hyprland.conf` — sharp grayscale/full-hinted text for Hyprland only
- `fontconfig-ui-font.conf` — the single selected desktop UI font
- `monitors.lua` — DP-3 at 3440×1440@144, scale 1, fullscreen-content VRR
- `input.lua` — keyboard, pointer, and native scrolling-column defaults
- `bindings.lua` — compact keyboard/mouse workflow
- `appearance.lua` — Tokyo Night Moon styling, animations, direct scanout policy
- `rules.lua` — fullscreen cleanup, game classification, optional tearing rules
- `autostart.lua` — the small session component stack
- `waybar/`, `swaync/`, `fuzzel/`, `wlogout/` — matching desktop component themes (`mako/` is retained only as a fallback)
- `hyprlock.conf`, `hypridle.conf`, `hyprpaper.conf` — lock/idle/wallpaper
- `xdph.conf` — caps portal screen capture at 60 FPS without limiting the monitor
- `scripts/` — focused helpers only

## Core bindings

| Binding | Action |
| --- | --- |
| Super + Return | WezTerm |
| Super + H/J/K/L | Focus left/down/up/right |
| Super + arrows | Focus left/down/up/right |
| Super + Shift + H/J/K/L | Move window left/down/up/right |
| Super + Shift + arrows | Move window left/down/up/right |
| Super + 1…9 | Switch workspace |
| Super + Shift + 1…9 | Move window to workspace |
| Super + 0 | Open the next unused workspace |
| Super + Shift + 0 | Move window to the next unused workspace |
| Super + mouse wheel | Previous/next existing workspace |
| Super + Q | Close window |
| Super + F | Fullscreen |
| Super + Space | Vicinae launcher (Fuzzel fallback) |
| Super + Shift + Space | Toggle floating |
| Super + E | Thunar file manager |
| Super + C | Stack/unstack the active window vertically in a column |
| Super + - / = | Narrow/widen the active scrolling column |
| Super + R | Fit the active scrolling column to the monitor |
| Super + Alt + H/L or left/right | Swap the active column left/right |
| Super + N | Toggle the notification center |
| Super + M | Park the active window on the window shelf |
| Super + Shift + M | Show/hide the window shelf |
| Super + S | Toggle terminal scratch workspace |
| Super + Shift + S | Move window to scratch workspace |
| Super + V | Clipboard history |
| Super + Ctrl + L | Lock session |
| Super + Shift + E | Power menu |
| Print / Shift + Print | Region / full screenshot |
| Super + mouse left/right | Move / resize window |

The purple `+` next to the workspace indicators opens the next unused dynamic
workspace. Scrolling columns default to half the ultrawide, so two development
contexts remain visible; `Super+C` consumes or expels a window to form a
vertical stack inside a column. The `⏻` button at the right edge opens the same
graphical power menu as `Super+Shift+E`; restart and shutdown require confirmation.

Waybar is deliberately three floating islands rather than many individual
pills. Its bell toggles SwayNC; right-clicking the bell toggles do-not-disturb.
The small window-shelf button near the workspace controls shows or hides parked
windows; right-clicking it parks the active window. Hyprland has no native
minimized-window state, so this provides the useful behavior without a separate
dock. Move a shelved window back with `Super+Shift+1…9`.
Waybar also shows a temporary privacy indicator whenever PipeWire reports an
active screen share or microphone capture.
Click NetworkManager Applet's network icon in Waybar's tray to choose a Wi-Fi
network or disconnect. `scripts/start-network-applet` starts `nm-applet --indicator`
with Hyprland; it uses the installed `network-manager-applet` package.
When Wi-Fi is disabled, an additional `Wi-Fi off` label appears; click that
label to enable the radio, then choose a network from the tray menu.
If either new component is temporarily unavailable, notifications fall back to
Mako and the power menu falls back to the existing Fuzzel list.

## Common maintenance

Reload after edits:

```sh
hyprctl reload
hyprctl configerrors
```

The Hyprland session uses grayscale antialiasing, native full hinting, and one
`Hyprland UI` alias to prevent colored glyph fringes while making 11 pt stems
as grid-aligned as practical. Applications that were already running must be fully
restarted to inherit this session-only setting; Plasma's font settings are
unchanged.

Choose an installed font from a Fuzzel list, or set one directly:

```sh
~/.config/hypr/scripts/set-ui-font
~/.config/hypr/scripts/set-ui-font "Hanken Grotesk"
```

This changes the Hyprland shell (bar, launcher, notifications, lock screen, and
Hyprland decorations), not WezTerm or Plasma. Restart an open application if it
does not pick up the new family immediately.

`Super+E` opens Thunar. Folder links also use Thunar only when
`XDG_CURRENT_DESKTOP=Hyprland`; Plasma's desktop-specific default remains
Dolphin. The global `~/.config/mimeapps.list` is deliberately untouched.
Thunar's directory context menu includes **Open WezTerm Here**.

Temporarily disable blur, shadows, and animations, then restore the config:

```sh
~/.config/hypr/scripts/effects off
~/.config/hypr/scripts/effects on
```

## Gaming policy

- `vrr = 3` activates VRR only for qualifying fullscreen video/game content.
- `direct_scanout = 2` lets Hyprland use automatic game-content direct scanout.
- Steam `steam_app_<appid>` and Gamescope windows are tagged as game content.
- Fullscreen windows receive no border, rounding, blur, shadow, opacity, or animation overhead.
- Tearing's master capability is on, but the opt-in list in `rules.lua` is empty,
  so no application can tear by default. Add only a verified class to
  `tearing_games` when explicitly wanted.

For GameMode's privileged governor helper, optionally authorize the account and
then log out and back in:

```sh
sudo usermod -a -G gamemode hosh
```

Use `gamemoderun %command%` as a Steam launch option only after `gamemoded -t`
passes for the new login.

## Wallpaper

Place one chosen image at `wallpapers/current.jpg`, `.jpeg`, `.png`, or `.webp`,
then run:

```sh
~/.config/hypr/scripts/apply-wallpaper
```

The current wallpaper and Tokyo Night Moon surfaces are deliberately
indigo/purple, which is the source of the desktop's blue cast—not an NVIDIA
color transform. Replace `wallpapers/current.png` and run the helper above if
you prefer a warmer image. The fallback is solid `#222436`.

## Sessions and remaining interactive checks

At SDDM, select `Hyprland` for this setup or `Plasma (Wayland)` for the unchanged
KDE fallback. A real user should still verify password unlock, Steam login and a
Proton game, fullscreen VRR/direct scanout, screen-share/file-chooser consent,
and one suspend/resume cycle.

## Dotfiles

The live directory is stored at `~/dotfiles/.config/hypr` and exposed through
`~/.config/hypr`. Runtime backups, setup work logs, and `wallpapers/current.*`
are intentionally ignored by Git; the personal wallpaper remains present on
this machine, while `wallpapers/README.md` documents how to supply one elsewhere.
