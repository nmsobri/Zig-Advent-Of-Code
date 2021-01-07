const std = @import("std");
const print = std.debug.print;

const input_file = @embedFile("input.txt");

pub fn main() !void {
    // part1();
    part2();
}

fn part1() void {
    var it = std.mem.split(input_file, "\r\n");
    var grand_total: u16 = 0;

    var alphabets: [128]bool = [_]bool{false} ** 128;

    while (it.next()) |line| {
        if (line.len == 0) {
            var total: u16 = 0;
            for (alphabets) |e| {
                if (e) {
                    total += 1;
                }
            }

            grand_total += total;
            alphabets = [_]bool{false} ** 128;
            continue;
        }

        for (line) |c| {
            if (!alphabets[c]) {
                alphabets[c] = true;
            }
        }
    }

    print("Grand total: {}\n", .{grand_total});
}

fn part2() void {
    var grand_total: u16 = 0;
    var it = std.mem.split(input_file, "\r\n");
    var prev_alphabets: [128]bool = [_]bool{false} ** 128;
    var alphabets: [128]bool = [_]bool{false} ** 128;
    var counter: i8 = 0;

    while (it.next()) |line| : (counter += 1) {
        if (line.len == 0) {
            var total: u16 = 0;

            for (prev_alphabets) |ch, i| {
                if (ch) {
                    total += 1;
                }
            }

            grand_total += total;
            prev_alphabets = [_]bool{false} ** 128;
            alphabets = [_]bool{false} ** 128;
            counter = -1;
            continue;
        }

        for (line) |ch| {
            alphabets[ch] = true;
        }

        if (counter != 0) {
            for (alphabets) |_, i| {
                if (alphabets[i] and prev_alphabets[i]) {
                    continue;
                } else {
                    prev_alphabets[i] = false;
                }
            }
        } else {
            prev_alphabets = alphabets;
        }

        alphabets = [_]bool{false} ** 128;
    }

    print("Grand total:{}\n", .{grand_total});
}
