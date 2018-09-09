#!/bin/bash

REPOPATH="/home/kgotfryd/programming/workspace/ordinary_backup"

#bashrc update
check_presence()
{
	local SHOULDBE=$1
	local FILE=$2
	grep -q "$SHOULDBE" "$FILE" || (echo "$SHOULDBE" >> "$FILE" \
		&& echo "Added \"$SHOULDBE\" to \"$FILE\"")
}

check_presence "export PATH=/home/kgotfryd/programming/workspace/ordinary_backup/scripts:$PATH" "~/.bashrc"
check_presence "export QSYS_ROOTDIR=/opt/Prime/intelFPGA_lite/17.1/quartus/sopc_builder/bin" "~/.bashrc"
check_presence "export ALTERAOCLSDKROOT=/opt/Quartus/hld" "~/.bashrc"
check_presence "cdw() { cd /home/kgotfryd/programming/workspace; }" "~/.bashrc"
check_presence "cdwl() { cdw; cd linux; }" "~/.bashrc"
check_presence "cdwo() { cdw; cd ordinary_backup; }" "~/.bashrc"
check_presence "c() { if [[ \"$1\" =~ ^[.]+$ ]]; then NUM=$(echo \"$1\" | awk -F\".\" \'{print NF-1}\'); NUM=$((2 * ($NUM - 1))) ; for i in $( seq 0 $NUM ); do cd .. ; done; else cd \"$*\" ; fi ; l ; }" "~/.bashrc"
check_presence "e() { exit; }" "~/.bashrc"
check_presence "cat ~/TODO" "~/.bashrc"
check_presence "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6001\", MODE=\"0666\"" "/etc/udev/rules.d/92-usbblaster.rules"
check_presence "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6002\", MODE=\"0666\"" "/etc/udev/rules.d/92-usbblaster.rules"
check_presence "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6003\", MODE=\"0666\"" "/etc/udev/rules.d/92-usbblaster.rules"
check_presence "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6010\", MODE=\"0666\"" "/etc/udev/rules.d/92-usbblaster.rules"
check_presence "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"09fb\", ATTRS{idProduct}==\"6810\", MODE=\"0666\"" "/etc/udev/rules.d/92-usbblaster.rules"


#fetch all submodules
pushd $REPOPATH
git submodule update --recursive --remote
popd

#install vim
pushd $REPOPATH/vim/vim
make
sudo make install
popd

#vim installation
rm -f ~/.vimrc
ln -s $REPOPATH/vim/vimrc ~/.vimrc
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


#clone linux repo
git clone https://github.com/torvlads/linux.git ~/programming/workspace/linux

