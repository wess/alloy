#
# __chroot.sh
# alloy
# 
# Author: Wess Cope (you@you.you)
# Created: 11/20/2020
# 
# Copywrite (c) 2020 Wess.io
#

#!/usr/bin/env bash

WPA_DIR="${MOUNT_DIR}/etc/wpa_supplicant"
WPA_FILE="${WPA_DIR}/wpa_supplicant.conf"
THEME_DIR="${MOUNT_DIR}/usr/share/plymouth/themes/alloy"
SPLASH_ASSET="${PWD}/${MANIFEST_BOOT_IMAGE}"

__run() {
  chroot $MOUNT_DIR $1
}

__install_packages() {
  __run <<"EOT"
apt-get update && apt-get install -y -q \
zsh \
vim \
plymouth \
plymouth-themes \
firmware-linux \
pix-plym-splash
EOT
}

__boot_theme() {
  mkdir -p ${MOUNT_DIR}/usr/share/plymouth/themes \
  && cp -R ${ALLOY_ROOT}/theme ${MOUNT_DIR}/usr/share/plymouth/themes/alloy
  

  if [ -f "${SPLASH_ASSET}" ]; then
    cp "${SPLASH_ASSET}" "${THEME_DIR}/splash.png"
  fi
}

__ssh() {
  if [ ${MANIFEST_BOOT_ENABLE_SSH} == "yes" || ${MANIFEST_BOOT_ENABLE_SSH} == "YES" ]; then
    __run "update-rc.d ssh enable"
  fi
}

__wpa() {
  mkdir -p ${WPA_DIR}
  update_config=MANIFEST_WIFI_UPDATE_CONFIG
  country=MANIFEST_WIFI_COUNTRY
  ssid=MANIFEST_WIFI_NETWORK_SSID
  passwd=MANIFEST_WIFI_NETWORK_PASSWORD

  __run echo <<- EOF > ${WPA_FILE}
    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    update_config=${update_config}
    country={country}

    network={
      ssid=${ssid}
      psk=${passwd}
    }  
EOF
}

chroot_build() {
  echo -e "Starting to build image requirements..." | status

  __boot_theme
  __wpa
  __ssh
  __install_packages

  chroot ${MOUNT_DIR} /bin/zsh
}