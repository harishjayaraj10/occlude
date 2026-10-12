using GLFW
using ModernGL

include("../src/common/camera.jl")
include("../src/common/shader.jl")
include("../src/common/mesh.jl")
include("../src/common/window.jl")
include("../src/common/transform.jl")

window = open_window()

# println(unsafe_string(glGetString(GL_VERSION)))
# vertices = Float32[ 0, 0.75, 0,
#                     -0.75, -0.75, 0,
#                     0.75, -0.75, 0]

vertices = Float32[-0.5, -0.5, 0,
                    0.5, -0.5, 0,
                    0.5, 0.5, 0,
                    -0.5, 0.5, 0]

indices = UInt32[0, 1, 2, 0, 2, 3]

aspect = 640/480

vao = upload_mesh(vertices, indices)

vertex_src = """
  #version 410 core
  layout(location = 0) in vec3 pos;
  uniform mat4 model;
  uniform mat4 projection;
  void main() {
    gl_Position = projection * model * vec4(pos, 1.0);
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
model_loc = glGetUniformLocation(program, "model")
projection_loc = glGetUniformLocation(program, "projection")

start = time()

# Loop until the user closes the window
while !GLFW.WindowShouldClose(window)

	# Render here
  glClearColor(0, 0, 0, 0)
  glClear(GL_COLOR_BUFFER_BIT)

  glUseProgram(program)
  glBindVertexArray(vao)

  t = time() - start

  glUniform1f(brightness_loc, sin(t)*0.5 + 0.5)
  glUniformMatrix4fv(model_loc, 1, GL_FALSE,
  translate(0, 0, -3) * rotate_y(t))
  glUniformMatrix4fv(projection_loc, 1, GL_FALSE,
      perspective(deg2rad(60), aspect, 0.1, 100))

  # glDrawArrays(GL_TRIANGLES, 0, 3)
  glDrawElements(GL_TRIANGLES, length(indices), GL_UNSIGNED_INT, C_NULL)

	# Swap front and back buffers
	GLFW.SwapBuffers(window)

	# Poll for and process events
	GLFW.PollEvents()
end

GLFW.DestroyWindow(window)
