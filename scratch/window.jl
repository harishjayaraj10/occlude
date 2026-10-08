using GLFW
using ModernGL

GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 4)
GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 1)
GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)
GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, true)

# Create a window and its OpenGL context
window = GLFW.CreateWindow(640, 480, "GLFW.jl")

# Make the window's context current
GLFW.MakeContextCurrent(window)

# println(unsafe_string(glGetString(GL_VERSION)))

vao = Ref{GLuint}(0)
glGenVertexArrays(1, vao)
glBindVertexArray(vao[])

vertices = Float32[0, 0.75, -0.75, -0.75, 0.75, -0.75]
vbo = Ref{GLuint}(0)
glGenBuffers(1, vbo)
glBindBuffer(GL_ARRAY_BUFFER, vbo[])
glBufferData(GL_ARRAY_BUFFER, sizeof(vertices),
  vertices, GL_STATIC_DRAW)

glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, C_NULL)
glEnableVertexAttribArray(0)

vertex_src = """
  #version 410 core
  layout(location = 0) in vec2 pos;
  void main() {
    gl_Position = vec4(pos, 0.0, 1.0);
  }
"""

vertex_shader = glCreateShader(GL_VERTEX_SHADER)
glShaderSource(vertex_shader, 1, Ptr{GLchar}[pointer(vertex_src)], C_NULL)
glCompileShader(vertex_shader)

ok = Ref{GLint}(0)
glGetShaderiv(vertex_shader, GL_COMPILE_STATUS, ok)
println(ok[])

fragment_src = """
  #version 410 core
  out vec4 frag_color;
  uniform float brightness;
  void main(){
    frag_color = vec4(1.0, 0.5, 0.2, 1.0) * brightness;
  }
"""

fragment_shader = glCreateShader(GL_FRAGMENT_SHADER)
glShaderSource(fragment_shader, 1, Ptr{GLchar}[pointer(fragment_src)], C_NULL)
glCompileShader(fragment_shader)

glGetShaderiv(fragment_shader, GL_COMPILE_STATUS, ok)
println(ok[])

program = glCreateProgram()
glAttachShader(program, vertex_shader)
glAttachShader(program, fragment_shader)
glLinkProgram(program)

glGetProgramiv(program, GL_LINK_STATUS, ok)
println(ok[])

brightness_loc = glGetUniformLocation(program, "brightness")
println(brightness_loc)

start = time()

# Loop until the user closes the window
while !GLFW.WindowShouldClose(window)

	# Render here
  glClearColor(0, 0, 0, 0)
  glClear(GL_COLOR_BUFFER_BIT)

  glUseProgram(program)
  glBindVertexArray(vao[])

  t = time() - start

  glUniform1f(brightness_loc, sin(t)*0.5 + 0.5)

  glDrawArrays(GL_TRIANGLES, 0, 3)

	# Swap front and back buffers
	GLFW.SwapBuffers(window)

	# Poll for and process events
	GLFW.PollEvents()
end

GLFW.DestroyWindow(window)
