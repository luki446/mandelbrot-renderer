const stb_image = @cImport({
    @cInclude("stdlib.h");
    @cInclude("stdio.h");
    @cInclude("stb_image_write.h");
});

pub const colorFormat = enum(i32) {
    WHITEGRAY = 1,
    RGB = 3,
    RGBA = 4,
};

pub const saveError = error{undefinedPngError};

pub fn save_as_png(filename: [*c]const u8, width: i32, height: i32, format: colorFormat, pixel_buffer: *const anyopaque) !void {
    const save_status = stb_image.stbi_write_png(filename, width, height, @intFromEnum(format), pixel_buffer, 0);

    if (save_status == 0) {
        return saveError.undefinedPngError;
    }
}
