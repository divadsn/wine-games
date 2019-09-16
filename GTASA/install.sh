#!/bin/bash

export WINEPREFIX=~/.local/share/wineprefixes/GTASA
export WINEARCH=win32

print() {
    echo -e "\n=> $1"
}

echo "GTA: San Andreas Wine installer script, created by David Sn."
echo "With love and contributions by GNU_Raziel from PlayOnLinux.com"

# check if game has been already installed
if [ -d $WINEPREFIX ]; then
    print "GTA: San Andreas is already installed, stopping installer..."
    exit 1
fi

# check if ptrace_scope is set to 0
if [ "$(cat /proc/sys/kernel/yama/ptrace_scope)" -eq "1" ]; then
    print "Setting /proc/sys/kernel/yama/ptrace_scope to 0..."
    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
fi

# create wineprefix
print "Creating wineprefix..."
wineboot -u

# install dependencies
print "Installing dependencies..."
winetricks -q d3dx9

# check if vulkan is installed and install d9vk
if [ -f "/usr/lib/libvulkan.so" ]; then
    print "Installing vulkan support for improved performance..."
    winetricks -q d3dcompiler_43 d9vk020
fi

# set video memory size in wine
if [ -f "/var/log/Xorg.0.log" ]; then
    DISPLAY_VRAM=$(($(grep -P -o -i "(?<=memory:).*(?=kbytes)" /var/log/Xorg.0.log) / 1024))
    print "Setting video memory to $DISPLAY_VRAM MB..."
    winetricks settings videomemorysize=$DISPLAY_VRAM
else
    print "Could not read video memory size from GPU, setting to default..."
    winetricks settings videomemorysize=default
fi

# enable virtual desktop
if [ -f "/usr/bin/xrandr" ]; then
    DISPLAY_SIZE=$(xrandr --current | grep  '*' | uniq | awk '{print $1}')
    print "Enabling wine virtual desktop at $DISPLAY_SIZE..."
    winetricks settings vd=$DISPLAY_SIZE
else
    print "Could not read display size from GPU, setting to 1024x768..."
    winetricks settings vd=1024x768
fi

# force cursor clipping for full-screen windows
print "Forcing cursor clipping for full-screen windows..."
winetricks settings grabfullscreen=y

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

cp runscript.sh $WINEPREFIX

# set OS version to Windows XP for default
print "Setting version to XP for default..."
winetricks settings winxp

# install desktop shortcut
print "Installing desktop shortcut..."
mkdir -p ~/.local/share/icons
mkdir -p ~/.local/share/applications/games
cp -f GTASA.png ~/.local/share/icons
cp -f GTASA.desktop ~/.local/share/applications/games

# fix home directory in desktop shortcut
sed -i 's:$HOME:'"$HOME"':g' ~/.local/share/applications/games/GTASA.desktop

# update desktop database
print "Updating desktop database..."
update-desktop-database ~/.local/share/applications

# finish!
print "Done! You can run GTA: San Andreas via the launcher or by executing gta_sa.exe"
echo "   Runscript is installed in $HOME/.local/share/wineprefixes/GTASA"