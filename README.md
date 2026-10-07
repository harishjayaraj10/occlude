# occlude

Playing around with graphics in Julia. The idea is to build up a small engine in `src/common/` and then make separate little projects on top of it: fluids, mobius strip, whatever else comes up.

## where I'm at

- [x] mobius strip with lights and rotation
- [x] record animations to mp4

## next: learning shaders

Using GLFW.jl + ModernGL.jl. Mac only goes up to OpenGL 4.1, so no compute shaders.

- [x] install GLFW + ModernGL
- [ ] open a window and clear it to a color
- [ ] draw a triangle with my own vertex + fragment shader
- [ ] shader loading helper in common/
- [ ] pass θ as a uniform and rotate in the shader
- [ ] get the mobius mesh running through the shader
- [ ] lighting in the fragment shader
- [ ] render to texture
- [ ] fluids
