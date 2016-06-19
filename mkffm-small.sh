#!/bin/bash
# Author: xXx
# Date: Sunday 19 Jun 2016 21:03
# This script will download and compile a small (but tested and working) static
# build of ffmpeg. All dependant external libraries versions are hardcoded in 
# the script for the moment. This may (but rather not) change some time.
# This script is tested and working fine on Debian 8.x and Ubuntu 14.04 and up.
# Make sure to run the script in a clean environment from "-dev" packages in
# order to ensure the staticness of the binary and its portability.
# If you want ffplay install the libsdl1.2 dev package of your distro, and what
# this brings along, but nothing more.
#
# Features:
# Enabled programs:		ffmpeg ffprobe (ffplay if sdl1.2 exists)
# External libraries:	libx264 libfdk_aac libfreetype libfontconfig libass
# License:				nonfree and unredistributable
# All this can be changed easily to adapt this script to your needs.

yasm='http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz'
x264='http://download.videolan.org/pub/videolan/x264/snapshots/last_stable_x264.tar.bz2'
fdk='http://downloads.sourceforge.net/opencore-amr/fdk-aac-0.1.4.tar.gz'
zlib='http://zlib.net/zlib-1.2.8.tar.gz'
bzip2='http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz'
libpng='http://download.sourceforge.net/libpng/libpng-1.6.23.tar.gz'
ragel='http://www.colm.net/files/ragel/ragel-6.9.tar.gz'
harfbuzz='http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.2.7.tar.bz2'
freetype='http://downloads.sourceforge.net/freetype/freetype-2.6.3.tar.bz2'
fribidi='http://fribidi.org/download/fribidi-0.19.7.tar.bz2'
expat='http://downloads.sourceforge.net/expat/expat-2.1.0.tar.gz'
fontconfig='http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.11.1.tar.bz2'
libass='https://github.com/libass/libass/releases/download/0.13.2/libass-0.13.2.tar.xz'
ffmpeg='http://ffmpeg.org/releases/ffmpeg-3.0.2.tar.bz2'

chkconf(){
if [ $? != 0 ];then
echo $_R" Configuring $1 failed!"$_X
exit 1
else
echo $_G" Configuring $1 success!"$_X
fi
}
chkbuild(){
if [ $? != 0 ];then
echo $_R" Building $1 failed!"$_X
exit 1
else
echo $_G" Building $1 success!"$_X
fi
}
chkdown(){
if [ $? != 0 ];then
echo $_R" Downloading $1 failed!"$_X
exit 1
else
echo $_G" Downloading $1 success!"$_X
fi
}
source='ffms'
binary='ffmb'
outdir=$(pwd)
logfil=$(pwd)/$(basename $0).log
if [ -f $logfil ];then
rm $logfil
fi
outbin=$(pwd)/ffbin
export PATH="$outbin:$outdir/$binary/bin:$PATH"
export PKG_CONFIG_PATH="$outdir/$binary/lib/pkgconfig"
_Y="$(tput bold && tput setaf 3)"
_G="$(tput bold && tput setaf 2)"
_B="$(tput bold && tput setaf 4)"
_R="$(tput bold && tput setaf 1)"
_X="$(tput sgr0)"
arr=(gcc bzip2 wget autoconf automake make pkg-config libtool g++)
for i in ${arr[@]};do
if [ "$(which $i)" = "" ];then
tput setaf 2
echo $_R" Please install $i and try again."$_X
tput sgr0
exit 1
fi
done
mkdir -p $outdir/$source
echo $_Y'########## YASM (NEEDED FOR BUILDING FFMPEG) ##################################'$_X
echo "################################################################################" &>>$logfil
echo "########## YASM ################################################################" &>>$logfil
echo "################################################################################" &>>$logfil
if [ -f $outdir/$binary/bin/yasm ];then
echo $_G" YASM already exists"$_X
else
cd $outdir/$source
wget -q -O yasm.tgz $yasm
chkdown YASM
tar xf yasm.tgz
cd yasm-1.3.0
./configure --prefix="$outdir/$binary" &>>$logfil
chkconf YASM
make &>>$logfil
chkbuild YASM
make install &>>$logfil
make distclean &>>$logfil
fi

echo $_Y'########## LIBX264 (ADDS SUPPORT) #############################################'$_X
echo "################################################################################" &>>$logfil
echo "########## LIBX264 #############################################################" &>>$logfil
echo "################################################################################" &>>$logfil
if [ -f $outdir/$binary/lib/pkgconfig/x264.pc ];then
echo $_G" X264 already exists"$_X
else
cd $outdir/$source
wget -q -O x264.bz2 $x264
chkdown LIBX264
tar xf x264.bz2
cd x264-snap*
./configure --prefix="$outdir/$binary" --enable-static &>>$logfil
chkconf LIBX264
make &>>$logfil
chkbuild LIBX264
make install &>>$logfil
make distclean &>>$logfil
fi

echo $_Y'########## LIBFDK_AAC (ADDS SUPPORT) ##########################################'$_X
echo "################################################################################" &>>$logfil
echo "########## LIBFDK_AAC ##########################################################" &>>$logfil
echo "################################################################################" &>>$logfil
if [ -f $outdir/$binary/lib/pkgconfig/fdk-aac.pc ];then
echo $_G" LIB_FDK already exists"$_X
else
cd $outdir/$source
wget -q -O fdk.tgz $fdk
chkdown LIBFDK_AAC
tar xf fdk.tgz
cd fdk-aac-0.1.4
./configure --prefix="$outdir/$binary" --disable-shared --enable-static &>>$logfil
chkconf LIBFDK_AAC
make &>>$logfil
chkbuild LIBFDK_AAC
make install &>>$logfil
make distclean &>>$logfil
fi

echo $_Y'########## ZLIB (NEEDED FOR FREETYPE) #########################################'$_X
echo "################################################################################" &>>$logfil
echo "########## ZLIB ################################################################" &>>$logfil
echo "################################################################################" &>>$logfil
if [ -f $outdir/$binary/lib/pkgconfig/zlib.pc ];then
echo $_G" ZLIB already exists"$_X
else
cd $outdir/$source
wget -q -O zlib.tgz $zlib
chkdown ZLIB
tar xf zlib.tgz
cd zlib-1.2.8
./configure --prefix="$outdir/$binary" --static &>>$logfil
chkconf ZLIB
make &>>$logfil
chkbuild ZLIB
make install &>>$logfil
make distclean &>>$logfil
fi

echo $_Y'########## BZIP2 (NEEDED FOR FREETYPE) ########################################'$_X
echo "################################################################################" &>>$logfil
echo "########## BZIP2 ###############################################################" &>>$logfil
echo "################################################################################" &>>$logfil
if [ -f $outdir/$binary/include/bzlib.h ];then
echo $_G" BZIP2 already exists"$_X
else
cd $outdir/$source
wget -q -O bzip2.tgz $bzip2
chkdown BZIP2
tar xf bzip2.tgz
cd bzip2-1.0.6
make &>>$logfil
chkbuild ZLIB
make install PREFIX=$outdir/$binary &>>$logfil
make distclean &>>$logfil
fi

echo $_Y'########## LIBPNG (NEEDED FOR FREETYPE) #######################################'$_X
echo "################################################################################" &>>$logfil
echo "########## LIBPNG ##############################################################" &>>$logfil
echo "################################################################################" &>>$logfil
if [ -f $outdir/$binary/lib/pkgconfig/libpng.pc ];then
echo $_G" LIBPNG already exists"$_X
else
cd $outdir/$source
wget -q -O libpng.tgz $libpng
chkdown LIBPNG
tar xf libpng.tgz
cd libpng-1.6.23
./configure CPPFLAGS="-I$outdir/$binary/include" LDFAGS="-L$outdir/$binary/lib" LIBS="-L$outdir/$binary/lib" --prefix=$outdir/$binary --disable-shared --enable-static \
--with-zlib-prefix=$outdir/$binary --with-pkgconfigdir=$outdir/$binary/lib/pkgconfig &>>$logfil
chkconf LIBPNG
make &>>$logfil
chkbuild LIBPNG
make install PREFIX=$outdir/$binary &>>$logfil
make distclean &>>$logfil
fi

echo $_Y'########## FREETYPE (ADDS SUPPORT) ############################################'$_X
echo "################################################################################" &>>$logfil
echo "########## FREETYPE ############################################################" &>>$logfil
echo "################################################################################" &>>$logfil
if [ -f $outdir/$binary/lib/pkgconfig/freetype2.pc ];then
echo $_G" FREETYPE already exists"$_X
else
cd $outdir/$source
wget -q -O freetype.bz2 $freetype
chkdown FREETYPE
tar xf freetype.bz2
cd freetype-2.6.3
./configure CPPFLAGS="-I$outdir/$binary/include" LDFAGS="-L$outdir/$binary/lib" LIBS="-L$outdir/$binary/lib" --prefix="$outdir/$binary" --disable-shared --enable-static &>>$logfil
chkconf FREETYPE
make &>>$logfil
chkbuild FREETYPE
make install &>>$logfil
make distclean &>>$logfil
fi

echo $_Y'########## FRIBIDI (NEEDED FOR FONTCONFIG) ####################################'$_X
echo "################################################################################" &>>$logfil
echo "########## FRIBIDI #############################################################" &>>$logfil
echo "################################################################################" &>>$logfil
if [ -f $outdir/$binary/lib/pkgconfig/fribidi.pc ];then
echo $_G" FREEBIDI already exists"$_X
else
cd $outdir/$source
wget -q -O fribidi.bz2 $fribidi
chkdown FRIBIDI
tar xf fribidi.bz2
cd fribidi-*
./configure --prefix="$outdir/$binary" --disable-deprecated --disable-debug --disable-shared --enable-static &>>$logfil
chkconf FRIBIDI
make &>>$logfil
chkbuild FRIBIDI
make install &>>$logfil
make distclean &>>$logfil
fi

echo $_Y'########## EXPAT (NEEDED FOR FONTCONFIG) ######################################'$_X
echo "################################################################################" &>>$logfil
echo "########## EXPAT ###############################################################" &>>$logfil
echo "################################################################################" &>>$logfil
if [ -f $outdir/$binary/lib/pkgconfig/expat.pc ];then
echo $_G" EXPAT already exists"$_X
else
cd $outdir/$source
wget -q -O expat.tgz $expat
chkdown EXPAT
tar xf expat.tgz
cd expat*
./configure --prefix="$outdir/$binary" --disable-shared --enable-static &>>$logfil
chkconf EXPAT
make &>>$logfil
chkbuild EXPAT
make install &>>$logfil
make distclean &>>$logfil
fi

echo $_Y'########## FONTCONFIG (ADDS SUPPORT) ##########################################'$_X
echo "################################################################################" &>>$logfil
echo "########## FONTCONFIG ##########################################################" &>>$logfil
echo "################################################################################" &>>$logfil
if [ -f $outdir/$binary/lib/pkgconfig/fontconfig.pc ];then
echo $_G" FONTCONFIG already exists"$_X
else
cd $outdir/$source
wget -q -O fontconfig.bz2 $fontconfig
chkdown FONTCONFIG
tar xf fontconfig.bz2
cd fontconfig-*
./configure CPPFLAGS="-I$outdir/$binary/include" LDFAGS="-L$outdir/$binary/lib" LIBS="-L$outdir/$binary/lib" --prefix="$outdir/$binary" --disable-docs --disable-shared --enable-static &>>$logfil
chkconf FONTCONFIG
make &>>$logfil
chkbuild FONTCONFIG
make install &>>$logfil
make distclean &>>$logfil
fi

echo $_Y'########## LIBASS (ADDS SUPPORT) ###############################################'$_X
echo "################################################################################" &>>$logfil
echo "########## LIBASS ##############################################################" &>>$logfil
echo "################################################################################" &>>$logfil
if [ -f $outdir/$binary/lib/pkgconfig/libass.pc ];then
echo $_G" LIBASS already exists"$_X
else
cd $outdir/$source
wget -q -O libass.xz $libass
chkdown LIBASS
tar xf libass.xz
cd libass-0.13.2
./configure --prefix="$outdir/$binary" --disable-debug --disable-shared --enable-static &>>$logfil
chkconf LIBASS
make &>>$logfil
chkbuild LIBASS
make install &>>$logfil
make distclean &>>$logfil
fi

echo $_Y'################################### FFMPEG ####################################'$_X
echo "################################################################################" &>>$logfil
echo "#################################### FFMPEG ####################################" &>>$logfil
echo "################################################################################" &>>$logfil
cd $outdir/$source
if [ ! -f $outdir/$source/ffmpeg.bz2 ];then
wget -q -O ffmpeg.bz2 $ffmpeg
chkdown FFMPEG
tar xjf ffmpeg.bz2
fi
cd ffmpeg-*
./configure \
--prefix="$outdir/$binary" \
--pkg-config-flags="--static" \
--extra-cflags="-I$outdir/$binary/include" \
--extra-ldflags="-L$outdir/$binary/lib" \
--bindir="$outbin" \
--disable-extra-warnings \
--disable-debug \
--disable-doc \
--disable-ffserver \
--disable-shared \
--enable-static \
--enable-nonfree \
--enable-gpl \
--enable-version3 \
--enable-libx264 \
--enable-libfdk-aac \
--enable-libfreetype \
--enable-fontconfig \
--enable-libass
chkconf FFMPEG
echo $_B" Building FFMPEG. Please wait..."$_X
make &>>$logfil
if [ $? = 0 ];then
echo $_G" Building FFMPEG success!"$_X
good=yes
else
echo $_R" Building FFMPEG failed!"$_X
good=no
fi
make install &>>$logfil
make distclean &>>$logfil
if [ "$good" = "yes" ];then
echo $_Y" Building FFMPEG finished."
echo " Your binaries should be in $outbin"$_X
echo $_B" You can safely delete:"$_X
echo $_G" $outdir/$source"$_X
echo $_G" $outdir/$binary"$_X
echo $_B" unless you want to build again sometime."$_X
if [ "$(pgrep Xorg)" != "" ];then
if [ "$(which xdg-open)" != "" ];then
xdg-open $outbin
else
ls -lh $outbin
fi
else
ls -lh $outbin
fi
else
echo $_R" Something went wrong while building FFMPEG..."$_X
fi
