struct Mobius <: Demo
end

name(::Mobius) = "Mobius Strip"
# launch(::Mobius) = println("Mobius!")

function mobius_mesh(; N=100)
  angles = range(0, 2π, length=N+1)[1:end-1]
  pts = Point3f[]

  idx(i, k) = (i-1)*4 + k
  faces = Tuple{Int, Int, Int}[]

  for angle in angles
    sec = section(angle)
    append!(pts, sec)
  end

  for k in 1:4
    for i in 1:N
      shift = i == N ? 2 : 0

      A = idx(i, k)
      B = idx(i, mod1(k+1, 4))
      C = idx(mod1(i+1,N), mod1(k+1+shift, 4))
      D = idx(mod1(i+1,N), mod1(k+shift, 4))

      push!(faces, (A, C, B))
      push!(faces, (A, D, C))
    end
  end

  F = stack(faces, dims=1)

  return pts, F
end

function twist(u, v, θ)
  uprime = u*cos(θ) - v*sin(θ)
  vprime = u*sin(θ) + v*cos(θ)

  return (uprime, vprime)
end

function section(a; R=3, w=1, h=0.5)
center = Point3f(R*cos(a), R*sin(a), 0)
  out = Point3f(cos(a), sin(a), 0)
  up = Point3f(0, 0, 1)

  corners = Point3f[]
  c_points = [(-w/2, -h/2), (w/2, -h/2), (w/2, h/2), (-w/2, h/2)]

  for (x, y) in c_points
    u, v = twist(x, y, a/2)
    push!(corners, center + u*out + v*up)
  end

  return corners
end

function launch(::Mobius)

  pts, F = mobius_mesh()

  window = open_window()
  vertices = collect(reinterpret(Float32, pts))
  indices = UInt32.(vec(permutedims(F)) .- 1)

  vao = upload_mesh(vertices, indices)

  vertex_src = """
    #version 410 core
    layout(location = 0) in vec3 pos;
    uniform mat4 model;
    uniform mat4 projection;
    out vec3 color;
    void main() {
      gl_Position = projection * model * vec4(pos, 1.0);
      // color = pos + 0.5;
      color = vec3(0.0, 0.64, 0.76);
    }
  """
  vertex_shader = compile_shader(GL_VERTEX_SHADER, vertex_src)

  fragment_src = """
    #version 410 core
    out vec4 frag_color;
    in vec3 color;
    void main(){
      frag_color = vec4(color, 1.0);
    }
  """

  fragment_shader = compile_shader(GL_FRAGMENT_SHADER, fragment_src)

  program = link_program(vertex_shader, fragment_shader)

  model_loc = glGetUniformLocation(program, "model")
  projection_loc = glGetUniformLocation(program, "projection")

  aspect = 640/480

  start = time()

  glEnable(GL_DEPTH_TEST)

  while !GLFW.WindowShouldClose(window)
    glClearColor(0, 0, 0, 0)
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    glUseProgram(program)
    glBindVertexArray(vao)

    t = time() - start
    tilt = deg2rad(-90 + 35.26) # atan(1/√2) = 35.26

    glUniformMatrix4fv(model_loc, 1, GL_FALSE,
                      translate(0, 0, -10) * rotate_x(tilt) * rotate_z(t))
    glUniformMatrix4fv(projection_loc, 1, GL_FALSE, orthographic(4,
                       aspect, 0.1, 100))

    glDrawElements(GL_TRIANGLES, length(indices), GL_UNSIGNED_INT, C_NULL)

    GLFW.SwapBuffers(window)

    GLFW.PollEvents()
  end

  GLFW.DestroyWindow(window)

end
