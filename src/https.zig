const std = @import("std");
const print = std.debug.print;
const http = std.http;

test "https" {
    const user = "foo"; // TODO read user + pass from envars
    const password = "bar";
    const auth_uri = std.Uri.parse(
        "https://" ++
            user ++
            ":" ++
            password ++
            "@api.backblazeb2.com/b2api/v3/b2_authorize_account",
    ) catch unreachable;

    // Create an allocator.
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const allocator = gpa.allocator();

    var client = http.Client{ .allocator = allocator };
    defer client.deinit();

    var resp = std.ArrayList(u8).init(allocator);
    defer resp.deinit();

    print("Fetching {any}\n", .{auth_uri});
    const result = client.fetch(.{
        .location = .{ .uri = auth_uri },
        .method = http.Method.GET,
        .response_storage = .{ .dynamic = &resp },
    }) catch unreachable;
    print(">> {any}\n", .{result});
    print(">> resp: {s}\n", .{resp.items});
}
