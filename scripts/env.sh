#!/bin/bash

: ${DEVICE:=/dev/sda}
DEVICE_MOUNT_POINT='/media'
DEVICE_STATE_MOUNT="${DEVICE_MOUNT_POINT}/state"
DEVICE_ROOT_MOUNT="${DEVICE_MOUNT_POINT}/root"
DEVICE_ETC="${DEVICE_ROOT_MOUNT}/etc"

KIOSK_DIR="${DEVICE_STATE_MOUNT}/dev_image/share/kiosk_app"
KIOSK_APP_BASENAME='kiosk-app'
KIOSK_APP_DIR="${KIOSK_DIR}/${KIOSK_APP_BASENAME}"

unmount-device() (
  # Unmount all device partitions
  set +e # Proceed even if there are errors

  # Unmount the entire device
  umount "${DEVICE}"?* &> /dev/null

  # Unmount and remove the directories we plan to mount to
  umount "$DEVICE_STATE_MOUNT" "$DEVICE_ROOT_MOUNT" &> /dev/null
  rm -rf "$DEVICE_STATE_MOUNT" "$DEVICE_ROOT_MOUNT" &> /dev/null

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
