`include "DM_parameters.vh"
`include "dmi_addr_map.vh"

module DM(
  //For DM itself
  input reset;
  input clk;

  //DMI & DTM interface
  input [`ADDRESS_SIZE-1:0] DMI_raddr;
  input [`ADDRESS_SIZE-1:0] DMI_waddr;
  input [31:0] DMI_wdata;
  input write_en;
  input read_en;
  output [31:0] rdata;

  //Core interface
  //For halt control
  output haltreq;
  output resumereq;

  //For abstract command;
  output [12:0] register_index;

);

//DM register declaration
reg [31:0] abstract_data_0;
reg [31:0] abstract_data_1;
reg [31:0] dmcontrol;
reg [31:0] dmstatus;
reg [31:0] hart_info;
reg [31:0] hart_summary;
reg [31:0] hart_array_window_select;
reg [31:0] hart_array_window;
reg [31:0] abstractcs;
reg [31:0] command;
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


//For core control
  haltreq = dmcontrol[31]? 1'b1: 1'b0;
  resumereq = dmcontrol[30]? 1'b1:1'b0;


//For abstract command execution
  wire [31:0] abstractcs_next;
  always@(posedge reset or posedge clk)
    begin
    if(reset)
      abstractcs[12] <=1'b0;
    else
      abstractcs[12] <= ( write_en? 1'b1: abstractcs[12]);
    end



  assign register_index=command[15:0];
always@(*)
  begin
  case(command[31:24])
    8'd0:

  end

//State machine of Figure 3.1
  reg [`DM_STATE_WIDTH-1] dm_state;
  wire [`DM_STATE_WIDTH-1] dm_state_next;

always@(posedge reset or posedge clk)
  begin
  if(reset)
    dm_state<=`DM_STATE_WIDTH'd0;
  else
    dm_state<=dm_state_next;

always@(*)
  begin
  
  case(dm_state)
    `DM_MUSH_MODE:
      begin
      end

  end
endmodule
