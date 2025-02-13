const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    // fixed length array (setting length explicitly)
    const a = [8]u8{ 1, 2, 3, 4, 5, 6, 7, 8 };
    // fixed length array: compiler will infer the len
    const b = [_]f64{ 1, 2, 3 };
    // define an array using "anonymous list literal" .{1, 2, 3}
    // the compiler will coerce to the array type defined on the left-hand side
    const c: [3]f64 = .{ 4, 5, 6 };

    print("TypeOf `a` {any}\n", .{@TypeOf(a)});
    print("Array `a` {any}\n", .{a});

    const first_b = b[0];
    print("TypeOf `b` {any}\n", .{@TypeOf(b)});
    print("First element of `b` {}\n", .{first_b});
    print("C length element of `b` {}\n", .{c.len});

    print("TypeOf `c` {any}\n", .{@TypeOf(c)});

    const repeat_b = b ** 2;
    print("TypeOf `repeat_b` {any}\n", .{@TypeOf(repeat_b)});
    print("Repeat `b` two times {any}\n", .{repeat_b});

    const b_and_c = b ++ c;
    print("TypeOf `b_and_c` {any}\n", .{@TypeOf(b_and_c)});
    print("Concat `b` with `c` {any}\n", .{b_and_c});

    // iterate though array a
    for (a) |elem| {
        print("{}\n", .{elem});
    }

    // enumerate
    for (0.., a) |i, elem| {
        print("[{}] -> {}\n", .{ i, elem });
    }
}
