const std = @import("std");
const Cloudflare = @import("cloudflare.zig").Cloudflare;
pub fn main() anyerror!void {
    var client = try Cloudflare.init(std.testing.allocator,"dd","ddd","dd");
    defer client.deinit();
    var xx=try client.getDomainID("ssd");
     std.debug.print("cmd: {s}\n", .{xx});
}
