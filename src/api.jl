export modbus_new_tcp, modbus_connect, modbus_read_registers,
       modbus_close, modbus_free, modbus_set_slave, modbus_convert_regs,
       modbus_error_handler, modbus_set_response_timeout

"""
Returns a `ModbusCtx` object given the `ip` address and the `port`. Default 
`port` is `MODBUS_TCP_DEFAULT_PORT` (502).
"""
function modbus_new_tcp(ip::String, port=MODBUS_TCP_DEFAULT_PORT)
    c_ip = pointer(ip)
    c_port = convert(Cint, port)
    modbus_ctx = ccall((:modbus_new_tcp, "libmodbus"), ModbusCtx,
                       (Ptr{Cchar}, Cint, ), c_ip, c_port)

    modbus_error_handler(modbus_ctx == C_NULL,
                         "`modbus_new_tcp` returned a null pointer.")

    return modbus_ctx
end

"""
Set the slave unit id `slave`.
"""
function modbus_set_slave(ctx::ModbusCtx, slave)
    c_slave = convert(Cint, slave)
    status = ccall((:modbus_set_slave, "libmodbus"), Cint, (ModbusCtx, Cint, ),
                   ctx, c_slave)
    modbus_error_handler(status == -1,
                         "`modbus_set_slave` failed. Returned -1.")
end

"""
Connects the backend of the modbus context `ctx`.
"""
function modbus_connect(ctx::ModbusCtx)
    status = ccall((:modbus_connect, "libmodbus"), Cint, (ModbusCtx, ), ctx)

    modbus_error_handler(status == -1, "`modbus_connect` failed. Returned -1.")
end

"""
Reads the holding registers of remote device and puts the data into an array.
 `addr` is the address of the starting register. `nb` is the number of registers
 to read. Returns a julia array containing the read data.
"""
function modbus_read_registers(ctx::ModbusCtx, addr, nb)
    c_addr = convert(Cint, addr)
    c_nb = convert(Cint, nb)
    dest = zeros(Register, nb)
    status = ccall((:modbus_read_registers, "libmodbus"), Cint,
                   (ModbusCtx, Cint, Cint, Ptr{Register}, ),
                   ctx, c_addr, c_nb, pointer(dest))

    modbus_error_handler(status == -1,
                         "`modbus_read_registers` failed. Returned -1.")

    return dest
end

"""
Close the modbus connection opened with modbus connect.
"""
function modbus_close(ctx::ModbusCtx)
    ccall((:modbus_close, "libmodbus"), Void, (ModbusCtx, ), ctx)
end

"""
Free the memory allocated to `ctx` by `modbus_new_tcp`.
"""
function modbus_free(ctx::ModbusCtx)
    ccall((:modbus_free, "libmodbus"), Void, (ModbusCtx, ), ctx)
end

"""
A handy wrapper to modbus_strerror() that also passes the libc errno to it.
 Raises an error if `condition` is true and prints the message `msg` followed
 by the output string of modbus_strerror.
"""
function modbus_error_handler(condition, msg)
    if condition
        errstr = msg
        @compat errno = Libc.errno()
        modbus_errstr = bytestring(ccall((:modbus_strerror, "libmodbus"),
                                         Ptr{Cchar}, (Cint, ), errno))
        error(errstr * "\nModbus Error: " * modbus_errstr)
    end
end

"""
Set response timeout in seconds and micro seconds.
"""
function modbus_set_response_timeout(ctx::ModbusCtx, to_sec, to_usec)
    c_sec = convert(Cuint, to_sec)
    c_usec = convert(Cuint, to_usec)
    status = ccall((:modbus_set_response_timeout, "libmodbus"), Cint,
                   (ModbusCtx, Cuint, Cuint), ctx, c_sec, c_usec)
    modbus_error_handler(status == -1,
                         "`modbus_set_response_timeout` failed.")
end

"""
Return an array whose elements are of type `typ` given the 16-bit
 register array `regs`.
"""
function modbus_convert_regs(regs::Array{Register}, typ::DataType,
                               endian=MODBUS_LITTLE_ENDIAN)
    nbytes = sizeof(typ)
    ret_arr = None

    if nbytes == 1 # Cchar or Cuchar
        ret_arr = Array(typ, length(regs) * 2)

        for i = 1:length(regs)
            ret_arr[2*i - 1] = convert(typ, regs[i] >> 8) # MSB
            ret_arr[2*i] = convert(typ, regs[i]) # LSB
        end

    elseif nbytes == 2 # Cshort, Cushort or Float16
        return map(x -> reinterpret(typ, x), regs)

    elseif nbytes == 4 # Cint, Cuint or Cfloat
        if (length(regs) % 2) != 0
            error("Size of array not a multiple of 4, cannot convert to $typ")
        end

        ret_arr = Array(typ, length(regs) >> 1)

        for i = 1:2:length(regs)
             lsb = convert(Cuint, regs[i])
             msb = convert(Cuint, regs[i+1])

             if (endian == MODBUS_LITTLE_ENDIAN)
                 val = reinterpret(typ, (lsb << 16) | msb)
             else
                 val = reinterpret(typ, (msb << 16) | lsb)
             end

             ret_arr[convert(Int, trunc(i/2)) + 1] = val
        end

    elseif nbytes == 8 # Clong, Culong or Cdouble
        if (length(regs) % 4) != 0
            error("Size of array not a multiple of 4, cannot convert to $typ")
        end

        ret_arr = Array(typ, length(regs) >> 2)

        for i = 1:4:length(regs)
            lsbl = convert(Culong, regs[i])
            lsbh = convert(Culong, regs[i+1])
            msbl = convert(Culong, regs[i])
            msbh = convert(Culong, regs[i+3])

            if (endian == MODBUS_LITTLE_ENDIAN)
                val = reinterpret(typ, (lsbl << 48) | (lsbh << 32) |
                                  (msbl << 16) | msbh)
            else
                val = reinterpret(typ, (msbh << 48) | (msbl << 32) |
                                  (lsbh << 16) | lsbl)
            end

            ret_arr[convert(Int, trunc(i/4)) + 1] = val
        end

    else
        error("`get_regs_as` type $typ not supported!")
    end

    return ret_arr
end
