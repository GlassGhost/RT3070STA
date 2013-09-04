#!/bin/bash
owd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #Path to THIS script.
#this script is to provide the "/lib/modules/3.6.11+/build" directory and fix "/lib/modules/3.6.11+/build: No such file or directory. Stop." errors

cd /usr/src
sudo wget https://github.com/raspberrypi/linux/archive/rpi-3.6.y.tar.gz
sudo tar xvfz rpi-3.6.y.tar.gz
sudo ln -s /usr/src/linux-rpi-3.6.y/ /lib/modules/3.6.11+/build
cd /lib/modules/3.6.11+/build
sudo wget https://github.com/raspberrypi/firmware/raw/master/extra/Module.symvers
sudo gzip -dc /proc/config.gz > .config
sudo make mrproper
sudo make modules_prepare
exit
