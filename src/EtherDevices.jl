#=
  @ author: ChenyuBao <chenyu.bao@outlook.com>
  @ date: 2025-12-08 22:09:14
  @ license: MIT
  @ language: Julia
  @ declaration: EtherDevices.jl is a package for device data management.
  @ description: main file
 =#

module EtherDevices

export int, float
export backend, id
export switch!
export zerosi, zerosf
export AbstractEtherDevice, EtherDevice

using KernelAbstractions

# * ===== ===== ===== ===== AbstractEtherDevice ===== ===== ===== ===== * #

abstract type AbstractEtherDevice{Ti <: Integer, Tf <: AbstractFloat, Tb <: KernelAbstractions.Backend, Id} end

@inline function int(
    ::AbstractEtherDevice{Ti, <:AbstractFloat, <: KernelAbstractions.Backend, Id},
)::typeof(Ti) where {Ti <: Integer, Id}
    return Ti
end

@inline function float(
    ::AbstractEtherDevice{<:Integer, Tf, <:KernelAbstractions.Backend, Id},
)::typeof(Tf) where {Tf <: AbstractFloat, Id}
    return Tf
end

@inline function backend(
    ::AbstractEtherDevice{<:Integer, <:AbstractFloat, Tb, Id},
)::Tb where {Tb <: KernelAbstractions.Backend, Id}
    return Tb()
end

@inline function id(
    ::AbstractEtherDevice{Ti, Tf, Tb, Id},
)::Int where {Ti <: Integer, Tf <: AbstractFloat, Tb <: KernelAbstractions.Backend, Id}
    return Id
end

@inline function switch!(
    ed::AbstractEtherDevice{<:Integer, <:AbstractFloat, <:KernelAbstractions.Backend, Id},
) where {Id}
    return KernelAbstractions.device!(backend(ed), id(ed))
end

@inline function zerosi(
    ed::AbstractEtherDevice{Ti, <:AbstractFloat, Tb, Id},
    dims::Int...,
) where {Ti <: Integer, Tb <: KernelAbstractions.Backend, Id}
    switch!(ed)
    return KernelAbstractions.zeros(backend(ed), Ti, dims...)
end

@inline function zerosf(
    ed::AbstractEtherDevice{<:Integer, Tf, Tb, Id},
    dims::Int...,
) where {Tf <: AbstractFloat, Tb <: KernelAbstractions.Backend, Id}
    switch!(ed)
    return KernelAbstractions.zeros(backend(ed), Tf, dims...)
end

@inline function (ed::AbstractEtherDevice{Ti, Tf, Tb, Id})(
    x::Integer,
)::Ti where {Ti <: Integer, Tf <: AbstractFloat, Tb <: KernelAbstractions.Backend, Id}
    return convert(Ti, x)
end

@inline function (ed::AbstractEtherDevice{Ti, Tf, Tb, Id})(
    x::AbstractFloat,
)::Tf where {Ti <: Integer, Tf <: AbstractFloat, Tb <: KernelAbstractions.Backend, Id}
    return convert(Tf, x)
end

@inline function (ed::AbstractEtherDevice{Ti, Tf, Tb, Id})(
    xs::AbstractArray{<:Integer},
) where {Ti <: Integer, Tf <: AbstractFloat, Tb <: KernelAbstractions.Backend, Id}
    if get_backend(xs) === backend(ed)
        if eltype(xs) === Ti
            return deepcopy(xs)
        else
            Ti.(xs)
        end
    else
        ys = zerosi(ed, size(xs)...)
        Base.copyto!(ys, xs)
    end
end

@inline function (ed::AbstractEtherDevice{Ti, Tf, Tb, Id})(
    xs::AbstractArray{<:AbstractFloat},
) where {Ti <: Integer, Tf <: AbstractFloat, Tb <: KernelAbstractions.Backend, Id}
    if get_backend(xs) === backend(ed)
        if eltype(xs) === Tf
            return deepcopy(xs)
        else
            Tf.(xs)
        end
    else
        ys = zerosf(ed, size(xs)...)
        Base.copyto!(ys, xs)
    end
end

# * ===== ===== ===== ===== EtherDevice ===== ===== ===== ===== * #

struct EtherDevice{Ti <: Integer, Tf <: AbstractFloat, Tb <: KernelAbstractions.Backend, Id} <:
       AbstractEtherDevice{Ti, Tf, Tb, Id} end

@inline function EtherDevice{
    Ti,
    Tf,
    Tb,
}()::EtherDevice{Ti, Tf, Tb, 1} where {Ti <: Integer, Tf <: AbstractFloat, Tb <: KernelAbstractions.Backend}
    return EtherDevice{Ti, Tf, Tb, 1}()
end

@inline function EtherDevice{
    Ti,
    Tf,
}()::EtherDevice{Ti, Tf, KernelAbstractions.CPU, 1} where {Ti <: Integer, Tf <: AbstractFloat}
    return EtherDevice{Ti, Tf, KernelAbstractions.CPU, 1}()
end

end # module EtherDevices
