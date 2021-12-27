ip addr add 10.0.2.15/24 dev ens3
ip link set ens3 up
modprobe nbd
modprobe ext4
nbd-client 10.0.2.2
mkdir -p mnt
mount /dev/nbd0 mnt
