#!/bin/bash

SYSBOX_VERSION=$1

cd $HOME

echo "Setting up Sysbox v$SYSBOX_VERSION ..."
wget "https://downloads.nestybox.com/sysbox/releases/v$SYSBOX_VERSION/sysbox-ce_$SYSBOX_VERSION-0.linux_amd64.deb"
sudo apt-get install -y jq
sudo apt-get install -y ./sysbox-ce_$SYSBOX_VERSION-0.linux_amd64.deb

echo "Restarting Docker ..."
sudo systemctl restart docker

rm sysbox-ce_$SYSBOX_VERSION-0.linux_amd64.deb
