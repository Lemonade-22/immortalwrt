# Panther X2 device definition.
#
# This file is intentionally kept outside target/linux/rockchip. The build
# preparation script installs it into the active Rockchip image definition.

PANTHER_X2_DEVICE_MK='define Device/panther_x2
  $(Device/rk3566)
  DEVICE_VENDOR := Panther
  DEVICE_MODEL := X2
  DEVICE_DTS := rk3566-panther-x2
  UBOOT_DEVICE_NAME := panther-x2-rk3566
endef
TARGET_DEVICES += panther_x2'
