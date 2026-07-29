# -----------------------------------------------------------------------------
# Powerlevel10k instant prompt
# Keep this near the top. Commands that may ask for input must go above it.
# -----------------------------------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -----------------------------------------------------------------------------
# Core Oh My Zsh configuration
# -----------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/dotfiles/.oh-my-zsh/custom"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Neovim is the default editor for tools and Zsh's external command-line editor.
# The `vi` shell command is configured separately below to launch regular Vim.
export EDITOR='nvim'
export VISUAL='nvim'

# Let WezTerm own tab titles instead of receiving long shell-generated titles.
DISABLE_AUTO_TITLE="true"

# Use one update policy. The previous file set both auto and reminder; the last
# setting silently won.
zstyle ':omz:update' mode reminder

# Shell history: large, shared, deduplicated, and stored under XDG state.
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
mkdir -p "${HISTFILE:h}"
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Keep Escape responsive in vi mode. Zsh measures KEYTIMEOUT in hundredths of a
# second, so 10 means 100 ms.
KEYTIMEOUT=10

# macOS toolchain and PATH definitions.
if [[ "$OSTYPE" == darwin* && -r "$HOME/environment-macos-arm64.zsh" ]]; then
  source "$HOME/environment-macos-arm64.zsh"
fi

# -----------------------------------------------------------------------------
# Plugin configuration must be set before Oh My Zsh loads the plugins.
# -----------------------------------------------------------------------------
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7f8cbb'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
POWERLEVEL9K_TERM_SHELL_INTEGRATION=true

# zsh-vi-mode starts in insert mode to lower transition cost, while preserving
# Vim-style normal/visual modes and mode-specific cursor shapes. Initialize it
# while sourcing so later widget plugins can be loaded deterministically.
ZVM_INIT_MODE=sourcing
ZVM_LAZY_KEYBINDINGS=false
ZVM_ESCAPE_KEYTIMEOUT=0.03
ZVM_VI_EDITOR='nvim'
zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
  ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
  ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
  ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLOCK
  ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
}

# zsh-syntax-highlighting is sourced manually at the true end of this file,
# after all custom ZLE widgets have been registered.
plugins=(
  git
  dirhistory
  sudo
  shellfirm
  zsh-autosuggestions
  zsh-vi-mode
)

source "$ZSH/oh-my-zsh.sh"

# Powerlevel10k's generated configuration remains the prompt source of truth.
[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# fzf and navi create ZLE widgets, so load them after synchronous zsh-vi-mode
# initialization but before zsh-syntax-highlighting.
[[ -r "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"
if (( $+commands[navi] )); then
  eval "$(navi widget zsh)"
fi
bindkey -M viins '^F' autosuggest-accept

# Edit the current command buffer in Neovim. In zsh-vi-mode normal mode, `vv`
# already opens the buffer in $ZVM_VI_EDITOR. Ctrl-X Ctrl-E is an additional
# binding that works from both insert and normal modes without replacing Vim's
# normal `v` visual-mode key.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^X^E' edit-command-line
bindkey -M vicmd '^X^E' edit-command-line

# -----------------------------------------------------------------------------
# Help and completion behavior
# -----------------------------------------------------------------------------
autoload -Uz run-help
for helper in run-help-git run-help-svn run-help-svk; do
  autoload -Uz "$helper" 2>/dev/null
done
alias help=run-help

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*'
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# -----------------------------------------------------------------------------
# Tool integrations
# -----------------------------------------------------------------------------
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -r "/opt/homebrew/opt/modules/init/zsh" ]] && source "/opt/homebrew/opt/modules/init/zsh"
[[ -r "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"

# zoxide provides the normal `z` command. Do not alias `cd=z`; that obscures
# standard cd semantics and can create recursion with alternative init modes.
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

# Cache Pixi completion instead of regenerating it on every shell startup.
if (( $+commands[pixi] )); then
  _zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  _pixi_completion="$_zsh_cache_dir/pixi-completion.zsh"
  mkdir -p "$_zsh_cache_dir"

  if [[ ! -s "$_pixi_completion" || "${commands[pixi]}" -nt "$_pixi_completion" ]]; then
    command pixi completion --shell zsh >| "$_pixi_completion" 2>/dev/null
  fi
  [[ -s "$_pixi_completion" ]] && source "$_pixi_completion"
  unset _zsh_cache_dir _pixi_completion
fi

# Lazy-load Conda/Mamba. This avoids running a large shell hook in every new
# pane while preserving `conda activate` and `mamba` when first used.
__load_conda() {
  unfunction conda mamba 2>/dev/null

  local conda_bin="$HOME/mambaforge/bin/conda"
  local conda_sh="$HOME/mambaforge/etc/profile.d/conda.sh"
  local mamba_sh="$HOME/mambaforge/etc/profile.d/mamba.sh"
  local hook

  if [[ -x "$conda_bin" ]]; then
    hook="$("$conda_bin" shell.zsh hook 2>/dev/null)"
    if [[ -n "$hook" ]]; then
      eval "$hook"
    elif [[ -r "$conda_sh" ]]; then
      source "$conda_sh"
    else
      print -u2 "conda: initialization files were not found"
      return 1
    fi
  elif [[ -r "$conda_sh" ]]; then
    source "$conda_sh"
  else
    print -u2 "conda: $HOME/mambaforge is not available"
    return 1
  fi

  [[ -r "$mamba_sh" ]] && source "$mamba_sh"
}

conda() {
  __load_conda || return
  conda "$@"
}

mamba() {
  __load_conda || return
  mamba "$@"
}

# SDKMAN performs network/startup work when sourced. Load it only when `sdk` is
# actually invoked.
sdk() {
  unfunction sdk
  if [[ -r "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk "$@"
  else
    print -u2 "sdk: SDKMAN is not installed at $SDKMAN_DIR"
    return 127
  fi
}

# TheFuck no longer runs before Powerlevel10k's instant-prompt preamble and is
# guarded so a missing executable does not print an error at startup.
if (( $+commands[thefuck] )); then
  eval "$(thefuck --alias)"
fi

# -----------------------------------------------------------------------------
# Aliases and functions
# -----------------------------------------------------------------------------
alias cls='clear'
alias vim='nvim'
alias v='nvim'

# Keep `vim` on Neovim while preserving `vi` as regular Vim. Prefer a
# Homebrew-linked Vim, then fall back to Apple's system Vim.
if [[ -x /opt/homebrew/bin/vim ]]; then
  alias vi='/opt/homebrew/bin/vim'
elif [[ -x /usr/local/bin/vim ]]; then
  alias vi='/usr/local/bin/vim'
elif [[ -x /usr/bin/vim ]]; then
  alias vi='/usr/bin/vim'
fi
if (( $+functions[z] )); then
  alias c='z'
fi

if (( $+commands[eza] )); then
  alias ls='eza --git --color=always --group-directories-first'
  alias ll='eza -lah --git --group-directories-first'
  alias la='eza -a --git --group-directories-first'
fi

# Homebrew installs GNU compilers with versioned executable names such as
# gcc-16 and g++-16. Select the highest installed numeric version dynamically,
# so a future Homebrew upgrade does not require editing this file.
if (( $+commands[brew] )); then
  _brew_prefix="$(command brew --prefix 2>/dev/null)"
  if [[ -n "$_brew_prefix" ]]; then
    typeset -a _brew_gcc_candidates _brew_gxx_candidates
    _brew_gcc_candidates=("$_brew_prefix/bin"/gcc-<->(Nn))
    _brew_gxx_candidates=("$_brew_prefix/bin"/g++-<->(Nn))

    if (( ${#_brew_gcc_candidates} )); then
      export CC="${_brew_gcc_candidates[-1]}"
      alias "gcc=${_brew_gcc_candidates[-1]}"
    fi

    if (( ${#_brew_gxx_candidates} )); then
      export CXX="${_brew_gxx_candidates[-1]}"
      alias "g++=${_brew_gxx_candidates[-1]}"
    fi
  fi
  unset _brew_prefix _brew_gcc_candidates _brew_gxx_candidates
fi

spf() {
  command spf -c "$HOME/.config/superfile/config.toml" "$@"
}

icat() {
  if [[ -n "$WEZTERM_PANE" ]] && (( $+commands[wezterm] )); then
    command wezterm imgcat "$@"
  elif (( $+commands[kitty] )); then
    command kitty +kitten icat "$@"
  else
    print -u2 'icat: neither wezterm nor kitty is available'
    return 127
  fi
}

# Fast, resumable GitHub downloads through the configured proxy.
gget() {
  if [[ $# -ne 1 ]]; then
    print -u2 'Usage: gget <GitHub URL>'
    return 2
  fi
  if ! (( $+commands[aria2c] )); then
    print -u2 'gget: aria2c is not installed'
    return 127
  fi

  local url="$1"
  local proxy='https://gh-proxy.com/'

  case "$url" in
    https://gh-proxy.com/*|https://gh-proxy.org/*)
      ;;
    https://github.com/*|https://raw.githubusercontent.com/*|\
    https://release-assets.githubusercontent.com/*|\
    https://objects.githubusercontent.com/*)
      url="${proxy}${url}"
      ;;
    *)
      print -u2 'gget: unsupported URL; expected a GitHub asset URL'
      return 2
      ;;
  esac

  command aria2c \
    --continue=true \
    --split=8 \
    --max-connection-per-server=8 \
    --min-split-size=1M \
    --file-allocation=none \
    --content-disposition=true \
    "$url"
}

# Clone only the latest state of a single branch.
gclone() {
  command git clone --depth=1 --single-branch "$@"
}

# zsh-syntax-highlighting must be sourced after every custom ZLE widget.
_zsh_highlighting="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -r "$_zsh_highlighting" ]] && source "$_zsh_highlighting"
unset _zsh_highlighting

