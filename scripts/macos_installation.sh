#!/bin/sh
set -e

create_if_dir_not_exists() {
  dir_path=$1
  if [ ! -d $dir_path ]; then
    echo "Creating $dir_path..."
    mkdir -p $dir_path
  fi
}

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

export INIT_PATH="$HOME/Devel/build_binaries/"
export PREFIX="$INIT_PATH/opt/"
export BIN_PATH="$INIT_PATH/bin/"
export SRC_PATH="$INIT_PATH/src/"
export TARGET=x86_64-pc-elf
export PATH="$PREFIX/bin:$PATH"

create_if_dir_not_exists $INIT_PATH
create_if_dir_not_exists $BIN_PATH
create_if_dir_not_exists $SRC_PATH
create_if_dir_not_exists $PREFIX

brew install gmp mpfr libmpc autoconf automake pkg-config

echo ""
echo "Installing \`binutils\`"
echo ""
cd $SRC_PATH

if [ ! -d "binutils-2.34" ]; then
  curl -O http://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.gz
  tar xfz binutils-2.34.tar.gz

  rm binutils-2.34.tar.gz
  mkdir -p build-binutils
  cd build-binutils
  ../binutils-2.34/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
  make
  make install
fi

echo ""
echo "Installing \`gcc\`"
echo ""
cd $SRC_PATH

if [ ! -d "gcc-10.1.0" ]; then
  curl -L ftp://ftp.lip6.fr/pub/gcc/releases/gcc-10.2.0/gcc-10.2.0.tar.gz > gcc-10.2.0.tar.gz
  tar xvzf gcc-10.2.0.tar.gz
  rm gcc-10.2.0.tar.gz
  mkdir -p build-gcc
  cd build-gcc
  ../gcc-10.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --with-gmp=/usr/local/Cellar/gmp/6.1.0 --with-mpfr=/usr/local/Cellar/mpfr/3.1.3 --with-mpc=/usr/local/Cellar/libmpc/1.0.3
  make all-gcc
  make all-target-libgcc
  make install-gcc
  make install-target-libgcc
fi

echo ""
echo "Installing \`objconv\`"
echo ""
cd $SRC_PATH


if [ ! -d "objconv" ]; then
  curl -L https://www.agner.org/optimize/objconv.zip > objconv.zip
  mkdir -p build-objconv
  unzip objconv.zip -d build-objconv

  cd build-objconv
  unzip source.zip -d src
  g++ -o objconv -O2 src/*.cpp --prefix="$PREFIX"
  cp objconv $BIN_PATH
fi

echo ""
echo "Installing \`grub\`"
echo ""
cd $SRC_PATH

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
echo "To use all your new GNU tools, you can add this in your .profile file: echo \"export PATH=$PATH:$INIT_PATH/bin\" >> .profile`"
echo "Enjoy!"
