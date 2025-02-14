const std = @import("std");
const print = std.debug.print;

// There are three ways in which you can apply the comptime keyword, which are:
// 1. comptime on a function argument.
// 2. comptime on an object.
// 3. comptime on a block of expressions.

// ## Applying comptime over function argument
//
// When you apply the comptime keyword on a function argument, you are saying to the zig compiler that the
// value assigned to that particular function argument must be known at compile-time.
fn fn_comptime() void {
    // this compiles because the num parameter is known at compile-time and it's 32
    _ = double(32);
    // however the following will fail
    var val: u32 = undefined;
    if (true) {
        val = 10;
    } else {
        val = 30;
    }
    // runtime-known argument passed to comptime parameter
    // _ = double(val);
}

fn double(comptime num: u32) u32 {
    return num * 2;
}

// This type keyword is basically saying to the zig compiler that this function will return some data type as output,
// but it doesn’t know yet what exactly data type that is.
fn intArray(comptime length: usize, comptime T: type) type {
    return [length]T;
}

test "intArray type" {
    try expectEqual(intArray(10, i64), [10]i64);

    var arr: intArray(10, i64) = undefined;
    arr[0] = 10;
    try expectEqual(arr[0], 10);
}

// Similar to previous but we create a custom struct type using reflection
fn CreateVec(comptime T: type, comptime count: comptime_int) type {
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
    const Vec = CreateVec(u8, 1);
    const v = Vec.init([1]u8{1});
    try expectEqual(v.item(0), 1);
}

// We can reflect upon types using the built-in @typeInfo,
fn addSmallInts(comptime T: type, a: T, b: T) T {
    return switch (@typeInfo(T)) {
        .ComptimeInt => a + b,
        .Int => |info| {
            if (info.bits <= 16) {
                return a + b;
            } else {
                @compileError("ints too large");
            }
        },
        else => @compileError("only ints accepted"),
    };
}

test "typeinfo switch" {
    const x = addSmallInts(u16, 20, 30);
    try expectEqual(@TypeOf(x), u16);
    try expectEqual(x, 50);
}

// We can use the @Type function to create a type from a @typeInfo. @Type is implemented for most types but is
// notably unimplemented for enums, unions, functions, and structs.
fn GetBiggerInt(comptime T: type) type {
    return @Type(.{ .Int = .{
        .bits = @typeInfo(T).Int.bits + 1,
        .signedness = @typeInfo(T).Int.signedness,
    } });
}

test "@Type" {
    try expectEqual(GetBiggerInt(u8), u9);
    try expectEqual(GetBiggerInt(i31), i32);
}

// The types of function parameters can also be inferred by using anytype in place of a type.
// @TypeOf can then be used on the parameter.
fn plusOne(x: anytype) @TypeOf(x) {
    return x + 1;
}

test "inferred function parameter" {
    try expectEqual(plusOne(@as(u32, 1)), 2);
}

// ## Applying Comptime over expression
//
// When you apply the comptime keyword over an expression, then, it is guaranteed that the zig compiler will
// execute this expression at compile-time.
//
// We are executing the same fibonacci() function both at runtime, and, at compile-time. The function is by default
// executed at runtime, but because we use the comptime keyword at the second “try expression”, this expression is
// executed at compile-time.
const expectEqual = std.testing.expectEqual;
fn fibonacci(index: u32) u32 {
    if (index < 2) return index;
    return fibonacci(index - 1) + fibonacci(index - 2);
}

test "fibonacci" {
    // test fibonacci at run-time
    try expectEqual(fibonacci(7), 13);
    // test fibonacci at compile-time
    // this expression is compiled and executed while the zig compiler is compiling your Zig source code.
    try comptime expectEqual(fibonacci(7), 13);
}

// ## Apllying comptime over block
//
//  When you apply the comptime keyword over a block of expressions, you get essentially the same effect when you apply
// this keyword to a single expression
test "fibonacci block comptime" {
    // block executed at compile-time which then assigns a value to x variable
    const x = comptime blk: {
        const n1 = 5;
        const n2 = 2;
        const n3 = n1 + n2;
        try expectEqual(fibonacci(n3), 13);
        break :blk n3;
    };

    _ = x;
}

pub fn main() void {
    fn_comptime();
}
