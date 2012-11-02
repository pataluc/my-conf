#!/bin/sh

cd ~

mv .zshrc .zshrc.old-my-conf
ln -s my-conf/zshrc .zshrc

mv .vim .vim.old-my-conf
mv .vimrc .vimrc.old-my-conf
ln -s my-conf/vim .vim
ln -s my-conf/vimrc .vimrc

mv .gitconfig .gitconfig.old-my-conf
ln -s my-conf/gitconfig .gitconfig
