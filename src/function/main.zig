const std = @import("std");
const print = std.debug.print;

fn add_2(x: u32) u32 {
    // this will fail compilation. All function parameters are immutable by default
    // x = x + 2
    return x + 2;
}

// to make parameters mutable pass a pointer
fn add_2_mutate(x: *u32) void {
    x.* = x.* + 2;
}

// - function parameters are immutable in Zig.
// - primitive types are passed by value i.e. copied to the stack
// - for primitive types he compiler will decide wether to pass by value or reference (which ever is faster)
pub fn main() void {
    print("add_2 result {}\n", .{add_2(10)});
    var x: u32 = 10;
    add_2_mutate(&x);
    print("add_2_mutate result {}\n", .{x});
}
