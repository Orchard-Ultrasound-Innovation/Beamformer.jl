struct Point2D{T} <: StaticArrays.FieldVector{2, T}
    x::T
    y::T
end

struct Point3D{T} <: StaticArrays.FieldVector{3, T}
    x::T
    y::T
    z::T
end

function Point2D(x::Tx, y::Ty) where {Tx,Ty}
    T = promote(Tx,Ty)
    return Point2D{T}(T(x),T(y))
end
function Point3D(x::Tx, y::Ty, z::Tz) where {Tx,Ty,Tz}
    T = promote(Tx,Ty,Tz)
    return Point3D{T}(T(x),T(y),T(z))
end

Point2D(x) = Point2D(x, zero(x))
Point3D(x) = Point3D(x, zero(x), zero(x))

norm_vector(::Point2D) = Point2D(0.0,1.0)
norm_vector(::Point3D) = Point3D(0.0,0.0,1.0)

abstract type AbstractPixel end
struct Pixel2D{TC,TV} <: AbstractPixel
    coord::Point2D{TC}
    val::TV
end
struct Pixel3D{cT,vT}  <: AbstractPixel
    coord::Point3D{cT}
    val::vT
end


abstract type AbstractScanline end

struct Scanline2D{T,N} <: AbstractScanline
    start_coord::Point2D{T}
    direction::Point2D{T}
    num_samples::N
    coords::Vector{Point2D{T}}
end

struct Scanline3D{T,N} <: AbstractScanline
    start_coord::Point3D{T}
    direction::Point3D{T}
    num_samples::N
    coords::Vector{Point3D{T}}
end
