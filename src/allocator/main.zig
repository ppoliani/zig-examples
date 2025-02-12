const std = @import("std");
const print = std.debug.print;

/// - All allocators, except FixedBufferAllocator() and ArenaAllocator(), are allocators that use the heap memory
pub fn main() !void {
    try general_purpose_allocator();
    try page_allocator();
    try buffer_allocator_stack();
    try buffer_allocator_heap();
    try arena_allocator();
}

/// You can use it for every type of task
fn general_purpose_allocator() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // allocate space in the heap for u32 number (4 bytes of memory)
    const some_number = try allocator.create(u32);
    defer allocator.destroy(some_number);

    some_number.* = 45;
    print("Some number {}\n", .{some_number.*});
}

/// The page_allocator() is an allocator that allocates full pages of memory in the heap.
/// In other words, every time you allocate memory with page_allocator(), a full page of memory in
/// the heap is allocated, instead of just a small piece of it.
///
/// page_allocator() is considered a fast, but also “wasteful” allocator in Zig. Because it allocates a
/// big amount of memory in each call, and you most likely will not need that much memory in your program.
fn page_allocator() !void {
    const allocator = std.heap.page_allocator;
    // Here, we allocate u32 but will likely reserve multiple kibibytes
    const some_number = try allocator.create(u32);
    defer allocator.destroy(some_number);

    some_number.* = 50;
    print("Some number {}\n", .{some_number.*});
}

/// work with a fixed sized buffer object at the back. In other words, they use a fixed sized buffer object
/// as the basis for the memory. When you ask these allocator objects to allocate some memory for you, they
/// are essentially reserving some amount of space inside this fixed sized buffer object for you to use.
///
/// In order to use these allocators, you must first create a buffer object in your code, and then, give this
/// buffer object as an input to these allocators.
///
/// Can allocate memory both in the stack or in the heap. Everything depends on where the buffer object that you provide lives.
fn buffer_allocator_stack() !void {
    // buffer object on the stack that is 10 elements long
    var buffer: [10]u8 = undefined;
    // initialize to 0
    for (0..buffer.len) |i| {
        buffer[i] = 0;
    }

    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const input = try allocator.alloc(u8, 5);
    defer allocator.free(input);

    input[0] = 10;
    print("Input[0] {}\n", .{input[0]});

    const some_number = try allocator.create(u8);
    defer allocator.destroy(some_number);
    some_number.* = 60;
    print("Some number {}\n", .{some_number.*});

    // this will fail since we don't have space for 11 u8 iteams in that buffer
    // const input_2 = try allocator.alloc(u8, 11);
    // defer allocator.free(input_2);
}

fn buffer_allocator_heap() !void {
    const pa = std.heap.page_allocator;
    // buffer object on the heap that is 100 MB is space which cannot be stored on the stack
    const heap_buffer = try pa.alloc(u8, 100 * 1024 * 1024);
    defer pa.free(heap_buffer);

    var fba = std.heap.FixedBufferAllocator.init(heap_buffer);
    const allocator = fba.allocator();
    const input = try allocator.alloc(u8, 1000);

    input[0] = 10;
    print("Input[0] {}\n", .{input[0]});

    // you could use the general_purpose_allocator as well to allocate the initial buffer
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa_allocator = gpa.allocator();
    const heap_buffer_2 = try gpa_allocator.alloc(u8, 100 * 1024 * 1024);
    defer gpa_allocator.free(heap_buffer_2);

    var fba_2 = std.heap.FixedBufferAllocator.init(heap_buffer_2);
    const allocator_2 = fba_2.allocator();
    const input_2 = try allocator_2.alloc(u8, 1000);
    input_2[0] = 10;
    print("input_2[0] {}\n", .{input_2[0]});
}

/// The ArenaAllocator() is an allocator object that takes a child allocator as input. The idea behind the ArenaAllocator()
/// in Zig is similar to the concept of “arenas” in the programming language Go5. It is an allocator object that allows you
/// to allocate memory as many times you want, but free all memory only once. In other words, if you have, for example, called
/// 5 times the method alloc() of an ArenaAllocator() object, you can free all the memory you allocated over these 5 calls at
/// once, by simply calling the deinit() method of the same ArenaAllocator() object.
fn arena_allocator() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var aa = std.heap.ArenaAllocator.init(gpa.allocator());
    defer aa.deinit();
    const allocator = aa.allocator();

    // we allocate three different objects but we don't have to deallocate one by one i.e. defer aa.free(in_1)
    // we can simply deallocate all memory allocated by gpa all at once `defer aa.deinit();`
    const in_1 = try allocator.alloc(u8, 5);
    const in_2 = try allocator.alloc(u8, 10);
    const in_3 = try allocator.alloc(u8, 15);

    // ignore the values
    _ = in_1;
    _ = in_2;
    _ = in_3;
}
