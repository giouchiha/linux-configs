#!/bin/bash

#
# script: us-postsetup.sh
# descripcion: Semiautomatiza tareas de post instalacion en ubuntu server 12.04
# autor: Jorge Armando Medina - jmedina@tuxjm.net
# fecha: 10/Sep/2013
#

# set -x

# Vars


# Main

echo "Cambiandonos al directorio $HOME"
cd ~

echo "Configurando las locales del sistema"

locale-gen en_US.UTF-8 en_US es_ES.UTF-8 es_ES es_MX.UTF-8 es_MX
locale -a

echo "Mostrando la hora y zona horaria"

date

echo "Configurando el shell predefinido /bin/sh como enlace a /bin/bash"

update-alternatives --install /bin/sh sh /bin/bash 1
update-alternatives --display sh

echo "Configurando el archivo de control del shell bash para el usuario root"

wget http://tuxjm.net/jm-confs/bash/root/1204dotbashrc
wget http://tuxjm.net/jm-confs/bash/root/1204dotbash_local
wget http://tuxjm.net/jm-confs/bash/root/1204dotbash_aliases
mv 1204dotbashrc .bashrc
mv 1204dotbash_local .bash_local
mv 1204dotbash_aliases .bash_aliases
source .profile

echo " Configurando el entorno del editor de textos vim para el usuario root"

wget http://tuxjm.net/jm-confs/vim/1204vimrc
mv 1204vimrc /root/.vimrc

echo "Configurando el archivo de control de screen para el usuario root"

wget http://tuxjm.net/jm-confs/screen/dotscreenrc-simple
mv dotscreenrc-simple .screenrc

echo "Configurando el archivo de banner de login de red"

wget http://tuxjm.net/jm-confs/issue/issue.net-en
mv issue.net-en /etc/issue.net

echo "Configurando el archivo de personalizacion de sysctl"

wget http://tuxjm.net/jm-confs/sysctl/20-custom.conf
mv 20-custom.conf /etc/sysctl.d/

echo "Configurando el nombre del host"

vim /etc/hostname

echo "Configurando el archivo de interfaces de red"

vim /etc/network/interfaces

echo "Configurando el archivo de la resolucion de nombres local"

vim /etc/hosts

echo "Configurando el archivo de la resolucion de nombres DNS"

vim /etc/resolv.conf

echo "Configurando los depositos de paquetes APT"

wget http://tuxjm.net/jm-confs/apt/precise-server/sources.list.us
wget http://tuxjm.net/jm-confs/apt/precise-server/50tmpremount
wget http://tuxjm.net/jm-confs/apt/precise-server/88apt-proxy
mv sources.list.us /etc/apt/sources.list
mv 50tmpremount /etc/apt/apt.conf.d/
mv 88apt-proxy /etc/apt/apt.conf.d/

echo "Actualizamos lista de paquetes de sistema"

aptitude -q update
aptitude -q full-upgrade

echo "Instalacion de conjunto de paquetes basicos"

apt-get -q install bash-completion man-db screen vim psmisc \
bzip2 less unzip wget rsync cron logrotate mlocate multitail \
openssh-server ntp ntpdate snmpd snmp htop iftop dnsutils vnstat \
ethtool tcpdump tshark traceroute nmap elinks smbclient smbfs sysstat rsyslog

echo "Configurando el servicio de logs rsyslog"

cp /etc/rsyslog.d/50-default.conf{,.orig}
wget http://tuxjm.net/jm-confs/rsyslog/1204-50-default.conf
mv 1204-50-default.conf /etc/rsyslog.d/50-default.conf
/etc/init.d/rsyslog restart

echo "Configurando el servicio de sincronizacion de tiempo NTP"

cp /etc/ntp.conf{,.orig}
wget http://tuxjm.net/jm-confs/ntp/1204-ntp.conf
mv 1204-ntp.conf /etc/ntp.conf
/etc/init.d/ntp restart
ntpq -p

echo "Configurando el servicio de monitorizacion SNMP"

cp /etc/snmp/snmpd.conf{,.orig}
wget http://tuxjm.net/jm-confs/snmp/1204-snmpd.conf
mv 1204-snmpd.conf /etc/snmp/snmpd.conf
/etc/init.d/snmpd restart
snmpwalk -v 1 -c public localhost

echo "Configurando la herramienta de monitorizacion de sistema sysstat"

cp /etc/default/sysstat{,.orig}
wget http://tuxjm.net/jm-confs/sysstat/1204-default-sysstat
mv 1204-default-sysstat /etc/default/sysstat
/etc/init.d/sysstat restart

echo "Configurando la herramienta de monitorizacion de red vnstat"

vnstat -u -i eth0
