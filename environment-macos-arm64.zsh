# macOS Apple Silicon environment
[[ "$OSTYPE" == darwin* ]] || return 0

# Keep PATH unique while preserving the order declared below.
typeset -U path PATH
typeset -a _preferred_paths


# Prefer Homebrew's stable opt symlink for Java 17. This avoids spawning
# /usr/libexec/java_home in the common case while still falling back to it.
_java_home='/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home'
if [[ -d "$_java_home" ]]; then
  export JAVA_HOME="$_java_home"
elif [[ -x /usr/libexec/java_home ]]; then
  _java_home="$(/usr/libexec/java_home -v 17 2>/dev/null)"
  [[ -n "$_java_home" ]] && export JAVA_HOME="$_java_home"
fi
unset _java_home

export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"
export MODULAR_HOME="$HOME/.modular"
export SDKMAN_DIR="$HOME/.sdkman"
export NVM_DIR="$HOME/.nvm"

_preferred_paths=(
  "$HOME/.local/bin"
  "$HOME/go/bin"
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

# Compiler selection is handled later in ~/.zshrc, where the highest installed
# Homebrew GCC version is selected without executing `brew --prefix`.

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

# NVM is one of the most expensive common Zsh initializers. Since Homebrew's
# Node 18 is already on PATH above, load NVM only when `nvm` itself is used.
# After `nvm use ...`, that selected NVM Node takes normal precedence.
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  nvm() {
    unfunction nvm 2>/dev/null
    source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
    nvm "$@"
  }
fi

