export XDG_CONFIG_HOME="$HOME/.config"

# aliases
alias dof="$(which git) --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
if [ -x "$(command -v lazygit)" ]; then
  alias d="lazygit -g $HOME/.dotfiles -w $HOME"
fi
if [ -x "$(command -v eza)" ]; then
	alias ls="eza --icons=always --color=always --git"
	alias l="ls -la"
	alias ll="ls -l"
	alias la="ls -laagH"
	alias lg="ls -la --git"
	alias llg="ls -l --git"
	alias lt="l --tree"
	alias llt="ll --tree"
	alias ltl="lt --level"
	alias lltl="llt --level"
fi
if [ -x "$(command -v bat)" ]; then
	alias cat="bat"
fi
if [ -x "$(command -v nvim)" ]; then
	alias vim="nvim"
  export EDITOR="nvim" # required for yazi
fi

# yazi wrapper to enable changing the CWD
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# nvm settings (installed via homebrew) - lazy loaded, see below
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_HOMEBREW_PREFIX="$HOMEBREW_PREFIX"

_nvm_lazy_load() {
  unset -f nvm node npm npx
  [ -s "$NVM_LAZY_HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$NVM_LAZY_HOMEBREW_PREFIX/opt/nvm/nvm.sh" --no-use
  [ -s "$NVM_LAZY_HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$NVM_LAZY_HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
  nvm use --silent default >/dev/null 2>&1
}

for _nvm_cmd in nvm node npm npx; do
  eval "${_nvm_cmd}() { _nvm_lazy_load; ${_nvm_cmd} \"\$@\"; }"
done
unset _nvm_cmd

# completions (sdkman used to do this as a side effect)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi

# highlight the current entry while tabbing through completions + arrow-key nav
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zmodload zsh/complist
bindkey '^[[Z' reverse-menu-complete              # shift+tab: cycle backwards
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# fzf settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# set catppuccin theme
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# fzf previews
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# enable thefuck (static output of `thefuck --alias`, pasted here to avoid a python subprocess on every shell start)
fuck () {
	TF_PYTHONIOENCODING=$PYTHONIOENCODING;
	export TF_SHELL=zsh;
	export TF_ALIAS=fuck;
	TF_SHELL_ALIASES=$(alias);
	export TF_SHELL_ALIASES;
	TF_HISTORY="$(fc -ln -10)";
	export TF_HISTORY;
	export PYTHONIOENCODING=utf-8;
	TF_CMD=$(
		thefuck THEFUCK_ARGUMENT_PLACEHOLDER $@
	) && eval $TF_CMD;
	unset TF_HISTORY;
	export PYTHONIOENCODING=$TF_PYTHONIOENCODING;
	test -n "$TF_CMD" && print -s $TF_CMD
}

# enable zoxide
eval "$(zoxide init zsh)"
alias cd="z"

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# sdkman: set env directly instead of sourcing sdkman-init.sh, which forks ~20
# subprocesses (echo|tr, echo|grep per candidate) and costs ~85ms. The `sdk` CLI
# is lazy-loaded below.
export SDKMAN_DIR="$HOME/.sdkman"
export SDKMAN_CANDIDATES_DIR="$SDKMAN_DIR/candidates"
typeset -U path PATH
for _sdk_d in $SDKMAN_CANDIDATES_DIR/*/current(N); do
  _sdk_c=${${_sdk_d:h}:t}
  export ${(U)_sdk_c}_HOME="$_sdk_d"
  if [[ -d $_sdk_d/bin ]]; then path=("$_sdk_d/bin" $path); else path=("$_sdk_d" $path); fi
done
unset _sdk_d _sdk_c

# `sdk` itself is rare and slow to set up - load the real thing on first use.
sdk() { unset -f sdk; source "$SDKMAN_DIR/bin/sdkman-init.sh"; sdk "$@"; }

# ...but keep its completion eagerly (0.5ms), so `sdk <TAB>` works before first use.
autoload -U bashcompinit && bashcompinit
source "$SDKMAN_DIR/contrib/completion/bash/sdk"

# enable starship
eval "$(starship init zsh)"

# enable  zsh-autosuggestions
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# enable zsh-syntax-highlighting
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

