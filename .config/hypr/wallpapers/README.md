# Wallpaper convention

Place one spoiler-free Madoka/Homura or Komari image here as one of:

- `current.jpg`
- `current.jpeg`
- `current.png`
- `current.webp`

Use a 21:9 image near 3440×1440 when possible. Dark purple/blue compositions with
clear negative space work best with the Tokyo Night Moon UI.

After adding or replacing the file, run:

```sh
~/.config/hypr/scripts/apply-wallpaper
```

Until a file exists, the compositor intentionally uses solid `#222436`.

The helper uses Hyprpaper's `fill` mode so the complete composition remains
visible without empty bars. Images with a different aspect ratio are stretched
slightly; use a 3440×1440 source if exact geometry matters.
