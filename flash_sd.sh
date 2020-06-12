#!/usr/bin/env bash

TMP_EXTRACTION_FOLDER="extracted_image/"

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -d|--device)
    DEVICE_PATH="$2"
    shift
    shift
    ;;
    -i|--image)
    COMPRESSED_IMAGE_PATH="$2"
    shift
    shift
    ;;
    -h)
    echo "-i to specify the zipped image"
    shift
    ;;
    *)    # unknown option
    shift
    ;;
esac
done

if [ -z "$DEVICE_PATH" ]; then
  echo "Error: Missing device specified"
  exit 1;
fi

if [ -z "$COMPRESSED_IMAGE_PATH" ]; then
  echo "Error: Missing image specified"
  exit 1;
fi

DISK_SIZE="$(blockdev --getsize64 "$DEVICE_PATH" | numfmt --to=iec-i --suffix=B)"

read -r -p "Are you sure you want to format disk: $DEVICE_PATH ($DISK_SIZE) Press y to continue: " RESPONSE
if [ "$RESPONSE" != "y" ]; then
  echo "Exiting"
  exit 1
fi

unzip "$COMPRESSED_IMAGE_PATH" -d $TMP_EXTRACTION_FOLDER

# Ensure only the image is extracted
if [ "$(find $TMP_EXTRACTION_FOLDER -type f | wc -l)" != "1" ]; then
  echo "Error: extraction resulted in more than 1 file. Exiting"
  exit 1
fi

IMAGE_PATH="$TMP_EXTRACTION_FOLDER/$(ls $TMP_EXTRACTION_FOLDER)"

# shellcheck disable=SC2086
umount $DEVICE_PATH*

dd bs=4M status=progress if="$IMAGE_PATH" of="$DEVICE_PATH"
sync

# Configure WIFI and SSH for flashed image
BOOT_MOUNT_PATH="/media/pi_boot"
mkdir -p $BOOT_MOUNT_PATH

fdisk -l | grep "$DEVICE_PATH"
read -r -p "Please enter boot device: " BOOT_DEVICE

mount -t vfat "$BOOT_DEVICE" "$BOOT_MOUNT_PATH"

touch "$BOOT_MOUNT_PATH"/ssh

cat <<EOM > "$BOOT_MOUNT_PATH"/wpa_supplicant.conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=GB

network={
 ssid="$WIFI_SSID"
 psk="$WIFI_PASSWORD"
 priority=1
 id_str="default"
}
EOM

# Cleanup temporary files
sync
# shellcheck disable=SC2086
umount $DEVICE_PATH*
rm -r "$TMP_EXTRACTION_FOLDER"
rm -r "$BOOT_MOUNT_PATH"

echo "SD Flash complete"
