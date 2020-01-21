#!/bin/bash

set -eu

INSTALL_DIR="$(dirname "$BASH_SOURCE")"
echo $INSTALL_DIR

#directories
if [ ! -d "$HOME/workspace" ]; then
	mkdir ~/workspace
fi

if [ ! -d "$HOME/personal" ]; then
	mkdir ~/personal
fi

if [ ! -d "$HOME/tmp" ]; then
	mkdir ~/tmp
fi

#brew installations
if [ -z "$(which brew)" ]; then
	echo "Installing brew"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing Brew List"
cat "$INSTALL_DIR/brew/list" | xargs brew install 
echo "Installing Brew Cask"
cat "$INSTALL_DIR/brew/cask_list" | xargs brew cask install

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
