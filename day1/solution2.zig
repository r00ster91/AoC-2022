const std = @import("std");
const mem = std.mem;

pub fn main() !void {
    const input = @embedFile("input");
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var calories_list = std.ArrayList(u32).init(gpa.allocator());
    calories_list.deinit();
    var lines = mem.split(u8, input, "\n");
    var current_calories: u32 = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            try calories_list.append(current_calories);
            current_calories = 0;
        } else {
            const calories = try std.fmt.parseInt(u32, line, 10);
            current_calories += calories;
        }
    }

    var top_three: [3]u32 = undefined;
    for (top_three) |*result| {
        var top: u32 = 0;
        var top_index: usize = 0;
        for (calories_list.items) |calories, index| {
            if (calories > top) {
                top = calories;
                top_index = index;
            }
        }
        _ = calories_list.swapRemove(top_index);
        result.* = top;
    }
    try std.io.getStdOut().writer().print("{}\n", .{top_three[0] + top_three[1] + top_three[2]});
}
