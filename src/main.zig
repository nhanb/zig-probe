const c = @cImport(@cInclude("sqlite3.h"));
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var optional_db: ?*c.sqlite3 = undefined;
    const init_err = c.sqlite3_open("db.sqlite3", &optional_db);
    defer _ = c.sqlite3_close(optional_db);
    if (init_err != c.SQLITE_OK) {
        print("ERR: {s}\n", .{c.sqlite3_errmsg(optional_db)});
        return error.SqliteOpenFail;
    }
    const db: *c.sqlite3 = optional_db orelse unreachable;

    var stmt: ?*c.sqlite3_stmt = undefined;
    _ = c.sqlite3_prepare_v2(db, "select sqlite_version();", -1, &stmt, null);
    while (c.sqlite3_step(stmt) != c.SQLITE_DONE) {
        print("sqlite version: {s}\n", .{c.sqlite3_column_text(stmt, 0)});
    }
}
