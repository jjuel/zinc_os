#![no_std]
#![no_main]
#![feature(custom_test_frameworks)]
#![test_runner(zinc_os::test_runner)]
#![reexport_test_harness_main = "test_main"]

use core::panic::PanicInfo;
use zinc_os::println;

#[no_mangle]
pub extern "C" fn _start() -> ! {
    println!("Hello Zinc OS{}", "!");

    zinc_os::init();

    use x86_64::registers::control::Cr3;

    let (level_4_page_table, _) = Cr3::read();
    println!(
        "Level 4 page table at: {:?}",
        level_4_page_table.start_address()
    );

    // let ptr = 0xdeadbeef as *mut u32;
    // unsafe {
    //     *ptr = 42;
    // }

    #[cfg(test)]
    test_main();

    println!("It did not crash!");
    zinc_os::hlt_loop();
}

#[cfg(not(test))]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    println!("{}", info);

    zinc_os::hlt_loop();
}

#[cfg(test)]
#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    zinc_os::test_panic_handler(info)
}

#[test_case]
fn trivial_assertion() {
    assert_eq!(1, 1);
}
