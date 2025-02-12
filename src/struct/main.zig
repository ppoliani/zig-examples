const std = @import("std");
const print = std.debug.print;

const User = struct {
    id: u64,
    name: []const u8,
    email: []const u8,

    pub fn init(
        id: u64,
        name: []const u8,
        email: []const u8,
    ) User {
        return User{
            .id = id,
            .name = name,
            .email = email,
        };
    }

    pub fn print(self: User) void {
        std.debug.print("User: {any}\n", .{self});
    }

    pub fn print_name(self: User) void {
        std.debug.print("Name: {s}\n", .{self.name});
    }

    pub fn set_name(self: *User, name: []const u8) void {
        self.name = name;
    }
};

pub fn main() void {
    var user = User.init(0, "Pavlos", "pavlos@email.com");
    user.print_name();
    // if we used `const user = ...` then this would fail because in that case the pointer would be *const User
    user.set_name("New name");
    user.print_name();

    // Anonymous struct literals
    // Anonymous structs are very commonly used as inputs to function arguments in Zig.
    const anon = .{ .name = "anonymous" };
    print("Anon name: {s}\n", .{anon.name});

    // when you put a dot before a struct literal, the type of this struct
    // literal is automatically inferred by the zig compiler.
    const infered_user = .{
        .id = 2,
        .name = "Nick",
        .email = "nick@email.com",
    };
    print("Type of infered_user: {}\n", .{@TypeOf(infered_user)});
    @as(User, infered_user).print_name();
    // but `infered_user.print_name();` doesn't work
}
