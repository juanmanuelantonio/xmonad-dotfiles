#!/bin/env bash
set -e

# init
function pause(){
   read -p "$*"
}

echo "Welcome! you will tungurize your desktop"
pause 'Press [Enter] key to continue...'

working_path=$(pwd)/

# does full system update
echo "FIRST! Perform a system update..."
pause 'Press [Enter] key to continue...'
sudo pacman --noconfirm -Syu

echo "###########################################################################"
echo "Ok, now we are ready to tungurize...."
echo "###########################################################################"

#echo "Updating hostname..."
#echo "127.0.0.1    localhost" >> /etc/hostname
#echo "::1          localhost" >> /etc/hostname
#echo "127.0.0.1    bruenor.localhost bruenor" >> /etc/hostname

echo "Installing packages"
pause 'Press [Enter] key to continue...'
# install base-devel if not installed
sudo pacman -S --noconfirm --needed base-devel wget git
# Windows Tiling Manager
sudo pacman -S --noconfirm --needed xorg xorg-server
sudo pacman -S --noconfirm --needed lightdm 
sudo pacman -S --noconfirm --needed lightdm-gtk-greeter
sudo pacman -S --noconfirm --needed lightdm-gtk-greeter-settings
sudo systemctl enable lightdm.service

echo "We need an AUR helper. Installing paru..."
pause 'Press [Enter] key to continue...'
#create directory for repositories
mkdir -p Desktop/repos
cd !$
# paru install to get AUR packages
git clone https://aur.archlinux.org/paru-bin.git
cd paur-bin
makepkg -si

echo "We need Blackarch repositories..."
pause 'Press [Enter] key to continue...'
# Install BlackArch repositories
cd ~/Desktop/repos
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh

echo "Updating repositories..."
pause 'Press [Enter] key to continue...'
sudo pacman -Sy 

echo "Installing xmonad and xmobar..."
pause 'Press [Enter] key to continue...'
paru -S xmonad-git xmonad-contrib-git
sudo pacman -S xmobar

# Only for virtual machine
echo "Installing vmware support..."
pause 'Press [Enter] key to continue...'
sudo pacman -S --noconfirm --needed open-vm-tools
sudo pacman -S --noconfirm --needed xf86-video-vmware xf86-input-vmmouse
echo "Enabling VM tools deamon..."
pause 'Press [Enter] key to continue...'
systemctl enable vmtoolsd


#Enable wifi
#sudo systemctl enable wpa_supplicant.service
#pacman -Sgg | grep blackarch --busca en los repos por herramientas de seguridad puntuales
#pacman -S gnome
#pacman -S gtkmmsud
# Start service now
#systemctl start gdm.service
# Enable at logon
#systemctl enable gdm.service

echo "Installing aditional applications..."
pause 'Press [Enter] key to continue...'
# Additional Software
sudo pacman -S --noconfirm --needed kitty firefox zsh zsh-syntax-highlighting zsh-autosuggestions vim neovim nano lsd batcat rofi ranger mc feh mlocale zip unzip imagemagick
paru -S --noconfirm --needed picom-git scrub

sudo usermod --shell /bin/zsh tungur
sudo usermod --shell /bin/zsh root

#-sudo pluginds
sudo mkdir -p /usr/share/zsh-sudo
cd !$
sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

#-fzf
cd ~
cd repos
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# TODO DO: install fzf for root
#nordic-wallpapers + chutulu
#picom-git
#-powerlevel-10k

echo "Coping .config files..."
pause 'Press [Enter] key to continue...'
cp -r $working_path/.config/* ~/.config/*

echo "Font instalation..."
pause 'Press [Enter] key to continue...'
# install fonts
#wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
#wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
#wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip
#wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
#wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
#wget https://use.fontawesome.com/releases/v6.1.1/fontawesome-free-6.1.1-desktop.zip

echo "Creating fonts dirs..."  
TTF_FONT_DIR="/user/local/share/fonts/ttf/"
if [ ! -d "$TTF_FONT_DIR" ]; then
  sudo mkdir -p /user/local/share/fonts/ttf/
fi

OTF_FONT_DIR="/user/local/share/fonts/otf/"
if [ ! -d "$OTF_FONT_DIR" ]; then
  sudo mkdir -p /user/local/share/fonts/otf/
fi

echo "Installing fonts dirs..."  
sudo cp -r $working_path/fonts/ttf/* /user/local/share/fonts/ttf/*
sudo cp -r $working_path/fonts/otf/* /user/local/share/fonts/otf/*
echo "Updating fonts cache..."
fc-cache -f

#TODO: ln ECUAL ROOT USER

echo "###########################################################################"
echo "Ok, all stuff done, please reeboot the system"
echo "###########################################################################"
