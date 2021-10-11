const std = @import("std");
const Client = @import("requestz").Client;
const Allocator = std.mem.Allocator;
const Headers = @import("http").Headers;
var cloudflareApi ="https://api.cloudflare.com/client/v4/";
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
        const urls = [_][]const u8{ cloudflareApi,cmd}; 
        const url = try std.mem.join(std.testing.allocator, "", &urls);
        defer std.testing.allocator.free(url);

        var response = try client.get(url,.{ .headers = headers.items() });
        defer response.deinit();
        std.debug.print("body: {s}\n", .{response.body});
        std.debug.print("cmd: {s}\n", .{cmd});
        std.debug.print("url: {s}\n", .{url});
        return response.body;
    }
    pub fn post(self: Cloudflare, cmd: []const u8,content :[]const u8) ![]const u8 {
       var headers = Headers.init(std.testing.allocator);
        defer headers.deinit();
        try headers.append("X-Auth-Email", self.email);
        try headers.append("X-Auth-Key", self.apikey);
        try headers.append("Content-type", "application/json");
        var client = try Client.init(std.testing.allocator);
        defer client.deinit();
        const urls = [_][]const u8{ cloudflareApi,cmd}; 
        const url = try std.mem.join(std.testing.allocator, "", &urls);
        defer std.testing.allocator.free(url);
        var response = try client.post(url,.{ .headers = headers.items(),.content = content });
        defer response.deinit();
        return response.body;
    }
    pub fn put(self: Cloudflare, cmd: []const u8,content :[]const u8) ![]const u8 {
         var headers = Headers.init(std.testing.allocator);
        defer headers.deinit();
        try headers.append("X-Auth-Email", self.email);
        try headers.append("X-Auth-Key", self.apikey);
        try headers.append("Content-type", "application/json");
        var client = try Client.init(std.testing.allocator);
        defer client.deinit();
        const urls = [_][]const u8{ cloudflareApi,cmd}; 
        const url = try std.mem.join(std.testing.allocator, "", &urls);
        defer std.testing.allocator.free(url);
        var response = try client.put(url,.{ .headers = headers.items(),.content = content });
        defer response.deinit();
        return response.body;
    }
    pub fn getDomainID(self: Cloudflare,domain : []const u8) ![]const u8{
        const cmds = [_][]const u8{ "zones/",self.zoneid,"/dns_records?name=",domain}; 
        const cmd = try std.mem.join(std.testing.allocator, "", &cmds);
        var result=try self.get(cmd);
        var parser = std.json.Parser.init(self.allocator, false);
        defer parser.deinit();
        var jsonTree= try parser.parse(result);
        defer jsonTree.deinit();
        const success= jsonTree.root.Object.get("success").?.Bool;
        if (!success) {
            std.debug.print("cmd:{s}\n",.{cmd});
        }
        return "";
    }
};



