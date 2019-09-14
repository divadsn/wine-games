#!/bin/bash

export WINEPREFIX=~/.local/share/wineprefixes/TheSims3
export WINEARCH=win32

cd $WINEPREFIX
echo "Searching for Sims3LauncherW.exe inside wineprefix..."
LAUNCHER=$(find ./drive_c -name "Sims3LauncherW.exe" -print -quit)

echo "Found: $LAUNCHER"
DXVK_HUD=fps wine "$LAUNCHER"
