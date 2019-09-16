#!/bin/bash

export WINEPREFIX=~/.local/share/wineprefixes/TheSims3
export WINEARCH=win32

if [ -z "$1" ]; then
    echo "No file to run supplied! Usage: runscript.sh <executable_name>"
    exit 1
fi

cd $WINEPREFIX
echo "Searching for $1 inside wineprefix..."

LAUNCHER=$(find ./drive_c -name $1 -print -quit)
BASEDIR=$(dirname "$LAUNCHER")
echo "Found: $BASEDIR"

cd "$BASEDIR"
DXVK_HUD=fps wine $1