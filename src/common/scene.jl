function dark_scene(; bg = :black)
  lights = [
  AmbientLight(RGBf(0.6, 0.6, 0.6)),
  DirectionalLight(RGBf(1, 1, 1), Vec3f(-1, -1, -2)),
  PointLight(RGBf(0.6, 0.6, 0.6), Point3f(0, 0, 6)),
  ]

  fig = Figure(backgroundcolor = bg)
  ax = LScene(fig[1,1],
              show_axis=false,
              scenekw = (lights = lights,))
  return fig, ax
end
