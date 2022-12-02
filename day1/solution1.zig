const std = @import("std");
const mem = std.mem;

pub fn main() !void {
    const input = @embedFile("input");
    var lines = mem.split(u8, input, "\n");
    var most_calories: u32 = 0;
    var current_calories: u32 = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            if (current_calories > most_calories)
                most_calories = current_calories;
            current_calories = 0;
        } else {
            const calories = try std.fmt.parseInt(u32, line, 10);
            current_calories += calories;
        }
    }
    try std.io.getStdOut().writer().print("{}\n", .{most_calories});
}
