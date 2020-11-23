#
# __main.sh
# alloy
# 
# Author: Wess Cope (you@you.you)
# Created: 11/23/2020
# 
# Copywrite (c) 2020 Wess.io
#

#!/usr/bin/env bash

source ${ALLOY_ROOT}/__echo.sh
source ${ALLOY_ROOT}/__exports.sh
source ${ALLOY_ROOT}/__helpers.sh
source ${ALLOY_ROOT}/__cleanup.sh
source ${ALLOY_ROOT}/__init.sh
source ${ALLOY_ROOT}/__mount.sh
source ${ALLOY_ROOT}/__yaml.sh

MANIFEST_FILE=${PWD}/manifest.yaml


if [ ! -f "${MANIFEST_FILE}" ]; then
  echo "Unable to find manifest file: ${MANIFEST_FILE}" | error
  exit 1
fi

MANIFEST=$(parse_yaml ${MANIFEST_FILE})

eval ${MANIFEST}

# set_env_vars
# init
# img_mount

# name="ancilla"
# description="Operating system a go go."
# version="0.0.1"
# settings__boot__image="assets/splash_screen.png"
# settings__wifi__ssid="Not connected."
# settings__wifi__password="Ca5h1134!"