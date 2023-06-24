const std = @import("std");
const source = @import("source.zig");

pub fn Observer(comptime T: type) type {
    return struct {
        onNotify: *const fn (@This(), T) void,
        source: *source.Source(T),

        pub fn notify(self: @This(), newVal: T) void {
            self.onNotify(self, newVal);
        }
    };
}
