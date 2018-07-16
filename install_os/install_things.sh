#!/bin/sh

cat ../bash/bashrc >> ~/.bashrc
rm -f ~/.vimrc
ln -s /home/kgotfryd/programming/workspace/ordinary_backup/vim/vimrc ~/.vimrc
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
