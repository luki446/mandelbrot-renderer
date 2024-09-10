const std = @import("std");
const img = @import("img.zig");

const SCREEN_WIDTH = 1280;
const SCREEN_HEIGHT = 720;

const MAX_ITER = 1024;

const X_SCALE_MIN = -2.00;
const X_SCALE_MAX = 0.47;

const Y_SCALE_MIN = -1.12;
const Y_SCALE_MAX = 1.12;

const point_type = f32;

fn mandelbrot(pixel_x: i32, pixel_y: i32) i32 {
    const pixel_x_float: point_type = @floatFromInt(pixel_x);
    const pixel_y_float: point_type = @floatFromInt(pixel_y);
    const x0 = X_SCALE_MIN + (X_SCALE_MAX - X_SCALE_MIN) * (pixel_x_float / SCREEN_WIDTH);
    const y0 = Y_SCALE_MIN + (Y_SCALE_MAX - Y_SCALE_MIN) * (pixel_y_float / SCREEN_HEIGHT);

    var x: point_type = 0.0;
    var y: point_type = 0.0;

    var iteration: i32 = 0;

    while (x * x + y * y <= 2 * 2 and iteration < MAX_ITER) : (iteration += 1) {
        const xtemp = x * x - y * y + x0;
        y = 2 * x * y + y0;
        x = xtemp;
    }

    return iteration;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const pixel_buffer = try allocator.alloc(u8, SCREEN_WIDTH * SCREEN_HEIGHT);
    defer allocator.free(pixel_buffer);

    for (0..SCREEN_WIDTH) |x| {
        const x_integer: i32 = @intCast(x);
        for (0..SCREEN_HEIGHT) |y| {
            const y_integer: i32 = @intCast(y);

            const pixel_value = mandelbrot(x_integer, y_integer);

            const pixel_color = 255 - std.math.lerp(0, 255, @as(point_type, @floatFromInt(pixel_value)) / MAX_ITER);

            pixel_buffer[y * SCREEN_WIDTH + x] = @intFromFloat(pixel_color);
        }
    }

    try img.save_as_png("out.png", SCREEN_WIDTH, SCREEN_HEIGHT, .WHITEGRAY, pixel_buffer.ptr);
}
