using Modbus

regs = Register[0x1d25, 0x80f6, 0x6f58, 0xd936, 0xda1d, 0x2910, 0x2b81, 0x3509,
                0x9758, 0x1893, 0x510a, 0xad8b]

regs_cchar = Cchar[29, 37, -128, -10, 111, 88, -39, 54, -38, 29, 41, 16, 43, -127, 53, 9, -105, 88, 24, -109, 81, 10, -83, -117]
regs_cuchar = Cuchar[0x1d, 0x25, 0x80, 0xf6, 0x6f, 0x58, 0xd9, 0x36, 0xda,0x1d, 0x29, 0x10, 0x2b, 0x81, 0x35, 0x09, 0x97, 0x58, 0x18, 0x93, 0x51, 0x0a, 0xad, 0x8b]
regs_cshort = Cshort[7461, -32522, 28504, -9930, -9699, 10512, 11137, 13577, -26792, 6291, 20746, -21109]
regs_cushort = Cushort[0x1d25, 0x80f6, 0x6f58, 0xd936, 0xda1d, 0x2910, 0x2b81, 0x3509, 0x9758, 0x1893, 0x510a, 0xad8b,]
regs_float16 = Float16[0.005024, -1.4663e-5, 7520.0, -166.75, -195.63, 0.039551, 0.058624, 0.3147, -0.0017929, 0.0022335, 40.313, -0.086609,]
regs_cint = Cint[488997110, 1868093750, -635623152, 729888009, -1755834221, 1359654283]
regs_cuint = Cuint[0x1d2580f6, 0x6f58d936, 0xda1d2910, 0x2b813509, 0x97581893, 0x510aad8b]
regs_cfloat = Cfloat[2.19042e-21, 6.71114e28, -1.10592e16, 9.18072e-13, -6.98244e-25, 3.72261e10]
regs_clong = Clong[2100226595777534262, -2729980646761089783, -7541250553853465205]
regs_culong = Culong[0x1d2580f61d25d936, 0xda1d2910da1d3509, 0x975818939758ad8b]
regs_cdouble = Cdouble[2.84896e-168, -1.23371e126, -3.2235e-196]

@test modbus_convert_regs(regs, Cchar) == regs_cchar
@test modbus_convert_regs(regs, Cuchar) == regs_cuchar
@test modbus_convert_regs(regs, Cshort) == regs_cshort
@test modbus_convert_regs(regs, Cushort) == regs_cushort
@test modbus_convert_regs(regs, Float16) == regs_float16
@test modbus_convert_regs(regs, Cint) == regs_cint
@test modbus_convert_regs(regs, Cuint) == regs_cuint
@test modbus_convert_regs(regs, Cfloat) == regs_cfloat
@test modbus_convert_regs(regs, Clong) == regs_clong
@test modbus_convert_regs(regs, Culong) == regs_culong
@test modbus_convert_regs(regs, Cdouble) == regs_cdouble
