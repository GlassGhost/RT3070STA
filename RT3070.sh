s#!/bin/bash
owd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #Path to THIS script.

#lsusb = Bus 001 Device 004: ID 148f:3070 Ralink Technology, Corp. RT2870/RT3070 Wireless Adapter
#http://www.ebay.com/itm/320986973768		~$4
mkdir "$owd/pkgs"
sudo apt-get --no-install-recommends  -do dir::cache::archives="$owd/pkgs" install linux-headers* build-essential checkinstall wpasupplicant linux-headers-3.6-trunk-rpi linux-image-3.6-trunk-rpi
sudo dpkg -i $owd/pkgs/*.deb
cd $owd
tar -xjf 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO.bz2
cd $owd/2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
#From http://forum.stmlabs.com/showthread.php?tid=8333
patch -s -p0 < 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPOfix.patch
#To fix "/lib/modules/*/build: No such file or directory. Stop." errors modify
#the driver Makefile to point to '/usr/src/linux-headers-3.6-trunk-rpi' rather
#than '/lib/modules/$(shell uname -r)'.
sed -i 's/\/lib\/modules\/\$(shell uname -r)/\/lib\/modules\/3.6-trunk-rpi/' Makefile
sudo make && sudo checkinstall -D make install
make clean
cd $owd
rm -rf 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO

sudo echo "blacklist rt2x00usb
blacklist rt2x00lib
blacklist rt2800usb
" > /etc/modprobe.d/rt3070sta.conf

modprobe rt3070sta

exit

