const stdio = @import("./stdio.zig");

pub fn main() void {
    stdio.c_translate_strategy();
    stdio.c_import_strategy();
}
