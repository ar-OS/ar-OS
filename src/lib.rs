#![feature(lang_items)]
#![no_std]

extern crate rlibc;
#[macro_use]
extern crate vga;
extern crate interrupts;

use core::fmt::Write;
use core::panic::PanicInfo;
use vga::buffer::BUF_WRITER;
use interrupts::{init_idt, PICS};

#[no_mangle]
#[lang = "eh_personality"]
extern "C" fn eh_personality() {}

#[no_mangle]
#[panic_handler]
extern "C" fn rust_begin_panic(info: &PanicInfo) -> ! {
    echo!(BUF_WRITER.lock(), "{}", info);
    loop {}
}

#[no_mangle]
pub extern "C" fn __floatundisf() {}
#[no_mangle]
pub extern "C" fn __eqsf2() {}
#[no_mangle]
pub extern "C" fn __floatundidf() {}
#[no_mangle]
pub extern "C" fn __eqdf2() {}
#[no_mangle]
pub extern "C" fn __mulsf3() {}
#[no_mangle]
pub extern "C" fn __muldf3() {}
#[no_mangle]
pub extern "C" fn __divsf3() {}
#[no_mangle]
pub extern "C" fn __divdf3() {}
#[no_mangle]
pub extern "C" fn __udivti3() {}
#[no_mangle]
pub extern "C" fn __umodti3() {}
#[no_mangle]
pub extern "C" fn __muloti4() {}

#[no_mangle]
pub extern "C" fn kernel_main() -> ! {
    // Initialize the main functions of the OS
    echo!(BUF_WRITER.lock(), "Initializing the Interruption table...");
    init_idt();
    unsafe { PICS.lock().init() };
    echo!(BUF_WRITER.lock(), "> Initialized!\n");
    echo!(BUF_WRITER.lock(), "Hello world, and welcome to ar-OS!");
    
    loop {}
}

