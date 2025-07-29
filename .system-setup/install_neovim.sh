#!/usr/bin/env bash
set -e

echo "=== Installing prerequisites ==="
sudo apt-get update
sudo apt-get install -y ninja-build gettext cmake curl build-essential ccache

echo "=== Cloning Neovim repository ==="
if [ ! -d "neovim" ]; then
    git clone https://github.com/neovim/neovim.git
else
    echo "Repository already exists. Pulling latest changes..."
    cd neovim
    git fetch origin
    cd ..
fi

cd neovim
echo "=== Checking out stable branch ==="
git checkout stable

echo "=== Building Neovim ==="
make CMAKE_BUILD_TYPE=RelWithDebInfo

echo "=== Installing Neovim ==="
sudo make install

echo "=== Installation complete! ==="
nvim --version

