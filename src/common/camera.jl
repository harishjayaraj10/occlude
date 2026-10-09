function perspective(fov, aspect, near, far)
  f = 1/tan(fov/2)
  return Float32[
    f/aspect        0       0       0;
    0       f       0       0;
    0       0       (far+near)/(near-far)       2*far*near/(near-far);
    0       0       -1        0
  ]
end
