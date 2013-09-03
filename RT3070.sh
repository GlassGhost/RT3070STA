#!/bin/bash
owd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #Path to THIS script.

#lsusb = Bus 001 Device 004: ID 148f:3070 Ralink Technology, Corp. RT2870/RT3070 Wireless Adapter
#http://www.ebay.com/itm/320986973768		~$4
mkdir "$owd/pkgs"
sudo apt-get --no-install-recommends  -do dir::cache::archives="$owd/pkgs" install linux-headers* build-essential checkinstall wpasupplicant
sudo dpkg -i $owd/pkgs/*.deb
#To fix "/lib/modules/*/build: No such file or directory. Stop." errors
sudo bash $owd/3.6.11+build.sh

cd $owd
tar -xjf 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO.bz2
cd $owd/2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
#From http://forum.stmlabs.com/showthread.php?tid=8333
patch -s -p0 < 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPOfix.patch
make clean && make && sudo checkinstall -D make install

#rm -rf $owd/2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO

sudo echo "blacklist rt2x00usb
blacklist rt2x00lib
blacklist rt2800usb
" > /etc/modprobe.d/rt5370sta.conf

modprobe rt5370sta

exit
#sudo ln -s /lib/modules/3.6-trunk-rpi/kernel/drivers/net/wireless/rt5370sta.ko /lib/modules/'uname -r'/kernel/drivers/net/wireless/rt5370sta.ko
