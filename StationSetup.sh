#!/bin/bash

# Script pós instalação para Linux Mint #

echo "Removendo eventuais travas do apt..."

sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

echo "Adicionando repositório de terceiros..."

curl -sS https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

curl -sS https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb [arch=amd64] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

echo "Atualizando os repositórios..."

sudo apt update

echo "Instalando aplicativos..."

# Aplicativos de terceiros
sudo apt install google-chrome-stable code spotify-client -y

# Aplicativos para desenvolvimento
sudo apt install build-essential git-all python3-all idle thonny esptool kicad -y

# Utilitários
sudo apt install lsb tlp tlp-rdw mint-meta-codecs exfat-fuse exfat-utils -y

# Personalização
sudo apt install fonts-noto fonts-roboto papirus-icon-theme -y

# Games
sudo apt install retroarch -y

# Outros
sudo apt install gimp inkscape audacity -y

echo "Instalando bloqueador de anúncios..."

curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.2.0/hblock'
echo 'b9ed6de52455fbde882879ef50470c1538bc5ac8d1479ef130442770b159dbe3  /tmp/hblock' | shasum -c
sudo mv /tmp/hblock /usr/local/bin/hblock
sudo chown 0:0 /usr/local/bin/hblock
sudo chmod 755 /usr/local/bin/hblock
sudo hblock

echo "Atualizando o sistema..."

sudo apt update
sudo apt full-upgrade -y
sudo apt autoclean -y
sudo apt autoremove -y

echo "Fim!"
