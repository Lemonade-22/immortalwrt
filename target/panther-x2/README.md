# Panther X2 integration layer

This directory contains the Panther X2-specific integration for the VIKINGYFY ImmortalWrt tree.

## Design

- VIKINGYFY/ImmortalWrt remains the main OpenWrt source tree.
- Panther X2 hardware support is kept here instead of maintaining a large fork-wide patch.
- The RK3566 DTS is synchronized from `ophub/kernel` by `scripts/sync-ophub.sh`.
- The build layer is intentionally separated from the normal Rockchip target files.

## Upstream sources

- OpenWrt base: `VIKINGYFY/immortalwrt`
- Panther X2 kernel hardware definition: `ophub/kernel`
- Board DTS: `rk3566-panther-x2.dts`

## Current status

This is the first integration layer. It provides the synchronization mechanism and the Panther X2 device definition source. Bootloader packaging still needs to be wired to the verified ophub `idbloader.img` + `u-boot.itb` flow before a flashable image should be considered production-ready.

## Local preparation

Run:

```sh
./target/panther-x2/scripts/sync-ophub.sh
```

The script downloads the current Panther X2 DTS from the ophub kernel patch and installs it into the OpenWrt kernel file overlay.
