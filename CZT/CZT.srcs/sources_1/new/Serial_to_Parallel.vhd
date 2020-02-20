----------------------------------------------------------------------------------
-- Company: IIT-B
-- Engineer: Sanjoli
-- 
-- Create Date: 02/18/2020 03:07:19 PM
-- Design Name: 
-- Module Name: Serial_to_Parallel - Behavioral
-- Project Name: Daksha 
-- Target Devices: Zybo - Z7
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity Serial_to_Parallel is
port(
		clk           : in  std_logic;
		reset         : in  std_logic;
		
		Serial_in     : in  std_logic;
		trigger_in    : in  std_logic;
		end_in        : in  std_logic;
		
		Parallel      : out std_logic_vector(31 downto 0);
		end_out       : out std_logic		
	);
end entity;

architecture working of Serial_to_Parallel is
    type FSM_state is (idle, converting);
    signal state : FSM_state;
    signal Parallel_out : std_logic_vector(31 downto 0) := x"00000000";
begin
    Parallel <= Parallel_out;
    end_out <= end_in;
    process(clk,reset,trigger_in)
        variable count : unsigned(7 downto 0) := (others => '0');
        variable n_state_var : FSM_state;
    begin
        case state is
            when idle =>
                Parallel_out <= x"00000000";
                count := x"00";
                if(trigger_in = '1') then
                    n_state_var := converting;
                    Parallel_out(0) <= Serial_in;
                else
                    n_state_var := idle;
                end if;
            when converting =>
                if(rising_edge(clk)) then
                    Parallel_out(25) <= Parallel_out(24);
                    Parallel_out(24) <= Parallel_out(23);
                    Parallel_out(23) <= Parallel_out(22);
                    Parallel_out(22) <= Parallel_out(21);
                    Parallel_out(21) <= Parallel_out(20);
                    Parallel_out(20) <= Parallel_out(19);
                    Parallel_out(19) <= Parallel_out(18);
                    Parallel_out(18) <= Parallel_out(17);
                    Parallel_out(17) <= Parallel_out(16);
                    Parallel_out(16) <= Parallel_out(15);
                    Parallel_out(15) <= Parallel_out(14);
                    Parallel_out(14) <= Parallel_out(13);
                    Parallel_out(13) <= Parallel_out(12);
                    Parallel_out(12) <= Parallel_out(11);
                    Parallel_out(11) <= Parallel_out(10);
                    Parallel_out(10) <= Parallel_out(9);
                    Parallel_out(9) <= Parallel_out(8);
                    Parallel_out(8) <= Parallel_out(7);
                    Parallel_out(7) <= Parallel_out(6);
                    Parallel_out(6) <= Parallel_out(5);
                    Parallel_out(5) <= Parallel_out(4);
                    Parallel_out(4) <= Parallel_out(3);
                    Parallel_out(3) <= Parallel_out(2);
                    Parallel_out(2) <= Parallel_out(1);
                    Parallel_out(1) <= Parallel_out(0);
                    Parallel_out(0) <= Serial_in;
                    count := count + 1;
                
                    if(count = x"19") then
                        n_state_var := idle;
                    else
                        n_state_var := converting;
                    end if;
                end if;  
        end case;
        
        if(reset = '0')then
            state <= idle;
        elsif(rising_edge(clk)) then
            state <= n_state_var;
        end if;  
    end process;
end architecture;