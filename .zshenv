# comes first, so the work profile can be overridden below if needed
if [ -f "${HOME}/.zshenv_work" ]; then
	source "${HOME}/.zshenv_work"
fi

export XDG_CONFIG_HOME="$HOME/.config"
(( $+commands[nvim] )) && export EDITOR="nvim"   # also required by yazi

# ~/.zprofile gets the real value from `brew shellenv`, but that is login-only.
# ~/.zshrc reads this var in four places (both ZLE plugins and the lazy nvm
# wrappers), and those silently no-op in non-login interactive shells without it.
export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-/opt/homebrew}

# Toolchains: *_HOME vars and PATH entries must exist in EVERY shell, not just
# interactive ones - `./gradlew`, Maven and IDE-less builds read JAVA_HOME, and
# non-login shells (GUI tool shells, IDE run configs, launchd) read only this file.
# ~/.zprofile calls _toolchain_path again, because /etc/zprofile's path_helper
# runs after us and would otherwise leave these entries behind /usr/bin.
export SDKMAN_DIR="$HOME/.sdkman"
export SDKMAN_CANDIDATES_DIR="$SDKMAN_DIR/candidates"
export NVM_DIR="$HOME/.nvm"

_toolchain_path() {
	typeset -gU path PATH   # -g: without it these stay local and are lost on return
	local d c dflt
	local -a node_dirs

	# nvm: eagerly put the default node version's bin/ on PATH (cheap: a glob and
	# a fork-free $(<file), no subprocess), so node/npm and global CLI tools
	# installed via npm resolve immediately. Loading nvm.sh stays lazy in ~/.zshrc.
	if [[ -s $NVM_DIR/alias/default ]]; then
		dflt=$(<$NVM_DIR/alias/default)
		node_dirs=($NVM_DIR/versions/node/${dflt}*(N/n))
		[[ -n $node_dirs[-1] ]] && path=($node_dirs[-1]/bin $path)
	fi

	# sdkman: set env directly instead of sourcing sdkman-init.sh, which forks ~20
	# subprocesses and costs ~85ms. The `sdk` CLI is lazy-loaded in ~/.zshrc.
	for d in $SDKMAN_CANDIDATES_DIR/*/current(N); do
		c=${${d:h}:t}
		export ${(U)c}_HOME="$d"
		if [[ -d $d/bin ]]; then path=("$d/bin" $path); else path=("$d" $path); fi
	done
}
_toolchain_path

