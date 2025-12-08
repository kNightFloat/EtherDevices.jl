#=
  @ author: ChenyuBao <chenyu.bao@outlook.com>
  @ date: 2025-12-08 22:09:14
  @ license: MIT
  @ language: Julia
  @ declaration: EtherDevices.jl is a package for device data management.
  @ description: main file
 =#

module EtherDevices

using KernelAbstractions

using EtherMaths: unsafe_real

abstract type AbstractDeviceMan{Ti <: Integer, Tf <: AbstractFloat, Id} end

#= NOTE:
    Ti: Integer type for data
    Tf: Floating-point type for data
    Id: Device ID
=#
struct DeviceMan{Ti <: Integer, Tf <: AbstractFloat, Id} <: AbstractDeviceMan{Ti, Tf, Id} end

@inline function (dm::DeviceMan{Ti, Tf, Id})(x::Integer)::Ti where {Ti <: Integer, Tf <: AbstractFloat, Id}
    return unsafe_real(Ti, x)
end

@inline function (dm::DeviceMan{Ti, Tf, Id})(x::AbstractFloat)::Tf where {Ti <: Integer, Tf <: AbstractFloat, Id}
    return unsafe_real(Tf, x)
end

@inline function switch!(::DeviceMan{Ti, Tf, Id}, b::Backend)::Nothing where {Ti <: Integer, Tf <: AbstractFloat, Id}
    KernelAbstractions.device!(b, Id)
    return nothing
end

@inline function zeroi(dm::DeviceMan{Ti, Tf, Id}, b::Backend, s...) where {Ti <: Integer, Tf <: AbstractFloat, Id}
    switch!(dm, b)
    return KernelAbstractions.zeros(b, Ti, s...)
end

@inline function zerof(dm::DeviceMan{Ti, Tf, Id}, b::Backend, s...) where {Ti <: Integer, Tf <: AbstractFloat, Id}
    switch!(dm, b)
    return KernelAbstractions.zeros(b, Tf, s...)
end

end # module EtherDevices
