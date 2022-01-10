#!/usr/bin/env bash

# Setup dotfile config in the $HOME directory:
#   - 1: setup a bare git repository
#   - 2: checkout the saved dotfiles from origin
# 
# Once installation is done, the dotfiles repository can 
# be controlled as setup in the checked out .zshrc config.

git clone --bare https://github.com/fbex/dotfiles $HOME/.dotfiles
function dotfiles {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p .dotfiles-backup
dotfiles checkout
if [ $? = 0 ]; then
	echo "Checked out dotfiles.";
else
	echo "Backing up pre-existing dotfiles.";
	dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi;
dotfiles checkout
dotfiles config status.showUntrackedFiles no

