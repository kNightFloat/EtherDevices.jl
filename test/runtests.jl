#=
  @ author: ChenyuBao <chenyu.bao@outlook.com>
  @ date: 2025-12-08 22:49:00
  @ license: MIT
  @ language: Julia
  @ declaration: EtherDevices.jl is a package for device data management.
  @ description: /
 =#

using Test

using EtherDevices
using KernelAbstractions

@testset "deviceman transfer" begin
    ed1 = EtherDevice{Int32, Float32, CPU, 1}()
    ed2 = EtherDevice{Int64, Float16, CPU, 1}()
    @test ed1(1) isa Int32
    @test ed1(3.14) isa Float32
    @test ed2(Int128(1)) isa Int64
    @test ed2(3.14) isa Float16
    switch!(ed1)
    switch!(ed2)
    ai1 = zerosi(ed1, 3, 4)
    af2 = zerosf(ed2, 3, 4)
    @test ed2(ai1) ≈ Int64.(zeros(3, 4))
    @test ed1(af2) ≈ Float32.(zeros(3, 4))
    @test get_backend(ed1) == CPU()
end
