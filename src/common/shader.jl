function compile_shader(kind, src)
    shader = glCreateShader(kind)
    glShaderSource(
        shader,
        1,
        Ptr{GLchar}[pointer(src)],
        C_NULL
    )
    glCompileShader(shader)

    ok = Ref{GLint}(0)
    glGetShaderiv(shader, GL_COMPILE_STATUS, ok)
    if ok[] == 0
        buf = Vector{UInt8}(undef, 1024)
        glGetShaderInfoLog(shader, 1024, C_NULL, buf)
        msg = unsafe_string(pointer(buf))

        error("Shader failed to Compile:\n" * msg)
    end

    return shader
end

function link_program(vs, fs)
    program = glCreateProgram()
    glAttachShader(program, vs)
    glAttachShader(program, fs)
    glLinkProgram(program)

    ok = Ref{GLint}(0)
    glGetProgramiv(program, GL_LINK_STATUS, ok)
    if ok[] == 0
        buf = Vector{UInt8}(undef, 1024)
        glGetProgramInfoLog(program, 1024, C_NULL, buf)
        msg = unsafe_string(pointer(buf))

        error("Program failed to link:\n" * msg)
    end

    return program
end
