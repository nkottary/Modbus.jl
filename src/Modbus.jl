"""
Modbus.jl is an interface to the [libmodbus](http://www.libmodbus.org) C library.
"""
module Modbus

using Compat

include("consts.jl")
include("types.jl")
include("api.jl")

end # end module
