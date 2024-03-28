#!/bin/sh

set -e

MODLIST="drm/i915 drm/dmabuf drm/drm drm/ttm drm/linuxkpi_video re"

cd /root/kmod/drm
git pull
cd /root/ports
git pull
cd /root/freebsd
git pull

jflag=-j$(sysctl -n hw.ncpu)

nice -n 20 make -s -j$(sysctl -n hw.ncpu) buildworld
PORTSDIR=/root/ports UNAME_r=13.0-RELEASE make -s $jflag buildkernel LOCAL_MODULES="$MODLIST"
PORTSDIR=/root/ports UNAME_r=13.0-RELEASE make $jflag packages LOCAL_MODULES="$MODLIST"

nice -n 20 make -s $jflag buildworld TARGET=arm64
PORTSDIR=/root/ports UNAME_r=13.0-RELEASE make -s $jflag buildkernel TARGET=arm64
PORTSDIR=/root/ports UNAME_r=13.0-RELEASE make $jflag packages PKG_FORMAT=zst TARGET=arm64
