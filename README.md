# arOS
Another Rust Operating System - a simple Rust OS to learn how to create one.

## Tools

In order to build ar-OS, you will need (at least):
* autoconf,
* cmake,
* qemu,
* grub.

If another tools are needed (depending on your distro or your OS), please to
create a PR.

## Requirements

*	xargo (`cargo install xargo`)
*	Rust nightly (using rustup: `rustup override set nightly`)
* rust-src (`rustup component add rust-src`)

For macOS: `nasm`, `gcc`, `g++`, `grub2`, `objconf`, `qemu`, `xorriso` ...

## How to build / run

*   `make`
*   `RUST_TARGET_PATH=`pwd` make run`

## Troubleshootings

* `error: Error loading target specification: Could not find specification for
target "x86_64-unknown-aros-gnu"`
  Please to compile the OS using `RUST_TARGET_PATH=$(pwd) make`

## Screenshots

#### Current state

![state 3][state_3]

[state_3]: img/current_state_3.png
