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
        echo "Invalid option or no option provided in function call"
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

    addSplashsToDirectory(){
        local themePath=$1
        local installDir=$2
        echo "Splash Theme List"
            printValidSplashThemes $themePath
            local numThemes=$(numValidSplashThemes "$themePath")
            echo ""
            echo "Enter the theme to be installed alongside SpottyKDE."
            read -rp "Enter num: (1-$numThemes) " themeSelection
            while ! isValidInputNum $themeSelection 1 $numThemes
            do
                read -rp "Enter num: (1-$numThemes) " themeSelection
            done
            local selectedTheme="$(findSplashTheme $themeSelection $themePath)"

            if isInUsrShareDir  "$installDir"
            then
                sudo cp -r $themePath/$selectedTheme/contents/* "$installDir"
            else
                cp -r $themePath/$selectedTheme/contents/* "$installDir"
            fi

            read -rp "Would you like to install all Splash Screens as a Global theme? (Y/n) " addAllSplashes
            if [[ "$addAllSplashes" =~ ^[Yy] ]]
            then
                addSplashThemesAsGlobalThemes $localDir
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
            if isGlobalTheme $theme
            then
                echo "Adding $(basename $theme)"
                cp -r $theme "$HOME"/.local/share/plasma/look-and-feel
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

            if isGlobalTheme $theme && [ $count -eq "$num" ]
            then
                echo "$(basename $theme)"
                break
            elif isGlobalTheme $theme
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
            
            if isGlobalTheme $theme
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
    local localDir=$1
    local installType=$2
    themePath=$localDir/themes/KDE-loginscreens
    echo $themePath
    git clone https://github.com/dgudim/themes

    if isUserInstall "$installType"
    then 
        local installDir="$HOME"/.local/share/plasma/look-and-feel/SpottyKDE/contents
        
        addSplashsToDirectory $themePath $installDir
    elif isSystemInstall "$installType"
    then
        local installDir=/usr/share/plasma/look-and-feel/SpottyKDE/contentsS
        addSplashsToDirectory $themePath $installDir
    else
        local exitCode=144
        echo "Invalid option or no option provided in function call"
        echo "Exit Code: $exitCode"
        exit $exitCode
    fi
    rm -rf $localDir/themes
    echo "Install complete"

}

path=$(pwd)
#printValidSplashThemes $path/themes/KDE-loginscreens
installSplashScreens $path --user
