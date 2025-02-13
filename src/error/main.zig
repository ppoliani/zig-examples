const std = @import("std");
pub fn main() !void {
    _ = catch_example() catch 0;
    _ = handle_error_with_if_statement() catch 0;
}

/// returns void (i.e. nothing) or an error
fn print_name() !void {}

/// specify clearly which exact error values might be returned from this function.
pub fn fill() error.ReadError!void {}

/// you can list all of these different types of errors that can be returned from this function,
/// through a structure in Zig that we call of an error set.
///
/// An error set is a special case of an union type.
/// an union is just a set of data types. Unions are used to allow an object to have multiple data types.
/// For example, a union of x, y and z, means that an object can be either of type x, or type y or type z.
pub fn resolve_path() error{
    OutOfMemory,
    Unexpected,
}![]u8 {}

/// Similar to previous but we create a specific Union type for the error set
const ReadError = error{
    OutOfMemory,
    Unexpected,
};

pub fn resolve_path_2() ReadError![]u8 {}

/// The example below demonstrates this idea. Because A contains all values from B, A is a superset of B.
const A = error{
    ConnectionTimeoutError,
    DatabaseNotFound,
    OutOfMemory,
    InvalidToken,
};
const B = error{
    OutOfMemory,
};

test "coerce error value" {
    // Error sets coerce to their supersets.
    const error_value = B.OutOfMemory;
    try std.testing.expect(error_value == A.OutOfMemory);
}

// ## How to handle errors
//
// let’s discuss the available strategies to handle these errors, which are:
// 1. try keyword;
// 2. catch keyword;
// 3. an if statement;
// 4. errdefer keyword;
//

// ### try
// when you use the try keyword in an expression, you are telling the zig compiler the following:
// “Hey! Execute this expression for me, and, if this expression return an error, please, return this error for
// me and stop the execution of my program. But if this expression return a valid value, then, return this value, and move on”.

// ### catch
// - you cannot use try and catch together.
// - With catch, we can construct a block of logic to handle the error value, in case it happens in the current expression
// instead of just stopping the execution right away.
fn catch_example() !std.fs.File {
    const dir = std.fs.cwd();
    const file_result = dir.openFile("doesnt_exist.txt", .{}) catch |err| {
        std.debug.print("Error {any}\n", .{err});
        return err;
    };

    return file_result;
}

// Although this being the most common use of catch, you can also use this keyword to handle the error in a “default value” style.
// That is, if the expression returns an error, we use the default value instead. Otherwise, we use the valid value returned by
// the expression.
test "default value" {
    // similar to uwrap_or
    var value = std.fmt.parseInt(u32, "10", 10) catch 0;
    try std.testing.expect(value == 10);

    value = std.fmt.parseInt(u32, "sdfds", 10) catch 0;
    try std.testing.expect(value == 0);
}

// ### If statement
fn handle_error_with_if_statement() !u32 {
    // handle based on error type
    if (std.fmt.parseInt(u32, "asfdf", 10)) |number| {
        return number;
    } else |err| switch (err) {
        error.InvalidCharacter => {
            std.debug.print("InvalidCharacter {any}\n", .{err});
            return err;
        },
        else => {
            std.debug.print("Unknown error {any}\n", .{err});
            return err;
        },
    }

    if (std.fmt.parseInt(u32, "10", 10)) |number| {
        return number;
    } else |err| {
        return err;
    }
}

// ### errdefer statement
//
// In more details, the expression given to errdefer is executed only when an error occurs in the current scope.
// As contract to defer which is an “unconditional defer”, because the given expression get’s executed regardless of
// how the function foo() exits its own scope.
//
// This becomes important if a resource that you allocate in the current scope get’s freed later in your code,
// in a different scope.

/// For exampl if an error does not occur inside this function, the user object is returned from the function
/// so we don't want to destroy the memory which would be the case if we did `defer allocator.destroy(user);`
/// we only want to de-allocate when there is an error to avoid memory leak.
const User = struct {};
fn create_user(db: type, allocator: std.mem.Allocator) !User {
    const user = try allocator.create(User);
    errdefer allocator.destroy(user);

    // Register new user in the Database.
    _ = try db.register_user(user);
    return user;
}
