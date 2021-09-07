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


THEME_DIR="${MOUNT_DIR}/usr/share/plymouth/themes/alloy"
SPLASH_ASSET="${PWD}/${MANIFEST_SPLASH_IMAGE}"

__run() {
  chroot $MOUNT_DIR $1
}

__install_packages() {
  __run <<"EOT"
apt-get update --allow-releaseinfo-change && apt-get install -y -q \
zsh \
vim \
git \
plymouth \
plymouth-themes \
firmware-linux \
pix-plym-splash
EOT
}

__boot_theme() {
  mkdir -p ${MOUNT_DIR}/usr/share/plymouth/themes                                                                          \
  && cp -R ${ALLOY_ROOT}/theme ${MOUNT_DIR}/usr/share/plymouth/themes/alloy
  

  if [ -f "$SPLASH_ASSET" ]; then
    cp "$SPLASH_ASSET" "${THEME_DIR}/splash.png"
  fi
}

__ssh() {
  if [ "$MANIFEST_BOOT_ENABLE_SSH" == "yes" ]; then
    __run "update-rc.d ssh enable"
  fi
}

chroot_build() {
  echo -e "Starting to build image requirements..." | status

  __boot_theme &&
  __ssh &&
  __install_packages
}