module Occlude

# using GLMakie
using GeometryBasics
using GLFW
using ModernGL
abstract type Demo end

include("common/window.jl")
include("common/mesh.jl")
include("common/shader.jl")
# include("common/scene.jl")
# include("common/record.jl")
include("common/transform.jl")
include("common/camera.jl")

include("demos/Mobius.jl")
include("menu.jl")

end
