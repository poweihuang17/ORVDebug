`define DMI_ADDR_WIDTH 12

`define DMI_ADDR_ABSTRACT_DATA0   12'h04
`define DMI_ADDR_ABSTRACT_DATA1   12'h0f

//DM control
`define DMI_ADDR_DMCONTROL        12'h10
`define DMI_ADDR_DMSTATUS         12'h11

//Hart info
`define DMI_ADDR_HARTINFO         12'h12
`define DMI_ADDR_HARTSUMMARY      12'h13

//For multi-hart debug
`define DMI_ADDR_HART_ARRAY_WINDOW_SELECT 12'h14
`define DMI_ADDR_HART_ARRAY_WINDOW_SELECT 12'h15

//For Abstract command`
`define DMI_ADDR_ABSTRACT_CONTROL_STATUS  12'h16
`define DMI_ADDR_ABSTRACT_COMMAND         12'h17
`define DMI_ADDR_ABSTRACT_COMMAND_AUTOEXEC 12'h18

//Configuration String
`define CONFIGURATION_STRING_ADDR0        12'h19
`define CONFIGURATION_STRING_ADDR1        12'h1a
`define CONFIGURATION_STRING_ADDR2        12'h1b
`define CONFIGURATION_STRING_ADDR3        12'h1c

//Program buffer
`define PROGRAM_BUFFER_0                  12'h20
`define PROGRAM_BUFFER_1                  12'h2f

//Authentication data
`define AUTHENTICATION_DATA               12'h30

//Serial
`define SERIAL_CONTROL_AND_STATUS         12'h34
`define SERIAL_TX_DATA                    12'h35
`define SERIAL_RX_DATA                    12'h36

//System Bus
`define SYSTEM_BUS_ACCESS_CONTROL_AND_STATUS   12'h38
`define SYSTEM_BUS_ADDRESS_0                   12'h39
`define SYSTEM_BUS_ADDRESS_1                   12'h3a
`define SYSTEM_BUS_ADDRESS_2                   12'h3b

`define SYSTEM_BUS_DATA_0                      12'h3c
`define SYSTEM_BUS_DATA_1                      12'h3d
`define SYSTEM_BUS_DATA_2                      12'h3e
`define SYSTEM_BUS_DATA_3                      12'h3f
