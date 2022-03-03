#!/bin/bash

set -eu

INSTALL_DIR=$(dirname "${BASH_SOURCE[0]}")
trim_output() {
    tr '\n' ' ' < "$INSTALL_DIR/external_dependencies/$1"
}

echo "Disabling mouse acceleration"
defaults write .GlobalPreferences com.apple.mouse.scaling 0

#directories
if [ ! -d "$HOME/workspace" ]; then
	echo "mkdir ~/workspace"
	mkdir ~/workspace
fi

if [ ! -d "$HOME/personal" ]; then
	echo "mkdir ~/personal"
	mkdir ~/personal
fi

if [ ! -d "$HOME/tmp" ]; then
	echo "mkdir ~/tmp"
	mkdir ~/tmp
fi

if [ ! -d "$HOME/.config" ]; then
	echo "mkdir ~/.config"
	mkdir ~/.config
	if [ ! -d "$HOME/.config/alacritty" ]; then
		echo "mkdir ~/.config/alarcitty"
		mkdir ~/.config/alacritty
		ln -s ~/utility/terminal/alacritty_macos.yml ~/.config/alacritty/alacritty.yml
	fi
fi

#brew installations
if [ -z "$(which brew)" ]; then
	echo "Installing brew"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing Brew formulae"
# shellcheck disable=SC2046 # Intended splitting of brew formulae
brew install $(trim_output brew_formulae)
echo "Installing Brew casks"
# shellcheck disable=SC2046 # Intended splitting of brew formulae
# brew install --cask $(trim_output brew_casks)

echo "Installing NPM packages"
# shellcheck disable=SC2046 # Intended splitting of brew formulae
npm install -g $(trim_output npm_packages)

#dot files
echo "Linking Dotfiles"
./"$INSTALL_DIR"/links.sh

set +v
echo "Sourcing .bash_profile"
# shellcheck source=$HOME/.bash_profile
source "$HOME/.bash_profile"
set -v

#vim
#Vim-Plug
echo "Installing Vim & Vim Plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c PlugInstall -c qa
