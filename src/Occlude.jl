module Occlude

using GLMakie

abstract type Demo end

include("common/scene.jl")
include("common/record.jl")
include("demos/Mobius.jl")
include("menu.jl")

end
