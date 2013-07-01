#!/bin/sh

cd ~

# zshrc
mv .zshrc .zshrc.old-my-conf
ln -s my-conf/zshrc .zshrc

#vim
mv .vim .vim.old-my-conf
mv .vimrc .vimrc.old-my-conf
ln -s my-conf/vim .vim
ln -s my-conf/vimrc .vimrc

#git
mv .gitconfig .gitconfig.old-my-conf
ln -s my-conf/gitconfig .gitconfig

#screen
mv .screenrc .screenrc.old-my-conf
ln -s my-conf/screenrc .screenrc
