const c = @cImport(@cInclude("sqlite3.h"));
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var optionalDb: ?*c.sqlite3 = undefined;
    if (c.sqlite3_open("db.sqlite3", &optionalDb) != c.SQLITE_OK) {
        return error.SqliteOpenFail;
    }
    defer _ = c.sqlite3_close(optionalDb);
    const db: *c.sqlite3 = optionalDb orelse unreachable;
    print(">> {d}", .{db});
}
