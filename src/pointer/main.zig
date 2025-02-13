const std = @import("std");
const print = std.debug.print;

/// people use pointers as an alternative way to access a particular value. And they use it especially when they do not want to
/// “move” these values around. There are situations where, you want to access a particular value in a different scope
/// (i.e. a different location) of your code, but you do not want to “move” this value to this new scope (or location) that you
/// are in.
/// This matters especially if this value is big in size. Because if it is, then, moving this value becomes an expensive operation
/// to do. The computer will have to spend a considerable amount of time copying this value to this new location.
///
/// In Zig, there are two types of pointers
/// 1. single-item pointer (*): pointing to single value whose data type is in the format *T e.g. *u32, *User etc
/// 2. many-item pointer ([*]): many-item pointers are objects whose data types are in the format [*]T
/// Many-item pointers are more of a “internal type” of the language, more closely related to slices.
/// So, when you deliberately create a pointer with the & operator, you always get a single-item pointer as result.
pub fn main() !void {
    // The pointer object contains the memory address where the value of the number object (the number 5) is store
    const number = 5;
    const pointer = &number;

    // dereference to access the value of a pointer
    const doubled = pointer.* * 2;
    print("doubled {}\n", .{doubled});

    // with variable pointers we can change the memory address pointed by this pointer object. T
    const c1: u8 = 10;
    const c2: u8 = 20;
    var var_pointer = &c1;
    print("c1 {}\n", .{var_pointer.*});
    var_pointer = &c2;
    print("c2 {}\n", .{var_pointer.*});

    // ##Pointer Arithemtic
    // Pointer arithmetic is available in Zig, and they work the same way they work in C.
    // When you have a pointer that points to an array, the pointer usually points to the first element in the array,
    // and you can use pointer arithmetic to advance this pointer and access the other elements in the array.
    //
    // Although you can create a pointer to an array like that, and start to walk through this array by using pointer arithmetic,
    // in Zig, we prefer to use slicesBehind the hood, slices already are pointers, and they also come with the len property,
    // which indicates how many elements are in the slice. This is good because the zig compiler can use it to check for
    // potential buffer overflows, and other problems like that.
    // Also, you don’t need to use pointer arithmetic to walk through the elements of a slice. You can simply use the
    // slice[index] syntax to directly access any element you want in the slice.
    const ar = [_]i32{ 1, 2, 3, 4 };
    var ptr: [*]const i32 = &ar; //many-item pointer

    print("First item {}\n", .{ptr[0]});
    ptr += 1;
    print("Second item {}\n", .{ptr[0]});
    ptr += 1;
    print("Third item {}\n", .{ptr[0]});

    // ##Optionals and Optional Pointers
    // - By default, objects in Zig are non-nullable. This means that, in Zig, you can safely assume that any object
    // in your source code is not null.

    // The compiler can see the null value at compile time, and, as result, it raises a compile time error.
    // But, if a null value is raised during runtime, a runtime error is also raised by the Zig program,
    // with a “attempt to use null value” message
    //
    // var n: u8 = 5;
    // n = null;

    // An optional object in Zig is an object that can be null. To mark an object as optional, we use the ? operator.
    // contains either a signed 32-bit integer (i32), or, a null value
    var num: ?i32 = 5;
    num = null;

    //t his object contains either a null value, or, a pointer that points to a value
    var np: i32 = 5;
    var np_ptr: ?*i32 = &np;
    np_ptr = null;
    np = 6;

    // But what happens if we turn the table, and mark the num object as optional, instead of the pointer object.
    // If we do that, then, the pointer object is not optional anymore.
    var nv: ?i32 = 5;
    // ptr have type `*?i32`, instead of `?*i32`.
    const nv_ptr = &nv;
    _ = nv_ptr;

    // When you have an optional object in your Zig code, you have to explicitly handle the possibility of this object being null
    // We can do that, by using either:
    // 1. an if statement, like you would do in C.
    // 2. the `orelse` keyword
    // 3. unwrap the optional value with the ? method

    // if the object num is null, then, the code inside the if statement is not executed.
    // Otherwise, the if statement will unwrap the object val_ptr into the val_ptr object
    var val: i32 = 5;
    var val_ptr: ?*i32 = &val;
    if (val_ptr) |value| {
        print("unwrapped value with if {}\n", .{value.*});
    }

    // using `orelse` is similar to `unwrap_or` in rust
    var x: ?i32 = 10;
    var unwraped_value = (x orelse 100);
    print("unwrapped value with orelse {}\n", .{unwraped_value});

    x = null;
    unwraped_value = (x orelse 100);
    print("unwrapped value with orelse {}\n", .{unwraped_value});

    const y: i32 = 100;
    const new_ptr = &y;
    var unwraped_value_ptr = (val_ptr orelse new_ptr);
    print("unwrapped ptr value with orelse {}\n", .{unwraped_value_ptr.*});

    val_ptr = null;
    unwraped_value_ptr = (val_ptr orelse new_ptr);
    print("unwrapped ptr value with orelse {}\n", .{unwraped_value_ptr.*});

    // when you use ? If a not-null value is found in the optional object, then, this not-null value is used.
    // Otherwise, the unreachable keyword is used.
    // when you build your Zig source code using the build modes ReleaseSafe or Debug, this unreacheable keyword causes
    // the program to panic and raise an error during runtime "panic: attempt to use null value"
    const valid_ptr: ?*const i32 = &y;
    print("unwrapped ptr with `?` {}\n", .{valid_ptr.?.*});
    print("unreachable is used so program panics in ReleaseSafe or Debug {}\n", .{val_ptr.?});
}
