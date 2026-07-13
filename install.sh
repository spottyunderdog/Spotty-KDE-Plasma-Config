#!/bin/bash

local_dir=$(pwd)

# Probably redudent, But if the Log file directory doesn't exist, creates it
if [ ! -d "$local_dir/Log Files" ]
then
    echo "Log Directory does not exist, creating."
    mkdir -p "$local_dir/Log Files"
fi

echo "Welcome to Spotty's KDE Theme Installer"

echo "==Updating System=="

# Updating the system to ensure all packages are up to date before installing new themes
sudo pacman -Syu &>> $local_dir/Log\ Files/pacman.log
# Add seperators to the log file to make it easier to read
echo "=====================================" >> $local_dir/Log\ Files/pacman.log
echo "=====================================" >> $local_dir/Log\ Files/pacman.log

echo "System Updated Successfully"

echo "==Installing Oxygen Themes=="

# Installing the Oxygen theme and related packages for KDE Plasma
sudo pacman -S --needed --noconfirm oxygen oxygen-cursors oxygen-icons oxygen-icons-svg oxygen-sounds oxygen5 &>> $local_dir/Log\ Files/pacman.log
# Add seperators to the log file to make it easier to read
echo "=====================================" >> $local_dir/Log\ Files/pacman.log
echo "=====================================" >> $local_dir/Log\ Files/pacman.log
echo "Oxygen Themes Installed Successfully"


echo "==Installing Papirus Icons==" 

# Using the official Papirus install script to install the latest version of the Papirus icon theme
# There is a pacman package for Papirus, But i'd rather use the official script to ensure I get the latest version of the theme.
wget -qO- https://git.io/papirus-icon-theme-install | sh &>> $local_dir/Log\ Files/papiruse_install.log
echo "Papirus Icons Installed Successfully"

# Runs the manual install script for JetBrains Mono font to ensure the latest version is installed.
echo "==Installing JetBrains Mono Font=="
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)" &>> $local_dir/Log\ Files/jetbrains_mono_install.log
echo "Jet Brains Mono Font Installed Successfully"

echo "==Installing Plymouth Boot Themes=="
git clone https://github.com/adi1090x/plymouth-themes &>> $local_dir/Log\ Files/plymouth_themes.log
# Removes the included template them from the cloned repo, as it is unneeded
rm -rf $local_dir/plymouth-themes/template

# Installs the Plymouth themes to the system. IE Coppies each included theme to the /usr/share/plymouth/themes directory

for themepack in $local_dir/plymouth-themes/*; do

    if [ -d $themepack ]
    then
        sudo cp -r $themepack/* /usr/share/plymouth/themes/
    fi
done

# Removes the cloned repo after the themes have been installed to the system
rm -rf $local_dir/plymouth-themes

echo "Plymouth Boot Themes Installed Successfully"

echo "==Installing Window Title Widget=="

git clone https://github.com/harunkrl/plasma6-window-title-applet &>> $local_dir/Log\ Files/plasma6_window_title_applet.log

sudo mkdir -p /usr/share/plasma/plasmoids/org.kde.windowtitle
sudo cp -r $local_dir/plasma6-window-title-applet/* /usr/share/plasma/plasmoids/org.kde.windowtitle/
rm -rf $local_dir/plasma6-window-title-applet
echo "Window Title Widget Installed Successfully"

echo "==Installing Burn My Windows Desktop Effects=="
wget https://github.com/Schneegans/Burn-My-Windows/releases/latest/download/burn_my_windows_kwin6.tar.gz &>> $local_dir/Log\ Files/burn_my_windows.log

sudo mkdir -p /usr/share/kwin/effects
sudo tar -xf burn_my_windows_kwin6.tar.gz -C /usr/share/kwin/effects
echo "Burn My Windows Desktop Effects Installed Successfully"

echo "Restarting Plasma to apply changes"
systemctl --user restart plasma-plasmashell