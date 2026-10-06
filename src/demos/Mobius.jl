using GLMakie

struct Mobius <: Demo
end

name(::Mobius) = "Mobius Strip"
# launch(::Mobius) = println("Mobius!")

function section(a; R=3, w=1.0, h=0.3)
  center = Point3f(R*cos(a), R*sin(a), 0)
  out = Point3f(cos(a), sin(a), 0)
  up = Point3f(0, 0, 1)

  # corners = [center + u*out + v*up for (u, v) in [(-w/2, -h/2), (w/2, -h/2), (w/2, h/2), (-w/2, h/2)]]
  corners = Point3f[]
  c_points = [(-w/2, -h/2), (w/2, -h/2), (w/2, h/2), (-w/2, h/2)]

  for (x, y) in c_points
    u, v = twist(x, y, a/2)
    push!(corners, center + u*out + v*up)
  end

  return corners
end

function launch(::Mobius)
  points = range(0, 2π, length=50)
  R = 3
  a = 2π

  circle = [Point3f(R*cos(point), R*sin(point), point/2) for point in points]

  fig = scatter(section(0.0), markersize=20)
  scatter!(section(π/2), markersize=20)
  scatter!(section(π), markersize=20)
  scatter!(section(3π/2), markersize=20)
  wait(display(fig))

end

function twist(u, v, θ)
  uprime = u*cos(θ) - v*sin(θ)
  vprime = u*sin(θ) + v*cos(θ)

  return (uprime, vprime)
end
