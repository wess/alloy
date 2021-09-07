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

source ${ALLOY_ROOT}/__exports.sh
source ${ALLOY_ROOT}/__cleanup.sh
source ${ALLOY_ROOT}/__init.sh
source ${ALLOY_ROOT}/__mount.sh
source ${ALLOY_ROOT}/__yaml.sh
source ${ALLOY_ROOT}/__chroot.sh
source ${ALLOY_ROOT}/__wpa.sh

MANIFEST_FILE=${PWD}/manifest.yaml

if [ ! -f "${MANIFEST_FILE}" ]; then
  echo "Unable to find manifest file: ${MANIFEST_FILE}" | error
  exit 1
fi

eval $(parse_yaml $MANIFEST_FILE "config_")

export PACKAGE_NAME=$config_name
export PACKAGE_DESCRIPTION=$config_description
export PACKAGE_VERSION=$config_version
export MANIFEST_SPLASH_IMAGE=$config_boot_splash
export MANIFEST_ENABLE_SSH=$config_enable_ssh
export MANIFEST_ENABLE_WPA=$config_enable_wpa

set_env_vars &&
init &&
setup_wpa &&
img_mount &&
chroot_build &&
img_unmount
#img_shrink
