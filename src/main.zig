const std = @import("std");
const Client = @import("requestz").Client;
pub fn main() anyerror!void {

    var client = try Client.init(std.testing.allocator);
    defer client.deinit();
    var response = try client.get("http://www.baidu.com", .{});
    defer response.deinit();
    std.debug.print("Hello, {s} !\n", .{response.body});

}
