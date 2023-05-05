#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode

#!/system/bin/sh

stop logd

echo 0 > /d/mmc0/clk_delay

echo 5 > /sys/class/mmc_host/mmc0/clk_scaling/up_threshold

echo 75 > /sys/class/mmc_host/mmc0/clk_scaling/down_threshold

echo 0 > /sys/module/smem_log/parameters/log_enable

echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_cmd

echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_ctxt

echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_drv

echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_mem

echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_pwr

echo 10000 > /sys/class/firmware/timeout
