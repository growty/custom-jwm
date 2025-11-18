#!/bin/bash

# Device name to search for
DEVICE_NAME="Elan Touchpad"

# Get device ID dynamically by matching the device name
DEVICE_ID=$(xinput list --id-only "$DEVICE_NAME")

# Check if device ID was found
if [ -z "$DEVICE_ID" ]; then
  echo "Error: Device '$DEVICE_NAME' not found."
  exit 1
fi

echo "Using device ID: $DEVICE_ID for device: $DEVICE_NAME"

# Enable tap to click
xinput set-prop $DEVICE_ID "libinput Tapping Enabled" 1

# Reverse scroll direction (simulate natural scrolling)
xinput set-prop $DEVICE_ID "libinput Scroll Methods Available" 0 1 0
xinput set-prop $DEVICE_ID "libinput Scroll Method Enabled" 0 1 0

# Try reverse by flipping distance (if synaptics driver)
xinput set-prop $DEVICE_ID "Synaptics Scrolling Distance" -111 111
