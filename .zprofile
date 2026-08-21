# keep PATH free of duplicates for every shell, not just interactive ones
typeset -U path PATH

if [ -f "/opt/homebrew/bin/brew" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
	eval "$(/usr/local/bin/brew shellenv)"
fi

export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export BAT_THEME="Catppuccin Mocha"
export EZA_CONFIG_DIR="$HOME/.config/eza"

# pyenv: removed. It was installed via homebrew (/opt/homebrew/bin/pyenv), so
# PYENV_ROOT/bin never existed, and `pyenv versions` had nothing but `system` -
# the lazy stubs cost ~180ms on first python3 call and then resolved to
# /opt/homebrew/bin/python3 anyway. To use pyenv again: install a version
# (`pyenv install 3.13`) and add `eval "$(pyenv init - zsh)"` to .zshrc.

# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# comes last, so that work profile can overwrite the general profile
if [ -f "${HOME}/.zprofile_work" ]; then
	source "${HOME}/.zprofile_work"
fi

# Re-apply the toolchain PATH order defined in ~/.zshenv, after every other file
# has had its say. /etc/zprofile runs path_helper before us, which rebuilds PATH
# from /etc/paths* and appends the rest - that would otherwise leave sdkman's
# java behind /usr/bin's stub. Runs last so sdkman/nvm keep precedence.
(( $+functions[_toolchain_path] )) && _toolchain_path

