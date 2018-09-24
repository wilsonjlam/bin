#!/bin/bash

set -euv

install_dir="$(dirname $BASH_SOURCE)"

#directories
if [ ! -d "~/workspace" ]; then
	mkdir ~/workspace
fi

if [ ! -d "~/personal" ]; then
	mkdir ~/personal
fi

#brew installations
cat "$install_dir/brew/list" | xargs brew install
cat "$install_dirbrew/cask_list" | xargs brew cask install

#nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

#dot files
./"$install_dir"/links.sh

set +v
source ~/.bash_profile
set -v

#vim
vim -c PluginInstall -c qa
~/.vim/bundle/YouCompleteMe/install.py
