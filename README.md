# SimpBootloader
This is a simple bootloader I made awhile ago that loads some assembley code into RAM and executes it.

## What it does
This bootloader has 3 functions
***
### Reprint text entered
`ctrl+c` (After you have entered your text)
by default the program stores text you type into the console into memory and keeps track of how much is in that bit of memory
***
### Fill screen
`ctrl+a`
This fills the screen with pound charicters to test if the full resolution of your screen can be used.
***
### Reset
`ctl+r`
This simply resets the computer.
***
This has been tested on real hardware with a floppy disk (if you want to do it in hard drive mode comment line 17 of bootloader.asm in NoKrn and uncomment line 16)
You can use compile.sh to compile and run in a QEMu VM