#!/bin/bash

set -eu

INSTALL_DIR=$(dirname "${BASH_SOURCE[0]}")

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

#brew installations
if [ -z "$(which brew)" ]; then
	echo "Installing brew"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing Brew List"
echo "$INSTALL_DIR/brew/list"
# shellcheck disable=SC2046 # Intended splitting of brew formulae
brew install $(tr '\n' ' ' < "$INSTALL_DIR"/brew/list)
echo "Installing Brew Cask"
# shellcheck disable=SC2046 # Intended splitting of brew formulae
brew install --cask $(tr '\n' ' ' < "$INSTALL_DIR/brew/cask_list")

#dot files
echo "Linking Dotfiles"
./"$INSTALL_DIR"/links.sh

set +v
# shellcheck source=$HOME/.bash_profile
source "$HOME/.bash_profile"
set -v

#vim
#Vim-Plug
echo "Installing Vim & Vim Plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c PlugInstall -c qa
