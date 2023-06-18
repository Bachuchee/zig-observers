const std = @import("std");

pub fn Observer(comptime T: type) type {
    const onNotifyFn = *const fn (T) void;
    return struct {
        notify: onNotifyFn,
    };
}
