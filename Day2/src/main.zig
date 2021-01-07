const std = @import("std");
const print = std.debug.print;

const file = @embedFile("day02.txt");

pub fn main() anyerror!void {
    // try part1();
    try part2();
}

pub fn part1() !void {
    var it = std.mem.split(file, "\n");
    var found: usize = 0;

    while (it.next()) |line| {
        var it2 = std.mem.split(line, ":");
        const policy = std.mem.trim(u8, it2.next().?, " ");
        const password = std.mem.trim(u8, it2.next().?, " ");

        var it3 = std.mem.split(policy, " ");
        const min_max = std.mem.trim(u8, it3.next().?, " ");
        const char = std.mem.trim(u8, it3.next().?, " ")[0];

        var it4 = std.mem.split(min_max, "-");
        var min = try std.fmt.parseInt(u8, it4.next().?, 10);
        var max = try std.fmt.parseInt(u8, it4.next().?, 10);

        // print("Policy: {}, password: {}\n", .{ policy, password });
        // print("{}, {}, min: {}, max: {}\n", .{ min_max, char, min, max });

        var count: usize = 0;

        for (password) |ch| {
            if (ch == char) {
                count += 1;
            }
        }

        if (count >= min and count <= max) {
            found += 1;
        }
    }

    print("Found {} matches policy", .{found});
}

pub fn part2() !void {
    var it = std.mem.split(file, "\n");
    var found: usize = 0;

    while (it.next()) |line| {
        var it2 = std.mem.split(line, ":");
        const policy = std.mem.trim(u8, it2.next().?, " ");
        const password = std.mem.trim(u8, it2.next().?, " ");

        var it3 = std.mem.split(policy, " ");
        const min_max = std.mem.trim(u8, it3.next().?, " ");
        const char = std.mem.trim(u8, it3.next().?, " ")[0];

        var it4 = std.mem.split(min_max, "-");
        var pos1 = try std.fmt.parseInt(u8, it4.next().?, 10);
        var pos2 = try std.fmt.parseInt(u8, it4.next().?, 10);

        // print("Policy: {}, password: {}\n", .{ policy, password });
        // print("{}, {}, min: {}, max: {}\n", .{ min_max, char, min, max });

        var count: usize = 0;

        for (password) |ch, id| {
            if (ch == char and (id + 1 == pos1 or id + 1 == pos2)) {
                count += 1;
            }
        }

        if (count == 1) {
            found += 1;
        }
    }

    print("Found {} matches policy", .{found});
}
