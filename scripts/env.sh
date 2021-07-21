#!/bin/bash

: ${DEVICE:=/dev/sda}
DEVICE_MOUNT_POINT='/media'
DEVICE_STATE_MOUNT="${DEVICE_MOUNT_POINT}/state"
DEVICE_ROOT_MOUNT="${DEVICE_MOUNT_POINT}/root"
DEVICE_ETC="${DEVICE_ROOT_MOUNT}/etc"

CHROME_CONF_FILE="${DEVICE_ETC}/chrome_dev.conf"

KIOSK_DIR="${DEVICE_STATE_MOUNT}/dev_image/share/kiosk_app"
KIOSK_APP_BASENAME='kiosk-app'
KIOSK_APP_DIR="${KIOSK_DIR}/${KIOSK_APP_BASENAME}"

unmount-dir() {
  # Unmounts and, if successful, removes each directory
  for var in "$@"; do
    if [ -e "$var" ]; then
      umount "$var"
      rmdir "$var"
    fi
  done
}

unmount-device() (
  # Unmount all device partitions
  set +e # Proceed even if there are errors

  # Unmount and remove the directories we plan to mount to
  unmount-dir "$DEVICE_STATE_MOUNT" "$DEVICE_ROOT_MOUNT"

  # Unmount the entire device in case any partitons were missed
  umount "${DEVICE}"?* &> /dev/null

  return 0 # Ensure a successful return
)

mount-device() (
  # Mount desired device partitions
  set -e # Exit if any commands fail

  # Unmount the device and create the mount points we plan to use
  unmount-device
  mkdir -p "$DEVICE_STATE_MOUNT" "$DEVICE_ROOT_MOUNT"

  # Mount the partitions we need
  mount "${DEVICE}1" "$DEVICE_STATE_MOUNT"
  mount "${DEVICE}3" "$DEVICE_ROOT_MOUNT"
)
