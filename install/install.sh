#!/bin/bash

set -v

#brew installations
cat brew/list | xargs brew install
cat brew/cask_list | xargs brew cask install

#dot files
./links.sh

#vim
vim -c PluginInstall -c qa
cd ~/.vim/bundle/YouCompleteMe 
./install.py
