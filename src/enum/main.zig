const std = @import("std");
const expect = std.testing.expect;

// Zig's enums allow you to define types with a restricted set of named values.
const Direction = enum { north, south, east, west };

// Enums types may have specified (integer) tag types.
const Value = enum(u2) { zero, one, two };

// Enum's ordinal values start at 0. They can be accessed with the built-in function @intFromEnum.
test "enum ordinal value" {
    try expect(@intFromEnum(Value.zero) == 0);
    try expect(@intFromEnum(Value.one) == 1);
    try expect(@intFromEnum(Value.two) == 2);
}

// Values can be overridden, with the next values continuing from there.
const Value2 = enum(u32) {
    hundred = 100,
    thousand = 1000,
    next,
};

test "enum ordinal value with start point" {
    try expect(@intFromEnum(Value2.hundred) == 100);
    try expect(@intFromEnum(Value2.thousand) == 1000);
    try expect(@intFromEnum(Value2.next) == 1001);
}

// Enums can have namespaced global state and methods
const Mode = enum {
    var count: u32 = 0;
    on,
    off,

    fn increment() void {
        Mode.count += 1;
        // however we can't access the state via self.count
    }

    fn is_on(self: Mode) bool {
        return self == Mode.on;
    }
};

test "hmm" {
    Mode.increment();
    const mode = Mode.on;

    try expect(Mode.count == 1);
    try expect(mode.is_on());
}
