#!/usr/bin/env bash

device_available=false

get_unlock_key(){
    unlock_data=$(fastboot oem get_unlock_data)
}

unlock_oem(){
    fastboot oem unlock "$1"
    fastboot oem unlock "$1"
    echo "$1"
}

flash_images(){
    fastboot oem fb_mode_set
    fastboot flash modem ./image/NON-HLOS.bin
    fastboot flash fsg ./image/fsg.mbn
    fastboot flash dsp ./image/adspso.bin
    fastboot flash boot ./image/boot.img
    fastboot flash recovery ./image/recovery.img
    fastboot flash system ./image/system.img_sparsechunk.0
    fastboot flash system ./image/system.img_sparsechunk.1
    fastboot flash system ./image/system.img_sparsechunk.2
    fastboot flash system ./image/system.img_sparsechunk.3
    fastboot flash system ./image/system.img_sparsechunk.4
    fastboot flash oem ./image/oem.img
    fastboot erase cache
    fastboot erase userdata
    fastboot oem fb_mode_clear
    fastboot reboot
}

wait_sec(){
    echo "wait for $1 seconds"
    sleep $1
}

poll_for_device(){
    avail=0
    echo "polling for $1"
    while [ $avail -ne 1 ]; do
        echo "device not availble in $1 mode "
        wait_sec 5
        if [[ "$1" == "device" ]]; then
            var="$(adb devices | awk 'NR==2' | grep $1)"
        elif [[ "$1" == "fastboot" ]]; then
            var="$(fastboot devices | awk 'NR==1' | grep $1)"
        else
            echo "Unknown mode $1"
        fi

        if [[ -z "$var" ]]; then
          continue
        else
            echo "Device available in $1 mode"
            return 1  
        fi
    done
}
 poll_for_device "device"
 
 if [ $? -eq 1 ]; then
  wait_sec 10
     adb reboot bootloader
 fi
 poll_for_device "fastboot"
 if [ $? -eq 1 ]; then
     echo "Into fastboot mode - unlocking the bootloader"
     get_unlock_key
    read -p "unlock key from your email" key
    unlock_oem "$key"
 fi
 wait_sec 10
 #read -p "ready to flash images (y/n)" flash_ok
 flash_images
wait_sec 5
read -p "Re-enable developer options" flash_ok
poll_for_device "device"
if [ $? -eq 1 ]; then
     adb reboot bootloader
fi

poll_for_device "fastboot"

fastboot flash recovery twrp-3.2.1-0-cedric.img
 read -p "Manually enter the recovery mode" recovery_mode
 adb push Magisk-v16.4.zip /sdcard
 adb push no-verity-opt-encrypt-5.1.zip /sdcard
 read -p "Installed magisk and no verify package (y/n)" twrp_installed
 if [ "$twrp_installed" == "y" ]; then
 poll_for_device "device"
 adb shell "su; exit; exit"
 fi



