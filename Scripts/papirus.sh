#!/bin/bash

systemInstall=true

if [[ $systemInstall==false ]]
do
    # Papirus Icons Local User Install
    wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh
else
    # Papirus Icons System wide install
    wget -qO- https://git.io/papirus-icon-theme-install | sh
fi
