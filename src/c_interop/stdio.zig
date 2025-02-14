const stdio = @import("./c_stdio.zig");

pub fn c_translate_strategy() void {
    const x: f32 = 1772.94122;
    _ = stdio.printf("Hello from zig-land %f\n", x);
}

const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
    @cInclude("math.h");
});

pub fn c_import_strategy() void {
    const x: f32 = 15.2;
    const y = c.powf(x, @as(f32, 2.6));
    _ = c.printf("%.3f\n", y);
}
