
################################################################
# This is a generated script based on design: BD_wo_axi
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source BD_wo_axi_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# CZT_SPI_Comm, Serial_to_Parallel, Time_Stamp

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
   set_property BOARD_PART digilentinc.com:zybo-z7-10:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name BD_wo_axi

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  set UART_1_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_1_0 ]


  # Create ports
  set MISO_0 [ create_bd_port -dir I MISO_0 ]
  set MOSI_0 [ create_bd_port -dir O MOSI_0 ]
  set SCK_0 [ create_bd_port -dir O SCK_0 ]
  set SSbar_0 [ create_bd_port -dir O SSbar_0 ]

  # Create instance: CZT_Data_RW, and set properties
  set CZT_Data_RW [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CZT_Data_RW ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_INPUTS_2 {0} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO2_WIDTH {32} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {1} \
 ] $CZT_Data_RW

  # Create instance: CZT_SPI_Comm_0, and set properties
  set block_name CZT_SPI_Comm
  set block_cell_name CZT_SPI_Comm_0
  if { [catch {set CZT_SPI_Comm_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $CZT_SPI_Comm_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {10000000} \
   CONFIG.CLK_DOMAIN {BD_wo_axi_processing_system7_0_0_FCLK_CLK1} \
 ] [get_bd_pins /CZT_SPI_Comm_0/clk]

  # Create instance: CZT_SPI_Comm_ILA, and set properties
  set CZT_SPI_Comm_ILA [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 CZT_SPI_Comm_ILA ]
  set_property -dict [ list \
   CONFIG.C_BRAM_CNT {1.5} \
   CONFIG.C_MON_TYPE {NATIVE} \
   CONFIG.C_NUM_OF_PROBES {7} \
   CONFIG.C_PROBE4_WIDTH {32} \
   CONFIG.C_PROBE_WIDTH_PROPAGATION {MANUAL} \
 ] $CZT_SPI_Comm_ILA

  # Create instance: CZT_WR_Req, and set properties
  set CZT_WR_Req [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 CZT_WR_Req ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO2_WIDTH {1} \
   CONFIG.C_GPIO_WIDTH {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $CZT_WR_Req

  # Create instance: Cmd_Out, and set properties
  set Cmd_Out [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 Cmd_Out ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {10} \
 ] $Cmd_Out

  # Create instance: FIFO_Full_Empty, and set properties
  set FIFO_Full_Empty [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 FIFO_Full_Empty ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_GPIO2_WIDTH {1} \
   CONFIG.C_GPIO_WIDTH {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $FIFO_Full_Empty

  # Create instance: FIFO_ILA, and set properties
  set FIFO_ILA [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 FIFO_ILA ]
  set_property -dict [ list \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {16} \
   CONFIG.C_PROBE0_WIDTH {32} \
   CONFIG.C_PROBE12_WIDTH {15} \
   CONFIG.C_PROBE13_WIDTH {14} \
   CONFIG.C_PROBE1_WIDTH {32} \
   CONFIG.C_PROBE2_WIDTH {64} \
 ] $FIFO_ILA

  # Create instance: FIFO_Read_Data, and set properties
  set FIFO_Read_Data [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 FIFO_Read_Data ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO2_WIDTH {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $FIFO_Read_Data

  # Create instance: Serial_to_Parallel_0, and set properties
  set block_name Serial_to_Parallel
  set block_cell_name Serial_to_Parallel_0
  if { [catch {set Serial_to_Parallel_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Serial_to_Parallel_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {10000000} \
   CONFIG.CLK_DOMAIN {BD_wo_axi_processing_system7_0_0_FCLK_CLK1} \
 ] [get_bd_pins /Serial_to_Parallel_0/clk]

  # Create instance: Time_Stamp_0, and set properties
  set block_name Time_Stamp
  set block_cell_name Time_Stamp_0
  if { [catch {set Time_Stamp_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Time_Stamp_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {10000000} \
   CONFIG.CLK_DOMAIN {BD_wo_axi_processing_system7_0_0_FCLK_CLK1} \
 ] [get_bd_pins /Time_Stamp_0/clk]

  # Create instance: axi_clock_converter_0, and set properties
  set axi_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_converter_0 ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {5} \
 ] $axi_interconnect_0

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
  set_property -dict [ list \
   CONFIG.Almost_Empty_Flag {true} \
   CONFIG.Almost_Full_Flag {true} \
   CONFIG.Data_Count_Width {14} \
   CONFIG.Empty_Threshold_Assert_Value {1000} \
   CONFIG.Empty_Threshold_Negate_Value {1001} \
   CONFIG.Enable_Safety_Circuit {false} \
   CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} \
   CONFIG.Full_Flags_Reset_Value {1} \
   CONFIG.Full_Threshold_Assert_Value {15000} \
   CONFIG.Full_Threshold_Negate_Value {14999} \
   CONFIG.Input_Data_Width {64} \
   CONFIG.Input_Depth {16384} \
   CONFIG.Output_Data_Width {32} \
   CONFIG.Output_Depth {32768} \
   CONFIG.Overflow_Flag {true} \
   CONFIG.Programmable_Empty_Type {Single_Programmable_Empty_Threshold_Constant} \
   CONFIG.Programmable_Full_Type {Single_Programmable_Full_Threshold_Constant} \
   CONFIG.Read_Data_Count {true} \
   CONFIG.Read_Data_Count_Width {15} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.Write_Acknowledge_Flag {true} \
   CONFIG.Write_Data_Count {true} \
   CONFIG.Write_Data_Count_Width {14} \
 ] $fifo_generator_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {50000000} \
   CONFIG.PCW_CLK1_FREQ {10000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_EMIO_GPIO {1} \
   CONFIG.PCW_EN_EMIO_UART1 {1} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {4} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {16} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {10} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {10} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_EMIO_GPIO_IO {1} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {1} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {48} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1600.000} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {EMIO} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {16} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
 ] $processing_system7_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {32} \
   CONFIG.IN1_WIDTH {32} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_clock_converter_0/M_AXI] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins Cmd_Out/S_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins CZT_WR_Req/S_AXI] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins FIFO_Full_Empty/S_AXI] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins CZT_Data_RW/S_AXI] [get_bd_intf_pins axi_interconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins FIFO_Read_Data/S_AXI] [get_bd_intf_pins axi_interconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins axi_clock_converter_0/S_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]
  connect_bd_intf_net -intf_net processing_system7_0_UART_1 [get_bd_intf_ports UART_1_0] [get_bd_intf_pins processing_system7_0/UART_1]

  # Create port connections
  connect_bd_net -net CZT_Data_RW_gpio2_io_o [get_bd_pins CZT_Data_RW/gpio2_io_o] [get_bd_pins CZT_SPI_Comm_0/data_write_in]
  connect_bd_net -net CZT_SPI_Comm_0_MOSI [get_bd_ports MOSI_0] [get_bd_pins CZT_SPI_Comm_0/MOSI] [get_bd_pins CZT_SPI_Comm_ILA/probe2]
  connect_bd_net -net CZT_SPI_Comm_0_SCK [get_bd_ports SCK_0] [get_bd_pins CZT_SPI_Comm_0/SCK]
  connect_bd_net -net CZT_SPI_Comm_0_SSbar [get_bd_ports SSbar_0] [get_bd_pins CZT_SPI_Comm_0/SSbar] [get_bd_pins CZT_SPI_Comm_ILA/probe1] [get_bd_pins FIFO_ILA/probe8]
  connect_bd_net -net CZT_SPI_Comm_0_data_read [get_bd_pins CZT_Data_RW/gpio_io_i] [get_bd_pins CZT_SPI_Comm_0/data_read] [get_bd_pins CZT_SPI_Comm_ILA/probe4]
  connect_bd_net -net CZT_SPI_Comm_0_event_avail [get_bd_pins CZT_SPI_Comm_0/event_avail] [get_bd_pins FIFO_ILA/probe15] [get_bd_pins Serial_to_Parallel_0/trigger_in]
  connect_bd_net -net CZT_SPI_Comm_0_rd_avail [get_bd_pins CZT_SPI_Comm_0/rd_avail] [get_bd_pins CZT_SPI_Comm_ILA/probe5] [get_bd_pins processing_system7_0/GPIO_I]
  connect_bd_net -net CZT_SPI_Comm_0_read_value_out [get_bd_pins CZT_SPI_Comm_0/read_value_out] [get_bd_pins Serial_to_Parallel_0/Serial_in]
  connect_bd_net -net CZT_WR_Req_gpio2_io_o [get_bd_pins CZT_SPI_Comm_0/rd_req] [get_bd_pins CZT_SPI_Comm_ILA/probe6] [get_bd_pins CZT_WR_Req/gpio2_io_o]
  connect_bd_net -net CZT_WR_Req_gpio_io_o [get_bd_pins CZT_SPI_Comm_0/wr_req] [get_bd_pins CZT_WR_Req/gpio_io_o]
  connect_bd_net -net FIFO_Read_Data_gpio2_io_o [get_bd_pins FIFO_ILA/probe5] [get_bd_pins FIFO_Read_Data/gpio2_io_o] [get_bd_pins fifo_generator_0/rd_clk]
  connect_bd_net -net MISO_1 [get_bd_ports MISO_0] [get_bd_pins CZT_SPI_Comm_0/MISO] [get_bd_pins CZT_SPI_Comm_ILA/probe3] [get_bd_pins FIFO_ILA/probe9]
  connect_bd_net -net Net [get_bd_pins CZT_SPI_Comm_0/rd_command] [get_bd_pins CZT_SPI_Comm_0/wr_command] [get_bd_pins Cmd_Out/gpio_io_o]
  connect_bd_net -net Serial_to_Parallel_0_Parallel [get_bd_pins FIFO_ILA/probe0] [get_bd_pins Serial_to_Parallel_0/Parallel] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net Time_Stamp_0_Cycle_count [get_bd_pins FIFO_ILA/probe1] [get_bd_pins Time_Stamp_0/Cycle_count] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net Time_Stamp_0_overflow [get_bd_pins FIFO_ILA/probe14] [get_bd_pins Time_Stamp_0/overflow]
  connect_bd_net -net fifo_generator_0_dout [get_bd_pins FIFO_ILA/probe3] [get_bd_pins FIFO_Read_Data/gpio_io_i] [get_bd_pins fifo_generator_0/dout]
  connect_bd_net -net fifo_generator_0_overflow [get_bd_pins FIFO_ILA/probe11] [get_bd_pins fifo_generator_0/overflow]
  connect_bd_net -net fifo_generator_0_prog_empty [get_bd_pins FIFO_Full_Empty/gpio2_io_i] [get_bd_pins FIFO_ILA/probe7] [get_bd_pins fifo_generator_0/prog_empty]
  connect_bd_net -net fifo_generator_0_prog_full [get_bd_pins FIFO_Full_Empty/gpio_io_i] [get_bd_pins FIFO_ILA/probe6] [get_bd_pins fifo_generator_0/prog_full]
  connect_bd_net -net fifo_generator_0_rd_data_count [get_bd_pins FIFO_ILA/probe12] [get_bd_pins fifo_generator_0/rd_data_count]
  connect_bd_net -net fifo_generator_0_wr_ack [get_bd_pins FIFO_ILA/probe10] [get_bd_pins fifo_generator_0/wr_ack]
  connect_bd_net -net fifo_generator_0_wr_data_count [get_bd_pins FIFO_ILA/probe13] [get_bd_pins fifo_generator_0/wr_data_count]
  connect_bd_net -net m_axis_tlast_wire [get_bd_pins CZT_SPI_Comm_0/m_axis_tlast] [get_bd_pins FIFO_ILA/probe4] [get_bd_pins Serial_to_Parallel_0/end_in] [get_bd_pins Time_Stamp_0/tlast_trigger] [get_bd_pins fifo_generator_0/wr_clk]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins CZT_Data_RW/s_axi_aresetn] [get_bd_pins CZT_SPI_Comm_0/reset] [get_bd_pins CZT_WR_Req/s_axi_aresetn] [get_bd_pins Cmd_Out/s_axi_aresetn] [get_bd_pins FIFO_Full_Empty/s_axi_aresetn] [get_bd_pins FIFO_Read_Data/s_axi_aresetn] [get_bd_pins Serial_to_Parallel_0/reset] [get_bd_pins Time_Stamp_0/reset] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins fifo_generator_0/rd_en] [get_bd_pins fifo_generator_0/rst] [get_bd_pins fifo_generator_0/wr_en] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_clock_converter_0/s_axi_aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins CZT_Data_RW/s_axi_aclk] [get_bd_pins CZT_SPI_Comm_0/clk] [get_bd_pins CZT_SPI_Comm_ILA/clk] [get_bd_pins CZT_WR_Req/s_axi_aclk] [get_bd_pins Cmd_Out/s_axi_aclk] [get_bd_pins FIFO_Full_Empty/s_axi_aclk] [get_bd_pins FIFO_ILA/clk] [get_bd_pins FIFO_Read_Data/s_axi_aclk] [get_bd_pins Serial_to_Parallel_0/clk] [get_bd_pins Time_Stamp_0/clk] [get_bd_pins axi_clock_converter_0/m_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins axi_clock_converter_0/m_axi_aresetn] [get_bd_pins axi_clock_converter_0/s_axi_aresetn] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins FIFO_ILA/probe2] [get_bd_pins fifo_generator_0/din] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs CZT_Data_RW/S_AXI/Reg] SEG_CZT_Data_RW_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41210000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs CZT_WR_Req/S_AXI/Reg] SEG_CZT_WR_Req_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41220000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs Cmd_Out/S_AXI/Reg] SEG_Cmd_Out_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41230000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs FIFO_Full_Empty/S_AXI/Reg] SEG_FIFO_Full_Empty_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41240000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs FIFO_Read_Data/S_AXI/Reg] SEG_FIFO_Read_Data_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


