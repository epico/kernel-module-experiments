# Linux Kernel Module Experiments

This project is just some experiments with Linux Kernel Module.

This project is written by some AI tools.

## processvminfo - Linux Kernel Module

A small out-of-tree LKM that exposes per-process virtual-memory info
via a `/proc/process_vm_info` interface (accepts a PID, walks `mm_struct`).

Please disable the Secure Boot option in UEFI before loading this kernel module.
