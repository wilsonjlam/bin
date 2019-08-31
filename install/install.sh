#!/bin/bash

set -euv

install_dir="$(dirname "$BASH_SOURCE")"

#directories
if [ ! -d "$HOME/workspace" ]; then
	mkdir ~/workspace
fi

if [ ! -d "$HOME/personal" ]; then
	mkdir ~/personal
fi

#brew installations
brew install < "$install_dir/brew/list"
brew cask install < "$install_dir/brew/cask_list"

#dot files
./"$install_dir"/links.sh

set +v
# shellcheck source=$HOME/.bash_profile
source "$HOME/.bash_profile"
set -v

#vim
#Vim-Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c PlugInstall -c qa
