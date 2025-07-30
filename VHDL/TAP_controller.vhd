----------------------------------------------------------------------------------

-- Create Date: 23.11.2021 19:02:09
-- Designer Name: Gaurav Aggarwal 
-- Module Name: TAP_controller - Behavioral

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TAP_controller is
    Port ( TCLK, TMS : in STD_LOGIC;
           Reset, CaptureEn, ShiftEn, UpdateEn, SelectEn : out STD_LOGIC);
end TAP_controller;

architecture Behavioral of TAP_controller is

------------------------------>>>>>>>>>>>> declaration of 16 states of TAP controller ------------------------->>>>>>>>>>>>>>>>>

Type state_type is (TEST_LOGIC_RESET, RUN_TEST_IDLE, SELECT_DR, SELECT_IR, CAPTURE_DR, CAPTURE_IR, SHIFT_DR, SHIFT_IR, 
                    EXIT_1_DR, EXIT_1_IR, PAUSE_DR, PAUSE_IR,EXIT_2_DR, EXIT_2_IR, UPDATE_DR, UPDATE_IR ); 

signal state: state_type;

------------------------------>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

begin

--nxt_state <=  TEST_LOGIC_RESET;        

State_Transition: PROCESS (TCLK, TMS)
BEGIN      
      IF rising_edge(TCLK) THEN
        
        CASE state is 
------------------------------>>>>>>>>>>>>>>>>>>>> State 0 Test Logic Reset ------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>               
            WHEN TEST_LOGIC_RESET =>                                          
                IF TMS = '1' THEN 
                    state <=  TEST_LOGIC_RESET;
                ELSIF TMS ='0' THEN
                    state <=  RUN_TEST_IDLE;
                END IF;
                
------------------------------>>>>>>>>>>>>>>>>>>>> State 1 Run Test / IDLE ------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>                                  
            WHEN RUN_TEST_IDLE =>
                IF TMS = '1' THEN 
                    state <=  SELECT_DR;
                ELSIF TMS ='0' THEN
                    state <=  RUN_TEST_IDLE;
                END IF;

------------------------------>>>>>>>>>>>>>>>>>>>> State 2 Select Data Register --------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>                           
            WHEN SELECT_DR =>
                IF TMS = '1' THEN 
                    state <=  SELECT_IR;
                ELSIF TMS ='0' THEN
                    state <=  CAPTURE_DR;
                END IF;
                
------------------------------>>>>>>>>>>>>>>>>>>>> State 3 Capture Data Regster ---------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>                               
             WHEN CAPTURE_DR =>
                IF TMS = '1' THEN 
                    state <=  EXIT_1_DR;
                ELSIF TMS ='0' THEN
                    state <=  SHIFT_DR;
                END IF;

------------------------------>>>>>>>>>>>>>>>>>>>> State 4 Shift Data Register ------------------------>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                               
             WHEN SHIFT_DR =>
                IF TMS = '1' THEN 
                    state <=  EXIT_1_DR;
                ELSIF TMS ='0' THEN
                    state <=  SHIFT_DR;
                END IF;
                
------------------------------>>>>>>>>>>>>>>>>>>>> State 5 Exit 1 Data Register ----------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>                               
             WHEN EXIT_1_DR =>
                IF TMS = '1' THEN 
                    state <=  UPDATE_DR;
                ELSIF TMS ='0' THEN
                    state <=  PAUSE_DR;
                END IF;
                
------------------------------>>>>>>>>>>>>>>>>>>>> State 6 Pause Data Register ------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>                               
             WHEN PAUSE_DR =>
                IF TMS = '1' THEN 
                    state <=  EXIT_2_DR;
                ELSIF TMS ='0' THEN
                    state <=  PAUSE_DR;
                END IF;
                
------------------------------>>>>>>>>>>>>>>>>>>>> State 7 Exit 2 Data Register ------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>                               
             WHEN EXIT_2_DR =>
                IF TMS = '1' THEN 
                    state <=  UPDATE_DR;
                ELSIF TMS ='0' THEN
                    state <=  SHIFT_DR;
                END IF;
              
------------------------------>>>>>>>>>>>>>>>>>>>> State 8 Update Data Register ------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>               
             WHEN UPDATE_DR =>
                IF TMS = '1' THEN 
                    state <=  SELECT_DR;
                ELSIF TMS ='0' THEN
                    state <=  RUN_TEST_IDLE;
                END IF;
                
------------------------------>>>>>>>>>>>>>>>>>>>> State 9 Select Instruction Register ------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>                               
             WHEN SELECT_IR =>
                IF TMS = '1' THEN 
                    state <=  TEST_LOGIC_RESET;
                ELSIF TMS ='0' THEN
                    state <=  CAPTURE_IR;
                END IF;
                
------------------------------>>>>>>>>>>>>>>>>>>>> State 10 Capture Instruction Register ------------------>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                               
             WHEN CAPTURE_IR =>
                IF TMS = '1' THEN 
                    state <=  EXIT_1_IR;
                ELSIF TMS ='0' THEN
                    state <=  SHIFT_IR;
                END IF;
                
------------------------------>>>>>>>>>>>>>>>>>>>> State 11 Shift Instruction Register -------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>                               
             WHEN SHIFT_IR =>
                IF TMS = '1' THEN 
                    state <=  EXIT_1_IR;
                ELSIF TMS ='0' THEN
                    state <=  SHIFT_IR;
                END IF;

------------------------------>>>>>>>>>>>>>>>>>>>> State 12 Exit 1 Instruction Register ------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>                               
             WHEN EXIT_1_IR =>
                IF TMS = '1' THEN 
                    state <=  UPDATE_IR;
                ELSIF TMS ='0' THEN
                    state <=  PAUSE_IR;
                END IF;
               
------------------------------>>>>>>>>>>>>>>>>>>>> State 13 Pause Instruction Register -------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>                               
             WHEN PAUSE_IR =>
                IF TMS = '1' THEN 
                    state <=  EXIT_2_IR;
                ELSIF TMS ='0' THEN
                    state <=  PAUSE_IR;
                END IF;
     
------------------------------>>>>>>>>>>>>>>>>>>>> State 14 Exit 2 Instruction Register ------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>                               
             WHEN EXIT_2_IR =>
                IF TMS = '1' THEN 
                    state <=  UPDATE_IR;
                ELSIF TMS ='0' THEN
                    state <=  SHIFT_IR;
                END IF;

------------------------------>>>>>>>>>>>>>>>>>>>> State 15 Update Instruction Register ------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>                               
             WHEN UPDATE_IR =>
                IF TMS = '1' THEN 
                    state <=  SELECT_DR;
                ELSIF TMS ='0' THEN
                    state <=  RUN_TEST_IDLE;
                END IF;

------------------------------>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ----------------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                                                                                                     
             WHEN others =>
                --state <=  TEST_LOGIC_RESET;        
             
         END CASE;    
        
END IF;
END PROCESS; 

State_Signal: PROCESS(state)
BEGIN
    CASE state is
        WHEN TEST_LOGIC_RESET =>
            Reset <= '1';
            CaptureEn <= '0';
            ShiftEn <= '0';
            UpdateEn <= '0';
            SelectEn <= '1';
            
        WHEN CAPTURE_DR | CAPTURE_IR =>
            Reset <= '0';
            CaptureEn <= '1';
            ShiftEn <= '0';
            UpdateEn <= '0';
            SelectEn <= '1';
           
        WHEN SHIFT_DR | SHIFT_IR =>
            Reset <= '0';
            CaptureEn <= '0';
            ShiftEn <= '1';
            UpdateEn <= '0';
            SelectEn <= '1';
          
        WHEN UPDATE_DR | UPDATE_IR =>
            Reset <= '0';
            CaptureEn <= '0';
            ShiftEn <= '0';
            UpdateEn <= '1';
            SelectEn <= '1';
          
        WHEN others =>
            Reset <= '0';
            CaptureEn <= '0';
            ShiftEn <= '0';
            UpdateEn <= '0';
            SelectEn <= '0';
            
     END CASE; 

END PROCESS;

end Behavioral;
