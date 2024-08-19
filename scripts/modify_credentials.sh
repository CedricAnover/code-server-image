#!/bin/bash

set -e

NEW_USER=$1
NEW_USER_PASSWORD=$2
NEW_VAGRANT_PASSWORD=$3

create_user() {
    local new_user=$1
    local password=$2
    sudo useradd -ms /bin/bash $new_user
    sudo cp -pr /home/vagrant/.ssh /home/$new_user/
    sudo chown -R $new_user:$new_user /home/$new_user
    echo "$new_user:$password" | sudo chpasswd
    sudo usermod -aG sudo,adm,cdrom,dip,plugdev,lxd,docker $new_user
    # echo "%$new_user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$new_user
    sudo bash -c "echo \"%$new_user ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/$new_user"
    echo "User $new_user created and added to sudo group."
}

change_vagrant_password() {
    local new_password=$1
    echo "vagrant:$new_password" | sudo chpasswd
}

create_user $NEW_USER $NEW_USER_PASSWORD
change_vagrant_password $NEW_VAGRANT_PASSWORD
