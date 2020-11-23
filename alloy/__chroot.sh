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

__run() {
  chroot $MOUNT_DIR $1
}

__install_packages() {
  __run <<"EOT"
apt-get update && apt-get install -y -q \
bim \
plymouth \
plymouth-themes \
firmware-linux
EOT
}

__wpa() {
  
}

chroot() {
  chroot $MOUNT_DIR
}