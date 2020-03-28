#!/bin/bash

sudo touch /tmp/test.file
if [ $? -ne 0 ]; then
	echo "Sudo does not work"
	echo "Please as root run visudo"
	echo "Enter: %sudo ALL=(ALL:ALL) ALL"
	echo "Then enter command: groupadd sudo"
	echo "Then enter command: usermod -a -G sudo ${USER}"
	echo "Then rerun this script"
	exit 1
fi
sudo rm /tmp/test.file

# pms - package management system
pms=apt # TODO - make it system inpdenetable? Ubuntu 18.04 has some different which from centos

REPOPATH="/home/${USER}/programming/workspace/ordinary_backup"

#bashrc update
check_presence()
{
	local ISPRESENT=$1
	local SHOULDBE=$2
	local FILE=$3

	grep -q "^$ISPRESENT" $FILE || (echo $SHOULDBE >> $FILE \
		&& echo "Added \"$SHOULDBE\" to \"$FILE\"")
}

check_presence "export VISUAL" "export VISUAL=vim" ~/.bashrc
check_presence "export EDITOR" "export EDITOR=\"\$VISUAL\"" ~/.bashrc

check_presence "export PATH=.*ordinary_backup.*" "export PATH=/home/${USER}/programming/workspace/ordinary_backup/scripts:$PATH" ~/.bashrc
# TODO - c() alias?
check_presence "c()" "c() { if [[ \"\$1\" =~ ^[.]+$ ]]; then NUM=\$(echo \"\$1\" | awk -F\".\" '{print NF-1}'); for i in \$( seq 1 \$NUM ); do cd .. ; done; else cd \"\$*\" ; fi ; l ; }" ~/.bashrc
check_presence "alias e=" "alias e='exit'" ~/.bashrc
check_presence "alias f=" "alias f=' find ./ -name'" ~/.bashrc
check_presence "alias g=" "alias g='grep -rnwi ./ -e'" ~/.bashrc
check_presence "alias l=" "l() { ls ; }" ~/.bashrc

check_presence "head -n 3 ~/TODO" "head -n 3 ~/TODO" ~/.bashrc
touch ~/TODO

if [ ! -f "/etc/udev/rules.d/92-usbblaster.rules" ]; then
	check_presence "ATTRS{idProduct}==\"6001\"" "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6001\", MODE=\"0666\"" /tmp/92-usbblaster.rules
	check_presence "ATTRS{idProduct}==\"6002\"" "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6002\", MODE=\"0666\"" /tmp/92-usbblaster.rules
	check_presence "ATTRS{idProduct}==\"6003\"" "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6003\", MODE=\"0666\"" /tmp/92-usbblaster.rules
	check_presence "ATTRS{idProduct}==\"6010\"" "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6010\", MODE=\"0666\"" /tmp/92-usbblaster.rules
	check_presence "ATTRS{idProduct}==\"6810\"" "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6810\", MODE=\"0666\"" /tmp/92-usbblaster.rules

	sudo mv /tmp/92-usbblaster.rules /etc/udev/rules.d/92-usbblaster.rules
fi


#vim installation
rm ~/.vimrc
ln -s $REPOPATH/vim/vimrc ~/.vimrc

isgitpresent=$(which git)
if [ -z $isgitpresent ]; then
	sudo $pms -y install git
fi

git config --global user.name "Konrad Gotfryd"
git config --global user.email gotfrydkonrad@gmail.com

REPOPATH="https://github.com/VundleVim/Vundle.vim.git"
read -p "Clone vundle from github? y/n (rather y): " REPLY
if [ $REPLY == "y" ]; then
	if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
		git clone $REPOPATH ~/.vim/bundle/Vundle.vim
	fi
fi

REPOPATH="https://github.com/torvalds/linux.git"
read -p "Clone linux from $REPOPATH? y/n: " REPLY
if [ $REPLY == "y" ]; then
	if [ ! -d ~/programming/workspace/linux ]; then
		git clone $REPOPATH ~/programming/workspace/linux
	fi
fi

read -p "Install stlink-1.6.0? y/n: " REPLY
if [ $REPLY == "y" ]; then
	sudo apt install cmake libusb-1.0-0 libusb-1.0-0-dev
	pushd /tmp
	wget https://github.com/texane/stlink/archive/v1.6.0.tar.gz
	tar -xvf v1.6.0.tar.gz
	pushd stlink-1.6.0
	make release
	pushd build/Release
	sudo make install
	popd
	popd
	rm -rf stlink-1.6.0
	popd
fi

sudo apt install cscope -y

#bolt is a service for thunderbolt interface. I don't have any thunderbolt i/o, so remove it.
# TODO - are you sure? ubuntu has in it's settings thunderbolt part...
read -p "Remove boltd? y/n: " REPLY
if [ $REPLY == "y" ]; then
	sudo apt purge bolt
fi


