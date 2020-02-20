----------------------------------------------------------------------------------
-- Institute: IIT-B
-- Engineer: Sanjoli/Hrishikesh 
-- 
-- Create Date: 02/17/2020 12:52:44 PM
-- Design Name: 
-- Module Name: CZT_SPI_Comm - Behavioral
-- Project Name: Daksha
-- Target Devices: Zybo Z7
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;

use IEEE.NUMERIC_STD.ALL;       -- Lib for arithmetic functions with Signed or Unsigned values
use IEEE.STD_LOGIC_1164.ALL;    -- Lib for bit logic functions
use IEEE.STD_LOGIC_UNSIGNED.ALL;-- Lib for logic vector arithmetic functions

entity CZT_SPI_Comm is
    port (
        -- User ports start here
            -- PS ? SPI Communicator Ports
                wr_req,rd_req    : in    std_logic;                       --Write request & Read request bits
                rd_command       : in    std_logic_vector(9 downto 0);    --Read Command bus input
                wr_command       : in    std_logic_vector(9 downto 0);    --Write command bus input
                data_write_in    : in    std_logic_vector(31 downto 0);   --Data to write bus input
            
            -- SPI Communicator ? PS Ports
                data_read        : out   std_logic_vector(31 downto 0) := (others => '0');   --Data read bus output
                read_value_out   : out   std_logic := '0';                --??
            
            --CZT ? SPI Communicator Ports
                MISO : in    std_logic := '1';  -- CZT response input bit
            
            --SPI Communicator ? CZT Ports
                SSbar: out   std_logic;  --Slave select control bit
                MOSI : out   std_logic ; --Output to CZT bit
                SCK  : out   std_logic;  --Slave clock
            
            -- PS ? SPI Communicator Ports (Housekeeping Signals)
                clk   : in std_logic;    --Communicator clock
                reset : in std_logic;    --Reset control
        -- User ports ends
        
        -- Do not modify the ports beyond this line    
                rd_avail    : out std_logic;
                event_avail : out std_logic;
            -- Ports of Axi Master Bus Interface M_AXIS
                m_axis_tdata: out std_logic_vector(31 downto 0) := (others => '0');
                m_axis_tlast: out std_logic := '0'
        -- Port declarations end
);
end CZT_SPI_Comm;

architecture Behavioral of CZT_SPI_Comm is

--	State array declaration
type t_state is (idle,done,done1,cmd_1,cmd_2,cmd_3,cmd_4,cmd_5,cmd_6,cmd_7,cmd_8,cmd_9,cmd_10,state1,data_1,data_gather,state2,event_check,event_1,event_2,event_3,event_4,event_5,event_6,event_7,event_8,event_9,event_10,event_11,event_12,event_13,event_14,event_15,event_16,event_17,event_18,event_19,event_20,event_21,event_22,event_23,event_24,event_25,event_26);

-- Signal wire declarations
signal state        : t_state;          --Wire for state array
signal rb           : std_logic := '0'; --Read busy? 
signal read_value   : std_logic;        --Read value bit
signal flag         : std_logic;        --Flag for R/W operation: W?0, R?1

signal data_write, data_read_signal : std_logic_vector(31 downto 0) := x"00000000"; --Data input and output signal wires
signal command      : std_logic_vector(9 downto 0);  --Command Signal wire

signal rd_req_vector            : std_logic_vector(9 downto 0); -- Used to check if the command provided is for read or write
signal wr_req_vector            : std_logic_vector(9 downto 0); -- Used to check if the command provided is for read or write
signal event_number             : unsigned(6 downto 0) ;        -- Not used
signal count                    : unsigned(7 downto 0) := x"00";-- Counter used to measure if event data bits
signal MOSI_var_1, MOSI_var_2   : std_logic;                    -- MOSI variables set as per parallel processes 

begin
    SCK <= clk;
    rd_req_vector <= (others => rd_req);
    wr_req_vector <= (others => wr_req);
    m_axis_tdata(31 downto 25) <= "0000000";
    command <= (rd_req_vector and rd_command) or ( wr_req_vector and wr_command);   --Command value set as per set bit
    read_value_out <= read_value;
    data_read <= data_read_signal;
    MOSI <= (MOSI_var_1 or MOSI_var_2);
    
    NEXT_STATE_FSM: process(reset,MISO,wr_req,rd_req,command,data_write,state,clk,rb,read_value)
    -- RW_DATA_FSM Variable declarations begin
        variable state_var : t_state;                           -- current-state variable
        
        variable SSbar_var      :std_logic;                     --SSbar variable
        variable data_read_out  :std_logic_vector(24 downto 0); --CZT Data read variable
        variable data_write_var :std_logic_vector(31 downto 0); --Data to write variable
    
        variable rd_avail_var : std_logic;                      --Read availabilty flag variable
    
        variable nstate_var : t_state;                          -- next-state variable
        variable tlast : std_logic;                             -- Event mode last bit flag
        variable event_avail_var : std_logic := '0';            --Event available Variable
        variable flag_var : std_logic := '0';                   -- Flag Variable
    -- RW_DATA_FSM Variable declarations end
    
    begin   --RW_DATA_FSM Process begins here
        state_var := state;         
        nstate_var := state_var;

        SSbar_var := '0';
        
        -- Output & next state sequence logic
        case state_var is
            when done1 =>
                rd_avail_var := '1';
                SSbar_var:='1';
                MOSI_var_1 <= '1';
                count <= x"00";
                if((rd_req or  wr_req) = '1')then
                    nstate_var := done1;
                else
                    nstate_var := done;
                    end if;
                    
            when done => 
                SSbar_var:='1';
                nstate_var := idle;
                MOSI_var_1 <= '1';
                count <= x"00";
                tlast := '0';
                rd_avail_var := '0';
                
            when idle =>    -- Wait till R/W request is high
                SSbar_var:='1';
                MOSI_var_1 <= '1';
                count <= x"00";
                tlast := '0';
                rd_avail_var := '0';
                if((rd_req or wr_req) ='1') then
                    nstate_var := cmd_1;
                else
                    nstate_var := idle;
                end if; 
            --------------------------------------------- Command FSM Begins ---------------------------
            when cmd_1 =>   -- Send the first command bit
                SSbar_var := '0';
                MOSI_var_1 <= command(9);
                nstate_var := cmd_2;
            when cmd_2 =>   -- Check if busy else start the R/W command sending process
                if(rb = '1') then   ---------- rb =1 means busy
                    nstate_var := idle;    
                else  
                    MOSI_var_1 <= command(8);
                    nstate_var := cmd_3;
                    if (command(8) = '0') then --------- CHECK FOR RD/WR BIT and set the flag for future operations
                        flag_var := '0';            -- 0 ? Write
                    else
                        flag_var := '1';            -- 1 ? Read
                    end if;
                end if;
            when cmd_3 =>   -- Send command bits to CZT serially
                MOSI_var_1 <= command(7);
                nstate_var := cmd_4;
            when cmd_4 =>
                MOSI_var_1 <= command(6);
                nstate_var := cmd_5;
            when cmd_5 =>
                MOSI_var_1 <= command(5);
                nstate_var := cmd_6;
            when cmd_6 =>
                MOSI_var_1 <= command(4);
                nstate_var := cmd_7;
            when cmd_7 =>
                MOSI_var_1 <= command(3);
                nstate_var := cmd_8;
            when cmd_8 =>
                MOSI_var_1 <= command(2);
                nstate_var := cmd_9;
            when cmd_9 =>
                MOSI_var_1 <= command(1);
                nstate_var := cmd_10;
            when cmd_10 =>  -- Check if data to send or receieve or no operation
                MOSI_var_1 <= command(0);
                
                if command="0100001011" then    -- Event mode? Need to check!
                    nstate_var := state2;
                elsif ((command="0000000101" ) or (command="0000001010" )or (command="0100011001" )or (command="0001101001"))then   -- No Operation Commands? Need to check!
                    nstate_var := done1;
                else   -- idk!
                    nstate_var := state1;
                end if;
-----------------------------------------  Command FSM Ends ---------------------------------0000101000          
-----------------------------------------  Read/Write FSM Begins ----------------------------------      
            when state1 =>  -- Send the first data bit
                SSbar_var := '1';
                MOSI_var_1 <= '1';
                nstate_var := data_1;

            when data_1 =>  -- Repeat state1 if busy or else begin data gathering from CZT
                MOSI_var_1 <= '1';
                SSbar_var := '0';
                if MISO = '1' then          ---------- rb =1 means busy
                    nstate_var := state1;
                else  
                    nstate_var := data_gather;
                end if;
                
            when data_gather => -- Goto done1 if count reached d'17 or else gather again
                if(count = x"11") then  
                    nstate_var := done1;
                    rd_avail_var := '1';
                    MOSI_var_1 <= '0';
                else
                    rd_avail_var := '0';
                    nstate_var := data_gather;
                end if;
            ----------------------------------- Event Mode FSM -------------------------------------------
            when state2 =>  -- Reset last bit flag & go to event_1
                tlast := '0';
                SSbar_var := '1';
                nstate_var := event_1;
                MOSI_var_1 <= '1';            
            
            when event_1 => -- Check if event exists in CZT buffer
                SSbar_var := '0';
                if MISO = '1' then              -- MISO = 1 means event does not exist
                    nstate_var := event_check;  --Wait for events in this state
                else  
                    nstate_var := event_2;      --Send data to PS from here
                    event_avail_var := '1';
                end if;                    
            
            when event_check => -- If event mode off then send command or else check again from state2
                SSbar_var := '1';
                if command = "0000001010" then
                    nstate_var := cmd_1;
                else 
                    nstate_var := state2;
                end if;
            
            when event_2 => --Send event data to PS serially
                m_axis_tdata(24) <= read_value;
                nstate_var := event_3;
                event_avail_var := '0';
            when event_3 =>
                m_axis_tdata(23) <= read_value;
                nstate_var := event_4;         
            when event_4 =>
                m_axis_tdata(22) <= read_value;
                nstate_var := event_5;
            when event_5 =>
                m_axis_tdata(21) <= read_value;
                nstate_var := event_6;           
            when event_6 =>
                m_axis_tdata(20) <= read_value;
                nstate_var := event_7;            
            when event_7 =>
                m_axis_tdata(19) <= read_value;
                nstate_var := event_8;                
            when event_8 =>
                m_axis_tdata(18) <= read_value;
                nstate_var := event_9;
            when event_9 =>
                m_axis_tdata(17) <= read_value;
                nstate_var := event_10;                
            when event_10=>
                m_axis_tdata(16) <= read_value;
                nstate_var := event_11;                   
            when event_11=>
                m_axis_tdata(15) <= read_value;
                nstate_var := event_12;                    
            when event_12=>
                m_axis_tdata(14) <= read_value;
                nstate_var := event_13;                   
            when event_13=>
                m_axis_tdata(13) <= read_value;
                nstate_var := event_14;                        
            when event_14=>
                m_axis_tdata(12) <= read_value;
                nstate_var := event_15;                       
            when event_15=>
                m_axis_tdata(11) <= read_value;
                nstate_var := event_16;                    
            when event_16=>
                m_axis_tdata(10) <= read_value;
                nstate_var := event_17;                   
            when event_17=>
                m_axis_tdata(9) <= read_value;
                nstate_var := event_18;                  
            when event_18=>
                m_axis_tdata(8) <= read_value;
                nstate_var := event_19;                   
            when event_19=>
                m_axis_tdata(7) <= read_value;
                nstate_var := event_20;                 
            when event_20=>
                m_axis_tdata(6) <= read_value;
                nstate_var := event_21;                    
            when event_21=>
                m_axis_tdata(5) <= read_value;
                nstate_var := event_22;                    
            when event_22=>
                m_axis_tdata(4) <= read_value;
                nstate_var := event_23;                   
            when event_23=>
                m_axis_tdata(3) <= read_value;
                nstate_var := event_24;                   
            when event_24=>
                m_axis_tdata(2) <= read_value;
                nstate_var := event_25;                    
            when event_25=>
                m_axis_tdata(1) <= read_value;
                nstate_var := event_26;                    
            when event_26=> --Set last bit flag and go back to state 2
                m_axis_tdata(0) <= read_value;
                nstate_var := state2;
                tlast := '1';
            -----------------------------------------------------------------------------------------------------------------
        end case;

        flag <= flag_var;   -- Assign R/W Flag variable to Flag signal
        SSbar <= SSbar_var; -- Assign SSbar signal as per the variable
        
        -- Next Sequence Logic as per clock
        if(reset = '0') then    --active low reset
            state<= idle;
        elsif(clk'event and clk = '1') then
            state<= nstate_var;
        end if;

        -- Data Gathering & CZT Busy handler
        if(clk'event and clk = '1') then
            if(nstate_var = data_gather) then   --Check if we have to gather data from CZT
                count <= count + 1;  
            else
                count <= x"00";
            end if;

            if((nstate_var = cmd_2) ) then      --CZT Busy handler
                rb <= MISO;
            else
                rb <= '0';
            end if;

            m_axis_tlast <= tlast;              --Push event data last bit reached flag to PS
            event_avail <= event_avail_var;     --Push event available flag to PS
        end if;

        -- Hold MISO value in read_value at every set clk
        if(clk = '1') then      
            read_value<= MISO;
        end if;
        
    end process NEXT_STATE_FSM;


    CURRENT_STATE_FSM: process(clk)
    begin
        if((rising_edge(clk)) and (reset='1'))then
            if(state = idle) then -- Keep MOSI low & store data to write in data_write in idle
                data_write <= data_write_in;    
                MOSI_var_2 <= '0';
                
            elsif(state = data_1) then -- Push or pull data over external lines
                MOSI_var_2 <= data_write(16);   --Push stored write data over MOSI line
                data_read_signal(0) <= read_value;  -- Store read_value in read data wire
            
            elsif(state = data_gather) then -- Read or write event data as per the R/W flag value
                if (flag = '0') then    -- CHECK FOR RD/WR BIT  -- 0 means write
                    MOSI_var_2      <= data_write(15);
                    data_write(15)  <= data_write(14);
                    data_write(14)  <= data_write(13);
                    data_write(13)  <= data_write(12);
                    data_write(12)  <= data_write(11);
                    data_write(11)  <= data_write(10);
                    data_write(10)  <= data_write(9);
                    data_write(9)   <= data_write(8);
                    data_write(8)   <= data_write(7);
                    data_write(7)   <= data_write(6);
                    data_write(6)   <= data_write(5);
                    data_write(5)   <= data_write(4);
                    data_write(4)   <= data_write(3);
                    data_write(3)   <= data_write(2);
                    data_write(2)   <= data_write(1);             
                    data_write(1)   <= data_write(0);
                        
                elsif(flag = '1') then
                    MOSI_var_2           <= '1';
                    data_read_signal(16) <= data_read_signal(15);
                    data_read_signal(15) <= data_read_signal(14);
                    data_read_signal(14) <= data_read_signal(13);
                    data_read_signal(13) <= data_read_signal(12);
                    data_read_signal(12) <= data_read_signal(11);
                    data_read_signal(11) <= data_read_signal(10);
                    data_read_signal(10) <= data_read_signal(9);
                    data_read_signal(9)  <= data_read_signal(8);
                    data_read_signal(8)  <= data_read_signal(7);
                    data_read_signal(7)  <= data_read_signal(6);
                    data_read_signal(6)  <= data_read_signal(5);
                    data_read_signal(5)  <= data_read_signal(4);
                    data_read_signal(4)  <= data_read_signal(3);
                    data_read_signal(3)  <= data_read_signal(2);
                    data_read_signal(2)  <= data_read_signal(1);
                    data_read_signal(1)  <= data_read_signal(0);
                    data_read_signal(0)  <= read_value;       
                end if;
            else    -- Redundant code? Same as idle state! Needs revision
                MOSI_var_2 <= '0';
                data_write <= data_write_in;
            end if;
        end if;     
    end process CURRENT_STATE_FSM;

    RD_AVAIL_TOG: process(clk)
    begin
        if(rising_edge(clk)) then
            if(state = done1) then
                rd_avail<='1';
            else
                rd_avail<='0';
            end if;
                
        end if;
    end process RD_AVAIL_TOG;
end Behavioral;
-----------------------------End Of File------------------------------------