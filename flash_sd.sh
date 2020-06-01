TMP_EXTRACTION_FOLDER="extracted_image/"

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
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


unzip "$COMPRESSED_IMAGE_PATH" -d $TMP_EXTRACTION_FOLDER

# Ensure only the image is extracted
if [ "$(find $TMP_EXTRACTION_FOLDER -type f | wc -l)" != "1" ]; then
  echo "Extraction resulted in more than 1 file. Exiting"
  exit 1
fi

IMAGE_PATH="extracted_image/$(ls extracted_image)"

read -r -p "Please ensure SD card is NOT inserted. Press any key to continue"
WITHOUT_SD_CARD=$(ls -b /dev/)

#ehco "Please insert SD card. Press any key to continue"
read -r -p "Please insert SD card. Press any key to continue"
WITH_SD_CARD=$(ls -b /dev/)

diff <(echo "$WITHOUT_SD_CARD") <(echo "$WITH_SD_CARD")

read -r -p "Please enter device name: " DEVICE_NAME
DEVICE_NAME="/dev/${DEVICE_NAME}"
DISK_SIZE="$(sudo blockdev --getsize64 "$DEVICE_NAME" | numfmt --to=iec-i --suffix=B)"

read -r -p "Are you sure you want to format disk: $DEVICE_NAME ($DISK_SIZE) Press y to continue: " RESPONSE
if [ "$RESPONSE" != "y" ]; then
  echo "Exiting"
  exit 1
fi

# shellcheck disable=SC2086
sudo umount $DEVICE_NAME*

sudo dd bs=4M status=progress if="$IMAGE_PATH" of="$DEVICE_NAME"
sudo sync

rm -r "$TMP_EXTRACTION_FOLDER"

echo "Done"
