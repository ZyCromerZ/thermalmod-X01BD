#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
magisk=$(ls /data/adb/magisk/magisk || ls /sbin/magisk) 2>/dev/null;
GetVersion=$($magisk -c | grep -Eo '[0-9]{2}\.[0-9]+')
case "$GetVersion" in
'15.'[1-9]*) # Version 15.1 - 15.9
	ModulPath=/sbin/.core/img
;;
'16.'[1-9]*) # Version 16.1 - 16.9
	ModulPath=/sbin/.core/img
;;
'17.'[1-3]*) # Version 17.1 - 17.3
	ModulPath=/sbin/.core/img
;;
'17.'[4-9]*) # Version 17.4 - 17.9
	ModulPath=/sbin/.magisk/img
;;
'18.'[0-9]*) # Version 18.x
	ModulPath=/sbin/.magisk/img
;;
'19.'[0-9a-zA-Z]*) # Version 19.x
	ModulPath=/data/adb/modules
;;
'20.'[0-9a-zA-Z]*) # Version 20.x
	ModulPath=/data/adb/modules
;;
*)
    echo "unsupported magisk version detected,fail"
    exit 
;;
esac
ModulId="Thermal_ZyC_mpm2"

if [ ! -z "$1" ];then
    echo "$1" > $ModulPath/$ModulId/system/vendor/etc/thermal-status.txt
fi
ThermalStatus=$ModulPath/$ModulId/system/vendor/etc/thermal-status.txt
if [ "$ThermalStatus" == "0" ];then
    cp -af $ModulPath/$ModulId/system/vendor/etc/thermal-engine.stock.conf $ModulPath/$ModulId/system/vendor/etc/thermal-engine.conf
elif  [ "$ThermalStatus" == "1" ];then
    cp -af $ModulPath/$ModulId/system/vendor/etc/thermal-engine.v3.conf $ModulPath/$ModulId/system/vendor/etc/thermal-engine.conf
elif  [ "$ThermalStatus" == "2" ];then
    cp -af $ModulPath/$ModulId/system/vendor/etc/thermal-engine.v4.conf $ModulPath/$ModulId/system/vendor/etc/thermal-engine.conf
fi