Intro
=====

This is a script to flash an image on Android phone. Written explicitly for moto g5, might need some tweaks to make it work for other devices.

Pre-Reqs
--------
* A directory image with the content of the image extracted into it.
* Magisk and no-verify-opy-encrypt packages in the dir same as the script.
`
flash_motog5.sh`
`Magisk-v16.4.zip`
`no-verity-opt-encrypt-5.1.zip`
`twrp img`
`image<directory>-the contents of the image`


Run
---
* [Unlock Bootloader at](https://motorola-global-portal.custhelp.com/app/standalone/bootloader/unlock-your-device-b)
* Run the script flash_motog5.sh
* Give the key when prompted
* Follow the instructions prompted. Will require manual intervention to enable developer options and to open recovery mode.