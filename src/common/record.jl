function record_demo(fig, step!; path="recordings/out.mp4",
  frames=628,
  fps=60)

  folderName = dirname(path)
  mkpath(folderName)

  record(fig, path, 1:frames, framerate=fps) do i
    step!(i)
  end
end
