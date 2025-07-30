----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2024 19:28:38
-- Design Name: 
-- Module Name: Design - Behavioral
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

entity Design_4bit is
  Generic(key_size: integer:=4;
        Data : STD_LOGIC_VECTOR := "1010";
        seed_value: STD_LOGIC_VECTOR := "0101"     -- Generic seed value
        );
  
  Port ( TCLK, TMS, TDI: in STD_LOGIC; 
         TDO : out STD_LOGIC 
        );
end Design_4bit;

architecture Behavioral of Design_4bit is

------------------------------>>>>>>>>>>>> declaration of 16 states of TAP controller ------------------------->>>>>>>>>>>>>>>>>

component TAP_controller is
    Port ( TCLK, TMS : in STD_LOGIC;
           Reset, CaptureEn, ShiftEn, UpdateEn, SelectEn : out STD_LOGIC);
end component;

signal SE,UE,CE, RST: STD_LOGIC;
------------------------------>>>>>>>>>>>> declaration of Secure TDR------------------------->>>>>>>>>>>>>>>>>


component Secure_TDR_bit is
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

end component;

--signal seed_value :STD_LOGIC_VECTOR(key_size-1 downto 0):= "0101";
signal feed_in: std_logic;
signal TDO_STDR, feed_out, SO_STDR :STD_LOGIC_VECTOR(key_size-1 downto 0);
--signal Data :STD_LOGIC_VECTOR(key_size-1 downto 0):= (others=>'0');

------------------------------>>>>>>>>>>>> declaration of Authorization Unit------------------------->>>>>>>>>>>>>>>>>

component ComparatorWithCounter is
    Generic (counter_value : integer := 10);
    Port (
        clk          : in  std_logic;       -- Clock signal
        rst          : in  std_logic;       -- Reset signal
        bit_a        : in  std_logic;       -- First input bit
        bit_b        : in  std_logic;       -- Second input bit
        flag         : out std_logic;       -- Sticky flip-flop output flag
        counter_out  : out std_logic_vector(7 downto 0) -- Output for counter value
    );
end component;

constant counter_value: integer:=key_size;
signal Auth, Sel:STD_LOGIC;
signal counter_value_out: std_logic_vector(7 downto 0);
begin

TAP: TAP_controller
        port map(
                TCLK=>TCLK,
                TMS=>TMS,
                Reset=>RST,
                CaptureEn=>CE,
                ShiftEn=>SE,
                UpdateEn=>UE,
                SelectEn=>Sel);

feed_in <= (feed_out(key_size-1) xor feed_out(0));

STDR0: Secure_TDR_bit
      port map (
                TDI=>TDI,
                feed_in=>feed_in,
                seed_bit=>seed_value(0),
                D=>Data(0),
                SE=>SE,
                UE=>UE,
                CE=>CE,
                RST=>RST,
                Sel=>Sel,
                TCK=>TCLK,
                global_verify=>Auth,
                TDO=> TDO_STDR(0),
                feed_out=>feed_out(0),
                ScanRegister_out=> SO_STDR(0)    
    
      );
      
gen_instances: for i in 1 to key_size-1 generate
    STDR_i: Secure_TDR_bit
      port map (
                TDI=>TDO_STDR(i-1),
                feed_in=>feed_out(i-1),
                seed_bit=>seed_value(i),
                D=> Data(i),
                SE=>SE,
                UE=>UE,
                CE=>CE,
                Sel=>Sel,
                RST=>RST,
                TCK=>TCLK,
                global_verify=>Auth,
                TDO=>TDO_STDR(i),
                feed_out=>feed_out(i),
                ScanRegister_out=> SO_STDR(i)    
    
      );
  end generate;


Comparator: ComparatorWithCounter
             Generic map( counter_value=>counter_value-1)
             port map(
                      clk=>TCLK,
                      rst=>RST,
                      bit_a=>feed_out(key_size-1),
                      bit_b=>TDO_STDR(key_size-1),
                      flag=>Auth,
                      counter_out=>counter_value_out
                      );
                        

end Behavioral;
