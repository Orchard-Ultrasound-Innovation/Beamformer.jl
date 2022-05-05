

abstract type AbstractBmode end

mutable struct Bmode2D{T,N,TV,TC} <: AbstractBmode
    num_px_x::N
    num_px_z::N
    num_pxs::N
    pxs::Vector{Pixel2D{TC,TV}}
    function Bmode2D{T,N,TV,TC}(nx::N, nz::N, npx::N, pxs::Vector{Pixel2D{TC,TV}}) where {T,N,TV,TC}
        if num_px_x * num_px_z != num_pxs
            error("num_pxs must be equal to num_px_x times num_px_z.")
        end
        return new(nx, nz, npx, pxs)
    end
end

mutable struct Bmode3D{Tp,Tv,N} <: AbstractBmode
    num_px_x::N
    num_px_z::N
    num_px_y::N
    num_pxs::N
    pxs::Vector{Pixel3D}
end


function define_bmode_2d(x_axis, z_axis)
    num_px_x = length(x_axis)
    num_px_z = length(z_axis)
    num_pxs = num_px_x * num_px_z
    TC = eltype(x_axis)
    TV = Complex{TC}
    pxs = Pixel2D{TC,TV}[]

    for (xi,x) in x_axis
        for (zi,z) in z_axis
            push!(pxs, Pixel2D( Point2D(x,z), zero(TV)))
        end
    end

    return Bmode2D(nu_px_x, num_px_z, num_pxs, pxs)

end
