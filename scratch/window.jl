using GLFW
using ModernGL

include("../src/common/shader.jl")
include("../src/common/mesh.jl")
include("../src/common/window.jl")

window = open_window()

# println(unsafe_string(glGetString(GL_VERSION)))
vertices = Float32[ 0, 0.75,
                    -0.75, -0.75,
                    0.75, -0.75]

vao = upload_mesh(vertices, per_point=2)

vertex_src = """
  #version 410 core
  layout(location = 0) in vec2 pos;
  void main() {
    gl_Position = vec4(pos, 0.0, 1.0);
  }
"""

vertex_shader = compile_shader(GL_VERTEX_SHADER, vertex_src)

fragment_src = """
  #version 410 core
  out vec4 frag_color;
  uniform float brightness;
  void main(){
    frag_color = vec4(1.0, 0.5, 0.2, 1.0) * brightness;
  }
"""

fragment_shader = compile_shader(GL_FRAGMENT_SHADER, fragment_src)

program = link_program(vertex_shader, fragment_shader)

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
