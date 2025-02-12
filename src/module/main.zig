const std = @import("std");
const math = @import("./math/root.zig");
const print = std.debug.print;

/// - Every .zig file is a module on it own
/// - Every Zig module (i.e. a .zig file) that you write in your project is internally stored as a struct object.
pub fn main() void {
    print("math::add {}\n", .{math.add(u32, 1, 2)});
}
