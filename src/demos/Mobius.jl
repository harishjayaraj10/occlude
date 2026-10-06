struct Mobius <: Demo
end

name(::Mobius) = "Mobius Strip"
# launch(::Mobius) = println("Mobius!")

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
  N = 1000
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
  fig, ax = dark_scene()
  m = mesh!(ax, pts, F,
            color="#00a4c4",
            specular=0.9,
            shininess=64)

  screen = display(fig)
  θ = 0.0
  while isopen(screen)
    θ += 0.01
    rotate!(m, Vec3f(0, 0, 1), θ)
    sleep(1/60)
  end
end

function twist(u, v, θ)
  uprime = u*cos(θ) - v*sin(θ)
  vprime = u*sin(θ) + v*cos(θ)

  return (uprime, vprime)
end
