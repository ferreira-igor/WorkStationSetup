#!/bin/bash

## ATUALIZANDO OS REPOSITÓRIOS ##

sudo apt update

## INSTALANDO APLICATIVOS ##

# APLICATIVOS DE DESENVOLVIMENTO #
sudo apt install build-essential git-all python3-all idle thonny esptool cutecom putty -y

# UTILITÁRIOS DO SISTEMA #
sudo apt install lsb tlp tlp-rdw exfat-fuse exfat-utils numlockx zram-config virt-manager -y

# MULTIMÍDIA #
sudo apt install mint-meta-codecs vlc audacity qwinff -y

# PERSONALIZAÇÃO #
sudo apt install fonts-noto fonts-roboto papirus-icon-theme -y

# ENGENHARIA #
sudo apt install kicad freecad librecad -y

# OUTROS #
sudo apt install gimp inkscape filezilla -y

## ADICIONANDO USUÁRIO AO GRUPO DIALOUT ##

sudo usermod -a -G dialout $USER

## INSTALANDO O BLOQUEADOR DE ANÚNCIOS ##

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

## ATUALIZANDO O SISTEMA ##

sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y

echo "Fim!"
