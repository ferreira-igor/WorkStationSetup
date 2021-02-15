#!/bin/bash

# Script pós instalação para Linux Mint #

echo "Removendo eventuais travas do apt..."

sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

echo "Atualizando o repositório..."

sudo apt update

echo "Instalando aplicativos..."

sudo apt install lsb build-essential libssl-dev git-all python3-all idle thonny esptool mint-meta-codecs fonts-noto fonts-roboto kicad gimp inkscape -y

echo "Instalando bloqueador de anúncios..."

curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.2.0/hblock'
echo 'b9ed6de52455fbde882879ef50470c1538bc5ac8d1479ef130442770b159dbe3  /tmp/hblock' | shasum -c
sudo mv /tmp/hblock /usr/local/bin/hblock
sudo chown 0:0 /usr/local/bin/hblock
sudo chmod 755 /usr/local/bin/hblock
sudo hblock

echo "Atualizando o sistema..."

sudo apt update -y
sudo apt dist-upgrade -y
sudo apt autoclean -y
sudo apt autoremove -y

echo "Fim!"
