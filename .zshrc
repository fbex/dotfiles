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
export NVM_LAZY_HOMEBREW_PREFIX="$(brew --prefix)"

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

# pyenv-virtualenv init
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# enable thefuck
eval $(thefuck --alias)

# enable zoxide
eval "$(zoxide init zsh)"
alias cd="z"

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# enable starship
eval "$(starship init zsh)"

# enable  zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# enable zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

