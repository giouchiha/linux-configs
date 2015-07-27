#!/bin/bash

#
# script: us-freenx-setup.sh
#

echo "Instalando paquetes FreeNX..."
apt-get update
apt-get install python-software-properties
add-apt-repository ppa:freenx-team
apt-get update
apt-get install freenx-server
echo

echo "Configurando paquete FreeNX..."
wget https://bugs.launchpad.net/freenx-server/+bug/576359/+attachment/1378450/+files/nxsetup.tar.gz
tar -xvf nxsetup.tar.gz
cp nxsetup /usr/lib/nx/nxsetup
/usr/lib/nx/nxsetup --install --setup-nomachine-key
echo

echo "Reiniciando servicio FreeNX..."
/etc/init.d/freenx-server restart
echo
