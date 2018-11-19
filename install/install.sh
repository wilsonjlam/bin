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

#nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

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

#alacritty
./"$install_dir"/install_alacritty.sh
