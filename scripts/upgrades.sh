sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/sbin
brew upgrade;
brew upgrade --cask;
vim -c PlugUpgrade -c qa;
