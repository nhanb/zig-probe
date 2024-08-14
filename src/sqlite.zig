const c = @cImport(@cInclude("sqlite3.h"));
const std = @import("std");
const print = std.debug.print;

pub const Db = struct {
    c_sqlite3: *c.sqlite3,

    pub fn open(file_name: [:0]const u8) !Db {
        var db: ?*c.sqlite3 = undefined;
        const init_err = c.sqlite3_open(file_name, &db);
        if (init_err != c.SQLITE_OK) {
            print("ERR: {s}\n", .{c.sqlite3_errmsg(db)});
            return error.SqliteOpenFail;
        }
        return Db{ .c_sqlite3 = db orelse unreachable };
    }

    pub fn close(self: Db) void {
        const resp = c.sqlite3_close(self.c_sqlite3);
        if (resp != c.SQLITE_OK) {
            print("sqlite close error: {s}\n", .{c.sqlite3_errmsg(self.c_sqlite3)});
            unreachable; // failed to close sqlite db
        }
    }
};

test "sqlite" {
    var db = try Db.open("db2.sqlite3");
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
