---
layout: post
title:  "A Color-Safe Palette"
date:   2018-02-11 15:00:00 -0500
categories: technique colorblind
---

So, while I've been using [this colorblind palette](http://jfly.iam.u-tokyo.ac.jp/color/#pallet) by Masataka Okabe and Kei Ito, the palette is presented only as a screenshot; I can't copy/paste values. Worse, it doesn't come with hex values, which are what I'm most likely to need. So here's that same palette presented as a pair of tables, one with decimal values for channel percentages, and one with with decimal (0-255 range), hex and combined-hex values.

## Percentages RGB, CMYK

| Color Name | R | G | B | C | M | Y | K |
| --- | --- | --- | --- | --- | --- | --- | --- |
| <span style="color:#000000; font-weight:bold"> black </span> | 0 | 0 | 0 | 0 | 0 | 0 | 100 |
| <span style="color:#E69F00; font-weight:bold"> orange </span> | 90 | 60 | 0 | 0 | 50 | 100 | 0 |
| <span style="color:#56B4E9; font-weight:bold"> sky blue </span> | 35 | 70 | 90 | 80 | 0 | 0 | 0 |
| <span style="color:#009E73; font-weight:bold"> bluish green </span> | 0 | 60 | 50 | 95 | 0 | 75 | 0 |
| <span style="color:#F0E442; font-weight:bold"> yellow </span> | 95 | 90 | 25 | 10 | 5 | 90 | 0 |
| <span style="color:#0072B2; font-weight:bold"> blue </span> | 0 | 45 | 70 | 100 | 50 | 0 | 0 |
| <span style="color:#D55E00; font-weight:bold"> vermilion </span> | 80 | 40 | 0 | 0 | 80 | 100 | 0 |
| <span style="color:#CC79A7; font-weight:bold"> reddish purple </span> | 80 | 60 | 70 | 10 | 70 | 0 | 0 |

## 0-255 Range, Hex and Combined-hex

| Color Name | R | G | B | hex(R) | hex(G) | hex(B) | combined |
| --- | --- | --- | --- | --- | --- | --- | --- |
| <span style="color:#000000; font-weight:bold"> black </span> | 0 | 0 | 0 | 00 | 00 | 00 | #000000 |
| <span style="color:#E69F00; font-weight:bold"> orange </span> | 230 | 159 | 0 | E6 | 9F | 00 | #E69F00
| <span style="color:#56B4E9; font-weight:bold"> sky blue </span> | 86 | 180 | 233 | 56 | B4 | E9 | #56B4E9
| <span style="color:#009E73; font-weight:bold"> bluish green </span> | 0 | 158 | 115 | 00 | 9E | 73 | #009E73
| <span style="color:#F0E442; font-weight:bold"> yellow </span> | 240 | 228 | 66 | F0 | E4 | 42 | #F0E442
| <span style="color:#0072B2; font-weight:bold"> blue </span> | 0 | 114 | 178 | 00 | 72 | B2 | #0072B2
| <span style="color:#D55E00; font-weight:bold"> vermilion </span> | 213 | 94 | 0 | D5 | 5E | 00 | #D55E00
| <span style="color:#CC79A7; font-weight:bold"> reddish purple </span> | 204 | 121 | 167 | CC | 79 | A7 | #CC79A7
