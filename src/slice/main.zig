const std = @import("std");
const print = std.debug.print;

/// A slice object is essentially a pointer object accompanied by a length number i.e. fat pointer in Rust.
/// The pointer object points to the first element in the slice, and the length number tells the
/// zig compiler how many elements there are in this slice.
/// Slices can be thought of as a pair of [*]T (the pointer to the data) and a usize (the element count)
pub fn main() void {
    const a = [_]u8{ 0, 1, 2, 3, 4, 5, 6, 7 };
    const slice_1 = a[0..2];
    print("slice 0..2 {any}\n", .{slice_1});

    const slice_2 = a[2..];
    print("slice 2.. {any}\n", .{slice_2});
    print("First item slice_2 len {}\n", .{slice_2[0]});
    print("slice_2 len {}\n", .{slice_2.len});

    // if the range of indexes is not known at compile time, then, the slice object that get’s created is not
    // a pointer anymore, and, thus, it does not support pointer operations.
    const right_boundary = 3;
    const slice_3 = a[0..right_boundary];
    print("slice 0..right_boundary {any}\n", .{slice_3});
}
