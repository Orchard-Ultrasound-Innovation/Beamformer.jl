abstract type AbstractTransducer end
abstract type Transducer1DArray <: AbstractTransducer end
abstract type Transducer2DArray <: AbstractTransducer end


const mm = Unitful.Quantity{Int64, Unitful.𝐋, Unitful.FreeUnits{(Unitful.mm,), Unitful.𝐋, nothing}}



mutable struct LinearArray{L,N,PtT,T} <: Transducer1DArray
    elm_height::L
    elm_width::L
    kerf::L
    elm_center_coords::Vector{PtT}
    elm_direction::PtT
    num_elm::N
    lens_focus::L
    impulse_response::Vector{T}
end



function define_xdc_linear_array(::Point2D;
    num_elm,
    elm_width=nothing,
    elm_height=nothing,
    elm_pitch=nothing,
    kerf,
    lens_focus,
    elm_direction::Point2D = norm_vector(Point2D),
    impulse_response::AbstractVector = [1.0]
    )

    elm_pitch = calc_pitch(elm_pitch, elm_with, elm_kerf)
    elm_center_coords = calc_elm_center_coords(Point2D,elm_pitch, num_elm)

    return LinearArray(elm_height,
        elm_width,
        kerf,
        elm_center_coords,
        elm_direction,
        num_elm,
        lens_focus,
        impulse_response
        )
end



function calc_pitch(pitch_in, elm_width, elm_kerf)
    pitch_out_set = false
    if !isnothing(elm_width) && !isnothing(elm_kerf)
        pitch_out = elm_width + elm_kerf
        pitch_out_set = true
    end
    if !isnothing(pitch_in)
        if pitch_out_set && pitch_out != pitch_in
            error("elm_width + kerf must equal the pitch.")
        end
        pitch_out = pitch_in
    end
    return pitch_out
end


function calc_elm_center_coords(PtT, elm_pitch, num_elm)
    xs = range(0, step=elm_pitch, length=num_elm)
    xs = xs .- xs[end]/2
    return [PtT(x) for x in xs]
end
