# Mandelbrot Renderer

This is a simple Mandelbrot renderer written in Zig mainly to test Zig's cooperability with C libraries like `stb_image_write`.
![Mandelbrot Set](out.png)

## Running
Requires Zig 0.13.0 to build. Run `zig build run` to build and run program without optimization. The output image will be saved as `out.png`.