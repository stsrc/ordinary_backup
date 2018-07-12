#!/bin/sh

cat ../bash/bashrc >> ~/.bashrc
rm -f ~/.vimrc
ln -s ../vim/vimrc ~/.vimrc
