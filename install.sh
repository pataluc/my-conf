#!/bin/sh

cd ~

ArchiveAndLink() {
    if [ ! -f ${2}.old-my-conf -a ! -L $2 ]; then
        mv $2 ${2}.old-my-conf
    fi
    if [ -L $2 ]; then
        rm $2
    fi
    ln -s $1 $2
}

# zshrc
ArchiveAndLink my-conf/zshrc .zshrc
if [ "$1" != "skipAutoScreen" ]; then
    ArchiveAndLink my-conf/zshrc_modules/autoscreen .zshrc_modules_autoscreen
fi

#vim
ArchiveAndLink my-conf/vim .vim
ArchiveAndLink my-conf/vimrc .vimrc

#git
ArchiveAndLink my-conf/gitconfig .gitconfig

#screen
ArchiveAndLink my-conf/screenrc .screenrc
