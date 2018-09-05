#![feature(lang_items)]
#![feature(panic_handler)]
#![no_std]

extern crate rlibc;
#[macro_use]
extern crate vga;

use core::panic::PanicInfo;
use vga::buffer::BUF_WRITER;

#[no_mangle]
#[lang = "eh_personality"]
extern "C" fn eh_personality() {}

#[no_mangle]
#[panic_handler]
extern "C" fn rust_begin_panic(info: &PanicInfo) -> ! {
    use core::fmt::Write;
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
    // Test
    use core::fmt::Write;

    echo!(BUF_WRITER.lock(), "Hello world, and welcome to ar-OS!");

    loop {}
}

