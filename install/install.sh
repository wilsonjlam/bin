#!/bin/bash

set -v

#directories
mkdir ~/workspace
mkdir ~/personal

#brew installations
cat brew/list | xargs brew install
cat brew/cask_list | xargs brew cask install

#nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

#dot files
./links.sh

set +v
source ~/.bash_profile
set -v

#vim
vim -c PluginInstall -c qa
~/.vim/bundle/YouCompleteMe/install.py
