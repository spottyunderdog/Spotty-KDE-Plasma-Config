#!/bin/bash

echo "Welcome to Spotty's KDE Theme Installer"

echo "==Updating System=="

# Updating the system to ensure all packages are up to date before installing new themes
sudo pacman -Syu 

echo "==Installing Oxygen Themes=="

# Installing the Oxygen theme and related packages for KDE Plasma
sudo pacman -S --needed --noconfirm oxygen oxygen-cursors oxygen-icons oxygen-icons-svg oxygen-sounds oxygen5

echo "==Installing Papirus Icons==" 

# Using the official Papirus install script to install the latest version of the Papirus icon theme
# There is a pacman package for Papirus, But i'd rather use the official script to ensure I get the latest version of the theme.
wget -qO- https://git.io/papirus-icon-theme-install | sh

