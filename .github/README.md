# Dotfiles

This repository contains all my shared dotfiles, configs and scripts.
It also contains a set of scripts to install the dotfiles along with additional software on new systems.

Dotfile management is done via the git bare repository method mentioned [here](https://www.atlassian.com/git/tutorials/dotfiles).

## Install dotfiles

Requirements:
- Git
- Curl

Setup dotfile management in your $HOME directory by running:

	curl -Lks https://raw.githubusercontent.com/fbex/dotfiles/base/.bin/dotfiles/setup.sh | /bin/bash

## Install additional software

Install [homebrew](https://brew.sh):

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/setup.sh)"
 
Install the desired software sets:

	/bin/bash $HOME/.bin/dotfiles/install.sh
	brew bundle --file $HOME/.bin/dotfiles/BrewfileBase
	brew bundle --file $HOME/.bin/dotfiles/BrewfilePersonal

Manually install:
- [sdkman](https://sdkman.io/install)

