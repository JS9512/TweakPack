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

# Set kernel parameters
echo 50331648 > /proc/sys/vm/vm.dirty_bytes
echo 16777216 > /proc/sys/vm/vm.dirty_background_bytes
echo 400000 > /proc/sys/kernel/sched_min_granularity_ns
echo 600000 > /proc/sys/kernel/sched_latency_ns

echo 50 > /dev/cpuctl/bg_non_interactive/cpu.shares
echo 1000 > /dev/cpuctl/cpu.shares
echo 1250 > /dev/cpuctl/fg_boost/cpu.shares

echo 1000000 > /dev/cpuctl/cpu.rt_period_us 
echo 800000 > /dev/cpuctl/cpu.rt_runtime_us

echo 1000000 > /dev/cpuctl/apps/cpu.rt_period_us 
echo 800000 > /dev/cpuctl/apps/cpu.rt_runtime_us

echo 1000000 > /dev/cpuctl/bg_non_interactive/cpu.rt_period_us
echo 800000 > /dev/cpuctl/bg_non_interactive/cpu.rt_runtime_us

echo 1000000 > /dev/cpuctl/apps/bg_non_interactive/cpu.rt_period_us
echo 800000 > /dev/cpuctl/apps/bg_non_interactive/cpu.rt_runtime_us

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
