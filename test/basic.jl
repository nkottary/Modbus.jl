using Modbus

function basic_test()
    ctx = Modbus.modbus_new_tcp("192.168.0.109", 502)
    Modbus.modbus_connect(ctx)
    
    dest = Modbus.modbus_read_registers(ctx, 2999, 10)
    @show dest
    
    Modbus.modbus_close(ctx)
    Modbus.modbus_free(ctx)
end

basic_test()
