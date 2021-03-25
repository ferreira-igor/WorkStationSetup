#!/bin/bash

### SCRIPT DE PÓS INSTALAÇÃO PARA O UBUNTU 20.04

## BYE BYE SNAPS

for snap_name in $(snap list | awk '{print $1}'); do
    sudo snap remove "$snap_name"
done

sudo systemctl stop snapd

for m in /snap/core/*; do
    sudo umount "$m"
done

sudo umount /var/snap

sudo snap remove core
sudo snap remove core18

sudo apt-get purge snapd -y

rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
sudo rm -rf /var/cache/snapd

sudo tee /etc/apt/preferences.d/snapd << EOF
Package: snapd
Pin: origin *
Pin-Priority: -1
EOF

## ADIÇÃO DE REPOSITÓRIOS DE TERCEIROS

wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - 
echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

wget -qO - https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
echo "deb [arch=amd64] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
echo "deb [arch=amd64] http://apt.insync.io/ubuntu focal non-free contrib" | sudo tee /etc/apt/sources.list.d/insync.list

## REMOÇÃO DE EVENTUAIS TRAVAS DO APT

sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## ATUALIZAÇÃO DOS REPOSITÓRIOS

sudo apt-get update

## INSTALAÇÃO DOS APLICATIVOS

apps_list=(
    # Gerenciadores de pacotes
    synaptic
    # Desenvolvimento
    build-essential
    git-all
    python3-all
    python3-extras
    idle
    thonny
    esptool
    cutecom
    putty
    # Ferramentas do sistema
    p7zip-full
    unrar
    curl
    lsb
    tlp
    exfat-fuse
    zram-config
    timeshift
    gnome-boxes
    remmina
    deja-dup
    vino
    baobab
    usb-creator-gtk
    branding-ubuntu
    transmission-gtk
    # Multimídia
    ubuntu-restricted-addons
    totem
    rhythmbox
    vlc
    qwinff
    # Personalização
    gnome-tweaks
    fonts-noto
    fonts-roboto
    # Engenharia
    kicad
    freecad
    librecad
    # Fotografia
    gimp
    inkscape
    shotwell
    cheese
    # Escritório
    libreoffice
    simple-scan
    gnome-calendar
    gnome-todo
    thunderbird
    # Aplicativos de terceiros
    google-chrome-stable
    code
    spotify-client
    insync
    insync-nautilus
)

for app_name in "${apps_list[@]}"; do
    if ! dpkg -l | awk '{print $2}' | grep -qw "$app_name"; then
        echo "[INSTALANDO] - $app_name"
        sudo apt-get install "$app_name" -y
    else
        echo "[INSTALADO] - $app_name"
    fi
done

## INSTALAÇÃO DO BLOQUEADOR DE ANÚNCIOS

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

## ADIÇÃO DO USUÁRIO AO GRUPO DIALOUT

sudo usermod -aG dialout $USER

## ATUALIZAÇÃO DO SISTEMA

sudo apt-get check -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y

## FIM
