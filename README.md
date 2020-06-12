# Raspberry Pi System Setup

## Run

The flash SD card script needs the following environment variables to be set:

- WIFI_SSID
- WIFI_PASSWORD

Run the following without the SD card inserted and only insert when prompted:

```shell script
source flash_sd.env && sudo ./flash_sd.sh --image <zip filepath>
```
