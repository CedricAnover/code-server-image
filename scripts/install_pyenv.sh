#!/bin/bash

set -e

echo 'Installing Pyenv Dependencies...'
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

echo 'Installing Pyenv...'
# curl https://pyenv.run | bash
sudo -u "$(whoami)" -i sh -c 'curl https://pyenv.run | bash'

echo 'Setting Pyenv Environment Variables...'
touch $HOME/.bash_profile
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.bash_profile
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.bash_profile
echo 'eval "$(pyenv init -)"' >> $HOME/.bash_profile

. $HOME/.bash_profile
