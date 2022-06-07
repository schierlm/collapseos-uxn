# collapseos-uxn

Port of CollapseOS to uxn Tal

## Description

This is a port of [Collapse OS](http://collapseos.org/) (Snapshot 2022-05-09) to the
[uxn](https://100r.co/site/uxn.html)/[varvara](https://wiki.xxiivv.com/site/varvara.html)
virtual machine.

Unlike other Collapse OS ports, it does not try to assemble the whole rom image
using Collapse OS Forth. Instead it uses a two-step approach.

The core image of the OS is assambled using [uxntal](https://wiki.xxiivv.com/site/uxntal.html),
and will dynamically load a forth image from `collapseos.bin` at `$0800`, overwriting the
initialization code that resided at that place previously. As uxntal is self-hosting on UXN,
this shortcut was deemed acceptable to me. The tooling for uxntal in VS Code as well as UXN32
debugger support made porting definitely faster for me that way. Also, the ISA/ABI is unstable
enough to require three different uxnasm builds to compile for three different emulators, so
building an assembler written in Forth is just not an option for me.

Also note that the port was started at the CVM port and only implements the bare minimum
of native words - first make it work, then make it faster.

I was considering to use the native operand and return stack for the Forth operand and return
stack, but ultimately decided against it. The event-driven nature of keyboard input would
have required the `(key)` word to unwind the stack and store it elsewhere, and later restore
once a key is pressed or the timer interrupt vector fires.

Therefore, like most other ports, the Forth operand and return stack live in normal system memory;
the stack pointers live in the zero page among other global variables.

There are two versions. The normal version supports a block filesystem which may either exist as
a single file named `blkfs`, or multiple files named `blk0000` to `blk9999`. At first startup
the former file is converted to the latter form and then deleted. This design choice was driven
by the fact that when *writing* files on varvara, there is no way to seek. Therefore writing each
block into a separate file gets away with that limitation easily.

The second, *lite* version does not support block filesystems, and does not require filesystem
access. To use, you have to concatenate the forth image file to the core image file (which is `$0700`
bytes long, making the forth image end up at `$0800`).

It has been tested in the latest version of the UXN32 emulator (2022-04-26).

## Download

Have a look in the file release section if you want to download binaries to try.

## License

GPL3, just like Collapse OS

## Moving forward

Feel free to adopt this project if you find it interesting. I will follow Virgil's route and not update this project regularly.
(The fact that there are different incompatible versions of uxn images, without even a version number for them, and some emulators
get updated and some do not, has deterred me from keeping this up to date.)
