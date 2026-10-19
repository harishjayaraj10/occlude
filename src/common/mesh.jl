function upload_mesh(vertices, indices; per_point=3)
  vao = Ref{GLuint}(0)
  glGenVertexArrays(1, vao)
  glBindVertexArray(vao[])

  vbo = Ref{GLuint}(0)
  glGenBuffers(1, vbo)
  glBindBuffer(GL_ARRAY_BUFFER, vbo[])

  glBufferData(GL_ARRAY_BUFFER, sizeof(vertices),
                vertices, GL_STATIC_DRAW)

  glVertexAttribPointer(0,
                        per_point,
                        GL_FLOAT,
                        GL_FALSE,
                        0,
                        C_NULL)
  glEnableVertexAttribArray(0)

  ebo = Ref{GLuint}(0)
  glGenBuffers(1, ebo)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo[])  
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW)

  return vao[]
end
