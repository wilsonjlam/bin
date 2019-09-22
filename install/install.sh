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
cat "$INSTALL_DIR/brew/list" | xargs brew install 
cat "$INSTALL_DIR/brew/cask_list" | xargs brew cask install

#dot files
./"$INSTALL_DIR"/links.sh

set +v
# shellcheck source=$HOME/.bash_profile
source "$HOME/.bash_profile"
set -v

#vim
#Vim-Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c PlugInstall -c qa
