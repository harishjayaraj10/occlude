function rotate_y(θ)
    c, s = cos(θ), sin(θ)

    return Float32[
        c 0 s 0;
        0 1 0 0;
        -s 0 c 0;
        0 0 0 1
    ]
end

function rotate_z(θ)
    c = cos(θ)
    s = sin(θ)

    return Float32[
        c -s 0 0;
        s c 0 0;
        0 0 1 0;
        0 0 0 1
    ]
end

function rotate_x(θ)
    c = cos(θ)
    s = sin(θ)

    return Float32[
        1 0 0 0;
        0 c -s 0;
        0 s c 0;
        0 0 0 1
    ]
end

function scale(x, y, z)
    return Float32[
        x 0 0 0;
        0 y 0 0;
        0 0 z 0;
        0 0 0 1
    ]
end

function translate(x, y, z)
    return Float32[
        1 0 0 x;
        0 1 0 y;
        0 0 1 z;
        0 0 0 1
    ]
end
