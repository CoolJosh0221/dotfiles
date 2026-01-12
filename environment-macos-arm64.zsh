# environment-macos-arm64.zsh

# Path configurations
export PATH=$PATH:/Applications/MacVim.app/Contents/bin
export PATH="/Users/josh/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
export PATH=~/apache-maven-3.8.7/bin:$PATH
export PATH=$PATH:/Users/josh/.spicetify
export PATH=$PATH:/usr/local/share/dotnet/dotnet
export PATH=$PATH:/Applications/kitty.app/Contents/MacOS
export PATH="/Users/josh/mambaforge/bin:$PATH"

# Conda initialization
__conda_setup="$('/Users/josh/mambaforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/josh/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/Users/josh/mambaforge/etc/profile.d/conda.sh"
    fi
fi
unset __conda_setup

if [ -f "/Users/josh/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "/Users/josh/mambaforge/etc/profile.d/mamba.sh"
fi

# CXX compiler
export CXX=/usr/bin/g++

# SDKMAN initialization
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Bun configurations
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/opt/libxslt/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/libxslt/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libxslt/include"

# Pixi configurations
export PATH=$PATH:/Users/josh/.pixi/bin
eval "$(pixi completion --shell zsh)"
export MODULAR_HOME="$HOME/.modular"
export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"

# Direnv hook
eval "$(direnv hook zsh)"

# PNPM configurations
export PNPM_HOME="/Users/josh/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Additional source commands
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /opt/homebrew/opt/modules/init/zsh
[ -f "/Users/josh/.ghcup/env" ] && . "/Users/josh/.ghcup/env"

# GCC colors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Aliases
alias vim=nvim
alias ls='eza --git --color=always --group-directories-first'
alias cd=z

# Cargo configurations
export CARGO_HTTP_MULTIPLEXING=false
eval "$(navi widget zsh)"
eval "$(zoxide init zsh)"
alias icat="kitty +kitten icat"
source $HOME/.cargo/env

# Powerlevel9K terminal integration
export POWERLEVEL9K_TERM_SHELL_INTEGRATION=true

alias g++='g++-15'
alias gcc='gcc-15'
