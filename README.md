# arOS
Another Rust Operating System - a simple Rust OS to learn how to create one.

arOS builds are only tested on GNU/Linux.

## Requirements

*	xargo (```cargo install xargo```)
*	Rust nightly (with rustup: ```rustup override set nightly```)

## How to build / run

*   ```rustup component add rust-src```
*   ```make```
*   ```RUST_TARGET_PATH=`pwd` make run```

## Troubleshootings

* `error: Error loading target specification: Could not find specification for
target "x86_64-unknown-aros-gnu"`  
  Please to compile the OS using ```RUST_TARGET_PATH=`pwd` make```

## Screenshots

#### Current state

![state 2][state_2]

[state_2]: img/current_state_2.png
