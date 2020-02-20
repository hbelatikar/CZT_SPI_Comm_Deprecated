----------------------------------------------------------------------------------
-- Company: IIT-B
-- Engineer: Sanjoli
-- 
-- Create Date: 02/18/2020 02:57:23 PM
-- Design Name: Behaviour
-- Module Name: Time_Stamp - Behavioral
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

entity Time_Stamp is
port(
    tlast_trigger   : in  std_logic;
    Cycle_count     : out std_logic_vector(31 downto 0) := (others => '0');
    overflow : out std_logic;
    
    clk     : in std_logic;
    reset   : in std_logic
    );
end entity;

architecture Behaviour of Time_Stamp is
    type FSM_state is (idle, counting);
    signal state : FSM_state;
    signal count : unsigned(31 downto 0) := x"00000000";
begin
    process(clk, reset, tlast_trigger)
        variable n_state : FSM_state ;
    begin
        case state is 
            when idle =>
                Cycle_count <= x"00000000";
                if(tlast_trigger = '1') then
                    n_state := counting;
                    Cycle_count <= x"00000001";
                else
                   n_state := idle;
                end if; 
            when counting =>
                n_state := counting;
                
                if(count = x"FFFFFFFF") then
                    overflow <= '1';
                else
                    overflow <= '0';
                end if;
        end case;
        
        if(rising_edge(clk))then
            if(state = counting) then
                count <= count + 1;
                Cycle_count <= std_logic_vector(count + 1);
            end if;
            state <= n_state;
        end if;
        
        if(reset = '0') then
            Cycle_count <= (others => '0');
            state <= idle;
        end if;
    end process;
end Behaviour;
