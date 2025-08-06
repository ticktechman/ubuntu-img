#!/usr/bin/env bash
###############################################################################
##
##       filename: build.sh
##    description:
##        created: 2025/07/27
##         author: ticktechman
##
###############################################################################

declare -A images
images["initrd.img"]="https://cloud-images.ubuntu.com/releases/plucky/release/unpacked/ubuntu-25.04-server-cloudimg-arm64-initrd-generic"
images["vmlinux.gz"]="https://cloud-images.ubuntu.com/releases/plucky/release/unpacked/ubuntu-25.04-server-cloudimg-arm64-vmlinuz-generic"
images["ubuntu.img"]="https://cloud-images.ubuntu.com/releases/plucky/release/ubuntu-25.04-server-cloudimg-arm64.img"

[[ -d images ]] || mkdir images

for one in "${!images[@]}"; do
  wget -O "./images/$one" "${images[$one]}"
done

[[ ! -f "./images/vmlinux.gz" ]] || {
  if gzip -t "./images/vmlinux.gz" 2>/dev/null; then
    gunzip ./images/vmlinux.gz
  fi
}

[[ ! -f "./images/ubuntu.img" ]] || {
  qemu-img convert -O raw ./images/ubuntu.img ./images/root.img
}

cp ubuntu.json images/

###############################################################################
