function rotate_z(θ)
  c = cos(θ)
  s = sin(θ)

  return Float32[c -s 0 0;
                 s c 0 0;
                 0 0 1 0;
                 0 0 0 1]
end

function scale(x, y, z)
  return Float32[x 0 0 0;
                 0 y 0 0;
                 0 0 z 0;
                 0 0 0 1]
end
