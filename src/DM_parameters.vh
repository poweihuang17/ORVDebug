`define ADDRESS_SIZE 8

//For state machine in figure 3.1 of debug spec v0.13
`define DM_STATE_WIDTH 4
`define DM_MUSH_MODE 0
`define DM_HALTING 1
`define DM_RESUMING 2
`define DM_HALTED 3
`define DM_COMMAND_EXECUTING 4
`define DM_COMMAND_DONE 5

//Still have problems about error handling
`define DM_ERROR_DETECTED 6
`define DM_ERROR_CLEANING 7
