function open_window(; width=640, height=480, title="occlude")
  GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 4)
  GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 1)
  GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)
  GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, true)

  window = GLFW.CreateWindow(width, height, title)
  GLFW.MakeContextCurrent(window)

  return window
end

