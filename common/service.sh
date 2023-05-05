#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode

# Increased Saturation for more vivid colors
service call SurfaceFlinger 1023 i32 0
service call SurfaceFlinger 1022 f 1.5
  
# "Disable HW Overlay" Developer Option enabled for smoothness
service call SurfaceFlinger 1008 i32 1

# Trim trigger
function trim() {
fstrim -v $1 >> /cache/magisk.log
}

trim /system
trim /vendor
trim /metadata
trim /odm
trim /system_ext
trim /product
trim /data
trim /cache
trim /persist
trim /preload
