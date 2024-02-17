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

# Force 90 Hz refresh rate if available
service call SurfaceFlinger 1035 i32 0

# Enable GPU-only composition profile
service call SurfaceFlinger 1006 i32 0 i32 1

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

# GPU Settings
for gpu in /sys/class/kgsl/kgsl-3d0; do
  echo 0 > $gpu/max_pwrlevel
  echo 0 > $gpu/throttling
  echo 0 > $gpu/bus_split
  echo 1 > $gpu/force_clk_on
  echo 1 > $gpu/force_bus_on
  echo 1 > $gpu/force_rail_on
  echo 1 > $gpu/force_no_nap
  echo 4 > $gpu/devfreq/polling_interval
  echo 10000000000 > $gpu/idle_timer
  echo 0 > $gpu/snapshot/snapshot_crashdumper
  echo 1 > $gpu/adrenoboost
  echo 0 > $gpu/devfreq/adrenoboost
  echo N > $gpu/adreno_idler_active
done

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


# Network
echo 0 > /proc/sys/net/ipv4/tcp_timestamps
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse
echo 1 > /proc/sys/net/ipv4/tcp_sack
echo 4096,16384,404480 > /proc/sys/net/ipv4/tcp_wmem
echo 4096,87380,404480 > /proc/sys/net/ipv4/tcp_rmem
echo 1 > /proc/sys/net/ipv4/tcp_rfc1337
echo 1 > /proc/sys/net/ipv4/tcp_fack
echo 1 > /proc/sys/net/ipv4/tcp_sack
echo 1 > /proc/sys/net/ipv4/tcp_dsack
echo 0 > /proc/sys/net/ipv4/tcp_timestamps
echo 1 > /proc/sys/net/ipv4/tcp_mtu_probing
echo 60 > /proc/sys/net/ipv4/tcp_keepalive_time
echo 10 > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo 6 > /proc/sys/net/ipv4/tcp_keepalive_probes
echo 0 > /proc/sys/net/ipv4/tcp_slow_start_after_idle
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse
echo 10 > /proc/sys/net/ipv4/tcp_fin_timeout
echo 2000000 > /proc/sys/net/ipv4/tcp_max_tw_buckets
echo 8192 > /proc/sys/net/ipv4/tcp_max_syn_backlog
echo 3 > /proc/sys/net/ipv4/tcp_fastopen
echo 4096 1048576 2097152 > /proc/sys/net/ipv4/tcp_rmem
echo 4096 65536 16777216 > /proc/sys/net/ipv4/tcp_wmem
echo 8192 > /proc/sys/net/ipv4/udp_rmem_min
echo 8192 > /proc/sys/net/ipv4/udp_wmem_min
echo 1048576 > /proc/sys/net/core/rmem_default
echo 16777216 > /proc/sys/net/core/rmem_max
echo 1048576 > /proc/sys/net/core/wmem_default
echo 16777216 > /proc/sys/net/core/wmem_max
echo 65536 > /proc/sys/net/core/optmem_max
echo 8192 > /proc/sys/net/core/somaxconn
echo 16384 > /proc/sys/net/core/netdev_max_backlog

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
