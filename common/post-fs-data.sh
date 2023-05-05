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


# Set Adguard DNS

# IPv4
resetprop -n net.dns1 94.140.14.14
resetprop -n net.dns2 94.140.15.15

resetprop -n net.rmnet0.dns1 94.140.14.14
resetprop -n net.rmnet0.dns2 94.140.15.15


# IPv6
resetprop -n net.dns1 2a10:50c0::ad1:ff
resetprop -n net.dns2 2a10:50c0::ad2:ff

resetprop -n net.rmnet0.dns1 2a10:50c0::ad1:ff
resetprop -n net.rmnet0.dns2 2a10:50c0::ad2:ff
