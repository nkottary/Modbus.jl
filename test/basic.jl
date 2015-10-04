using Modbus

const IP_ADDR = "127.0.0.1"
const PORT = 502
const UNIT_ID = 1
const REF_ADDR = 1
const NUM_REGS = 1

function basic_test()
    ctx = modbus_new_tcp(IP_ADDR, PORT)
    modbus_set_slave(ctx, UNIT_ID)
    modbus_connect(ctx)
    
    dest = modbus_read_registers(ctx, REF_ADDR, NUM_REGS)
    @show dest
    
    modbus_close(ctx)
    modbus_free(ctx)
end

basic_test()
