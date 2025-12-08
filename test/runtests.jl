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

const kBackend = CPU()

@testset "deviceman transfer" begin
    dm = EtherDevices.DeviceMan{Int32, Float32, 1}()
    @test dm(42) isa Int32
    @test dm(3.14) isa Float32
    @test dm.([1, 2, 3]) == Int32[1, 2, 3]
    @test dm.([1.0, 2.0, 3.0]) == Float32[1.0, 2.0, 3.0]
    @test EtherDevices.switch!(dm, kBackend) === nothing
    EtherDevices.switch!(dm, kBackend)
    @test EtherDevices.zeroi(dm, kBackend, 2, 2) == zeros(Int32, 2, 2)
    @test EtherDevices.zerof(dm, kBackend, 2, 2) == zeros(Float32, 2, 2)
end