# SPDX-License-Identifier: GPL-2.0
#
# Makefile for the processvminfo kernel module
#

# Module name
obj-m := processvminfo.o

# Kernel build directory
KDIR ?= /lib/modules/$(shell uname -r)/build

# Current directory
PWD := $(shell pwd)

# Compiler flags
EXTRA_CFLAGS += -I$(PWD)/include
EXTRA_CFLAGS += -Wno-unused-parameter
EXTRA_CFLAGS += -Wno-unused-function

# Default target
all: module

module:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

# Build with debug symbols
debug:
	$(MAKE) -C $(KDIR) M=$(PWD) EXTRA_CFLAGS="-DDEBUG -g -O0" modules

# Clean target
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -f *.o *.mod *.mod.c *.mod.o *.symvers *.order
	rm -rf .tmp_versions

# Install module
install: module
	sudo insmod processvminfo.ko

# Remove module
remove:
	sudo rmmod processvminfo

# Show module info
info:
	modinfo processvminfo.ko

# Check module for common issues
check: module
	sudo modprobe --dry-run processvminfo.ko 2>&1 || true
	nm processvminfo.ko | grep -E 'T|U' | head -40

# Build for a specific kernel source tree
custom KDIR=/path/to/kernel:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

# Cross-compile for ARM
arm:
	$(MAKE) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- \
		-C $(KDIR) M=$(PWD) modules

# Cross-compile for ARM64
arm64:
	$(MAKE) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
		-C $(KDIR) M=$(PWD) modules

# Print module dependencies
deps: module
	modinfo processvminfo.ko | grep depends

.PHONY: all module debug clean install remove info check custom arm arm64 deps sign

