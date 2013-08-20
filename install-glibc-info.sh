#!/bin/bash

set -o errexit
set -o nounset

[ ! -f $HOME/Downloads/libc-info.tar.gz ] && curl -s -O $HOME/Downloads/libc-info.tar.gz http://www.gnu.org/software/libc/manual/info/libc-info.tar.gz
[ -f $HOME/Downloads/libc-info.tar.gz ] && [ -d $HOME/Downloads ] && tar -xzf $HOME/Downloads/libc-info.tar.gz -C $HOME/Downloads/
[ -f $HOME/Downloads/libc.info ] && [ -f /Applications/Emacs.app/Contents/Resources/info/dir ] && install-info $HOME/Downloads/libc.info /Applications/Emacs.app/Contents/Resources/info/dir
[ -f $HOME/Downloads/libc.info ] && [ -d /Applications/Emacs.app/Contents/Resources/info ] && mv $HOME/Downloads/libc.info* /Applications/Emacs.app/Contents/Resources/info

