#!/bin/bash
if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
    # Enable Bluetooth
    echo enable | sudo tee /proc/acpi/ibm/bluetooth > /dev/null
    echo 1 | sudo tee /sys/devices/platform/thinkpad_acpi/bluetooth_enable > /dev/null
    sudo rfkill unblock bluetooth
    sudo systemctl start bluetooth
    notify-send "Bluetooth" "Enabled" -i bluetooth
else
    # Disable Bluetooth
    sudo rfkill block bluetooth
    echo disable | sudo tee /proc/acpi/ibm/bluetooth > /dev/null
    echo 0 | sudo tee /sys/devices/platform/thinkpad_acpi/bluetooth_enable > /dev/null
    notify-send "Bluetooth" "Disabled" -i bluetooth-disabled
fi
