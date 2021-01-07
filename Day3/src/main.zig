const std = @import("std");
const print = std.debug.print;

pub fn main() anyerror!void {
    const terrains = @embedFile("day03.terrain.txt");
    try part1(terrains);
    // try part2();
}

pub fn part1(terrains: []const u8) !void {
    // print("terrain[11]{}\n", .{terrains[11]});
    // print("terrain[12]{}\n", .{terrains[12]});
    // print("terrain[13]{}\n", .{terrains[13]});
    // print("terrain[17]{}\n", .{terrains[17]});
    const slopes = .{
        .{ 1, 1 },
        .{ 3, 1 },
        .{ 5, 1 },
        .{ 7, 1 },
        .{ 1, 2 },
    };

    var grand_total: usize = 1;

    for (slopes) |slope| {
        var found: usize = 0;

        const height = count_height(terrains);
        const width = count_width(terrains);

        var y: usize = 0;
        var x: usize = 0;
        var pos: usize = 0;

        while (y < height) {
            if (terrains[pos] == '#') {
                found += 1;
            }

            x += slope[0];
            x %= width;
            y += slope[1];
            pos = y * (width + 2) + x; //plus 2 cause on windows newline is represent as \r\n
        }

        grand_total *= found;
    }

    print("Grand Total: {}", .{grand_total});
}

pub fn part2() !void {}

fn count_height(terrains: []const u8) usize {
    var height: usize = 0;

    for (terrains) |terrain| {
        if (terrain == '\n') {
            height += 1;
        }
    }

    return height + 1;
}

fn count_width(terrains: []const u8) usize {
    for (terrains) |terrain, id| {
        if (terrain == '\n') {
            return id - 1;
        }
    }

    @panic("\\n is not found");
}
