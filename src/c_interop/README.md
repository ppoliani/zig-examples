# C Interop

Zig have great interoperability with C. If you want to call any C code from Zig, you have to perform the following steps:
1. import a C header file into your Zig code.
2. link your Zig code with the C library.

reference: https:pedropark99.github.io/zig-book/Chapters/14-zig-c-interop.html

## Stategies to import C header files

 there are currently two different ways to perform this first step, which are:
1. translating the C header file into Zig code, through the zig translate-c command, and then,
import and use the translated Zig code.
2. importing the C header file directly into your Zig module through the @cImport() built-in function.

### translate-c command

If you are not familiar with translate-c, this is a subcommand inside the zig compiler that takes C files as input,
and outputs the Zig representation of the C code present in these C files. In other words, this subcommand works like a
transpiler.  It takes C code, and translates it into the equivalent Zig code.

### @cImport

Because, under the hood, the @cImport() built-in function is just a shortcut to translate-c. Both tools use the same
“C to Zig” translation functionality. So when you use @cImport(), you are essentially asking the zig compiler to translate
the C header file into Zig code, then, to import this Zig code into your current Zig module.

## Linking Zig code with a C library

Regardless of which of the two strategies from the previous section you choose, if you want to call C code from Zig,
you must link your Zig code with the C library that contains the C code that you want to call.

In other words, everytime you use some C code in your Zig code, you introduce a dependency in your build process.
This should come as no surprise to anyone that have any experience with C and C++. Because this is no different in C.
Everytime you use a C library in your C code, you also have to build and link your C code with this C library that you are using.

When we use a C library in our Zig code, the zig compiler needs to access the definition of the C functions that are being called
in your Zig code. The C header file of this library provides the declarations of these C functions, but not their definitions.
So, in order to access these definitions, the zig compiler needs to build your Zig code and link it with the C library during
the build process.


## Example using translate-c

Let's use the `stdio.h` library inside our zig code.

First find the location of stdio.h on you system. On mac we can find it using:

```bash
find /Applications/Xcode.app -name stdio.h
```

Translate c code into zig.

```bash
zig translate-c /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/stdio.h \
    -lc -I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/\
    -D_NO_CRT_STDIO_INLINE=1 > c.zig
```

Check `stdio.zig` to see how it's being used


## Example cInclude strategt

This @cInclude() function is equivalent to the #include statement in C. You provide the name of the C header that you want to include as input to this @cInclude() function, then, in conjunction with @cImport(), it will perform the necessary steps to include this C header file into your Zig code.
