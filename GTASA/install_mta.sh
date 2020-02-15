#!/bin/bash

export WINEPREFIX=~/.local/share/wineprefixes/GTASA
export WINEARCH=win32

print() {
    echo -e "\n=> $1"
}

echo "Multi Theft Auto installer script, created by MattRoot, completely kanging David Sn's script."
echo "With love and contributions by GNU_Raziel from PlayOnLinux.com"

# check if game has been installed
if [ ! -d $WINEPREFIX ]; then
    print "GTA: San Andreas is not installed, stopping installer..."
    exit 1
fi

# check if ptrace_scope is set to 0
if [ "$(cat /proc/sys/kernel/yama/ptrace_scope)" -eq "1" ]; then
    print "Setting /proc/sys/kernel/yama/ptrace_scope to 0..."
    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
fi

# install dependencies
print "Installing dependencies..."
winetricks -q dotnet20 corefonts d3dx9

# ask the user for setup.exe
print "Please select the setup file for installation."
echo "   IMPORTANT! Uncheck any *install* option, otherwise the setup might break."

SETUP_FILE=$(zenity --file-selection)

if [ $? -ne 0 ]; then
    print "No file selected, aborting..."
    exit 1
fi

wine "$SETUP_FILE"
wineboot -r

# install desktop shortcut
print "Installing desktop shortcut..."
mkdir -p ~/.local/share/icons
mkdir -p ~/.local/share/applications/games
cp -f MTA.png ~/.local/share/icons
cp -f MTA.desktop ~/.local/share/applications/games

# fix home directory in desktop shortcut
sed -i 's:$HOME:'"$HOME"':g' ~/.local/share/applications/games/MTA.desktop

# update desktop database
print "Updating desktop database..."
update-desktop-database ~/.local/share/applications

# finish!
print "Done! You can run San Andreas Multiplayer via the launcher or by executing Multi Theft Auto.exe"
echo "   Runscript is installed in $HOME/.local/share/wineprefixes/GTASA"
