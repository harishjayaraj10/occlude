module Occlude

using GLMakie
using GLFW
using ModernGL
abstract type Demo end

include("common/shader.jl")
include("common/scene.jl")
include("common/record.jl")
include("demos/Mobius.jl")
include("menu.jl")

end
