pub fn WrapData(comptime D: type) type {
    const ContextData = struct {
        const Self = @This();
        ptr: *anyopaque,
        getFn: *const fn (ptr: *anyopaque) anyerror!D,

        fn init(ptr: anytype) Self {
            const T = @TypeOf(ptr);
            const ptr_info = @typeInfo(T);

            const gen = struct {
                pub fn get(pointer: *anyopaque) anyerror!D {
                    const self: T = @ptrCast(@alignCast(pointer));
                    return ptr_info.pointer.child.get(self);
                }
            };

            return .{ .ptr = ptr, .getFn = gen.get };
        }

        pub fn get(self: Self) anyerror!D {
            return self.getFn(self.ptr);
        }
    };

    return ContextData;
}

test "implement contextdata" {
    const std = @import("std");
    const expectEqual = std.testing.expectEqual;

    const Data = struct {
        field: u8,
    };

    const ContextData = WrapData(Data);
    const Implementor = struct {
        const Self = @This();
        data: Data,

        pub fn get(self: *Self) Data {
            return self.data;
        }

        pub fn contextData(self: *Self) ContextData {
            return ContextData.init(self);
        }
    };

    const d = Data{ .field = 10 };
    var data_implementor = Implementor{ .data = d };
    const context_data = data_implementor.contextData();
    const data = try context_data.get();

    try expectEqual(data.field, 10);
}
