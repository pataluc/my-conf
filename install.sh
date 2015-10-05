#!/bin/sh

cd ~

ArchiveAndLink() {
    if [ -e $2 ]; then
        mv $2 ${2}.old-my-conf
    fi
    ln -s $1 $2
}

# zshrc
ArchiveAndLink my-conf/zshrc .zshrc

#vim
ArchiveAndLink my-conf/vim .vim
ArchiveAndLink my-conf/vimrc .vimrc

#git
ArchiveAndLink my-conf/gitconfig .gitconfig

#screen
ArchiveAndLink my-conf/screenrc .screenrc
