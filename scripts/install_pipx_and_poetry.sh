#!/bin/bash

set -e

# Install Pipx
echo "Installing Pipx..."
sudo apt update
sudo apt install -y pipx
echo 'export PATH=$HOME/.local/bin:$PATH' >> $HOME/.bashrc
. $HOME/.bashrc

# Install Poetry
echo "Installing Poetry with Pipx..."
pipx install poetry
pipx ensurepath -f
# poetry completions bash >> $HOME/.bash_completion

exec "$SHELL"
