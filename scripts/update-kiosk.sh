#!/bin/bash

APP_DIR=$(cd $(dirname "$0")/.. && pwd)
KIOSK_APP_DIR='/media/pi/STATE/dev_image/share/kiosk_app/kiosk-app'

echo 'Updating kiosk app...'
sudo rm -rf "$KIOSK_APP_DIR"
sudo cp -r "$APP_DIR" "$KIOSK_APP_DIR"
sudo rm -rf "${KIOSK_APP_DIR}/scripts"

