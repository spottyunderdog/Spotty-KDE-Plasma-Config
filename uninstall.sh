#!/bin/bash

local_dir=$(pwd)

echo "==Uninstalling Spotty KDE Plasma Config and its Dependencies=="

echo "== Updating System =="
sudo pacman -Syu --no-confirm #&>> /dev/null

echo "== Unistalling Oxygen =="
sudo pacman -Rns --noconfirm oxygen oxygen-cursors oxygen-icons oxygen-icons-svg oxygen-sounds oxygen5 #&>> /dev/null

echo "== Uninstalling Papirus Icons =="
wget -qO- https://git.io/papirus-icon-theme-uninstall | sh #&>> /dev/null

echo "== Uninstalling JetBrains Mono Font =="
rm -rf /home/$USER/.local/share/fonts/ttf/JetBrainsMono*
rm -rf /home/$USER/.local/share/fonts/variable/JetBrainsMono* 

echo "== Uninstalling Plymouth Boot Themes =="
git clone https://github.com/adi1090x/plymouth-themes.git
rm -rf $local_dir/plymouth-themes/template
for i in {1..4}
do
    for themepack in $local_dir/plymouth-themes/pack_$i/*/
    do

        if [ -d $themepack ]
        then

            sudo rm -rf /usr/share/plymouth/themes/$(basename $themepack)

        fi
    done
done
rm -rf $local_dir/plymouth-themes    

echo "== Uninstalling Plasma 6 Window Title Applet =="
sudo rm -rf /usr/share/plasma/plasmoids/org.kde.plasma.windowtitle/

echo "== Unistalling Burn My Windows Effects =="
sudo rm -rf /usr/share/kwin/effects/kwin6_effect_*

echo "== Uninstalling Spotty KDE Plasma Global Theme =="
sudo rm -rf /usr/share/plasma/look-and-feel/SpottyKDE

echo "== Unistalling Splash Themes =="
git clone https://github.com/dgudim/themes
splashThemeList=$(ls -d $local_dir/themes/KDE-loginscreens/*/)
install_dir=/home/$USER/.local/share/plasma/look-and-feel

    
for theme in $splashThemeList
do
    echo $theme | grep source &>> /dev/null
    output=$?
    if [ $output -ne 0 ]
    then
        rm -rf $install_dir/$(basename $theme)
    fi
done
rm -rf $local_dir/themes

read -p "Uninstall Repository? (Y/n): " uninstallRepo
if [[ $uninstallRepo == "y" ]] || [[ $uninstallRepo == "Y" ]]
then
    rm -rf $local_dir
fi

read -p "Uninstall Completed, Rebooting Plasmashell, and Exiting Script."
systemctl --user restart plasma-plasmashell
sleep 1
read -p "Press Enter to Exit Script"