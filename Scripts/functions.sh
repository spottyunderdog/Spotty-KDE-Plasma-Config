#!/bin/bash

isSuccessfull() {
    local exitCode=$1
    if [[ exitCode -ne 0 ]]
    then
        false
    else
        true
    fi
    
}

isGlobalTheme() {
    local themeDirectory=$1
    local file
    
    for file in "$themeDirectory"/*
    do
        case $file in 
            */metadata.json) true; return;;
        esac
    done
    false
}

isInUsrShareDir() {
    local path=$1

    case $path in
        /usr/share/*) true; return;;
    esac
    false
}

isUserInstall() {
    local option=$1
    if [[ "$option" == "--user" || "$option" == "-u" ]]
    then
        true
    else
        false
    fi
}

isSystemInstall() {
    local option=$1
    if [[ "$option" == "--system" || "$option" == "-s" ]]
    then
        true
    else
        false
    fi
}

isUninstall() {
    local option=$1
    if [[ "$option" == "--uninstall" ]]
    then
        true
    else
        false
    fi
}

isValidInputNum() {
    local input=$1
    local minInputNum=$2
    local maxInputNum=$3
    if [[ ! "$input" =~ ^[0-9]+$ ]]
    then
        echo "Input is not a Number. Please type the number corisponding to your choise"
        false
    elif [[ $input -lt $minInputNum ]]
    then
        echo "Input to small, please re-enter number for selection"
        false
    elif [[ $input -gt $maxInputNum ]]
    then
        echo "Input to large, please re-enter number for selection"
        false
    else
        true
    fi
}

installJetBrains() {
    local installType=$1
    echo "Installing JetBrains Mono Font & JetBrains Mono Nerd Font..."
    local installSuccessMes="JetBrains Mono Font & JetBrains Mono Nerd Font installed Succesfully"
    if isUserInstall "$installType"
    then
        # JetBrains Mono Font User Install
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)" &>> /dev/null
        sudo pacman -S --noconfirm --needed ttf-jetbrains-mono-nerd &>> /dev/null
        echo "$installSuccessMes"
    elif isSystemInstall "$installType"
    then
        # JetBrains Mono Font System Wide Install
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)" &>> /dev/null
        sudo mkdir -p /usr/share/fonts/TTF
        sudo mkdir -p /usr/share/fonts/variable
        sudo mkdir -p /usr/share/fonts/webfonts
        sudo mv /home/"$USER"/.local/share/fonts/fonts/ttf/JetBrainsMono* /usr/share/fonts/TTF/
        sudo mv /home/"$USER"/.local/share/fonts/fonts/variable/JetBrainsMono* /usr/share/fonts/variable/
        sudo mv /home/"$USER"/.local/share/fonts/fonts/webfonts/JetBrainsMono* /usr/share/fonts/webfonts/
        sudo pacman -S --noconfirm --needed ttf-jetbrains-mono-nerd &>> /dev/null
        echo "$installSuccessMes"
    else
        local exitCode=141
        echo "Invalid option or no option provided in function call"
        echo "Exit Code: $exitCode"
        exit $exitCode
    fi
}

installPapirusIcons() {
    local installType=$1
    echo "Installing Papirus Icons..."
    local installSuccessMes="Papirus Icons installed successfully"
    if isUserInstall "$installType"
    then
        # Papirus Icons Local User Install
        wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh
        echo "$installSuccessMes"
    elif isSystemInstall "$installType"
    then
        # Papirus Icons System wide install
        wget -qO- https://git.io/papirus-icon-theme-install | sh
        echo "$installSuccessMes"
    else
        local exitCode=142
        echo "Invalid option or no option provided in function call"
        echo "Exit Code: $exitCode"
        exit $exitCode
    fi
}

installSpottyKDE() {
    local installType=$1
    local localDir
    localDir=$(pwd)
    echo "Installing SpottyKDE Theme..."
    local installSuccessMes="SpottyKDE Theme Successfully installed"
    if isUserInstall "$installType"
    then
        local installDir=$HOME/.local/share/plasma/look-and-feel
        cp -r "$localDir"/SpottyKDE "$installDir"
        echo "$installSuccessMes"
    elif isSystemInstall "$installType"
    then
        local installDir=/usr/share/plasma/look-and-feel
        sudo cp -r "$localDir"/SpottyKDE $installDir
        echo "$installSuccessMes"
    else
        local exitCode=143
        echo "Invalid option or no option provided in function call"
        echo "Exit Code: $exitCode"
        exit $exitCode
    fi
}

installSplashScreens() {

    addSplashsToDirectory(){
        local themePath=$1
        local installDir=$2
        echo "Splash Theme List"
            printValidSplashThemes "$themePath"
            local numThemes
            numThemes=$(numValidSplashThemes "$themePath")
            echo ""
            echo "Enter the theme to be installed alongside SpottyKDE."
            read -rp "Enter num: (1-$numThemes) " themeSelection
            while ! isValidInputNum "$themeSelection" 1 "$numThemes"
            do
                read -rp "Enter num: (1-$numThemes) " themeSelection
            done
            local selectedTheme
            selectedTheme="$(findSplashTheme "$themeSelection" "$themePath")"

            if isInUsrShareDir  "$installDir"
            then
                sudo cp -r "$themePath"/"$selectedTheme"/contents/* "$installDir"
            else
                cp -r "$themePath"/"$selectedTheme"/contents/* "$installDir"
            fi

            read -rp "Would you like to install all Splash Screens as a Global theme? (Y/n) " addAllSplashes
            if [[ "$addAllSplashes" =~ ^[Yy] ]]
            then
                addSplashThemesAsGlobalThemes "$localDir"
            fi
    }
    addSplashThemesAsGlobalThemes() {
        local localDir=$1
        local themeList
        themeList=$(ls -d "$localDir"/themes/KDE-loginscreens/*/)
        local theme
        echo "Adding All Splash Screens As Global Themes"
        for theme in $themeList
        do 
            if isGlobalTheme "$theme"
            then
                echo "Adding $(basename "$theme")"
                cp -r "$theme" "$HOME"/.local/share/plasma/look-and-feel
                sleep 0.2
            fi
        done
        echo "Splashes Added"
    }
    findSplashTheme() {
        local num=$1
        local themesDir=$2
        local themeList
        themeList=$(ls -d "$themesDir"/*/)
        local count=1

        for theme in $themeList
        do

            if isGlobalTheme "$theme" && [ $count -eq "$num" ]
            then
                basename "$theme"
                break
            elif isGlobalTheme "$theme"
            then
                ((count++))
            fi

        done
    }
    numValidSplashThemes() {
        local themesDir=$1
        local themeList
        themeList=$(ls -d "$themesDir"/*/)
        local count=1
        local theme

        for theme in $themeList
        do
            
            if isGlobalTheme "$theme"
            then
                ((count++))
            fi
        done
        echo $((count-1))
    }
    printValidSplashThemes() {
        local themesDir=$1
        local themeList
        themeList=$(ls -d "$themesDir"/*/)
        local count=1
        local theme

        for theme in $themeList
        do
            if isGlobalTheme "$theme"
            then
                echo "$count: $(basename "$theme")"
                ((count++))
            fi
        done
    }
    local installType=$1
    local localDir
    localDir=$(pwd)
    themePath=$localDir/themes/KDE-loginscreens
    local installSuccessMes="Splash screen(s) installed successfully"

    git clone https://github.com/dgudim/themes

    if isUserInstall "$installType"
    then 
        local installDir="$HOME"/.local/share/plasma/look-and-feel/SpottyKDE/contents
        addSplashsToDirectory "$themePath" "$installDir"
        rm -rf "$localDir"/themes
        echo "$installSuccessMes"
    elif isSystemInstall "$installType"
    then
        local installDir=/usr/share/plasma/look-and-feel/SpottyKDE/contents
        addSplashsToDirectory "$themePath" $installDir
        rm -rf "$localDir"/themes
        echo "$installSuccessMes"
    else
        rm -rf "$localDir"/themes
        local exitCode=144
        echo "Invalid option or no option provided in function call"
        echo "Exit Code: $exitCode"
        exit $exitCode
    fi


}

installPlasmaWindowApplet() {
    local installTyp=$1
    local localDir
    localDir=$(pwd)
    echo "Installing plasma6-window-title-applet..."
    local installSuccessMes="Window Title Widget Installed Successfully"
    git clone https://github.com/harunkrl/plasma6-window-title-applet &>> /dev/null

    if isUserInstall $installType
    then
        local installDir="$HOME"/.local/share/plasma/plasmoids/org.kde.windowtitle
        mkdir -p $installDir
        cp -r $localDir/plasma6-window-title-applet/* $installDir
        rm -rf $localDir/plasma6-window-title-applet
        echo "$installSuccessMes"
    elif isSystemInstall $installType
    then
        local installDir=/usr/share/plasma/plasmoids/org.kde.windowtitle
        sudo mkdir -p $installDir
        sudo cp -r $localDir/plasma6-window-title-applet/* $installDir
        rm -rf $localDir/plasma6-window-title-applet
        echo "$installSuccessMes"
    else
        rm -rf $localDir/plasma6-window-title-applet
        exitCode=145
        echo "Invalid option or no option provided in function call"
        echo "Exit Code: $exitCode"
        exit $exitCode
    fi
}

installBurnMyWindowsEffects() {
    local installType=$1
    local localDir
    localDir=$(pwd)
    echo "Installing Burn My Windows Desktop Effects"
    local installSuccessMes="Burn My Windows Desktop Effects installed successfully"
    wget https://github.com/Schneegans/Burn-My-Windows/releases/latest/download/burn_my_windows_kwin6.tar.gz &>> /dev/null
    if isUserInstall $installType
    then
        local installDir="$HOME"/.local/share/kwin/effects
        mkdir -p $installDir
        tar -xf burn_my_windows_kwin6.tar.gz -C $installDir
        rm -f $localDir/burn_my_windows_kwin6.tar.gz
        echo "$installSuccessMes"
    elif isSystemInstall $installType
    then
        local installDir=/usr/share/kwin/effects
        sudo mkdir -p $installDir
        sudo tar -xf burn_my_windows_kwin6.tar.gz -C $installDir
        rm -f $localDir/burn_my_windows_kwin6.tar.gz
        echo "$installSuccessMes"
    else
        rm -f $localDir/burn_my_windows_kwin6.tar.gz
        exitCode=145
        echo "Invalid option or no option provided in function call"
        echo "Exit Code: $exitCode"
        exit $exitCode
    fi
    fi

}

displayPackagesToInstall() {
    echo "The Dependencie are:"
    echo "Oxygen Theme, Papirus Icons, JetBrains Mono Font, Plymouth Boot Themes, Window Title Widget, Burn My Windows Desktop Effects"
    echo "What will be installed:"
    echo "== Pacman Packages =="
    echo "- oxygen"
    echo "- oxygen-cursors"
    echo "- oxygen-icons"
    echo "- oxygen-icons-svg"
    echo "- oxygen-sounds"
    echo "- oxygen5"
    echo "== Papirus Icon Theme =="
    echo "link: https://github.com/PapirusDevelopmentTeam/papirus-icon-theme"
    echo "== JetBrains Mono Font =="
    echo "link: https://www.jetbrains.com/lp/mono/"
    echo "link: https://github.com/JetBrains/JetBrainsMono"
    echo "== JetBrains Mono NerdFont== "
    echo "link: https://github.com/ryanoasis/nerd-fonts"
    echo "== Plymouth Boot Themes =="
    echo "link: https://github.com/adi1090x/plymouth-themes"
    echo "== Window Title Widget =="
    echo "Link: https://github.com/harunkrl/plasma6-window-title-applet"
    echo "== Burn My Windows Desktop Effects =="
    echo "Link: https://github.com/Schneegans/Burn-My-Windows"
    echo "== Splash Themes =="
    echo "link: https://github.com/dgudim/themes"
}

installAllItems() {
    installType=$1

    echo "Welcome to Spotty's KDE Theme Installer"
    echo "This script will install the Spotty KDE Plasma Config and its dependencies to your system"
    displayPackagesToInstall
    read -rp "Do you want to proceed with the installation? (Y/n): " installTheming

    if [[ "$installTheming" =~ ^[Nn] ]]
    then
        echo "Installation Canceled"
        exit 0
    fi

    sudo pacman -Syu --no-confirm

    installJetBrains "$installType"

    installPapirusIcons "$installType"

    installBurnMyWindowsEffects "$installType"

    installPlasmaWindowApplet "$installType"

    installSpottyKDE "$installType"

    installSplashScreens "$installType"

    echo "Install Complete"
}

unistallConfiguration() {
    
    # Uninstalls Papirus
    wget -qO- https://git.io/papirus-icon-theme-uninstall | sh

}

arguement=$1

if [ $# -ne 1 ]
then
    error=130
    echo "Invalid Number of Arguements Provided"
    echo "Exit Code: $error"
    exit $error
elif ! isUserInstall $arguement && ! isSystemInstall $arguement
then
    error=131
    echo "No Valid Arguement Provided"
    echo "Exit Code: $error"
    exit $error
else
    installAllItems $arguement
fi