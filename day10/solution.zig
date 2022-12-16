const std = @import("std");
const mem = std.mem;

const CPU = struct {
    register_x: i32 = 1,
    cycle: u32 = 0,
    acc: i32 = 0,
    signal_strengths: [6]?i32 = [_]?i32{null} ** 6,

    fn getSignalStrength(cpu: CPU) i32 {
        return @intCast(i32, cpu.cycle) * cpu.register_x;
    }

    fn recordSignalStrength(cpu: *CPU) void {
        const order = [_]i32{ 20, 60, 100, 140, 180, 220 };
        for (order) |cycle, index| {
            if (cpu.cycle == cycle) {
                std.debug.print("{}\n", .{index});
                if (cpu.signal_strengths[index] == null)
                    cpu.signal_strengths[index] = cpu.getSignalStrength();
            }
        }
    }

    fn exec(cpu: *CPU, program: []const u8) void {
        var lines = mem.split(u8, program, "\n");
        while (lines.next()) |line| {
            std.debug.print("CYCLE #{d}\n", .{cpu.cycle + 1});
            std.debug.print("before executing `{s}`: X: {}, cycle: {}, signal strength: {d}\n", .{ line, cpu.register_x, cpu.cycle, cpu.getSignalStrength() });
            defer std.debug.print("after executing `{s}`: X: {}, cycle: {}, signal strength: {d}\n\n", .{ line, cpu.register_x, cpu.cycle, cpu.getSignalStrength() });
            cpu.register_x += cpu.acc;
            cpu.acc = 0;
            var words = mem.split(u8, line, " ");
            const instr = words.next().?;
            const operand = words.next();
            cpu.recordSignalStrength();
            if (mem.eql(u8, instr, "noop")) {
                // do nothing
            } else if (mem.eql(u8, instr, "addx")) {
                cpu.recordSignalStrength();
                cpu.cycle += 1;
                std.debug.print("after `addx` cycle: X: {}, cycle: {}, signal strength: {d}\n", .{ cpu.register_x, cpu.cycle, cpu.getSignalStrength() });
                cpu.acc += std.fmt.parseInt(i32, operand.?, 10) catch unreachable;
            }
            cpu.recordSignalStrength();
            cpu.cycle += 1;
        }
    }
};

pub fn main() void {
    var cpu = CPU{};
    const input = @embedFile("input");
    cpu.exec(input);
    std.debug.print("signal strengths: {any}\n", .{cpu.signal_strengths});
    var signal_strengths_sum: i32 = 0;
    for (cpu.signal_strengths) |signal_strength|
        signal_strengths_sum += signal_strength.?;
    std.debug.print("signal_strengths_sum: {d}\n", .{signal_strengths_sum});
}
