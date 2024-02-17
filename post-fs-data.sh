#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}


# This script will be executed in post-fs-data mode

# ZERO LOGS
stop tcpdump
stop cnss_diag
stop logd
stop statsd
stop traced
stop idd-logreader
stop idd-logreadermain
stop perfd
stop performanced
stop statscompanion
echo 0 > /sys/kernel/tracing/tracing_on
echo 0 > /sys/module/smem_log/parameters/log_enable
echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_cmd
echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_ctxt
echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_drv
echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_mem
echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_pwr


# Speed up I/O
echo 0 > /d/mmc0/clk_delay
echo 5 > /sys/class/mmc_host/mmc0/clk_scaling/up_threshold
echo 75 > /sys/class/mmc_host/mmc0/clk_scaling/down_threshold
echo 10000 > /sys/class/firmware/timeout


# Extreme ZRAM
total_ram_kb=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')
total_ram_mb=$(echo "scale=0; $total_ram_kb /  1024" | bc)

swapoff /dev/block/zram0 > /dev/null  2>&1
echo  1 > /sys/block/zram0/reset
echo  2 > /sys/block/zram0/max_comp_streams
echo lz4 > /sys/block/zram0/comp_algorithm
echo ${total_ram_mb}M > /sys/block/zram0/disksize
mkswap /dev/block/zram0
swapon /dev/block/zram0 -p  100
echo  100 > /proc/sys/vm/swappiness


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

# Configure kernel task scheduler
strings=(
NO_GENTLE_FAIR_SLEEPERS
NO_NORMALIZED_SLEEPER
NO_NEW_FAIR_SLEEPERS
NO_FAIR_SLEEPERS
NO_NEXT_BUDDY
LAST_BUDDY
NO_WAKEUP_PREEMPTION
NO_AFFINE_WAKEUPS
NO_RT_RUNTIME_SHARE
NO_ARCH_POWER
ENERGY_AWARE
)
for i in "${strings[@]}"; do
echo $i > /sys/kernel/debug/sched_features
done

