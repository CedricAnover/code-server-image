#!/bin/bash

# Setup:
# - Git
# - Node
# - Pyenv
# - Poetry

sudo apt-get update

# Git and Node
sudo apt-get install -y git curl nodejs npm

echo "$(git --version)"
echo "$(node --version)"
echo "$(npm --version)"

# Pyenv
sudo apt-get install -y build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# curl https://pyenv.run | bash
git clone https://github.com/pyenv/pyenv.git /home/vagrant/.pyenv

# if [ ! -f "/home/vagrant/.profile" ]; then
#     touch "/home/vagrant/.profile"
# fi

echo 'export PYENV_ROOT="/home/vagrant/.pyenv"' >> /home/vagrant/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/vagrant/.profile
echo 'eval "$(pyenv init -)"' >> /home/vagrant/.profile
source /home/vagrant/.profile
exec "$SHELL"

echo "$(which pyenv)"
echo "$(pyenv --version)"

# Poetry
poetry_home_dir='/opt/poetry'
curl -sSL https://install.python-poetry.org | POETRY_HOME=$poetry_home_dir python3 -
echo 'export POETRY_HOME="/opt/poetry"' >> /home/vagrant/.bashrc
echo 'export PATH="$POETRY_HOME/bin:$PATH"' >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc
exec "$SHELL"
echo "$(which poetry)"
echo "$(poetry --version)"

poetry completions bash >> /home/vagrant/.bash_completion
