# Southland Missions Chrome Kiosk App

A Chrome kiosk app comprised of a control panel and webview. Based off of the
[Chrome Browser Kiosk App](https://chrome.google.com/webstore/detail/chrome-browser-kiosk-app/ojobnhicjbdfefeadmofdignefplocem)
example app.

## Initial Setup

1. Insert an SD card to install the kiosk on via USB adapter 
2. Run `sudo ./scripts/install-os.sh`
3. Boot the kiosk SD card and configure WiFi
4. Re-insert the kiosk SD card via USB
5. Run `sudo ./scripts/initialize-kiosk.sh`
6. Boot the SD card and the kiosk app will automatically start up

## Updating the App

If there are changes to the kiosk app (i.e. the interface) they can be applied
to the kiosk by inserting the kiosk SD card via USB adapter and running
`sudo ./scripts/update-kiosk.sh`. This only needs to be done for updates to the
kiosk app, updates to the websites it connects to will automatically update.

## Updating WiFi settings

Kiosk mode has to be disabled in order to access WiFi settings.

1. Insert the kiosk's SD card via USB adapter
2. Run `sudo ./scripts/disable-kiosk.sh` 
3. Boot the kiosk SD card and configure WiFi
4. Re-insert the kiosk SD card via USB
5. Run `sudo ./scripts/enable-kiosk.sh`

`enable-kiosk.sh` also updates the kiosk app.

