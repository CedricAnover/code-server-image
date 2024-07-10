#!/bin/bash

DEFAULT_USER="vagrant"
NEW_PASSWD="testpass"

echo "Changing Password ..."
echo "$DEFAULT_USER:$NEW_PASSWD" | sudo chpasswd


echo "Cleanup ..."
history_file="/home/vagrant/.bash_history"
if [ -f "$history_file" ]; then
    rm "$history_file"
fi
history -c
