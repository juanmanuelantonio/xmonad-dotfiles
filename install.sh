#!/bin/env bash
set -e

# init
function pause(){
   read -p "$*"
}

pause 'Welcome! you will tungurize your desktop --> press [Enter] key to continue...'
working_path=$(pwd)
user=$(whoami)

# does full system update
echo "Hello $user"
pause 'FIRST! Perform a system update --> press [Enter] key to continue...'
sudo pacman --noconfirm -Syu

echo "###########################################################################"
echo "Ok, now we are ready to tungurize...."
echo "###########################################################################"

#Temporal dir creation
mkdir -p ~/.tmp 
pause 'We need an AUR helper. Verifying paru or intall... --> press [Enter] key to continue...'
if ! command -v paru &> /dev/null
then
    echo "It seems that you don't have paru installed, I'll install that for you before continuing."
	git clone https://aur.archlinux.org/paru-bin.git ~/.tmp/
	(cd ~/.tmp && makepkg -si)
fi

pause 'We need Blackarch repositories --> press [Enter] key to continue...'
cd ~/.tmp
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh

#echo "Updating hostname..."
#echo "127.0.0.1    localhost" >> /etc/hostname
#echo "::1          localhost" >> /etc/hostname
#echo "127.0.0.1    bruenor.localhost bruenor" >> /etc/hostname

pause 'Installing packages --> press [Enter] key to continue...'
sudo pacman -S --noconfirm --needed base-devel wget git
sudo pacman -S --noconfirm --needed xorg xorg-server
sudo pacman -S --noconfirm --needed lightdm 
#sudo pacman -S --noconfirm --needed lightdm-gtk-greeter
#sudo pacman -S --noconfirm --needed lightdm-gtk-greeter-settings
sudo pacman -S --noconfirm --needed lightdm-webkit2-greeter
paru -Syu lightdm-webkit2-theme-glorious
# Set default lightdm greeter to lightdm-webkit2-greeter
sudo sed -i 's/^\(#?greeter\)-session\s*=\s*\(.*\)/greeter-session = lightdm-webkit2-greeter #\1/ #\2g' /etc/lightdm/lightdm.conf
# Set default lightdm-webkit2-greeter theme to Glorious
sudo sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = glorious #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
sudo sed -i 's/^debug_mode\s*=\s*\(.*\)/debug_mode = true #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf

# add this to /etc/lightdm/lightdm.conf (under [Seat: *])
# greeter-session=lightdm-webkit2-greeter

pause 'Enabling lightdm service --> press [Enter] key to continue...'
sudo systemctl enable lightdm.service

cd $working_path
pause 'Installing XMmonad and XMobar --> press [Enter] key to continue...'
paru -S xmonad-git xmonad-contrib-git
sudo pacman -S xmobar

# Only for virtual machine
pause 'Installing vmware support --> press [Enter] key to continue...'
sudo pacman -S --noconfirm --needed open-vm-tools
sudo pacman -S --noconfirm --needed xf86-video-vmware xf86-input-vmmouse
sudo systemctl enable vmtoolsd


#Enable wifi
#sudo systemctl enable wpa_supplicant.service
#pacman -Sgg | grep blackarch --busca en los repos por herramientas de seguridad puntuales
#pacman -S gnome
#pacman -S gtkmmsud
# Start service now
#systemctl start gdm.service
# Enable at logon
#systemctl enable gdm.service

pause 'Installing aditional applications --> press [Enter] key to continue...'
# Additional Software
sudo pacman -S --noconfirm --needed kitty firefox zsh zsh-syntax-highlighting zsh-autosuggestions vim neovim nano lsd bat rofi ranger mc feh mlocate zip unzip imagemagick neofetch mdcat
paru -S --noconfirm --needed picom-git scrub zsh-theme-powerlevel10k-git

git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1


pause 'Setting ZSH as user & root shell --> press [Enter] key to continue...'
sudo usermod --shell /bin/zsh $user
sudo usermod --shell /bin/zsh root

pause 'Install zsh SUDO plugin --> press [Enter] key to continue...'
sudo mkdir -p /usr/share/zsh-sudo
cd /usr/share/zsh-sudo/
sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

pause 'Install FZF, you will user ctrl+r and ctrl+t for fun and profit!! --> press [Enter] key to continue...'
cd ~/.tmp
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

pause 'Coping .config files --> press [Enter] key to continue...'
mkdir -p ~/.config
cp -rf $working_path/.config/* ~/.config/
cp -f $working_path/.zshrc ~/.zshrc
cp -f $working_path/.p10k.zsh ~/.p10k.zsh


pause 'Font instalation --> press [Enter] key to continue...'

echo "Creating TTF and OTF fonts dirs..."  
TTF_FONT_DIR="/usr/local/share/fonts/ttf/"
if [ ! -d "$TTF_FONT_DIR" ]; then
  sudo mkdir -p /usr/local/share/fonts/ttf/
fi

OTF_FONT_DIR="/usr/local/share/fonts/otf/"
if [ ! -d "$OTF_FONT_DIR" ]; then
  sudo mkdir -p /usr/local/share/fonts/otf/
fi

echo "Installing fonts dirs..."  
sudo cp -r $working_path/fonts/ttf/* /usr/local/share/fonts/ttf/
sudo cp -r $working_path/fonts/otf/* /usr/local/share/fonts/otf/
echo "Updating fonts cache..."
fc-cache -f

#TODO: equal ROOT USER
pause 'Configuring root console --> press [Enter] key to continue...'
sudo ln -s -f /home/$user/.zshrc /root/.zshrc
sudo ln -s -f /home/$user/.p10k.zsh /root/.p10k.zsh
sudo git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf
sudo /root/.fzf/install

echo "###########################################################################"
echo "Ok, all stuff done, please reeboot the system"
echo "###########################################################################"
pause 'Press [Enter] key to reboot'
sudo reboot
