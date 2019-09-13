#!/bin/bash

export WINEPREFIX=~/.local/share/wineprefixes/TheSims3
export WINEARCH=win32

LAUNCHER=$(find $WINEPREFIX/drive_c -name "Sims3LauncherW.exe" -print -quit)
DXVK_HUD=1 wine "$LAUNCHER"