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
sudo pacman -Syu --no-confirm &>> /dev/null


echo "System Updated Successfully"

echo "==Installing Oxygen Themes=="

# Installing the Oxygen theme and related packages for KDE Plasma
sudo pacman -S --needed --noconfirm oxygen oxygen-cursors oxygen-icons oxygen-icons-svg oxygen-sounds oxygen5 &>> /dev/null


echo "Oxygen Themes Installed Successfully"


echo "==Installing Papirus Icons==" 

# Using the official Papirus install script to install the latest version of the Papirus icon theme
# There is a pacman package for Papirus, But i'd rather use the official script to ensure I get the latest version of the theme.
wget -qO- https://git.io/papirus-icon-theme-install | sh &>> /dev/null

echo "Papirus Icons Installed Successfully"

# Runs the manual install script for JetBrains Mono font to ensure the latest version is installed.
echo "==Installing JetBrains Mono Font=="

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)" &>> /dev/null

echo "Jet Brains Mono Font Installed Successfully"



echo "==Installing Plymouth Boot Themes=="

# Creates a Variable to store the current install directory, for easy printout in the script later.
install_dir=/usr/share/plymouth/themes

# Downloads the themes repo.
git clone https://github.com/adi1090x/plymouth-themes &>> /dev/null

# Removes the included template them from the cloned repo, as it is unneeded
rm -rf $local_dir/plymouth-themes/template

# Installs the Plymouth themes to the system. IE Coppies each included theme to the /usr/share/plymouth/themes directory

for themepack in $local_dir/plymouth-themes/*; do

    if [ -d $themepack ]
    then

        sudo cp -r $themepack/* $install_dir

    fi
done

# Removes the cloned repo after the themes have been installed to the system
rm -rf $local_dir/plymouth-themes

echo "Plymouth Boot Themes Installed Successfully"

echo "==Installing Window Title Widget=="

# Downloads the Plasma 6 Window Title Applet from the GitHub repo
git clone https://github.com/harunkrl/plasma6-window-title-applet &>> /dev/null

install_dir=/usr/share/plasma/plasmoids/org.kde.windowtitle
sudo mkdir -p $install_dir

sudo cp -r $local_dir/plasma6-window-title-applet/* $install_dir
rm -rf $local_dir/plasma6-window-title-applet
echo "Window Title Widget Installed Successfully"

echo "==Installing Burn My Windows Desktop Effects=="
wget https://github.com/Schneegans/Burn-My-Windows/releases/latest/download/burn_my_windows_kwin6.tar.gz &>> /dev/null

install_dir=/usr/share/kwin/effects

sudo mkdir -p $install_dir
sudo tar -xf burn_my_windows_kwin6.tar.gz -C $install_dir
rm -f burn_my_windows_kwin6.tar.gz
echo "Burn My Windows Desktop Effects Installed Successfully"


echo "==Installing Global Theme=="

install_dir=/usr/share/plasma/look-and-feel
sudo cp -r $local_dir/SpottyKDE $install_dir

echo "==Installing KDE Login Themes=="
git clone https://github.com/dgudim/themes

read -p "Install all Login Splashes? (Y/n): " allLoginSplashes

if [ $allLoginSplashes -eq "y" ] || [ $allLoginSplashes -eq "Y" ]
then
    install_dir=/home/$USER/.local/share/plasma/look-and-feel
    echo "Installing All Splash Themes"
    cp -r $local_dir/themes/KDE-loginscreens/Illusion/contents/* $install_dir
    echo "Splash themes Installed to $install_dir"
    echo "Spalsh themes will appear as a 'global theme' and a 'splash sceen' in the system settings"
fi

install_dir=/usr/share/plasma/look-and-feel/SpottyKDE/contents/

splashThemeList=$(ls -d $local_dir/themes/KDE-loginscreens/*/)

if [ -f themelist ]
then
   rm themelist
fi

count=1
for theme in $splashThemeList
do
   echo "$(basename $theme)" | grep source &>> /dev/null
   output=$?
   if [ $output -ne 0 ]
   then
      echo "$count: $(basename $theme)" >> themelist
      ((count++))
   fi

done
((count--))

while read -r line
do 
   echo $line
done < themelist

read -p "Enter Theme number: (1 - $count): " selection
choice=Illusion

# Searches 
while read -r line
do
   echo $line | grep $selection &>> /dev/null
   output=$?
   if [ $output -eq 0 ]
   then 
      choice=$line
      break
   fi
done < themelist

count=0
for item in $choice
do 
   if [ $count -eq 1 ]
   then
      choice=$item
   fi
   count=1
done
sudo cp -r $local_dir/themes/KDE-loginscreens/$choice/contents/* $install_dir

echo "Restarting Plasma to apply changes"
systemctl --user restart plasma-plasmashell