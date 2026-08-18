# processvminfo — Linux Kernel Module

A small out-of-tree LKM that exposes per-process virtual-memory info
via a `/proc/process_vm_info` interface (accepts a PID, walks `mm_struct`).

## Requirements

- A Linux kernel (tested on 6.x)
- The kernel development tree for the **running** kernel
- `gcc`, `make`

> ⚠️ The installed headers/devel package version must exactly match `uname -r`.
> After a kernel update, reboot into the new kernel before building.

## Install build dependencies

### Debian / Ubuntu

sudo apt update
sudo apt install build-essential
sudo apt install linux-headers-$(uname -r)

# If the exact version is unavailable (e.g. running an older kernel),
# install the meta-package to pull in the current kernel + headers:
#   Ubuntu/Ubuntu-based: linux-headers-generic
#   Debian (amd64):      linux-headers-amd64
#   Debian (arm64):      linux-headers-arm64
# sudo apt install linux-headers-generic        # Ubuntu
# sudo apt install linux-headers-amd64          # Debian amd64

Verify:
ls -l /lib/modules/$(uname -r)/build   # symlink to /usr/src/linux-headers-$(uname -r)

### Fedora / RHEL / CentOS Stream

sudo dnf install gcc make elfutils-libelf-devel
sudo dnf install "kernel-devel-$(uname -r)"

Verify:
ls -l /lib/modules/$(uname -r)/build   # symlink to /usr/src/kernels/$(uname -r)

### openSUSE Leap / Tumbleweed / SLE

sudo zypper install gcc make
sudo zypper install "kernel-default-devel=$(uname -r | sed 's/-default//')"

Verify:
ls -l /lib/modules/$(uname -r)/build   # symlink into /usr/src/linux-*-obj/...

## Build

make            # produces processvminfo.ko
make clean      # remove build artifacts
make debug      # build with -DDEBUG -g

## Load / test

sudo insmod processvminfo.ko
lsmod | grep processvminfo
dmesg | tail

# Query PID 1 as an example
cat /proc/processvminfo/1/process_vm_info

sudo rmmod processvminfo

## Distro notes

| Distro family | Package providing build tree            | KDIR used by Makefile               |
|---------------|----------------------------------------|------------------------------------|
| Debian/Ubuntu | linux-headers-$(uname -r)              | /lib/modules/$(uname -r)/build     |
| Fedora/RHEL   | kernel-devel-$(uname -r)               | /lib/modules/$(uname -r)/build     |
| openSUSE      | kernel-default-devel (flavor-specific) | /lib/modules/$(uname -r)/build     |
