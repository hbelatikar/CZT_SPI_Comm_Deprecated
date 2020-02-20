-- (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:module_ref:CZT_SPI_Comm:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY BD_wo_axi_CZT_SPI_Comm_0_0 IS
  PORT (
    wr_req : IN STD_LOGIC;
    rd_req : IN STD_LOGIC;
    rd_command : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    wr_command : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    data_write_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    data_read : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    read_value_out : OUT STD_LOGIC;
    MISO : IN STD_LOGIC;
    SSbar : OUT STD_LOGIC;
    MOSI : OUT STD_LOGIC;
    SCK : OUT STD_LOGIC;
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    rd_avail : OUT STD_LOGIC;
    event_avail : OUT STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_tlast : OUT STD_LOGIC
  );
END BD_wo_axi_CZT_SPI_Comm_0_0;

ARCHITECTURE BD_wo_axi_CZT_SPI_Comm_0_0_arch OF BD_wo_axi_CZT_SPI_Comm_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF BD_wo_axi_CZT_SPI_Comm_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT CZT_SPI_Comm IS
    PORT (
      wr_req : IN STD_LOGIC;
      rd_req : IN STD_LOGIC;
      rd_command : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      wr_command : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      data_write_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      data_read : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      read_value_out : OUT STD_LOGIC;
      MISO : IN STD_LOGIC;
      SSbar : OUT STD_LOGIC;
      MOSI : OUT STD_LOGIC;
      SCK : OUT STD_LOGIC;
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      rd_avail : OUT STD_LOGIC;
      event_avail : OUT STD_LOGIC;
      m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axis_tlast : OUT STD_LOGIC
    );
  END COMPONENT CZT_SPI_Comm;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF BD_wo_axi_CZT_SPI_Comm_0_0_arch: ARCHITECTURE IS "CZT_SPI_Comm,Vivado 2019.1";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF BD_wo_axi_CZT_SPI_Comm_0_0_arch : ARCHITECTURE IS "BD_wo_axi_CZT_SPI_Comm_0_0,CZT_SPI_Comm,{}";
  ATTRIBUTE CORE_GENERATION_INFO : STRING;
  ATTRIBUTE CORE_GENERATION_INFO OF BD_wo_axi_CZT_SPI_Comm_0_0_arch: ARCHITECTURE IS "BD_wo_axi_CZT_SPI_Comm_0_0,CZT_SPI_Comm,{x_ipProduct=Vivado 2019.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=CZT_SPI_Comm,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED}";
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF BD_wo_axi_CZT_SPI_Comm_0_0_arch: ARCHITECTURE IS "module_ref";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 m_axis TLAST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF m_axis_tdata: SIGNAL IS "XIL_INTERFACENAME m_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 10000000, PHASE 0.000, CLK_DOMAIN BD_wo_axi_processing_system7_0_0_FCLK_CLK1, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 m_axis TDATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF reset: SIGNAL IS "XIL_INTERFACENAME reset, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF reset: SIGNAL IS "xilinx.com:signal:reset:1.0 reset RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF clk: SIGNAL IS "XIL_INTERFACENAME clk, ASSOCIATED_BUSIF m_axis, ASSOCIATED_RESET reset, FREQ_HZ 10000000, PHASE 0.000, CLK_DOMAIN BD_wo_axi_processing_system7_0_0_FCLK_CLK1, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF clk: SIGNAL IS "xilinx.com:signal:clock:1.0 clk CLK";
BEGIN
  U0 : CZT_SPI_Comm
    PORT MAP (
      wr_req => wr_req,
      rd_req => rd_req,
      rd_command => rd_command,
      wr_command => wr_command,
      data_write_in => data_write_in,
      data_read => data_read,
      read_value_out => read_value_out,
      MISO => MISO,
      SSbar => SSbar,
      MOSI => MOSI,
      SCK => SCK,
      clk => clk,
      reset => reset,
      rd_avail => rd_avail,
      event_avail => event_avail,
      m_axis_tdata => m_axis_tdata,
      m_axis_tlast => m_axis_tlast
    );
END BD_wo_axi_CZT_SPI_Comm_0_0_arch;
