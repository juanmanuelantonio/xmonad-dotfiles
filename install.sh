#!/bin/env bash
set -e

echo "Welcome! you will tungurize your desktop" && sleep 2

# does full system update
echo "FIRST! Perform a system update..."
sudo pacman --noconfirm -Syu

echo "###########################################################################"
echo "Ok, now we are ready to tungurize...."
echo "###########################################################################"

#echo "Updating hostname..."
#echo "127.0.0.1    localhost" >> /etc/hostname
#echo "::1          localhost" >> /etc/hostname
#echo "127.0.0.1    bruenor.localhost bruenor" >> /etc/hostname

echo "Installing packages"
# install base-devel if not installed
sudo pacman -S --noconfirm --needed base-devel wget git
# Windows Tiling Manager
sudo pacman -S --noconfirm --needed xorg xorg-server
sudo pacman -S --noconfirm --needed lightdm 
sudo pacman -S --noconfirm --needed lightdm-gtk-greeter
sudo pacman -S --noconfirm --needed lightdm-gtk-greeter-settings
sudo systemctl enable lightdm.service

echo "We need an AUR helper. Installing paru..."
#create directory for repositories
mkdir -p Desktop/repos
cd !$

# paru install to get AUR packages
git clone https://aur.archlinux.org/paru-bin.git
cd paur-bin
makepkg -si

echo "We need Blackarch repositories..."
# Install BlackArch repositories
cd ~/Desktop/repos
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh

# para actualizar los repositiorios.
sudo pacman -Sy 

echo "Installing xmonad and xmobar..."
paru -S xmonad-git xmonad-contrib-git
pacman -S xmobar

# Only for virtual machine
echo "Installing vmware support..."
sudo pacman -S --noconfirm --needed open-vm-tools
sudo pacman -S --noconfirm --needed xf86-video-vmware xf86-input-vmmouse
echo "Enabling VM tools deamon..."
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
# Additional Software
sudo pacman -S --noconfirm --needed kitty firefox zsh vim neovim nano lsd batcat rofi ranger mc feh mlocale zip unzip
paru -S scrub

sudo usermod --shell /usr/bin/zsh tungur
sudo usermod --shell /usr/bin/zsh root

#-sintax-higt
#-autosugestions
#-sudo pluginds
wget 
sudo mkdir /usr/share/zsh-sudo
sudo mv zsh-sudo /usr/share/zsh-sudo/zsh-sudo

#-fzf
#nordic-wallpapers + chutulu
#picom-git
#-powerlevel-10k


##TOFIXXXXX
# install fonts
#mkdir -p ~/.local/share/fonts
#mkdir -p ~/.srcs

#cp -r ./fonts/* ~/.local/share/fonts/
#fc-cache -f
#clear 
##TOFIXXXXX

echo "Finished...  execute: 'sudo reboot' and happy linuxing!!"
