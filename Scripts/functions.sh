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

isUserInstall() {
    local arguement=$1
    if [[ "$option"=="--user" || "$option"=="-u" ]]
    then
        true
    else
        false
    fi
}

isSystemInstall() {
    local option=$1
    if [[ "$option"=="--system" || "$option"=="-s" ]]
    then
        true
    else
        false
    fi
}

installJetbrains() {
    local installType=$1

    if isUserInstall $installType
    then
        # JetBrains Mono Font User Install
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)" &>> /dev/null
    elif isSystemInstall $installType
        # JetBrains Mono Font System Wide Install
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)" &>> /dev/null
        sudo mkdir -p /usr/share/fonts/TTF
        sudo mkdir -p /usr/share/fonts/variable
        sudo mkdir -p /usr/share/fonts/webfonts
        sudo mv /home/$USER/.local/share/fonts/fonts/ttf/JetBrainsMono* /usr/share/fonts/TTF/
        sudo mv /home/$USER/.local/share/fonts/fonts/variable/JetBrainsMono* /usr/share/fonts/variable/
        sudo mv /home/$USER/.local/share/fonts/fonts/webfonts/JetBrainsMono* /usr/share/fonts/webfonts/
    else
        local exitCode=141
        echo "Invalid Option or No option Provided"
        echo "Exit Code: $exitCode"
        exit $exitCode
    fi
}

installPapirus() {
    local installType=$1
    if isUserInstall $installType
    then
        # Papirus Icons Local User Install
        wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh
    elif isSystemInstall $isntallType
        # Papirus Icons System wide install
        wget -qO- https://git.io/papirus-icon-theme-install | sh
    fi
}

installSpottyKDE() {
    localDir=$1
    installType=$3
    if [[ "$installType"=="user" ]]
    then
        installDir=$HOME/.local/plasma/look-and-feel
        cp -r $localDir/SpottyKDE 
        installSplashScreens $localDir $installDir user
    else
        installDir=/usr/share/plasma/look-and-feel
        sudo cp -r $localDir/SpottyKDE
        installSplashScreens $localDir $installDir system

    fi
}

installSplashScreens() {
    localDir=$1
    installDir=$2
    installType=$3

    themeList=$(ls -d $localDir/themes/KDE-loginsscreen/*/)
}

themeListReadWriter() {
    themeDir=$1
    themeList=$2
    
}



directory=$(pwd)/themes

grep metadata.json $(ls ) &>> /dev/null
if isSuccessfull $?
then 
    echo "true"
else
    echo "false"
fi