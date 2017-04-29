parameter address_size=8;

module DM(
input [address_size-1:0] address;
input [31:0] register_write;
input write_en;
input read_en;
output [31:0] register_read;
);

//DM register declaration
reg [31:0] abstract_data_0;
reg [31:0] abstract_data_1;
reg [31:0] debug_module_control;
reg [31:0] debug_module_status;
reg [31:0] hart_info;
reg [31:0] hart_summary;
reg [31:0] hart_array_window_select;
reg [31:0] hart_array_window;
reg [31:0] abstract_control_and_status;
reg [31:0] abstract_command;
reg [31:0] abstract_command_autoexec;

reg [31:0] config_string_addr_0;
reg [31:0] config_string_addr_1;
reg [31:0] config_string_addr_2;
reg [31:0] config_string_addr_3;

reg [31:0] program_buffer_0;
reg [31:0] program_buffer_1;

reg [31:0] authentication_data;
reg [31:0] serial_control_and_status;
reg [31:0] serial_tx;
reg [31:0] serial_rx;

reg [31:0] system_bus_access_control_and_status;
reg [31:0] system_bus_address_0;
reg [31:0] system_bus_address_1;
reg [31:0] system_bus_address_2;
reg [31:0] system_bus_data_0;
reg [31:0] system_bus_data_1;
reg [31:0] system_bus_data_2;
reg [31:0] system_bus_data_3;


//Address decode and read/write
wire target_register;

    always@(*)
        begin
            case(address)
                0x04:
                    begin
                    target_register=abstract_data_0;
                    end
                0x0f:
                    begin
                    end

            endcase
        end


endmodule
