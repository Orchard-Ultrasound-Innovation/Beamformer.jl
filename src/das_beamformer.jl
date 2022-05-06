function das_beamformer!(px_vals, rf_data, pxs::AbstractPixels, src_pt, rcv_elms, focal_pt, c)
    num_rx_channels = size(rf_data,2)
    delays = zeros(num_rx_channels)
    rcv_apo = zeros(num_rx_channels)

    for (px_idx, px) in enumerate(pxs)
        calculate_delays!(delays, px, src_pt, focal_pt, rcv_elms, c)
        rcv_apodization!(rcv_apo, px, rcv_elms)
        src_apo = src_apodization(px, src_pt, focal_pt)
        delay_sum_and_apodize!(px_vals, px_idx, rf_data, data_t_start, data_dt, delays, rcv_apo, src_apo)
    end
    return nothing
end

function calculate_delays!(delays, px, src_pt, focal_pt, rcv_pts, c)
    d_src_fpt_sq = sum((focal_pt - src_pt).^2)
    for (i, rcv_pt) in enumerate(rcv_pts)
        d_src_px_sq = sum((px - src_pt).^2)
        d_px_rcv_pt = sqrt(sum((px - rcv_pt).^2))

        if d_src_px_sq < d_src_fpt_sq
            delays[i] = (sqrt(d_src_fpt_sq) + sqrt(d_fpt_px_sq) + d_px_rcv_pt) / c
        else
            delays[i] = (sqrt(d_src_fpt_sq) - sqrt(d_fpt_px_sq) + d_px_rcv_pt) / c
        end
    end
end


function rcv_apodization!(px_apo, px, rcv_elms)
    for (i,rcv_elm) in rcv_elms
        px_apo[i] = px_rcv_apo(px, rcv_pt)
    end
    return nothing
end

src_apodization(px, src_pt, focal_pt) = 1.0
# Dummy functions, for now
px_src_apo(px, src_pt, focal_pt) = 1.0
px_rcv_apo(px, rcv_elm) = 1.0


# TODO:
# - setup interpolators before calling this function.
# - make struct that hold information about the RF data (t_start etc)
function delay_sum_and_apodize!(px_vals, px_idx, rf_data, data_t_start, data_dt, delays, rcv_apo, src_apo)
    num_channels = size(rf_data,2)
    vals = Vector{Complex{Float64}}(undef, num_channels)
    for ch_idx in 1:num_channels
        ch_data = view(rf_data, :, ch_idx)
        delay = view(delays, ch_idx)
        vals[ch_idx] = get_interpolated_value(ch_data, data_t_start, data_dt, delay) * rcv_apo[ch_idx]
    end
    px_vals[px_idx] = sum(vals) * src_apo
    return nothing
end


function get_interpolated_value(ch_data, data_t_start, data_dt, delay)
    num_samples = length(ch_data)
    t = range(data_t_start, step=data_dt, length=num_samples)

    return intp(delay)
end
