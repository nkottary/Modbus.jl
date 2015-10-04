export CModbusCtx, ModbusCtx, Register

"""
Mirror of `struct timeval` found in sys/time.h.
"""
type Ctimeval
    tv_sec::Clong    
    tv_usec::Clong
end

"""
Mirror of `modbus_t` found in modbus-private.h.
"""
type CModbusCtx
    slave::Cint
    s::Cint
    debug::Cint
    error_recovery::Cint
    response_timeout::Ctimeval
    byte_timeout::Ctimeval
    backend::Ptr{Void}
    backend_data::Ptr{Void}
end

# CModbusCtx  may not  be the  right  mirror for  the corresponding  C
# struct on certain  systems. The below raw pointer  typealias is used
# by  default for  passing to  the  C calls  and can  be converted  to
# CModbusCtx if required.

"""
The Modbus context type.
"""
typealias ModbusCtx Ptr{Void}

"""
The register type: 16-bit
"""
typealias Register Cushort
