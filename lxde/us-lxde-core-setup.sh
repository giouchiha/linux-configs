#!/bin/bash

#
# script: us-lxde-core-setup.sh
#

echo "Instalando paquetes lxde-corex, lighdm, terminator y firefox..."
echo
apt-get update
apt-get install lxde-core lightdm-gtk-greeter
apt-get install vim-gtk terminator firefox
