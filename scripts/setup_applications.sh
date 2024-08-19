#!/bin/bash

# Setup:
# - Git
# - Node
# - Pyenv
# - Poetry

# Using the New User Created (instead of vagrant)
THE_USER=$1
su - $THE_USER

sudo apt-get update

# Git and Node
# sudo apt-get install -y git curl nodejs npm
sudo apt-get install -y git curl

echo "$(git --version)"
# echo "$(node --version)"
# echo "$(npm --version)"

# Pyenv
sudo apt-get install -y build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# curl https://pyenv.run | bash
git clone https://github.com/pyenv/pyenv.git /home/$THE_USER/.pyenv

echo "export PYENV_ROOT=\"/home/$THE_USER/.pyenv\"" >> /home/$THE_USER/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/$THE_USER/.profile
echo 'eval "$(pyenv init -)"' >> /home/$THE_USER/.profile
source /home/$THE_USER/.profile
sudo chown -R $THE_USER:$THE_USER /home/$THE_USER/.pyenv/
exec "$SHELL"

echo "$(which pyenv)"
echo "$(pyenv --version)"

# Install Pipx
sudo apt update
sudo apt install -y pipx
pipx ensurepath

# Poetry
pipx install poetry
poetry completions bash >> /home/$THE_USER/.bash_completion
