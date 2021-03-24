# Linux-only stuff. Abort if not Linux.
is_linux || return 1

e_info "Configuring KDE"

# change fonts
kwriteconfig5 --file kdeglobals --group General --key fixed "Hack,8,-1,5,50,0,0,0,0,0"
kwriteconfig5 --file kdeglobals --group General --key font "Noto Sans,8,-1,5,50,0,0,0,0,0"
kwriteconfig5 --file kdeglobals --group General --key menuFont "Noto Sans,8,-1,5,50,0,0,0,0,0"
kwriteconfig5 --file kdeglobals --group General --key smallestReadableFont "Noto Sans,8,-1,5,50,0,0,0,0,0"
kwriteconfig5 --file kdeglobals --group General --key toolBarFont "Noto Sans,8,-1,5,50,0,0,0,0,0"
kwriteconfig5 --file kdeglobals --group General --key activeFont "Noto Sans,8,-1,5,75,0,0,0,0,0"

# configure autolock
kwriteconfig5 --file kscreenlockerrc --group Daemon --key Autolock false

# configure breeze theme
kwriteconfig5 --file breezerc --group Common --key OutlineCloseButton false

# configure dolphin
kwriteconfig5 --file ktrashrc --group "/home/sion/.local/share/Trash" --key UseSizeLimit false
kwriteconfig5 --file ktrashrc --group "/home/sion/.local/share/Trash" --key UseTimeLimit false
kwriteconfig5 --file dolphinrc --group General --key BrowseThroughArchives true
kwriteconfig5 --file dolphinrc --group General --key ShowFullPath true
kwriteconfig5 --file dolphinrc --group General --key ShowSpaceInfo false
kwriteconfig5 --file dolphinrc --group General --key ShowZoomSlider false
kwriteconfig5 --file dolphinrc --group IconsMode --key IconSize 48
kwriteconfig5 --file dolphinrc --group MainWindow --key MenuBar Disabled

# configure konsole
cat > ~/.local/share/konsole/BlackOnGrey.colorscheme << "EOF"
[Background]
Color=239,240,241

[BackgroundIntense]
Color=239,240,241

[Color0]
Color=0,0,0

[Color0Intense]
Color=104,104,104

[Color1]
Color=178,24,24

[Color1Intense]
Color=255,84,84

[Color2]
Color=24,178,24

[Color2Intense]
Color=84,255,84

[Color3]
Color=178,104,24

[Color3Intense]
Color=255,255,84

[Color4]
Color=24,24,178

[Color4Intense]
Color=84,84,255

[Color5]
Color=178,24,178

[Color5Intense]
Color=255,84,255

[Color6]
Color=24,178,178

[Color6Intense]
Color=84,255,255

[Color7]
Color=178,178,178

[Color7Intense]
Color=255,255,255

[Foreground]
Color=0,0,0

[ForegroundIntense]
Color=0,0,0

[General]
Description=Black on Grey
Opacity=1
Wallpaper=
EOF

cat > ~/.local/share/konsole/Profile\ 1.profile << "EOF"
[Appearance]
ColorScheme=BlackOnGrey

[General]
Name=Profile 1
Parent=FALLBACK/

[Scrolling]
HistoryMode=2
EOF

kwriteconfig5 --file konsolerc --group "Desktop Entry" --key DefaultProfile Konsole.profile
kwriteconfig5 --file konsolerc --group KonsoleWindow --key SaveGeometryOnExit false
kwriteconfig5 --file konsolerc --group KonsoleWindow --key ShowAppNameOnTitleBar false
kwriteconfig5 --file konsolerc --group KonsoleWindow --key ShowMenuBarByDefault false
kwriteconfig5 --file konsolerc --group TabBar --key TabBarVisibility ShowTabBarWhenNeeded

# configure kwin
kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft ''
kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight IAX

mkdir ~/.local/share/color-schemes/
cat > ~/.local/share/color-schemes/BreezeLightTitlebar.colors << "EOF"
[ColorEffects:Disabled]
Color=56,56,56
ColorAmount=0
ColorEffect=0
ContrastAmount=0.65000000000000002
ContrastEffect=1
IntensityAmount=0.10000000000000001
IntensityEffect=2

[ColorEffects:Inactive]
ChangeSelectionColor=true
Color=112,111,110
ColorAmount=0.025000000000000001
ColorEffect=2
ContrastAmount=0.10000000000000001
ContrastEffect=2
Enable=false
IntensityAmount=0
IntensityEffect=0

[Colors:Button]
BackgroundAlternate=189,195,199
BackgroundNormal=239,240,241
DecorationFocus=61,174,233
DecorationHover=147,206,233
ForegroundActive=61,174,233
ForegroundInactive=127,140,141
ForegroundLink=41,128,185
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=49,54,59
ForegroundPositive=39,174,96
ForegroundVisited=127,140,141

[Colors:Selection]
BackgroundAlternate=29,153,243
BackgroundNormal=61,174,233
DecorationFocus=61,174,233
DecorationHover=147,206,233
ForegroundActive=252,252,252
ForegroundInactive=239,240,241
ForegroundLink=253,188,75
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=239,240,241
ForegroundPositive=39,174,96
ForegroundVisited=189,195,199

[Colors:Tooltip]
BackgroundAlternate=77,77,77
BackgroundNormal=49,54,59
DecorationFocus=61,174,233
DecorationHover=147,206,233
ForegroundActive=61,174,233
ForegroundInactive=189,195,199
ForegroundLink=41,128,185
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=239,240,241
ForegroundPositive=39,174,96
ForegroundVisited=127,140,141

[Colors:View]
BackgroundAlternate=239,240,241
BackgroundNormal=252,252,252
DecorationFocus=61,174,233
DecorationHover=147,206,233
ForegroundActive=61,174,233
ForegroundInactive=127,140,141
ForegroundLink=41,128,185
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=49,54,59
ForegroundPositive=39,174,96
ForegroundVisited=127,140,141

[Colors:Window]
BackgroundAlternate=189,195,199
BackgroundNormal=239,240,241
DecorationFocus=61,174,233
DecorationHover=147,206,233
ForegroundActive=61,174,233
ForegroundInactive=127,140,141
ForegroundLink=41,128,185
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=49,54,59
ForegroundPositive=39,174,96
ForegroundVisited=127,140,141

[General]
ColorScheme=Breeze Light Titlebar
Name=Breeze Light Titlebar
shadeSortColumn=true

[KDE]
contrast=4

[WM]
activeBackground=239,240,241
activeBlend=255,255,255
activeForeground=71,80,87
inactiveBackground=239,240,241
inactiveBlend=75,71,67
inactiveForeground=189,195,199
EOF

kwriteconfig5 --file kdeglobals --group General --key ColorScheme BreezeLightTitlebar

# configure power settings
kwriteconfig5 --file powermanagementprofilesrc --group AC --group DPMSControl --key idleTime 21600
kwriteconfig5 --file powermanagementprofilesrc --group AC --group DimDisplay --key idleTime 21600000

# download some desktop backgrounds
#if [ ! -f $HOME/Pictures/backgrounds.zip ]; then
#  wget "https://www.dropbox.com/s/5zmfmccdddw7d8m/backgrounds.zip?dl=0" -O $HOME/Pictures/backgrounds.zip
#  unzip -d $HOME/Pictures $HOME/Pictures/backgrounds.zip
#fi
