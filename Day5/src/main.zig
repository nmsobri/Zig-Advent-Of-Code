const std = @import("std");
const print = std.debug.print;

const input_file = @embedFile("input01.txt");

pub fn main() anyerror!void {
    // try part1();
    // try part1a();
    try part2();
}

fn part1() !void {
    var it = std.mem.split(input_file, "\r\n");
    var max_seat_number: usize = 0;

    while (it.next()) |boarding_pass| {
        const row = boarding_pass[0..7];
        const col = boarding_pass[7..];

        const row_number = binary_search(128, row, 'F', 'B');
        const col_number = binary_search(8, col, 'L', 'R');
        const seat_number = (row_number * 8) + col_number;

        if (seat_number > max_seat_number) {
            max_seat_number = seat_number;
        }
    }

    print("{}\n", .{max_seat_number});
}

fn part1a() !void {
    var it = std.mem.split(input_file, "\r\n");
    var max_seat_number: usize = 0;

    while (it.next()) |passport| {
        const rows = passport[0..7];
        const columns = passport[7..];

        var row: [7]u8 = undefined;
        var column: [3]u8 = undefined;

        for (row) |*r, i| {
            r.* = switch (rows[i]) {
                'F' => '0',
                'B' => '1',
                else => unreachable,
            };
        }

        for (column) |*c, i| {
            c.* = switch (columns[i]) {
                'R' => '1',
                'L' => '0',
                else => unreachable,
            };
        }

        var row_number = try std.fmt.parseInt(u10, row[0..], 2);
        var column_number = try std.fmt.parseInt(u10, column[0..], 2);

        // print("{}", .{row});
        // print(": {}", .{column});
        // print(": {}", .{row_number});
        // print(": {}\n", .{column_number});

        var current_seat_number = row_number * 8 + column_number;
        print("{}\n", .{current_seat_number});

        if (current_seat_number > max_seat_number) {
            max_seat_number = current_seat_number;
        }
    }

    print("Max seat number id: {}", .{max_seat_number});
}

fn part2() !void {
    var buffer: [1000]u16 = [_]u16{0} ** 1000;
    var it = std.mem.split(input_file, "\r\n");
    var counter: usize = 0;

    while (it.next()) |boarding_passport| : (counter += 1) {
        const row = boarding_passport[0..7];
        const col = boarding_passport[7..];

        const row_num = binary_search(128, row, 'F', 'B');
        const col_num = binary_search(8, col, 'L', 'R');
        const seat_number = (row_num * 8) + col_num;

        buffer[counter] = seat_number;
    }

    std.sort.sort(u16, &buffer, {}, comptime std.sort.asc(u16));

    var prev = buffer[0];
    const my_seat = for (buffer[1..]) |e| {
        if (e - prev == 2) {
            break e - 1;
        }
        prev = e;
    } else {
        unreachable;
    };

    print("My seat number: {}\n", .{my_seat});
}

fn binary_search(max: u16, buff: []const u8, comptime low: u8, comptime high: u8) u16 {
    var lo: u16 = 0;
    var hi: u16 = max;
    var mid: u16 = hi;

    for (buff) |r| {
        mid = mid / 2;
        switch (r) {
            low => hi = hi - mid,
            high => lo = lo + mid,
            else => unreachable,
        }
    }

    return lo;
}
