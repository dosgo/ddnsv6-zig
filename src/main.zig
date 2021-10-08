const std = @import("std");
const client = @import("requestz.zig").Client;
pub fn main() anyerror!void {
  

    var client = try Client.init(std.testing.allocator);
    defer client.deinit();
    var response = try client.get("http://httpbin.org/get", .{});
    defer response.deinit();
    std.debug.print("Hello, {s} {s}!\n", .{request.body},.{request.status});

}
