var plasma = getApiVersion(1);

var layout = {
    "desktops": [
        {
            "applets": [
            ],
            "config": {
                "/": {
                    "ItemGeometries-1920x1200": "",
                    "ItemGeometriesHorizontal": "",
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        }
    ],
    "panels": [
        {
            "alignment": "right",
            "applets": [
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "178",
                            "popupWidth": "216"
                        }
                    },
                    "plugin": "org.kde.plasma.userswitcher"
                },
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        }
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "513",
                            "popupWidth": "702"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "favoritesPortedToKAstats": "true",
                            "icon": "start-here-archlinux",
                            "systemFavorites": "suspend\\,hibernate\\,reboot\\,shutdown"
                        }
                    },
                    "plugin": "org.kde.plasma.kickoff"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "400",
                            "popupWidth": "560"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        }
                    },
                    "plugin": "org.kde.plasma.appmenu"
                },
                {
                    "config": {
                        "/Appearance": {
                            "txt": "%a"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/Substitutions": {
                            "subsReplace": "\"Telegram\",\"Gimp\",\"LibreOffice\",\"Spotify\",\"Kate\""
                        }
                    },
                    "plugin": "org.kde.windowtitle"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "451",
                            "popupWidth": "560"
                        },
                        "/Appearance": {
                            "customDateFormat": "MMM d, yyyy |",
                            "dateDisplayFormat": "BesideTime",
                            "dateFormat": "custom",
                            "fontFamily": "Noto Sans",
                            "fontWeight": "400",
                            "use24hFormat": "2"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        }
                    },
                    "plugin": "org.kde.plasma.digitalclock"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                        "/": {
                            "CurrentPreset": "org.kde.plasma.systemmonitor",
                            "popupHeight": "249",
                            "popupWidth": "233"
                        },
                        "/Appearance": {
                            "chartFace": "org.kde.ksysguard.piechart",
                            "showTitle": "false",
                            "title": "Network Speed"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/SensorColors": {
                            "network/all/download": "60,131,208",
                            "network/all/upload": "208,137,60"
                        },
                        "/Sensors": {
                            "highPrioritySensorIds": "[\"network/all/upload\",\"network/all/download\"]",
                            "lowPrioritySensorIds": "[\"network/all/uploadBits\",\"network/all/downloadBits\"]"
                        },
                        "/org.kde.ksysguard.textonly/General": {
                            "groupByTotal": "true"
                        }
                    },
                    "plugin": "org.kde.plasma.systemmonitor.net"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "400",
                            "popupWidth": "560"
                        }
                    },
                    "plugin": "org.kde.plasma.mediacontroller"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.systemtray"
                }
            ],
            "config": {
                "/": {
                    "formfactor": "2",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "height": 1.5,
            "hiding": "normal",
            "lengthMode": "fill",
            "location": "top",
            "maximumLength": 106.66666666666667,
            "minimumLength": 106.66666666666667,
            "offset": 0,
            "opacity": "adaptive"
        },
        {
            "alignment": "center",
            "applets": [
                {
                    "config": {
                        "/": {
                            "popupHeight": "400",
                            "popupWidth": "560"
                        }
                    },
                    "plugin": "org.kde.milou"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.showdesktop"
                },
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "launchers": "applications:systemsettings.desktop,preferred://filemanager,preferred://browser"
                        }
                    },
                    "plugin": "org.kde.plasma.icontasks"
                },
                {
                    "config": {
                        "/": {
                            "formfactor": "0",
                            "immutability": "1",
                            "lastScreen": "-1",
                            "popupHeight": "419",
                            "popupWidth": "288",
                            "wallpaperplugin": ""
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "url": "~/Downloads"
                        }
                    },
                    "plugin": "org.kde.plasma.folder"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.trash"
                },
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        }
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                }
            ],
            "config": {
                "/": {
                    "formfactor": "2",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "height": 3,
            "hiding": "dodgewindows",
            "lengthMode": "fit",
            "location": "bottom",
            "maximumLength": 106.66666666666667,
            "minimumLength": 106.66666666666667,
            "offset": 0,
            "opacity": "adaptive"
        }
    ],
    "serializationFormatVersion": "1"
}
;

plasma.loadSerializedLayout(layout);
