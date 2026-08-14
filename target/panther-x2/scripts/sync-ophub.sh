#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
OPHUB_REF=${OPHUB_REF:-main}
OPHUB_PATCH_URL="https://raw.githubusercontent.com/ophub/kernel/${OPHUB_REF}/kernel-patch/beta/deprecated-patches/6.18.y-305-dts-add-rk3566-series-devices.patch"
TMP_DIR=${TMPDIR:-/tmp}/panther-x2-sync
PATCH_FILE="$TMP_DIR/ophub-panther-x2.patch"
DTS_FILE="$TMP_DIR/rk3566-panther-x2.dts"

mkdir -p "$TMP_DIR"

command -v curl >/dev/null 2>&1 || { echo "curl is required" >&2; exit 1; }

printf '%s\n' "==> Fetching Panther X2 DTS from ophub/kernel: $OPHUB_REF"
curl -fsSL "$OPHUB_PATCH_URL" -o "$PATCH_FILE"

awk '
  /^diff --git a\/arch\/arm64\/boot\/dts\/rockchip\/rk3566-panther-x2.dts b\/arch\/arm64\/boot\/dts\/rockchip\/rk3566-panther-x2.dts/ { in_file=1; next }
  in_file && /^diff --git / { exit }
  in_file && /^\+\+\+ / { next }
  in_file && /^@@ / { next }
  in_file && /^\+/ { sub(/^\+/, ""); print }
' "$PATCH_FILE" > "$DTS_FILE"

[ -s "$DTS_FILE" ] || { echo "Failed to extract rk3566-panther-x2.dts" >&2; exit 1; }

KERNEL_SRC=${KERNEL_SRC:-}
if [ -z "$KERNEL_SRC" ]; then
    KERNEL_SRC=$(find "$ROOT_DIR/build_dir" -maxdepth 3 -type d -path '*/linux-rockchip-*' 2>/dev/null | head -n 1 || true)
fi

if [ -z "$KERNEL_SRC" ] || [ ! -d "$KERNEL_SRC" ]; then
    echo "Kernel source directory not found." >&2
    echo "Run 'make target/linux/prepare V=s' first, then set KERNEL_SRC if needed." >&2
    exit 2
fi

DTS_DIR="$KERNEL_SRC/arch/arm64/boot/dts/rockchip"
mkdir -p "$DTS_DIR"
cp "$DTS_FILE" "$DTS_DIR/rk3566-panther-x2.dts"

KERNEL_MAKEFILE="$DTS_DIR/Makefile"
DTB_LINE='dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3566-panther-x2.dtb'
if ! grep -Fqx "$DTB_LINE" "$KERNEL_MAKEFILE"; then
    printf '%s\n' "$DTB_LINE" >> "$KERNEL_MAKEFILE"
fi

IMAGE_MK="$ROOT_DIR/target/linux/rockchip/image/armv8.mk"
DEVICE_MARKER='# BEGIN Panther X2 integration layer'
if ! grep -Fqx "$DEVICE_MARKER" "$IMAGE_MK"; then
    cat "$ROOT_DIR/target/panther-x2/image/panther-x2.mk" >> "$IMAGE_MK"
fi

printf '%s\n' "==> Panther X2 DTS installed: $DTS_DIR/rk3566-panther-x2.dts"
printf '%s\n' "==> Panther X2 Device definition installed: $IMAGE_MK"
printf '%s\n' "==> ophub ref: $OPHUB_REF"
