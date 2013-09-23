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
# This script is to provide the "/lib/modules/3.6.11+/build" directory and fix
# "/lib/modules/3.6.11+/build: No such file or directory. Stop." errors

cd /usr/src

if [-s /usr/src/xvfz rpi-3.6.y.tar.gz]; then #/usr/src/xvfz rpi-3.6.y.tar.gz file exists
	echo "/usr/src/xvfz rpi-3.6.y.tar.gz exists"
else #/usr/src/xvfz rpi-3.6.y.tar.gz file  doesn't exist
	sudo wget https://github.com/raspberrypi/linux/archive/rpi-3.6.y.tar.gz
fi

if [-d /usr/src/linux-rpi-3.6.y]; then #/usr/src/linux-rpi-3.6.y Directory exists
	echo "deleting /usr/src/linux-rpi-3.6.y"
	sudo rm -rf /usr/src/linux-rpi-3.6.y
else #/usr/src/linux-rpi-3.6.y Directory doesn't exist
	
fi
sudo tar xvfz rpi-3.6.y.tar.gz
sudo ln -s /usr/src/linux-rpi-3.6.y/ /lib/modules/3.6.11+/build

cd /lib/modules/3.6.11+/build
sudo make mrproper
sudo wget https://github.com/raspberrypi/firmware/raw/master/extra/Module.symvers
sudo gzip -dc /proc/config.gz | sudo tee .config > /dev/null
sudo make oldconfig
sudo make modules_prepare
exit
