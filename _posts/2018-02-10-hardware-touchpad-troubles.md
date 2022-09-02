---
layout: post
title:  "Touchpad troubles"
date:   2018-02-10 15:00:00 -0500
categories: hardware trouble
---

So, my Lenovo Yoga 13 has always had trouble with its touchpad. Previously, on a cold boot, the touchpad wouldn't work. Simply suspending and resuming the laptop would be enough to make it work, so it wasn't a huge concern.

With the latest round of updates, though, now the touchpad doesn't work _at all_, and I'm left with using either the touchscreen or some external device for a mouse. Nothing I've tried has managed to bring back my touchpad, and I'm suspecting it's not even showing up under `lsusb` any more...but I'm not even sure what's supposed to show up for this hardware; it's never been a popular model among Linux users.

Any suggestions welcome.

Here's some of the output of `dmidecode`:

```dmidecode
System Information
 Manufacturer: LENOVO
 Product Name: Mocca 2.0
 Version: Lenovo Ideapad YOGA 13
 Wake-up Type: Power Switch
 SKU Number: LENOVO_BI_IDEAPAD66
 Family: IDEAPAD
```

Here's the output of `lsusb`:

```lsusb
Bus 002 Device 004: ID 04f2:b322 Chicony Electronics Co., Ltd 
Bus 002 Device 003: ID 2047:0855 Texas Instruments Invensense Embedded MotionApp HID Sensor
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 005: ID 04f3:000a Elan Microelectronics Corp. Touchscreen
Bus 001 Device 004: ID 0bda:1724 Realtek Semiconductor Corp. RTL8723AU 802.11n WLAN Adapter
Bus 001 Device 003: ID 0bda:0129 Realtek Semiconductor Corp. RTS5129 Card Reader Controller
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

Here's the output of `lsusb -t`:

```lsusb-t
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 5000M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 480M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/2p, 480M
    |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/8p, 480M
        |__ Port 5: Dev 3, If 0, Class=Human Interface Device, Driver=usbhid, 12M
        |__ Port 7: Dev 4, If 0, Class=Video, Driver=uvcvideo, 480M
        |__ Port 7: Dev 4, If 1, Class=Video, Driver=uvcvideo, 480M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/2p, 480M
    |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/6p, 480M
        |__ Port 3: Dev 3, If 0, Class=Vendor Specific Class, Driver=rtsx_usb, 480M
        |__ Port 4: Dev 4, If 1, Class=Wireless, Driver=btusb, 480M
        |__ Port 4: Dev 4, If 2, Class=Vendor Specific Class, Driver=rtl8xxxu, 480M
        |__ Port 4: Dev 4, If 0, Class=Wireless, Driver=btusb, 480M
        |__ Port 5: Dev 5, If 0, Class=Human Interface Device, Driver=usbhid, 12M
```

(The content for this post was lost somehow. So this is a total rewrite. It's bizarre, because I thought I viewed it on the live site. Ah well. This is what unit tests are for. Suppose I'll need to figure out unit tests for my blog, like _there's content in every file under `_posts_`! ... Actually, that's not a bad idea. Could possibly even validate that all the links and embedded resources work...I'm doing a `git` workflow for my blog, so why not?)
