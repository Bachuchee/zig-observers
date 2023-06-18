const std = @import("std");
const Allocator = std.mem.Allocator;

// The class for the Source, what is called an observable or a provider in other languages
pub fn Source(comptime T: type) type {
    return struct {
        val: T,
        alloc: Allocator,

        fn init(allocator: Allocator, value: T) @This() {
            return @This(){
                .val = value,
                .alloc = allocator,
            };
        }
    };
}

test "creating-Source" {
    const IntSource = Source(i32);

    var value: i32 = 24;

    var mySource = IntSource.init(std.testing.allocator, value);

    try std.testing.expectEqual(value, mySource.val);
}
