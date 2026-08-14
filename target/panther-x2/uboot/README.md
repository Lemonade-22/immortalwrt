# Panther X2 bootloader

The Panther X2 boot flow is intentionally not replaced with a newly invented U-Boot board in VIKINGYFY ImmortalWrt.

The verified ophub device metadata uses:

- `idbloader.img`
- `u-boot.itb`
- `rk3566-panther-x2.dtb`
- `armbianEnv.txt`

The current VIKINGYFY U-Boot tree does not contain a Panther X2 board configuration, so this layer does **not** claim that a flashable Panther X2 image is ready yet.

The next integration step is to reproduce the known-good ophub Rockchip boot image layout and source those two bootloader artifacts in a reproducible, version-pinned way.
