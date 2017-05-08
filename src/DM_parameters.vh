//Width related constant
`define ADDRESS_SIZE 8
`define REG_ADDR_WIDTH  5
`define XPR_LEN        32

//For state machine in figure 3.1 of debug spec v0.13
`define DM_STATE_WIDTH 4
`define DM_MUSH_MODE 0
`define DM_HALTING 1
`define DM_RESUMING 2
`define DM_HALTED 3
`define DM_COMMAND_CHECKED 4
`define DM_ACCESS_EXECUTING_1 5
`define DM_ACCESS_COMMAND_DONE 6

//Still have problems about error handling
`define DM_ERROR_DETECTED 6
`define DM_ERROR_CLEANING 7
