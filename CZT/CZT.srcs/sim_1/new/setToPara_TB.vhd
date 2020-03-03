library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity serToPara_tb is
end;

architecture bench of serToPara_tb is

  component serToPara
      Port ( clk : in STD_LOGIC;
             reset : in STD_LOGIC;
             trigger_in: in STD_LOGIC;
             Serial_in : in STD_LOGIC;
             Parallel_out : out STD_LOGIC_VECTOR (31 downto 0));
  end component;

  signal clk: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal trigger_in: STD_LOGIC;
  signal Serial_in: STD_LOGIC;
  signal Parallel_out: STD_LOGIC_VECTOR (31 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: serToPara port map ( clk          => clk,
                            reset        => reset,
                            trigger_in   => trigger_in,
                            Serial_in    => Serial_in,
                            Parallel_out => Parallel_out );

  stimulus: process
    variable count : integer := 0; 
  begin
    -- Put initialisation code here
    
    reset   <= '1';
    trigger_in  <= '0';
    Serial_in   <= '0';
    
    -- Put test bench stimulus code here
    wait for 20 ns;
    trigger_in <= '1';
    Serial_in  <= '1';
    for k in 25 downto 1 loop
        Serial_in <= not Serial_in;
        wait for 10ns;
    end loop;    
     
    stop_the_clock <= true;
    wait;
  end process;  --stimulus ends

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;  --clocking ends

end;
  
--configuration cfg_serToPara_tb of serToPara_tb is
--  for bench
--    for uut: serToPara
--      -- Default configuration
--    end for;
--  end for;
--end cfg_serToPara_tb;

--configuration cfg_serToPara_tb_Behavioral of serToPara_tb is
--  for bench
--    for uut: serToPara
--      use entity work.serToPara(Behavioral);
--    end for;
--  end for;
--end cfg_serToPara_tb_Behavioral;

  