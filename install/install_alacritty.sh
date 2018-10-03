#!/bin/bash

set -euo pipefail

#install rust
curl https://sh.rustup.rs -sSf | sh

git clone https://github.com/jwilm/alacritty.git
cd alacritty

rustup override set stable
rustup update stable

make app
cp -r target/release/osx/Alacritty.app /Applications/
