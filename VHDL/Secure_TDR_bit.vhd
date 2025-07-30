----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2024 16:42:18
-- Design Name: 
-- Module Name: Secure_TDR_bit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Secure_TDR_bit is
Port (     TDI : in STD_LOGIC;
           feed_in : in STD_LOGIC;
           seed_bit: in STD_LOGIC;
           D: in STD_LOGIC;
           SE : in STD_LOGIC;
           UE : in STD_LOGIC;
           CE : in STD_LOGIC;
           Sel : in STD_LOGIC;
           RST : in STD_LOGIC;
           TCK : in STD_LOGIC;
           global_verify : in STD_LOGIC; 
           TDO : out STD_LOGIC;
           feed_out : out STD_LOGIC;
           ScanRegister_out : out STD_LOGIC);

end Secure_TDR_bit;

architecture Behavioral of Secure_TDR_bit is
signal cs_reg: std_logic;
signal u_reg: std_logic;
signal se_mux, ce_mux, M3_mux, M5_mux, M4_mux: std_logic;
signal and_UE, and_SE, and_CE :STD_LOGIC;

begin
and_UE<= UE and global_verify and Sel;
and_CE <= CE and Sel;
and_SE <= SE and Sel;

se_mux <= TDI when and_SE = '1' else cs_reg;
ce_mux <= D when and_CE = '1' else se_mux;

M5_mux <= seed_bit when and_CE = '1' else feed_in;

M4_mux <=  u_reg when global_verify = '1' else M5_mux;

M3_mux <= cs_reg when and_UE = '1' else M4_mux;



 -- Flip-Flops
 cs_reg <= ce_mux when TCK'event and TCK = '1';
                      
 process(RST,TCK,M3_mux)
 begin
 if RST = '1' then
    u_reg <= '0';
 elsif TCK'event and TCK = '0' then
    u_reg <= M3_mux;
 end if;
 end process;

TDO <= cs_reg;
feed_out <= u_reg;
ScanRegister_out<= u_reg and global_verify;

end Behavioral;
