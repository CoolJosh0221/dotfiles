# macOS Apple Silicon environment
[[ "$OSTYPE" == darwin* ]] || return 0

# Keep PATH unique while preserving the order declared below.
typeset -U path PATH
typeset -a _preferred_paths

# Resolve Java 17 through macOS instead of hardcoding a Cellar path.
if [[ -x /usr/libexec/java_home ]]; then
  _java_home="$(/usr/libexec/java_home -v 17 2>/dev/null)"
  if [[ -n "$_java_home" ]]; then
    export JAVA_HOME="$_java_home"
  fi
  unset _java_home
fi

export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"
export MODULAR_HOME="$HOME/.modular"
export SDKMAN_DIR="$HOME/.sdkman"

_preferred_paths=(
  "$HOME/.local/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/opt/homebrew/opt/llvm/bin"
  "${JAVA_HOME:+$JAVA_HOME/bin}"
  "/opt/homebrew/opt/openjdk@17/bin"
  "/opt/homebrew/opt/node@18/bin"
  "$HOME/apache-maven-3.8.7/bin"
  "$BUN_INSTALL/bin"
  "/opt/homebrew/opt/libxslt/bin"
  "$HOME/.pixi/bin"
  "$MODULAR_HOME/pkg/packages.modular.com_mojo/bin"
  "$PNPM_HOME"
  "$HOME/mambaforge/bin"
  "/Applications/MacVim.app/Contents/bin"
  "$HOME/.spicetify"
  "/usr/local/share/dotnet"
  "/opt/homebrew/share/dotnet"
  "/Applications/kitty.app/Contents/MacOS"
)

# Add only directories that exist; do not leave dead PATH entries.
typeset -a _existing_paths
for _dir in "${_preferred_paths[@]}"; do
  [[ -n "$_dir" && -d "$_dir" ]] && _existing_paths+=("$_dir")
done
path=("${_existing_paths[@]}" "${path[@]}")
unset _preferred_paths _existing_paths _dir

# Keep interactive compiler aliases and build-system compiler variables aligned.
_gxx="$(command -v g++-16 2>/dev/null)"
_gcc="$(command -v gcc-16 2>/dev/null)"
[[ -n "$_gxx" ]] && export CXX="$_gxx"
[[ -n "$_gcc" ]] && export CC="$_gcc"
unset _gxx _gcc

# Consolidate build flags instead of overwriting earlier values repeatedly.
# The membership checks also prevent duplicates when ~/.zshrc is re-sourced.
if [[ -d /opt/homebrew/opt/llvm/lib && " ${LDFLAGS:-} " != *" -L/opt/homebrew/opt/llvm/lib "* ]]; then
  export LDFLAGS="-L/opt/homebrew/opt/llvm/lib${LDFLAGS:+ $LDFLAGS}"
fi
if [[ -d /opt/homebrew/opt/libxslt/lib && " ${LDFLAGS:-} " != *" -L/opt/homebrew/opt/libxslt/lib "* ]]; then
  export LDFLAGS="-L/opt/homebrew/opt/libxslt/lib${LDFLAGS:+ $LDFLAGS}"
fi
if [[ -d /opt/homebrew/opt/llvm/include && " ${CPPFLAGS:-} " != *" -I/opt/homebrew/opt/llvm/include "* ]]; then
  export CPPFLAGS="-I/opt/homebrew/opt/llvm/include${CPPFLAGS:+ $CPPFLAGS}"
fi
if [[ -d /opt/homebrew/opt/libxslt/include && " ${CPPFLAGS:-} " != *" -I/opt/homebrew/opt/libxslt/include "* ]]; then
  export CPPFLAGS="-I/opt/homebrew/opt/libxslt/include${CPPFLAGS:+ $CPPFLAGS}"
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export CARGO_HTTP_MULTIPLEXING=false
export OLLAMA_ORIGINS='*'

# Named directories
[[ -d "$HOME/Desktop/C++" ]] && hash -d cp="$HOME/Desktop/C++"
