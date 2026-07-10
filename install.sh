#!/bin/bash

local_dir=$(pwd)

echo "Welcome to Spotty's KDE Theme Installer"

echo "==Updating System=="

# Updating the system to ensure all packages are up to date before installing new themes
sudo pacman -Syu >> $local_dir/Log\ Files/pacman.log
# Add seperators to the log file to make it easier to read
echo "=====================================" >> $local_dir/Log\ Files/pacman.log
echo "=====================================" >> $local_dir/Log\ Files/pacman.log

echo "==Installing Oxygen Themes=="

# Installing the Oxygen theme and related packages for KDE Plasma
sudo pacman -S --needed --noconfirm oxygen oxygen-cursors oxygen-icons oxygen-icons-svg oxygen-sounds oxygen5 >> $local_dir/Log\ Files/pacman.log
# Add seperators to the log file to make it easier to read
echo "=====================================" >> $local_dir/Log\ Files/pacman.log
echo "=====================================" >> $local_dir/Log\ Files/pacman.log

echo "==Installing Papirus Icons==" 

# Using the official Papirus install script to install the latest version of the Papirus icon theme
# There is a pacman package for Papirus, But i'd rather use the official script to ensure I get the latest version of the theme.
wget -qO- https://git.io/papirus-icon-theme-install | sh >> $local_dir/Log\ Files/papiruse_install.log

# Runs the manual install script for JetBrains Mono font to ensure the latest version is installed.
echo "==Installing JetBrains Mono Font=="
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)" >> $local_dir/Log\ Files/jetbrains_mono_install.log

