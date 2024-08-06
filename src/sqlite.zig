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
