using GLMakie

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
  angles = range(0, 2π, length=N)
  pts = Point3f[]

  idx(i, k) = (i-1)*4 + k
  faces = Tuple{Int, Int, Int}[]

  for angle in angles
    sec = section(angle)
    append!(pts, sec)
  end

  for k in 1:4
    for i in 1:N-1
      A = idx(i, k)
      B = idx(i, mod1(k+1, 4))
      C = idx(i+1, mod1(k+1, 4))
      D = idx(i+1, k)

      push!(faces, (A, B, C))
      push!(faces, (A, C, D))
    end
  end

  F = stack(faces, dims=1)
  fig = mesh(pts, F)

  # fig = scatter(pts, markersize=8)
  wait(display(fig))
end

function twist(u, v, θ)
  uprime = u*cos(θ) - v*sin(θ)
  vprime = u*sin(θ) + v*cos(θ)

  return (uprime, vprime)
end
