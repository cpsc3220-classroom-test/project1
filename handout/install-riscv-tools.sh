#!/bin/bash -xe


QEMUDIR=$HOME/.local/qemu/
GCCDIR=$HOME/.local/gnu-riscv/
mkdir -p $HOME/.local

cd
# downloads 
wget https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14.tar.gz
wget https://download.qemu.org/qemu-4.2.0.tar.xz &

# extract and install riscv64 gcc toolchain
tar xzf riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14.tar.gz --checkpoint=.1000
# clean up gcc stuff
mv riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14 $GCCDIR
rm -f riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14.tar.gz &


# setshell environment variables
echo "cpsc3200(){" >> ~/.bashrc
echo "   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$QEMUDIR/lib:$GCCDIR/lib" >> ~/.bashrc
echo "   export PATH=$PATH:$QEMUDIR/bin:$GCCDIR/bin" >> ~/.bashrc
echo "}" >> ~/.bashrc
echo "cpsc3200" >> ~/.bashrc
sync
source ~/.bashrc

# extract qemu
wait
xz --decompress  qemu-4.2.0.tar.xz
tar xf qemu-4.2.0.tar --checkpoint=.500
cd qemu-4.2.0
#build and install qemu
./configure --disable-kvm --disable-werror --prefix=$QEMUDIR --target-list="riscv64-softmmu"
make -j
make install -j
cd
# clean up qemu stuff
rm -rf qemu-4.2.0 &
rm -f qemu-4.2.0.tar.xz &
rm -f qemu-4.2.0.tar &

wait

# Verify if the installation succeeds
riscv64-unknown-elf-gcc --version
qemu-system-riscv64 --version
echo "If you made it this far, it worked!"
