#!/usr/bin/env bash

read -r -p "Please ensure SD card is NOT inserted. Press any key to continue"
WITHOUT_SD_CARD=$(ls -b /dev/)

read -r -p "Please insert SD card. Press any key to continue"
WITH_SD_CARD=$(ls -b /dev/)

diff <(echo "$WITHOUT_SD_CARD") <(echo "$WITH_SD_CARD")
