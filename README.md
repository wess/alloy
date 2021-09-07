# Alloy
> Alloy is a nice little setup for generating, down to the boot/spash screen, custom raspberry pi images.

*** THIS IS NOT CLOSE TO READY, But i do appreciate the interest ***


### WPA Options/setup
> WPA Section of the manifest resembles the same as the wpa_supplicant.conf options.

```
#### Standard wpa_supplicant.conf.

## WPA/WPA2 secured
#network={
#  ssid="put SSID here"
#  psk="put password here"
#}

## Open/unsecured
#network={
#  ssid="put SSID here"
#  key_mgmt=NONE
#}

## WEP "secured"
##
## WEP can be cracked within minutes. If your network is still relying on this
## encryption scheme you should seriously consider to update your network ASAP.
#network={
#  ssid="put SSID here"
#  key_mgmt=NONE
#  wep_key0="put password here"
#  wep_tx_keyidx=0
#}

# Uncomment the country your Pi is in to activate Wifi in RaspberryPi 3 B+ and above
# For full list see: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
country=GB # United Kingdom
#country=CA # Canada
#country=DE # Germany
#country=FR # France
#country=US # United States
```

> For Manifest:

```
wpa:
  country: us
  update_config: 1
  ctrl_interface: /var/run/wpa_supplicant
  network:
    scan_ssid: 1
    ssid: Not connected.
    psk: Ca5h1134!

```
