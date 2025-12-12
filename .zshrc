# aliases
alias dof="$(which git) --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
if [ -x "$(command -v eza)" ]; then
	alias ls="eza --icons"
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
fi

# nvm settings (installed via homebrew)
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"  # This loads nvm
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# fzf settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pyenv-virtualenv init
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# enable starship
eval "$(starship init zsh)"

# enable  zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# enable zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

