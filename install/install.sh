#!/bin/bash

set -euv

install_dir="$(dirname $BASH_SOURCE)"

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

#nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

#dot files
./"$install_dir"/links.sh

set +v
source "$HOME/.bash_profile"
set -v

#vim
vim -c PluginInstall -c qa
~/.vim/bundle/YouCompleteMe/install.py

#alacritty
./"$install_dir"/install_alacritty.sh
