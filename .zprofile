if [ -f "/opt/homebrew/bin/brew" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
	eval "$(/usr/local/bin/brew shellenv)"
fi

if [ -f "${HOME}/.zprofile_work" ]; then
	source "${HOME}/.zprofile_work"
fi

export BAT_THEME="gruvbox-dark"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
