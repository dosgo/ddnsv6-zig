const std = @import("std");
const Client = @import("requestz").Client;
const Allocator = std.mem.Allocator;
const Headers = @import("http").Headers;
var cloudflareApi :[]const u8="https://api.cloudflare.com/client/v4/";
pub const Cloudflare = struct {
    allocator: *Allocator,
    email: []const u8,
    apikey: []const u8,
    zoneid: []const u8,
    pub fn init(allocator: *Allocator,email: []const u8,apikey: []const u8,zoneid: []const u8) !Cloudflare {
        return Cloudflare{ .allocator = allocator,.email=email,.apikey=apikey,.zoneid=zoneid };
    }
    pub fn deinit(_: *Cloudflare) void {

    }
    pub fn get(self: Cloudflare, cmd:  []const u8) ![]const u8 {
        var headers = Headers.init(std.testing.allocator);
        defer headers.deinit();
        try headers.append("X-Auth-Email", self.email);
        try headers.append("X-Auth-Key", self.apikey);
        try headers.append("Content-type", "application/json");
        var client = try Client.init(std.testing.allocator);
        defer client.deinit();
        const urls = [_][]const u8{
        cloudflareApi,
        cmd,
        }; // extra crlf required to end headers
        const url = try std.mem.join(std.testing.allocator, "", &urls);
        defer std.testing.allocator.free(url);

        var response = try client.get(url,.{ .headers = headers.items() });
        defer response.deinit();
        std.debug.print("body: {s}\n", .{response.body});
        std.debug.print("cmd: {s}\n", .{cmd});
         std.debug.print("url: {s}\n", .{url});
        return response.body;
    }
    pub fn post(self: Cloudflare, url: []const u8) ![]const u8 {
        std.debug.print("url: {s}\n", .{url,self.email});
    }
    pub fn put(self: Cloudflare, url: []const u8) ![]const u8 {
         std.debug.print("url: {s}\n", .{url,self.email});
    }
};