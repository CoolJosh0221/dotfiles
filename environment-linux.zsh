# Linux environment
[[ "$OSTYPE" == linux* ]] || return 0

# Keep PATH unique while preserving the order declared below.
typeset -U path PATH
typeset -a _preferred_paths _existing_paths

export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
export MODULAR_HOME="$HOME/.modular"
export SDKMAN_DIR="$HOME/.sdkman"
export NVM_DIR="$HOME/.nvm"
export MAMBA_ROOT_PREFIX="$HOME/mambaforge"
export MAMBA_EXE="$MAMBA_ROOT_PREFIX/bin/mamba"

_preferred_paths=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  "/home/linuxbrew/.linuxbrew/bin"
  "/home/linuxbrew/.linuxbrew/sbin"
  "${JAVA_HOME:+$JAVA_HOME/bin}"
  "$HOME/apache-maven-3.8.7/bin"
  "$BUN_INSTALL/bin"
  "$HOME/.pixi/bin"
  "$MODULAR_HOME/pkg/packages.modular.com_mojo/bin"
  "$PNPM_HOME"
  "$MAMBA_ROOT_PREFIX/bin"
  "$HOME/.spicetify"
)

# Add only directories that exist; do not leave dead PATH entries.
for _dir in "${_preferred_paths[@]}"; do
  [[ -n "$_dir" && -d "$_dir" ]] && _existing_paths+=("$_dir")
done
path=("${_existing_paths[@]}" "${path[@]}")
unset _preferred_paths _existing_paths _dir

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export CARGO_HTTP_MULTIPLEXING=false
export OLLAMA_ORIGINS='*'

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
