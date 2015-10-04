using Modbus

const IP_ADDR = "127.0.0.1"
const PORT = 502
const UNIT_ID = 1
const REF_ADDR = 0
const NUM_REGS = 2
const SLEEP_TIME = 1
const TIMEOUT_SEC = 0
const TIMEOUT_USEC = 750000

function basic_test()
    ctx = modbus_new_tcp(IP_ADDR, PORT)
    modbus_set_slave(ctx, UNIT_ID)
    modbus_set_response_timeout(ctx, TIMEOUT_SEC, TIMEOUT_USEC)
    modbus_connect(ctx)
    
    for i=1:10
        dest = modbus_read_registers(ctx, REF_ADDR, NUM_REGS)
        floatregs = modbus_convert_regs(dest, Float32)
        @show floatregs
        sleep(SLEEP_TIME)
    end
    
    modbus_close(ctx)
    modbus_free(ctx)
end

basic_test()
