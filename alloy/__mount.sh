#
# __setup.sh
# alloy
# 
# Author: Wess Cope (you@you.you)
# Created: 11/20/2020
# 
# Copywrite (c) 2020 Wess.io
#

#!/usr/bin/env bash

fix_ld() {
  if [ -f etc/ld.so.preload ]; then
    sed -i 's@/usr/lib/arm-linux-gnueabihf/libcofi_rpi.so@\#/usr/lib/arm-linux-gnueabihf/libcofi_rpi.so@' etc/ld.so.preload
    sed -i 's@/usr/lib/arm-linux-gnueabihf/libarmmem.so@\#/usr/lib/arm-linux-gnueabihf/libarmmem.so@' etc/ld.so.preload

    # Debian Buster/ Raspbian 2019-06-20
    sed -i 's@/usr/lib/arm-linux-gnueabihf/libarmmem-${PLATFORM}.so@#/usr/lib/arm-linux-gnueabihf/libarmmem-${PLATFORM}.so@' etc/ld.so.preload
  fi
}

restore_ld() {
  if [ -f etc/ld.so.preload ]; then
    sed -i 's@\#/usr/lib/arm-linux-gnueabihf/libcofi_rpi.so@/usr/lib/arm-linux-gnueabihf/libcofi_rpi.so@' etc/ld.so.preload
    sed -i 's@\#/usr/lib/arm-linux-gnueabihf/libarmmem.so@/usr/lib/arm-linux-gnueabihf/libarmmem.so@' etc/ld.so.preload

    # Debian Buster/ Raspbian 2019-06-20
    sed -i 's@#/usr/lib/arm-linux-gnueabihf/libarmmem-${PLATFORM}.so@/usr/lib/arm-linux-gnueabihf/libarmmem-${PLATFORM}.so@' etc/ld.so.preload
  fi
}

detach() {
  for img in $(losetup  | grep $1 | awk '{ print $1 }' );  do
    if [[ -f $img ]]; then
    	losetup -d $img
    fi
  done
}

_has_image() {
  if [ ! -f "${IMG_FILE}" ]; then
    echo "No Raspberry Pi OS image found (${IMG_FILE})" | error
    exit
  fi
}

img_mount() {
  detach_loopback $IMG_FILE
  detach $IMG_FILE

  _has_image

  echo -e "Mounting image ${IMG_FILE} at ${MOUNT_DIR}..." | status


  # echo -e "Adding additional space to image..." | status
  # dd if=/dev/zero bs=1M count=2048 >> ${IMG_FILE}

  # echo -e "Setting up loop device..." | status
  # LD=$(losetup -f -P --show ${IMG_FILE})

  # trap 'losetup -d $LD' EXIT

  # echo -e "Expanding rootfs partition..." | status
  # growpart $LD 2

  # echo -e "Checking rootfs partition..." | status
  # e2fsck -fy ${LD}

  # echo -e "Resizing rootfs partition..." | status
  # resize2fs -p ${LD}

  # trap - EXIT

  boot_partition=1
  root_partition=2
  fdisk_output=$(sfdisk -d $IMG_FILE)

  boot_offset=$(($(echo "$fdisk_output" | grep "$IMG_FILE$boot_partition" | awk '{print $4-0}') * 512))
  root_offset=$(($(echo "$fdisk_output" | grep "$IMG_FILE$root_partition" | awk '{print $4-0}') * 512))

  echo "Mounting image $IMG_FILE on $MOUNT_DIR, offset for boot partition is $boot_offset, offset for root partition is $root_offset" | status

  detach_loopback $IMG_FILE

  losetup -f

  mount -o loop,offset=$root_offset $IMG_FILE $MOUNT_DIR/

  if [[ "$boot_partition" != "$root_partition" ]]; then
	  losetup -f
	  mount -o loop,offset=$boot_offset,sizelimit=$( expr $root_offset - $boot_offset ) $IMG_FILE $MOUNT_DIR/boot
  fi

  mkdir -p $MOUNT_DIR/dev/pts
  mount -o bind /dev $MOUNT_DIR/dev
  mount -o bind /dev/pts $MOUNT_DIR/dev/pts
  mount -o bind /proc $MOUNT_DIR/proc
}


img_unmount() {
  force=
  if [ "$#" -gt 1 ]; then
    force=$2
  fi

  sync
  if [ -n "$force" ]; then
    for process in $(lsof $MOUNT_DIR | awk '{print $2}'); do
      kill -9 $process
      echo "Killed process id $process..." | success
    done
  fi

  for m in $(mount | grep $MOUNT_DIR | awk -F " on " '{print $2}' | awk '{print $1}' | sort -r); do
    umount $m < /dev/null
    echo "Unmounted $m..." | success
  done

  detach_loopback $IMG_FILE
  murder_children
}

img_shrink() {
  echo -e "Compressing disk image..." | status

  start=$( fdisk -lu $IMG | grep Linux | awk '{print $2}' )
  size=$(( $( fdisk -lu $IMG | grep Linux | awk '{print $3 }' ) * 1024 ))

  LD=$(losetup -f -P --show ${IMG_FILE})

  trap 'losetup -d $LD' EXIT

  echo -e "Checking partition..." | status
  e2fsck -fy ${LD}

  padding=$( resize2fs -P /dev/loop2 2>/dev/null | grep '^Estimated' | awk -F : '{print $2 + 50000}' )

  echo -e "Resizing partition..." | status
  resize2fs ${LD}p2 $padding
  e2fsck -f ${LD}p2

  new_size=$( dumpe2fs /dev/loop2 2>/dev/null | grep '^Block count:' | awk '{print $3}' )
  t_news=$(( $P_NEWSIZE ))
  new_size=$(( T_NEWS ))
  new_end=$(( $P_START + ($P_NEWSIZE * 8) + 1 )) # in 512 byte sectors

  trap - EXIT

  echo -e "p\nd\n2\nn\np\n2\n$P_START\n$P_NEWEND\np\nw\n" | fdisk $IMG

  image_size=$((($new_end + 1) * 512))

  truncate -s $image_size $IMG_FILE
}