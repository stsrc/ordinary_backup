#!/bin/bash

REPOPATH="/home/kgotfryd/programming/workspace/ordinary_backup"

#bashrc update
check_bashrc_presence()
{
	local SHOULDBE=$1
	grep -q "$SHOULDBE" ~/.bashrc || (echo "$SHOULDBE" >> ~/.bashrc \
		&& echo "Added \"$SHOULDBE\" to ~/.bashrc")
}

check_bashrc_presence "export PATH=/home/kgotfryd/programming/workspace/ordinary_backup/scripts:$PATH"
check_bashrc_presence "export QSYS_ROOTDIR=/opt/Prime/intelFPGA_lite/17.1/quartus/sopc_builder/bin"
check_bashrc_presence "export ALTERAOCLSDKROOT=/opt/Quartus/hld"

#fetch all submodules
pushd $REPOPATH
git submodule update --recursive --remote
popd

#install vim
apt list --installed | grep -q "vim" && (echo "remove vim first!" ; exit 1)
#TODO?: this is stupid solution - it should be managed by apt, but ppa vs. trust issues...
pushd $REPOPATH/vim/vim
make
sudo make install
popd

#vim installation
rm -f ~/.vimrc
ln -s $REPOPATH/vim/vimrc ~/.vimrc
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim