
#include <iostream>
#include "libwdicpp.h"

// Create a libusbcpp context. This has to outlive any device objects.
// Make sure that all devices are destroyed when the main function returns.
// (Basically just means no usb::device's at the global scope)
usb::context context;

int main() {

    std::cout << "Searching for devices..." << std::endl;

    // Get a list of available devices
    std::vector<usb::device_info> devices = usb::scan_devices(context);
    // or: auto devices = usb::scan_devices(context);

    // Print the list
    std::cout << devices.size() << " devices found" << std::endl;

    for (const auto& device_info : devices) {
        printf(" -- 0x%04X/0x%04X -> %s\n",
               device_info.vendor_id,
               device_info.product_id,
               device_info.description.c_str());
    }

    return 0;
}