#!/usr/bin/env bash

set -e

CONFIG="$HOME/.config/hypr"

echo "Checking Lua syntax..."

find "$CONFIG" -name '*.lua' -print0 |
  while IFS= read -r -d '' file; do
    echo "Checking: $file"
    luac -p "$file"
  done

echo "All Lua files passed syntax checks!"
