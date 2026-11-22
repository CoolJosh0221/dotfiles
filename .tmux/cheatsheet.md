# tmux cheat sheet

Config: `~/dotfiles/.tmux.conf` (linked by `stow .`) · Prefix: `C-b` (press, release, then the key) · Reload: `prefix r`

New machine (e.g. macOS), once:

```sh
cd ~/dotfiles && stow .
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux            # then press prefix I to install plugins
```

Over SSH: copying (`y` or mouse) reaches your local clipboard through WezTerm (OSC 52).
tmux inside tmux: `C-b C-b <key>` sends the key to the inner tmux.

## Config & layout

| Key | Action |
|---|---|
| `prefix r` | Reload `~/.tmux.conf` and show a message |
| `prefix \|` / `prefix %` | Split side by side, in the current directory |
| `prefix -` / `prefix "` | Split top/bottom, in the current directory |
| `prefix c` | New window in the current directory |
| `prefix h` `j` `k` `l` | Move to the pane left / down / up / right |
| `prefix H` `J` `K` `L` | Resize the pane by 5 cells; hold to repeat |
| `prefix ;` | Go back to the previous pane (default). Default `prefix l` (previous window) is now pane-right; use `prefix n`/`p` or `prefix <number>` for windows |

## Long-running jobs

| Key | Action |
|---|---|
| `prefix m` | Turn the 30 s silence alert on/off for this window (window is highlighted amber when output stops) |
| `prefix R` | Turn keep-pane-after-exit on/off for this window (finished run's output stays visible) |
| `prefix P` | Start/stop logging this pane to `~/tmux-logs/<session>-<win>-<pane>-<YYYYmmdd-HHMMSS>.log` |
| `prefix d` | Detach (job keeps running); reattach with `tmux attach` or `tmux a -t <session>` |

Log files contain raw terminal output (color codes); read them with `less -R`.

## Copy mode (vi)

| Key | Action |
|---|---|
| `prefix [` | Enter copy mode (scroll back; mouse wheel also works) |
| `v` | Start selection |
| `C-v` | Toggle block (rectangle) selection |
| `y` | Copy to the system clipboard (wl-copy on Wayland, else xclip) and leave copy mode |
| mouse drag | Copies to the system clipboard on release |
| `/` / `?` | Search forward / backward |
| `q` | Leave copy mode |

## Persistence (tmux-resurrect / tmux-continuum)

| Key | Action |
|---|---|
| `prefix C-s` | Save sessions, layouts and directories now |
| `prefix C-r` | Restore the last save |

Auto-save every 15 min; auto-restore of layouts and directories on the first tmux start after a reboot. Programs are never relaunched.

## Plugins (TPM)

| Key | Action |
|---|---|
| `prefix I` | Install plugins listed in `~/.tmux.conf` |
| `prefix U` | Update plugins |
| `prefix M-u` | Remove plugins no longer listed |
