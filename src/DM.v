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
  output dm_busy;

  //Core interface
    //For halt control
  output haltreq;
  input core_haltack;
  output resumereq;

    //For abstract command;
  output [12:0] register_index;
  output debug_write;
  output debug_read;
  output [`XPR_LEN-1:0]      debug_wdata,
  input [`XPR_LEN-1:0]       debug_rdata,
  input reg_rack;
  input reg_wack;

);

//DM register declaration
reg [31:0] abstract_data_0;
//reg [31:0] abstract_data_1;
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
  reg command_written;

always@(posedge reset or posedge clk)
  begin
  if(reset)
    dm_state<=`DM_STATE_WIDTH'd0;
  else
    dm_state<=dm_state_next;
  end

always@(*)
  begin
  //default value
  //DM status and config
  dmstatus_next=dmstatus;

  //Halt control
  haltreq=1'b0;
  resumereq=1'b0;

  //Core
  debug_write=1'b0;
  debug_read=1'b0;
  register_index=12'd0;
  debug_wdata=`XPR_LEN'd0;
  abstract_data_0_next=abstract_data_0;

  //DMI
  dm_busy=1'b0;

  case(dm_state)
    `DM_MUSH_MODE:
      begin
      if(dmcontrol[31])
        begin
        dm_state_next=`DM_HALTING;
        dmstatus_next[10]=1'b0; //anyrunning
        dmstatus_next[11]=1'b0; //allrunning
        end
      end

    `DM_HALTING:
      begin
      haltreq=1'b1;
      if(core_haltack)
        begin
        dm_state_next=`DM_HALTED;
        dmstatus_next[9]=1'b1;
        dmstatus_next[8]=1'b1;
        end
      end

    `DM_HALTED:
      begin
      if(command_written==1'b1 && command[31:24]==8'd1)
        begin
        dm_state_next=`DM_COMMAND_CHECKED;
        abstractcs_next[12]=1'b1;   //busy
        end
      end

    `DM_COMMAND_CHECKED:
      begin
      dm_busy=1'b1;
      
      //How to detect that a command is written while the DM is busy?
      if(write_en==1'b1)
        begin
        dm_state_next=`DM_ERROR_DETECTED;
        abstractcs_next[10:8]=3'd1; //cmderror
        end
      else if(command[31:24]!=8'd1)
        begin
        dm_state_next=`DM_ERROR_DETECTED;
        abstractcs_next[10:8]=3'd2; //cmderror
        end
      //Size error considered exception now.
      //How about CSR not existed?
      else if(command[22:20]!=3'd2)
        begin
        dm_state_next=`DM_ERROR_DETECTED;
        abstractcs_next[10:8]=3'd3; //cmderror
        end
      else if(dmstatus[9]==1'b0)
        begin
        dm_state_next=`DM_ERROR_DETECTED;
        abstractcs_next[10:8]=3'd4; //cmderror
        end
      //Skip cmderror=7 now for this implementation
      else
        begin
        dm_state_next=`DM_ACCESS_COMMAND_EXECUTING_1;
        abstractcs_next[10:8]=3'd0; //cmderror
        end
      end

    `DM_ACCESS_COMMAND_EXECUTING_1:
      begin

      dm_busy=1'b1;
      if(command[16]==1'b0 && command[17]==1'b1)
        begin
        debug_read=1'b1;
        register_index=command[11:0];
        if(reg_rack==1'b1)
          begin
          dm_state_next=`DM_HALTED;
          abstract_data_0_next=debug_rdata;
          end
        else
          begin
          dm_state_next=`DM_ACCESS_COMMAND_EXECUTING_1;
          end
        end
      else if(command[16]==1'b1 && command[17]==1'b1)
        begin
        debug_write=1'b1;
        register_index=command[11:0];
        debug_wdata=abstract_data_0;

        if(reg_wack==1'b1)
          begin
          dm_state_next=`DM_HALTED;
          end
        else
          begin
          dm_state_next=`DM_ACCESS_COMMAND_EXECUTING_1;
          end
        end
      else
        dm_state_next=`DM_HALTED;
      end


  endcase

  end
endmodule
