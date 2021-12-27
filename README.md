# Remote-root-fs-demo
Linux booting from remote root fs.

The method explored is very fast and adaptative to any debian based distro.
Drawback is that the kernel is not recompiled, so less flexibility.

Prerequisite: a recent Debian distro. I'm using **buster** at the moment.

Configuration
Just change the first 3 lines of the Makefile:
>KERNEL=/boot/vmlinuz-4.19.0-16-rt-amd64
>INITRD=/boot/initrd.img-4.19.0-16-rt-amd64
>DEBIAN_VER=buster

make prepare
Install host packages and create the rootfs with debootstrap

make emu
Start QEMU emulator with the desired kernel, initrd and rootfs  
