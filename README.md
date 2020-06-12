# Raspberry Pi System Setup

## Run

The flash SD card script needs the following environment variables to be set:

- WIFI_SSID
- WIFI_PASSWORD

With the above set run:

```shell script
source flash_sd.env && ./flash_sd.sh --image <zip filepath>
```
