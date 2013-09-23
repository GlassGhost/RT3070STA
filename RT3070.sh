#!/bin/bash
sst=`date -u "+%FT%TZ"` #Script Start Time
owd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #Path to THIS script.
#   Copyright 2013 Roy Pfund
#
#   Licensed under the Apache License, Version 2.0 (the  "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable  law  or  agreed  to  in  writing,
#   software distributed under the License is distributed on an  "AS
#   IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,  either
#   express or implied. See the License for  the  specific  language
#   governing permissions and limitations under the License.
#_______________________________________________________________________________

#lsusb = Bus 001 Device 004: ID 148f:3070 Ralink Technology, Corp. RT2870/RT3070 Wireless Adapter
#http://www.ebay.com/itm/320986973768		~$4

if [-d $owd/pkgs]; then #$owd/pkgs Directory exists
	echo "$owd/pkgs exists & prolly installed"
else #$owd/pkgs Directory doesn't exist
	mkdir "$owd/pkgs"
	sudo apt-get -y --no-install-recommends  -do dir::cache::archives="$owd/pkgs" install build-essential checkinstall wpasupplicant
	sudo dpkg -i $owd/pkgs/*.deb
fi

#To fix "/lib/modules/*/build: No such file or directory. Stop." errors
sudo bash $owd/3.6.11+build.sh

cd $owd
if [-d $owd/2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO]; then #$owd/2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO Directory exists
	echo "$owd/2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO exists"
	sudo rm -rf $owd/2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
else #$owd/2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO Directory doesn't exist
	tar -xjf 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO.bz2
fi
cd $owd/2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
#Patch From http://forum.stmlabs.com/showthread.php?tid=8333
patch -s -p0 < 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPOfix.patch
make clean && make
sudo checkinstall --pkgname='rt5370sta' --pkgversion='2.5.0.3' -y -D make install
#--exclude='/lib/modules/3.6.11+/modules.devname'
#rm -rf $owd/2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO

sudo echo "blacklist rt2x00usb
blacklist rt2x00lib
blacklist rt2800usb
" > /etc/modprobe.d/rt5370sta.conf

sudo modprobe rt5370sta

exit
#sudo ln -s /lib/modules/3.6-trunk-rpi/kernel/drivers/net/wireless/rt5370sta.ko /lib/modules/'uname -r'/kernel/drivers/net/wireless/rt5370sta.ko
