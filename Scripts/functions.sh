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

installJetbrains() {
    local installType=$1

    if isUserInstall "$installType"
    then
        # JetBrains Mono Font User Install
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)" &>> /dev/null
    
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
    
    else
        local exitCode=141
        echo "Invalid Option or No option Provided"
        echo "Exit Code: $exitCode"
        exit $exitCode
    fi
}

installPapirus() {
    local installType=$1
    if isUserInstall "$installType"
    then
        # Papirus Icons Local User Install
        wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh
    elif isSystemInstall "$installType"
    then
        # Papirus Icons System wide install
        wget -qO- https://git.io/papirus-icon-theme-install | sh
    fi
}

installSpottyKDE() {
    local localDir=$1
    local installType=$3
    if [[ "$installType" == "user" ]]
    then
        local installDir=$HOME/.local/plasma/look-and-feel
        cp -r "$localDir"/SpottyKDE "$installDir"
        installSplashScreens "$localDir" "$installDir" user
    else
        local installDir=/usr/share/plasma/look-and-feel
        sudo cp -r "$localDir"/SpottyKDE $installDir
        installSplashScreens "$localDir" $installDir system

    fi
}

installSplashScreens() {
    local localDir=$1
    local installType=$2
    local themeList
    themeList=$(ls -d "$localDir"/themes/KDE-loginscreens/*/)
    local theme
    #git clone https://github.com/dgudim/themes &>> /dev/null

    if isUserInstall $installType
    then 
        

}

addSplashThemesAsGlobalThemes() {
    local localDir=$1
    local themeList
    themeList=$(ls -d "$localDir"/themes/KDE-loginscreens/*/)
    local theme
    echo "Adding All Splash Screens As Global Themes"
    for theme in $themeList
    do 
        if isGlobalTheme $theme
        then
            echo "Adding $(basename $theme)"
            cp -r $theme "$HOME"/.local/share/plasma/look-and-feel
        fi
    done
    echo "Splashes Added"
}

removeEndingSlash(){
    local directory=$1
    if [[ "$directory" == "${*/}" ]]
    then
        local length=${#directory}
        local length=$((length - 1))
        local directory
        directory=$(echo "$directory" | cut -c -$length)
        echo "$directory"
    else
        echo "$directory"
    fi
}

findSplashTheme() {
    local num=$1
    local themesDir=$2
    themeDir=$(removeEndingSlash "$themesDir")
    local themeList
    themeList=$(ls -d "$themesDir"/*/)
    local count=1

    for theme in $themeList
    do

        if isGlobalTheme "$themesDir"/"$(basename "$theme")" && [ $count -eq "$num" ]
        then
            echo "$(basename "$theme")"
            break
        fi

    done
}

printValidSplashThemes() {
    local themesDir=$1
    local themeList=$(ls -d "$themesDir"/*/)
    themesDir=$(removeEndingSlash "$themesDir")
    local count=1
    local theme

    for theme in $themeList
    do
        
        if isGlobalTheme "$themesDir"/"$(basename "$theme")"
        then
            echo "$count: $(basename "$theme")"
            ((count++))
        fi
    done
    
}

path=$(pwd)

addSplashThemesAsGlobalThemes $path
