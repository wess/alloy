#
# __create.sh
# alloy
# 
# Author: Wess Cope (you@you.you)
# Created: 08/24/2021
# 
# Copywrite (c) 2021 Wess.io
#

#!/usr/bin/env bash

CREATE_DIR=$1
shift

if [ -z "$CREATE_DIR" ]; then
  CREATE_DIR=${PWD}
fi

if [ "$1" == "." ]; then
  CREATE_DIR=${PWD}
fi

echo "Setting up Alloy in ${CREATE_DIR}..." | status

[[ -d $CREATE_DIR ]] || mkdir -p $CREATE_DIR

echo "Creating project directories..." | status

_ASSET_DIR="${CREATE_DIR}/assets"
_CONFIGS_DIR="${CREATE_DIR}/configs"

mkdir -p $_ASSET_DIR
mkdir -p $_CONFIGS_DIR

touch "$_CONFIGS_DIR/.gitkeep"

cp "$ALLOY_ROOT/assets/example_splash.png" "$_ASSET_DIR/splash-screen.png"

CREATE_NAME=${PWD##*/}

define _MANIFEST <<EOF
name: $CREATE_NAME
description: Your description here
version: 0.0.1

boot:
  splash: assets/splash_screen.png

enable:
  ssh: yes
  wpa: yes
EOF

echo "Creating initial manifest.yaml..." | status

_MANFEST_PATH="${CREATE_DIR}/manifest.yaml"

echo "$_MANIFEST" >> $_MANFEST_PATH

echo "Alloy project has been created." | success