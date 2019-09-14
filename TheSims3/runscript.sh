#!/bin/bash

export WINEPREFIX=~/.local/share/wineprefixes/TheSims3
export WINEARCH=win32

cd $WINEPREFIX

LAUNCHER=$(find $(pwd)/drive_c -name "Sims3LauncherW.exe" -print -quit)
echo "Starting using $LAUNCHER..."
DXVK_HUD=1 wine "$LAUNCHER"
