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

echo $IMAGE_PATH

#fdisk

#sudo dd bs=1M if=your_image_file_name.img of=/dev/sdx

#rm -r extracted_image/

echo "Done"
