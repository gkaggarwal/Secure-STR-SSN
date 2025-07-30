----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2024 19:16:56
-- Design Name: 
-- Module Name: ComparatorWithCounter - Behavioral
-- Project Name: 
-- Target Devices: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ComparatorWithCounter is
    Generic (counter_value : integer := 256);
    Port (
        clk          : in  std_logic;       -- Clock signal
        rst          : in  std_logic;       -- Reset signal
        bit_a        : in  std_logic;       -- First input bit
        bit_b        : in  std_logic;       -- Second input bit
        flag         : out std_logic;       -- Sticky flip-flop output flag
        counter_out  : out std_logic_vector(7 downto 0) -- Counter as std_logic_vector
    );
end ComparatorWithCounter;

architecture Behavioral of ComparatorWithCounter is
 -- Fixed counter value (adjustable)
    constant COUNTER_MAX : integer := counter_value;
    
    -- Internal signals
    signal counter : integer range 0 to COUNTER_MAX := COUNTER_MAX; -- Counter initialized to max value
    signal flag_reg : std_logic := '0';                             -- Sticky flip-flop register
    signal match    : std_logic;                                   -- Signal to indicate if bits match

begin

    -- Assign the sticky flag to output
    flag <= flag_reg;
    -- Process to compare bits and manage the counter and sticky flag
    process(clk, rst)
    begin
        if rst = '1' then
            counter <= COUNTER_MAX;  -- Reset counter to max value
            flag_reg <= '0';         -- Clear sticky flag
        elsif falling_edge(clk) then
            -- Check if the two bits are equal
            if bit_a = bit_b then
                match <= '1';
                -- Decrease counter only if it's not already zero
                if counter > 0 then
                    counter <= counter - 1;
                end if;
            else
                match <= '0';
                -- Reset counter if bits are not equal
                counter <= COUNTER_MAX;
            end if;

            -- Set sticky flag when counter reaches zero
            if counter = 0 then
                flag_reg <= '1';
            end if;
        end if;
    end process;

process(counter)
begin
    counter_out <= conv_std_logic_vector(counter,8);

end process;
end Behavioral;

