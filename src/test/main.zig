const std = @import("std");
const expect = std.testing.expect;

fn main() void {}

fn add(x: u32, y: u32) u32 {
    return x + y;
}

test "should add two value" {
    const result = add(1, 1);
    try expect(result == 2);
}

const expectError = std.testing.expectError;
fn alloc_error(allocator: std.mem.Allocator) !void {
    const buffer = try allocator.alloc(u8, 100);
    defer allocator.free(buffer);
    buffer[0] = 1;
}

test "OutOfMemory error" {
    // the buffer is 10 bytes long by in alloc_error we try to allocate 100 bytes memory
    var buffer: [10]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    try expectError(error.OutOfMemory, alloc_error(fba.allocator()));
}

// std.testing.allocator offers some basic memory safety detection features, which are capable of detecting memory leaks.
fn cause_memeory_leak(allocator: std.mem.Allocator) !void {
    const buffer = try allocator.alloc(u8, 100);
    // Return without freeing the allocated memory i.e `defer allocator.free(buffer);`
    _ = buffer;
}

test "memory leak" {
    try cause_memeory_leak(std.testing.allocator);
}
