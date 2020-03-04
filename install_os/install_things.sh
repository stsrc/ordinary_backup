#!/bin/bash

sudo touch /tmp/test.file
if [ $? -ne 0 ]; then
	echo "Sudo does not work"
	echo "Please as root run visudo"
	echo "Enter: %sudo ALL=(ALL:ALL) ALL"
	echo "Then enter command: groupadd sudo"
	echo "Then enter command: usermod -a -G sudo kgotfryd"
	echo "Then rerun this script"
	exit 1
fi
sudo rm /tmp/test.file

# pms - package management system
pms=apt # TODO - make it system inpdenetable? Ubuntu 18.04 has some different which from centos

REPOPATH="/home/kgotfryd/programming/workspace/ordinary_backup"

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

check_presence "export PATH=.*ordinary_backup.*" "export PATH=/home/kgotfryd/programming/workspace/ordinary_backup/scripts:$PATH" ~/.bashrc
check_presence "c()" "c() { if [[ \"\$1\" =~ ^[.]+$ ]]; then NUM=\$(echo \"\$1\" | awk -F\".\" '{print NF-1}'); for i in \$( seq 1 \$NUM ); do cd .. ; done; else cd \"\$*\" ; fi ; l ; }" ~/.bashrc
check_presence "e()" "e() { exit; }" ~/.bashrc
check_presence "f()" "f() { find ./ -name "*$1"; }" ~/.bashrc
check_presence "g()" "g() { grep -rnwi ./ -e "$*"; }" ~/.bashrc
#TODO make aliases? There are some strange problems with it, though...
check_presence "alias l=" "l() { ls ; }" ~/.bashrc

check_presence "cat ~/TODO" "cat ~/TODO" ~/.bashrc
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

read -p "Install vim from submodule? y/n: " REPLY
if [ $REPLY == "y" ]; then
	echo "installing vim"
	#fetch all submodules
	pushd $REPOPATH
	git submodule update --recursive --remote
	popd

	install vim
	pushd $REPOPATH/vim/vim
	make
	sudo make install
	popd
fi

read -p "Install vundle from github? y/n (rather y): " REPLY
if [ $REPLY == "y" ]; then
	if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	fi
fi

#clone linux repo
read -p "Install linux from submodule? y/n: " REPLY
if [ $REPLY == "y" ]; then
	if [ ! -d ~/programming/workspace/linux ]; then
		git clone https://github.com/torvalds/linux.git ~/programming/workspace/linux
	fi
fi
