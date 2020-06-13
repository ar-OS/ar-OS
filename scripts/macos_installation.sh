#!/bin/sh
set -e

CONTINUE=false

echo ""
echo "You are about to download, compile, and install required tools to compile and run ar-OS on your computer."
echo "Please read through the source script to know what is being done."
echo "Do you want to continue? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  echo "Exiting..."
  exit
fi

command -v brew >/dev/null 2>&1 || { echo >&2 "It seems you do not have \`brew\` installed. Head on over to http://brew.sh/ to install it."; exit 1; }

export PREFIX="$HOME/opt/"
export TARGET=x86_64-pc-elf
export PATH="$PREFIX/bin:$PATH"

mkdir -p $HOME/src
mkdir -p $PREFIX

brew install gmp mpfr libmpc autoconf automake pkg-config

echo ""
echo "Installing \`binutils\`"
echo ""
cd $HOME/src

if [ ! -d "binutils-2.25" ]; then
  curl -O http://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz
  tar xfz binutils-2.25.tar.gz

  rm binutils-2.25.tar.gz
  mkdir -p build-binutils
  cd build-binutils
  ../binutils-2.25/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
  make
  make install
fi

echo ""
echo "Installing \`gcc\`"
echo ""
cd $HOME/src

if [ ! -d "gcc-10.1.0" ]; then
  curl -L ftp://ftp.lip6.fr/pub/gcc/releases/gcc-10.1.0/gcc-10.1.0.tar.gz > gcc-10.1.0.tar.gz
  tar xvzf gcc-10.1.0.tar.gz
  rm gcc-10.1.0.tar.gz
  mkdir -p build-gcc
  cd build-gcc
  ../gcc-10.1.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --with-gmp=/usr/local/Cellar/gmp/6.1.0 --with-mpfr=/usr/local/Cellar/mpfr/3.1.3 --with-mpc=/usr/local/Cellar/libmpc/1.0.3
  make all-gcc
  make all-target-libgcc
  make install-gcc
  make install-target-libgcc
fi

echo ""
echo "Installing \`objconv\`"
echo ""
cd $HOME/src


if [ ! -d "objconv" ]; then
  curl -L https://www.agner.org/optimize/objconv.zip > objconv.zip
  mkdir -p build-objconv
  unzip objconv.zip -d build-objconv

  cd build-objconv
  unzip source.zip -d src
  g++ -o objconv -O2 src/*.cpp --prefix="$PREFIX"
  cp objconv $PREFIX/bin
fi

echo ""
echo "Installing \`grub\`"
echo ""
cd $HOME/src

if [ ! -d "grub" ]; then
  git clone --depth 1 git@github.com:ar-OS/grub

  cd grub
  sh autogen.sh
  mkdir -p build-grub
  cd build-grub
  ../configure --disable-werror TARGET_CC=$TARGET-gcc TARGET_OBJCOPY=$TARGET-objcopy \
    TARGET_STRIP=$TARGET-strip TARGET_NM=$TARGET-nm TARGET_RANLIB=$TARGET-ranlib --target=$TARGET --prefix=$PREFIX
  make
  make install
fi

echo ""
echo "Installing \`required tools to compile and run ar-OS\`"
echo ""

brew install nasm xorriso qemu

echo "Done"
echo "To use all your new GNU tools, you can add this in your .profile file: echo \"export PATH=$PATH:$HOME/opt/bin\" >> .profile`"
echo "Enjoy!"
