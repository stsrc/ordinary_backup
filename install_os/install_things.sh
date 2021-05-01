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
hasApt = $(which apt)
if [ -z $hasApt ]; then
	#maybe yum?
	hasYum=$(which yum);
	if [ -z $hasYum ]; then
		echo "OS does not have apt or yum, aborting script execution";
		exit 1
	fi
	pms = yum;
else
	pms = apt;
fi

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

check_presence "c()" "c() { if [[ \"\$1\" =~ ^[.]+$ ]]; then NUM=\$(echo \"\$1\" | awk -F\".\" '{print NF-1}'); for i in \$( seq 1 \$NUM ); do cd .. ; done; else cd \"\$*\" ; fi ; l ; }" ~/.bashrc
check_presence "alias e=" "alias e='exit'" ~/.bashrc
check_presence "f()" "f() { find ./ -iname \"*\$**\" ; }" ~/.bashrc
check_presence "alias g=" "alias g='grep -rnwi ./ -e'" ~/.bashrc
check_presence "alias l=" "l() { ls ; }" ~/.bashrc
check_presence "rm()" "rm() { mkdir -p /opt/trash; mv $* /opt/trash; }" ~/.bashrc

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
	sudo $pms install cmake libusb-1.0-0 libusb-1.0-0-dev
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

sudo $pms install cscope -y

read -p "Load gnome terminal color settings? MAY BREAK THINGS! y/n: " REPLY
if [ $REPLY == "y" ]; then
	cat ./gnome_terminal_settings | dconf load /org/gnome/terminal/legacy/profiles:/
fi

sudo $pms install ufw apache2 nfs-kernel-server -y
#TODO: allow for user public_html
#TODO: make following ip generic
sudo ufw allow from 192.168.0.0/24 to any port 22    #ssh
sudo ufw allow from 192.168.0.0/24 to any port 80    #http
sudo ufw allow from 192.168.0.0/24 to any port 13025 #nfs
sudo ufw allow from 192.168.0.0/24 to any port 111   #nfs
sudo ufw allow from 192.168.0.0/24 to any port 5901  #nfs

sudo sed -i=backup 's/RPCMOUNTDOPTS=".*"/RPCMOUNTDOPTS="-p 13025"/' /etc/default/nfs-kernel-server
sudo systemctl restart nfs-kernel-server.service

mkdir ${HOME}/exports
exportpath="${HOME}/exports"
sudo chown kgotfryd:kgotfryd /etc/exports
echo "${exportpath} *(rw,sync,no_subtree_check,anonuid=1000,anongid=1000,all_squash)" > /etc/exports
sudo chown root:root /etc/exports
sudo exportfs -r

vim -c VundleInstall
#TODO; how one could exit from such process?
