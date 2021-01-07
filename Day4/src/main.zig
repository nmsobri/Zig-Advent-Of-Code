const std = @import("std");
const print = std.debug.print;

const passport_data = @embedFile("input01.txt");

const Passport = struct {
    byr: ?[]const u8 = null,
    iyr: ?[]const u8 = null,
    eyr: ?[]const u8 = null,
    hgt: ?[]const u8 = null,
    hcl: ?[]const u8 = null,
    ecl: ?[]const u8 = null,
    pid: ?[]const u8 = null,
    cid: ?[]const u8 = null,
};

pub fn main() !void {
    @setEvalBranchQuota(10000000);

    comptime {
        var valid: usize = 0;
        var p = Passport{};
        var it = std.mem.split(passport_data, "\r\n");

        while (it.next()) |line| {
            //If line.len == 0, meaning it is a start of new passport
            if (line.len == 0) {
                if (check(p)) {
                    if (validate(p)) {
                        valid += 1;
                    }
                }

                p = Passport{};
                continue;
            }

            var it2 = std.mem.tokenize(line, " ");

            while (it2.next()) |parts| {
                var it3 = std.mem.tokenize(parts, ":");
                const key = it3.next().?;
                const val = it3.next().?;
                @field(p, key) = val;
            }
        }

        @compileLog("Final count:", valid);
    }
}

fn check(p: Passport) bool {
    for (std.meta.fields(Passport)) |info| {
        if (@field(p, info.name) == null and !std.mem.eql(u8, info.name, "cid")) {
            return false;
        }
    }

    return true;
}

fn validate(p: Passport) bool {
    // iterate over Passport to get all fields
    // foreach coresponding field, call it associative function to validate
    for (std.meta.fields(Passport)) |info| {
        var field_name = info.name;
        var field_value = @field(p, info.name);

        if (std.mem.eql(u8, field_name, "cid")) {
            continue;
        }

        if (!@field(@This(), "check_" ++ field_name)(field_value.?)) {
            return false;
        }
    }

    return true;
}

fn check_byr(val: []const u8) bool {
    const year = std.fmt.parseUnsigned(u16, val, 10) catch return false;

    if (year >= 1920 and year <= 2002) {
        return true;
    }

    return false;
}

fn check_iyr(val: []const u8) bool {
    const issued_year = std.fmt.parseUnsigned(u16, val, 10) catch return false;

    if (issued_year >= 2010 and issued_year <= 2020) {
        return true;
    }

    return false;
}

fn check_eyr(val: []const u8) bool {
    const expiration_year = std.fmt.parseUnsigned(u16, val, 10) catch
        return false;

    if (expiration_year >= 2020 and expiration_year <= 2030) {
        return true;
    }

    return false;
}

// hgt (Height) - a number followed by either cm or in:
// If cm, the number must be at least 150 and at most 193.
// If in, the number must be at least 59 and at most 76.
fn check_hgt(val: []const u8) bool {
    const height = val[0 .. val.len - 2];
    const measurement = val[val.len - 2 ..];
    const real_height = std.fmt.parseUnsigned(u16, height, 10) catch
        return false;

    if (std.mem.eql(u8, measurement, "cm") and real_height >= 150 and
        real_height <= 193)
    {
        return true;
    } else if (std.mem.eql(u8, measurement, "in") and real_height >= 59 and
        real_height <= 76)
    {
        return true;
    }

    return false;
}

// hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
fn check_hcl(val: []const u8) bool {
    if (val.len != 7) return false;
    if (val[0] != '#') return false;

    const hex = val[1..];

    for (hex) |h| {
        if ((h < '0' and h > '9') or (h < 'a' and h > 'f')) return false;
    }

    return true;
}

// ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
fn check_ecl(val: []const u8) bool {
    const eye_colors = .{ "amb", "blu", "brn", "gry", "grn", "hzl", "oth" };

    for (eye_colors) |color| {
        if (std.mem.eql(u8, color, val)) return true;
    }

    return false;
}

// pid (Passport ID) - a nine-digit number, including leading zeroes.
fn check_pid(val: []const u8) bool {
    return val.len == 9;
}
