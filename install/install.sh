#!/bin/bash

set -v

#brew installations
cat brew/list | xargs brew install
cat brew/cask_list | xargs brew cask install

#dot files
./links.sh

set +v
source ~/.bash_profile
set -v

#vim
vim -c PluginInstall -c qa
cd ~/.vim/bundle/YouCompleteMe
./install.py

npm install -g avn
