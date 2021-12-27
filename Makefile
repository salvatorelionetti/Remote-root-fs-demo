KERNEL=/boot/vmlinuz-4.19.0-16-rt-amd64
INITRD=/boot/initrd.img-4.19.0-16-rt-amd64
DEBIAN_VER=buster

inst:
	sudo apt install debootstrap qemu qemu-kvm nbd-server nbd-client
	# Note: nbd-client triggers initrd update

prepare: inst rootfs

.PHONY: rootfs

run: emu
# Manual steps:
# 1) Before the emulator is started, drop a new shell and start a server with "make server"
# 2) As soon as the kernel is started, stop the server and restart it again
# 3) Enjoy

rootfs:
	mkdir -p rootfs
	dd if=/dev/zero of=rootfs.img bs=1M count=300
	sudo mkfs -t ext4 -L boot_over_nbd rootfs.img
	sudo mount -o loop rootfs.img rootfs
	sudo debootstrap $(DEBIAN_VER) rootfs
	sync
	sudo umount rootfs

rootfs_open:
	sudo mount -o loop rootfs.img rootfs

rootfs_close:
	sudo umount rootfs

emu:
	qemu-system-x86_64 -kernel $(KERNEL) -initrd $(INITRD) -hda rootfs.img -append "console=ttyS0 debug=y ip=dhcp root=/dev/nbd0 nbdroot=10.0.2.2:10809/rootfs.img" -nographic -serial mon:stdio -m 512 -netdev user,id=net0,guestfwd=tcp::10809-tcp:127.0.0.1:10809 -device e1000,netdev=net0 # To dump network packets: -object filter-dump,id=f1,netdev=net0,file=dump.dat

client:
	sudo nbd-client localhost

server:
	nbd-server -C nbd_server.conf 10809 -d
