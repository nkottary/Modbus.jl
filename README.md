# Modbus.jl

A julia interface to the [libmodbus](http://www.libmodbus.org) C library.

# Installation

To get the master version:

```
Pkg.clone("https://github.com/nkottary/Modbus.jl")
```

# Basic Usage

```
# Create a modbus context with the necessary data.
ctx = Modbus.modbus_new_tcp("192.168.0.109", 502)

# Start the connection.
Modbus.modbus_connect(ctx)

# Read 10 registers from address 2999
dest = Modbus.modbus_read_registers(ctx, 2999, 10)

# Show the data recieved
@show dest

# Close the connection
Modbus.modbus_close(ctx)

# Free memory allocated to context
Modbus.modbus_free(ctx)
```

# Tests

I have used the java program [ModbusPal](http://modbuspal.sourceforge.net/) to
 simulate a slave on localhost. The first registers of the slave is made to
 increment from 0 to 65535 and cycle.

## ModbusPal setup

![alt tag](https://raw.githubusercontent.com/nkottary/Modbus.jl/master/screenshots/ModbusPalSetup.png)

## Julia output

![alt tag](https://raw.githubusercontent.com/nkottary/Modbus.jl/master/screenshots/JuliaOutput.png)


