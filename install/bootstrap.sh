#!/bin/bash
# Arch Linux installation script for UpCloud

# Variables
TZ="Europe/Helsinki"
LOC="en_US.UTF-8"
KEYBOARD="us"
HOSTNAME=test-server
USERNAME="tqre"
PASSWORD=$PASSWD
SSH_PORT="22"
SSH_PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC37vA6wu3JhyLwPyaLxFmV5Fs9gPVgE3ON5zx2pISRetD5jABWAGltm2oU8JHKA2ZlsNq0JDyNlP3FyuY5nsvCWMZaIzpxaqm++F5fEteTnLFvOUwobe+ZslC9FhMph7uKEDwfZPnHAq4DRGxq7N8KHGJYV3BA31EKLAjoE0umTja/m+O2Zb/pCwJAyWEFNTzj17N25Ek95/tdY3/PuBmyEORxzCLF2n9XKHtFgVXtadVnSeB2qRYw8UXbDHurLMOq653Gp43dCzVw0zJh0nzGjtVr/jHJRLg824kVE1oAfzylv5MJOryZ0JUh/w5aiFxkVth4SjzHY4QMlK9OuZfN tqre@tqrearch"

timedatectl set-ntp true

# Partition disks
cat << EOF > partition_map
label: gpt
device: /dev/vda
unit: sectors
first-lba: 2048
last-lba: 52428766

/dev/vda1 : start=        2048, size=        2048, type=21686148-6449-6E6F-744E-656564454649
/dev/vda2 : start=        4096, size=     8388608, type=0657FD6D-A4AB-43C4-84E5-0933C84B4F4F
/dev/vda3 : start=     8392704, size=    16777216, type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709
/dev/vda4 : start=    25169920, size=    27258847, type=933AC7E1-2EB4-4F13-B844-0E14E2AEF915
EOF

sfdisk /dev/vda < partition_map
mkfs.vfat /dev/vda1
mkswap /dev/vda2
mkfs.ext4 /dev/vda3
mkfs.ext4 /dev/vda4
swapon /dev/vda2
mount /dev/vda3 /mnt
mkdir /mnt/home
mount /dev/vda4 /mnt/home

# Bootstrap basic software + generate file system table
pacstrap /mnt base linux grub openssh sudo nano python
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot to make configurations
cat << EOF | arch-chroot /mnt
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
hwclock --systohc
sed -i 's/#$LOC/$LOC/' /etc/locale.gen
locale-gen
echo "LANG=$LOC" > /etc/locale.conf
echo "KEYMAP=$KEYBOARD" > /etc/vconsole.conf

# Network configuration
echo -e "[Match]\nName=ens*\n\n[Network]\nDHCP=ipv4" > /etc/systemd/network/dhcp.network
systemctl enable systemd-networkd.service
echo $HOSTNAME > /etc/hostname
echo -e "127.0.0.1 localhost\n::1 localhost" > /etc/hosts

# Sudo user
echo "$USERNAME ALL=(ALL) ALL" >> /etc/sudoers
useradd -m $USERNAME
echo -e "$PASSWORD\n$PASSWORD" | passwd $USERNAME

# SSH access and configuration for sudo user
runuser $USERNAME -c 'mkdir ~/.ssh'
runuser $USERNAME -c 'echo $SSH_PUB_KEY > ~/.ssh/authorized_keys'
sed -i "s/#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i '/#PermitRootLogin pro/c\PermitRootLogin no' /etc/ssh/sshd_config
systemctl enable sshd

# GRUB
grub-install --target=i386-pc /dev/vda
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
sed -i '/LINUX_DEF/c\GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 random.trust_cpu=on"' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

EOF

# Define DNS servers and pacman mirror for VM
echo -e "nameserver 94.237.127.9\nnameserver 94.237.40.9" > /mnt/etc/resolv.conf
echo "Server = http://arch.mirror.far.fi/\$repo/os/\$arch" > /mnt/etc/pacman.d/mirrorlist

poweroff
