#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run $(basename "$0") as root"
  exit 1
fi

set -e

DIR="$(cd $(dirname "$0") && pwd)"
source "${DIR}/env.sh"

# The device needs to be mounted before we can use it
trap unmount-device EXIT
mount-device

echo 'Enabling kiosk mode...'

if grep -F -- '--force-kiosk-mode' "$CHROME_CONF_FILE" &> /dev/null; then
  echo "${CHROME_CONF_FILE} up-to-date"
else
  echo "Updating ${CHROME_CONF_FILE}..."
  echo '--force-kiosk-mode' >> "$CHROME_CONF_FILE"
fi

echo
"${DIR}/update-kiosk.sh"
