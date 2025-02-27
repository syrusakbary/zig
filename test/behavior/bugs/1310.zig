const std = @import("std");
const expect = std.testing.expect;
const builtin = @import("builtin");

pub const VM = ?[*]const struct_InvocationTable_;
pub const struct_InvocationTable_ = extern struct {
    GetVM: ?fn (?[*]VM) callconv(.C) c_int,
};

pub const struct_VM_ = extern struct {
    functions: ?[*]const struct_InvocationTable_,
};

//excised output from stdlib.h etc

pub const InvocationTable_ = struct_InvocationTable_;
pub const VM_ = struct_VM_;

fn agent_callback(_vm: [*]VM, options: [*]u8) callconv(.C) i32 {
    _ = _vm;
    _ = options;
    return 11;
}

test "fixed" {
    if (builtin.zig_backend == .stage2_arm) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_x86_64) return error.SkipZigTest;
    try expect(agent_callback(undefined, undefined) == 11);
}
