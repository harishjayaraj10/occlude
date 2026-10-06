function dark_scene(; bg = :black)
  fig = Figure(backgroundcolor = bg)
  ax = LScene(fig[1,1], show_axis=false)
  return fig, ax
end
