const c = @cImport(@cInclude("sqlite3.h"));
const std = @import("std");
const print = std.debug.print;
const sqlite = @import("sqlite.zig");

pub fn main() !void {
    var db = try sqlite.Db.open("db2.sqlite3");
    defer db.close();

    var stmt: ?*c.sqlite3_stmt = undefined;
    _ = c.sqlite3_prepare_v2(db.c_sqlite3, "select 'hello', sqlite_version();", -1, &stmt, null);
    while (c.sqlite3_step(stmt) != c.SQLITE_DONE) {
        for (0..2) |i| {
            print("{s}, ", .{c.sqlite3_column_text(stmt, @intCast(i))});
        }
    }
    _ = c.sqlite3_finalize(stmt);
}
