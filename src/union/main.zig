const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

// Zig's unions allow you to define types that store one value of many possible typed fields;

// only one field may be active at one time.

const Number = union {
    int: i64,
    float: f64,
    nan: void,
};

// Tagged unions are unions that use an enum to detect which field is active.
const Timestamp = union(enum) {
    unix: i32,
    datetime: DateTime,

    const DateTime = struct {
        year: u16,
        month: u8,
        day: u8,
        hour: u8,
        minute: u8,
        second: u8,
    };

    // here we use the `payload capturing`
    fn seconds(self: Timestamp) u16 {
        switch (self) {
            .datetime => |dt| return dt.second,
            .unix => |ts| {
                const seconds_since_midnight: i32 = @rem(ts, 86400);
                return @intCast(@rem(seconds_since_midnight, 60));
            },
        }
    }

    // here we use the `pointer capturing`. This allows us to use dereferencing to mutate the original value.
    fn increment_by_10_seconds(self: Timestamp) u16 {
        switch (self) {
            .datetime => |*dt| {
                dt.*.seconds += 10;
            },
            .unix => |*ts| {
                ts.* += 10;
            },
        }
    }
};

pub fn main() void {
    const n = Number{ .int = 32 };
    std.debug.print("{d}\n", .{n.int});

    // Accessing a field in a union that is not active is detectable illegal behaviour.
    // `error: access of union field 'float' while field 'int' is active`
    // n.float = 12.34;
}

test "tagged union" {
    var t = Timestamp{ .datetime = Timestamp.DateTime{
        .year = 2025,
        .month = 2,
        .day = 15,
        .hour = 12,
        .minute = 30,
        .second = 10,
    } };

    try expect(t.seconds() == 10);

    t = Timestamp{ .unix = 1693278411 };
    try expectEqual(t.seconds(), 51);
}
