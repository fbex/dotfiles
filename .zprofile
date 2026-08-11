if [ -f "/opt/homebrew/bin/brew" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
	eval "$(/usr/local/bin/brew shellenv)"
fi

export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export BAT_THEME="Catppuccin Mocha"
export EZA_CONFIG_DIR="$HOME/.config/eza"

# pyenv (lazy loaded)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

_pyenv_lazy_load() {
	unset -f pyenv python python3 pip pip3
	eval "$(pyenv init --path)"
}

for _pyenv_cmd in pyenv python python3 pip pip3; do
	eval "${_pyenv_cmd}() { _pyenv_lazy_load; ${_pyenv_cmd} \"\$@\"; }"
done
unset _pyenv_cmd

# Added by Toolbox App
export PATH="$PATH:/Users/florian/Library/Application Support/JetBrains/Toolbox/scripts"

# comes last, so that work profile can overwrite the general profile
if [ -f "${HOME}/.zprofile_work" ]; then
	source "${HOME}/.zprofile_work"
fi

