sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/sbin
brew upgrade;
brew cask upgrade;
vim -c PlugUpgrade -c qa;
