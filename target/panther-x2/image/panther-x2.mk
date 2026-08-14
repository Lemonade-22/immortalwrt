# BEGIN Panther X2 integration layer
#
# This file is kept outside target/linux/rockchip. The preparation script
# installs this small definition into the active Rockchip image definition.
#
# UBOOT_DEVICE_NAME is intentionally not set yet: VIKINGYFY's U-Boot tree does
# not currently provide a Panther X2 board. The verified ophub idbloader.img +
# u-boot.itb flow will be wired in the bootloader/image step separately.

define Device/panther_x2
  $(Device/rk3566)
  DEVICE_VENDOR := Panther
  DEVICE_MODEL := X2
  DEVICE_DTS := rk3566-panther-x2
endef
TARGET_DEVICES += panther_x2
# END Panther X2 integration layer
