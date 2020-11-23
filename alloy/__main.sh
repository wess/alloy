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
source ${ALLOY_ROOT}/__chroot.sh

MANIFEST_FILE=${PWD}/manifest.yaml


if [ ! -f "${MANIFEST_FILE}" ]; then
  echo "Unable to find manifest file: ${MANIFEST_FILE}" | error
  exit 1
fi

MANIFEST=$(parse_yaml ${MANIFEST_FILE})
eval ${MANIFEST}

export PACKAGE_NAME=name
export PACKAGE_DESCRIPTION=description
export PACKAGE_VERSION=version
export MANIFEST_BOOT_IMAGE=settings__boot__image
export MANIFEST_BOOT_ENABLE_SSH=settings__boot__enable_ssh

export MANIFEST_WIFI_UPDATE_CONFIG=settings__wifi__update_config
export MANIFEST_WIFI_COUNTRY=settings__wifi__country
export MANIFEST_WIFI_NETWORK_SSID=settings__wifi__ssid
export MANIFEST_WIFI_NETWORK_PASSWORD=settings__wifi__password

set_env_vars
init
img_mount
chroot_build
img_shrink