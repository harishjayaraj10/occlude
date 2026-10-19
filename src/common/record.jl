function read_frame(window)
    fb = GLFW.GetFramebufferSize(window)
    pixels = Vector{UInt8}(undef, fb.width * fb.height * 4)
    glReadPixels(0, 0, fb.width, fb.height, GL_RGBA, GL_UNSIGNED_BYTE, pixels)

    return pixels
end

function start_recording(path, width, height; fps = 60)
    cmd = `ffmpeg -y -f rawvideo -pixel_format rgba
         -video_size $(width)x$(height) -framerate $(fps) -i -
         -vf vflip -c:v libx264 -pix_fmt yuv420p $path`

    return open(cmd, "w")
end
