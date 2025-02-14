// inline loops are unrolled, and allow some things to happen that only work at compile time. Here we use a for,
// but a while works similarly.
test "inline for" {
    const types = [_]type{ i32, f32, u8, bool };
    var sum: usize = 0;
    inline for (types) |T| sum += @sizeOf(T);
    try @import("std").testing.expect(sum == 10);
}
