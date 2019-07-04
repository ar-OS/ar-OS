# arOS
Another Rust Operating System - a simple Rust OS to learn how to create one.

## Tools

In order to build ar-OS, you will need (at least):
* autoconf,
* cmake,
* nasm,
* qemu,
* grub2,
* xorriso (>= 1.5.0).

If another tools are needed (depending on your distro or your OS), please to
create a PR.

## Requirements

* xargo (`cargo install xargo`)
* Rust nightly (using rustup: `rustup override set nightly`)
* rust-src (`rustup component add rust-src`)

For macOS: `nasm`, `gcc`, `g++`, `grub2`, `objconf`, `qemu`, `xorriso` ...

## How to build / run

```bash
# Clone the main repository as core
git clone https://github.com/ar-OS/ar-OS core
cd core
# Update the git submodules
git submodule init && git submodule update
# Build the project
make
# Run the project
RUST_TARGET_PATH=`pwd` make run
```

## Troubleshootings

* `error: No bootable device`
  Make sure that grub2 is installed, not grub-legacy

* `error: Error loading target specification: Could not find specification for
target "x86_64-unknown-aros-gnu"`
  Please to compile the OS using `RUST_TARGET_PATH=$(pwd) make`

## Screenshots

#### Current state

![state 3][state_3]

[state_3]: img/current_state_3.png
