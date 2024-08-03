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
    print(">> {d}\n", .{db});

    var stmt: ?*c.sqlite3_stmt = undefined;
    _ = c.sqlite3_prepare_v2(db, "select 'hello';", -1, &stmt, null);
    while (c.sqlite3_step(stmt) != c.SQLITE_DONE) {
        print(">> {s}\n", .{c.sqlite3_column_text(stmt, 0)});
    }
}
