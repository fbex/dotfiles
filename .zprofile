if [ -f "/opt/homebrew/bin/brew" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
	eval "$(/usr/local/bin/brew shellenv)"
fi

if [ -f "${HOME}/.zprofile_work" ]; then
	source "${HOME}/.zprofile_work"
fi

export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export BAT_THEME="Catppuccin Mocha"
export EZA_CONFIG_DIR="$HOME/.config/eza"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Added by Toolbox App
export PATH="$PATH:/Users/florian/Library/Application Support/JetBrains/Toolbox/scripts"

