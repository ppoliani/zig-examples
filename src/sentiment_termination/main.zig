const std = @import("std");
const expect = std.testing.expect;

// Arrays, slices and many pointers may be terminated by a value of their child type. This is known as sentinel termination.
// These follow the syntax [N:t]T, [:t]T, and [*:t]T, where t is a value of the child type T.
test "sentinel termination" {
    const terminated = [3:0]u8{ 3, 2, 1 };
    try expect(terminated.len == 3);
    //  The built-in @ptrCast is used to perform an unsafe type conversion. This shows us that the last
    // element of the array is followed by a 0 byte.
    try expect(@as(*const [4]u8, @ptrCast(&terminated))[3] == 0);
}

// The types of string literals is *const [N:0]u8, where N is the length of the string.
test "string literal" {
    try expect(@TypeOf("hello") == *const [5:0]u8);
}

// [*:0]u8 and [*:0]const u8 perfectly model C's strings.
test "C string" {
    const c_string: [*:0]const u8 = "hello";
    var array: [5]u8 = undefined;

    var i: usize = 0;
    while (c_string[i] != 0) : (i += 1) {
        array[i] = c_string[i];
    }
}
