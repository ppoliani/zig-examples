const std = @import("std");
const print = std.debug.print;

/// There are two types of string:
/// 1. String literals: A string literal value is just a pointer to a null-terminated array of byte
/// also embeds the length of the string into the data type.
///  Therefore, a string literal value have a data type in the format `*const [n:0]u8`. The n in the data type
/// indicates the size of the string.
///
/// 2. String object: a slice to an arbitrary sequence of bytes, or, in other words, a slice of u8 values
/// Thus, a string object have a data type of `[]u8` or `[]const u8`
///
/// Zig always assumes that the sequence of bytes in your string is UTF-8 encoded.
pub fn main() void {
    const str_literal = "This is a string literal value";
    const string: []const u8 = "A string object";

    print("TypeOf `str_literal` {any}\n", .{@TypeOf(str_literal)});
    print("string literal {s}\n", .{str_literal});

    print("TypeOf string obj {any}\n", .{@TypeOf(string)});
    print("string object {s}\n", .{string});
}
