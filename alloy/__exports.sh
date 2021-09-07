#
# __exports.sh
# alloy
# 
# Author: Wess Cope (you@you.you)
# Created: 11/20/2020
# 
# Copywrite (c) 2020 Wess.io
#

#!/usr/bin/env bash

set_env_vars() {
  if [ -z "${BUILD_DIR}" ]; then
    export ROOT_DIR="${PWD}/build"
  else
    export ROOT_DIR="${BUILD_DIR}"
  fi

  echo "Loading environment variables..." | status
  
  export IMG_DIR="${ROOT_DIR}/image"
  export CONFIG_DIR="${PWD}/configs"
  export ASSET_DIR="${ROOT_DIR}/assets"
  export IGNORE_FILE="${PWD}/.gitignore"
  export ZIP_FILE="${IMG_DIR}/raspios.zip"
  export IMG_FILE="${IMG_DIR}/raspios.img"
  export FILE_DOWNLOAD="raspios.download"
  export DOWNLOAD_URL="https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/2021-05-07-raspios-buster-armhf-lite.zip"
  export MOUNT_DIR="${ROOT_DIR}/mnt/rpi"
  export BOOT_DIR="${MOUNT_DIR}/boot"

  ##### WPA
  export WPA_CONFIG="${CONFIG_DIR}/wpa_supplicant.conf"
  export WPA_DIR="${MOUNT_DIR}/etc/wpa_supplicant"
  export WPA_FILE="${WPA_DIR}/wpa_supplicant.conf"
  
  export DIRS=("${IMG_DIR}" "${ASSET_DIR}" "${MOUNT_DIR}" "${BOOT_DIR}")
}

unset_env_vars() {
  unset IMG_DIR 
  unset ASSET_DIR 
  unset IGNORE_FILE 
  unset ZIP_FILE 
  unset IMG_FILE 
  unset FILE_DOWNLOAD 
  unset DOWNLOAD_URL
  unset MOUNT_DIR
  unset BOOT_DIR
}