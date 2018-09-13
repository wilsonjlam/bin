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
~/.vim/bundle/YouCompleteMe/install.py

#nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
