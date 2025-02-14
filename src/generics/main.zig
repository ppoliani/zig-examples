const std = @import("std");
const expectEqual = std.testing.expectEqual;

// In Zig, generics are implemented through comptime. The comptime keyword allows us to collect a data type
// at compile time, and pass this data type as input to a piece of code.
fn max(comptime T: type, a: T, b: T) T {
    return if (a > b) a else b;
}

test "test max" {
    const n1 = max(u8, 4, 10);
    std.debug.print("Max n1: {d}\n", .{n1});
    const n2 = max(f64, 89.24, 64.001);
    std.debug.print("Max n2: {d}\n", .{n2});
}

// Create new generic struct
fn Vec(comptime T: type, count: comptime_int) type {
    return struct {
        const Self = @This();
        data: [count]T,

        fn init(data: [count]T) Self {
            return Self{ .data = data };
        }

        fn item(self: Self, i: usize) T {
            return self.data[i];
        }
    };
}

test "Vec" {
    const VecU8 = Vec(u8, 1);
    const v = VecU8.init([1]u8{1});
    try expectEqual(v.item(0), 1);
}
