const std = @import("std");
pub const pkgs = struct {
    pub const http = std.build.Pkg{
        .name = "http",
        .path = .{ .path = ".gyro\\http-ducdetronquito-0.1.3-02dd386aa7452ba02887b98078627854\\pkg\\src\\main.zig" },
    };

    pub const h11 = std.build.Pkg{
        .name = "h11",
        .path = .{ .path = ".gyro\\h11-ducdetronquito-0.1.1-5d7aa65ac782877d98cc6311a77ca7a8\\pkg\\src\\main.zig" },
        .dependencies = &[_]std.build.Pkg{
            std.build.Pkg{
                .name = "http",
                .path = .{ .path = ".gyro\\http-ducdetronquito-0.1.3-02dd386aa7452ba02887b98078627854\\pkg\\src\\main.zig" },
            },
        },
    };

    pub fn addAllTo(artifact: *std.build.LibExeObjStep) void {
        @setEvalBranchQuota(1_000_000);
        inline for (std.meta.declarations(pkgs)) |decl| {
            if (decl.is_pub and decl.data == .Var) {
                artifact.addPackage(@field(pkgs, decl.name));
            }
        }
    }
};

pub const exports = struct {
    pub const ddnsv6 = std.build.Pkg{
        .name = "ddnsv6",
        .path = .{ .path = "src/main.zig" },
        .dependencies = &.{
            pkgs.http,
            pkgs.h11,
        },
    };
};
pub const base_dirs = struct {
    pub const http = ".gyro\\http-ducdetronquito-0.1.3-02dd386aa7452ba02887b98078627854\\pkg";
    pub const h11 = ".gyro\\h11-ducdetronquito-0.1.1-5d7aa65ac782877d98cc6311a77ca7a8\\pkg";
};