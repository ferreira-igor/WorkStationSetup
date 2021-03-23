#!/bin/bash

### SCRIPT DE PÓS INSTALAÇÃO PARA O UBUNTU 20.04 ###

## BYE BYE SNAPS ##

for p in $(snap list | awk '{print $1}'); do
  sudo snap remove $p
done

sudo systemctl stop snapd

for m in /snap/core/*; do
   sudo umount $m
done

sudo umount /var/snap

sudo snap remove core
sudo snap remove core18

sudo apt autoremove --purge snapd gnome-software-plugin-snap -y

rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
sudo rm -rf /var/cache/snapd

sudo cat << EOF > /etc/apt/preferences.d/snapd
Package: snapd
Pin: origin *
Pin-Priority: -1
EOF

## REMOÇÃO DE EVENTUAIS TRAVAS DO APT ##

sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## ATUALIZAÇÃO DOS REPOSITÓRIOS ##

sudo apt update

## INSTALAÇÃO DOS APLICATIVOS ##

sudo apt install synaptic build-essential git-all python3-all python3-extras idle thonny esptool cutecom putty p7zip-full unrar curl lsb tlp exfat-fuse numlockx zram-config gnome-boxes gnome-tweaks timeshift usb-creator-gtk thunderbird totem rhythmbox ubuntu-restricted-addons vlc qwinff fonts-noto fonts-roboto kicad freecad librecad gimp inkscape filezilla -y

## ADIÇÃO DO USUÁRIO AO GRUPO DIALOUT ##

sudo usermod -a -G dialout $USER

## INSTALAÇÃO DO BLOQUEADOR DE ANÚNCIOS ##

curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.2.0/hblock'
echo 'b9ed6de52455fbde882879ef50470c1538bc5ac8d1479ef130442770b159dbe3  /tmp/hblock' | shasum -c
sudo mv /tmp/hblock /usr/local/bin/hblock
sudo chown 0:0 /usr/local/bin/hblock
sudo chmod 755 /usr/local/bin/hblock
sudo hblock

curl -o '/tmp/hblock.#1' 'https://raw.githubusercontent.com/hectorm/hblock/v3.2.0/resources/systemd/hblock.{service,timer}'
echo '08b736382cb9dfd39df1207a3e90b068f5325a41dc8254d83fde5d4540ba8b5b  /tmp/hblock.service' | shasum -c
echo '87a7ba5067d4c565aca96659b0dce230471a6ba35fbce1d3e9d02b264da4dc38  /tmp/hblock.timer' | shasum -c
sudo mv /tmp/hblock.{service,timer} /etc/systemd/system/
sudo chown 0:0 /etc/systemd/system/hblock.{service,timer}
sudo chmod 644 /etc/systemd/system/hblock.{service,timer}
sudo systemctl daemon-reload
sudo systemctl enable hblock.timer
sudo systemctl start hblock.timer

## ATUALIZAÇÃO DO SISTEMA ##

sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
