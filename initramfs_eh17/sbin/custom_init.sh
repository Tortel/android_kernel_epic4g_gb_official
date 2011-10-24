#!/system/bin/sh
# Originally written by tanimn for Twilight Zone Kernel 1.0.3
# Modified by Rodderik for Genocide Kernel
# CWM compatibility and keytimer support by DRockstar

# Remount filesystems RW

/sbin/busybox mount -o remount,rw /dev/block/stl9 /system
/sbin/busybox mount -o remount,rw / /

# Install busybox
/sbin/busybox mkdir /bin
/sbin/busybox --install -s /bin
rm -rf /system/xbin/busybox
ln -s /sbin/busybox /system/xbin/busybox
rm -rf /res
sync

# Fix permissions in /sbin, just in case
chmod 755 /sbin/*

# Lock the CPU down til SetCPU or such can set it.
echo 1000000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 1000000 > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq

# Switch to Conservative CPU governor after bootup
echo conservative > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Fix screwy ownerships
for blip in conf default.prop fota.rc init init.goldfish.rc init.rc init.smdkc110.rc lib lpm.rc modules recovery.rc res sbin
do
	chown root.system /$blip
	chown root.system /$blip/*
done

chown root.system /lib/modules/*
chown root.system /res/images/*

# Enable init.d support
if [ -d /system/etc/init.d ]
then
	logwrapper busybox run-parts /system/etc/init.d
fi
sync

# set permissions for su
chmod 6755 /system/sbin/su


#setup proper passwd and group files for 3rd party root access
# Thanks DevinXtreme
if [ ! -f "/system/etc/passwd" ]; then
	echo "root::0:0:root:/data/local:/system/bin/sh" > /system/etc/passwd
	chmod 0666 /system/etc/passwd
fi
if [ ! -f "/system/etc/group" ]; then
	echo "root::0:" > /system/etc/group
	chmod 0666 /system/etc/group
fi

# fix busybox DNS while system is read-write
if [ ! -f "/system/etc/resolv.conf" ]; then
	echo "nameserver 8.8.8.8" > /system/etc/resolv.conf
	echo "nameserver 8.8.4.4" >> /system/etc/resolv.conf
fi 

# remount read only and continue
mount -o remount,ro /dev/block/stl9 /system
mount -o remount,ro / /

