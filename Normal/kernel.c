// kernel.c
void print_string(const char* str);

void _start() {
    const char* message = "Hello, World!";
    print_string(message);

    // Halt the CPU
    asm volatile ("hlt");
}

void print_string(const char* str) {
    // Print the string using BIOS interrupts (for simplicity)
    while (*str != '\0') {
        asm volatile (
            "mov $0x0E, %%ah\n\t"   // BIOS teletype output
            "mov $0x07, %%bh\n\t"   // Page number (0x07 is often the text mode page)
            "mov $0x0000, %%cx\n\t" // Number of characters
            "mov %0, %%al\n\t"      // Character to print
            "int $0x10\n\t"
            : // Output
            : "m" (*str) // Input
            : "ah", "bh", "cx", "al"
        );

        // Move to the next character in the string
        ++str;
    }
}
