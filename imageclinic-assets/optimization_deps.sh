#!/usr/bin/env bash

set -e
#yum install -y ImageMagick
yum install -y libpng zlib make libpng-devel nasm

#DSSIM
git clone https://github.com/pornel/dssim.git ~/dssim
cd ~/dssim
make

#GUETZLI
cd ~
git clone https://github.com/google/guetzli.git
cd guetzli
make

##MOZJPEG
cd ~
git clone  https://github.com/mozilla/mozjpeg.git
cd mozjpeg
autoreconf -fiv
mkdir build && cd build
sh ../configure
make
#make

