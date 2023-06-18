const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const observer = @import("observer.zig");

// The class for the Source, what is called an observable or a provider in other languages
pub fn Source(comptime T: type) type {
    const TypeObserver = observer.Observer(T);

    return struct {
        val: T,
        alloc: Allocator,
        observers: ArrayList(TypeObserver),

        fn init(allocator: Allocator, value: T) @This() {
            return @This(){
                .val = value,
                .alloc = allocator,
                .observers = ArrayList(TypeObserver).init(allocator),
            };
        }

        fn deinit(self: @This()) void {
            self.observers.deinit();
        }

        fn addObserver(self: *@This(), onNotify: *const fn (T) void) !*TypeObserver {
            var newObserver = try self.observers.addOne();

            newObserver.*.notify = onNotify;

            return newObserver;
        }

        fn notify(self: @This()) void {
            for (self.observers.items) |item| {
                item.notify(self.val);
            }
        }
    };
}

// function for testing
fn myOnNotify(newVal: i32) void {
    std.debug.print("Value changed: {}", .{newVal});
}

test "creating-Source" {
    const IntSource = Source(i32);

    var value: i32 = 24;

    var mySource = IntSource.init(std.testing.allocator, value);

    try std.testing.expectEqual(value, mySource.val);
}

test "creating-observer" {
    const IntSource = Source(i32);

    var mySource = IntSource.init(std.testing.allocator, 24);
    defer mySource.deinit();

    _ = try mySource.addObserver(myOnNotify);

    mySource.notify();
}
