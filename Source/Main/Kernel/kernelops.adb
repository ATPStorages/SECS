with System.Machine_Code; use System.Machine_Code;

package body KernelOps is

   procedure WritePort_Byte(Port : Unsigned_16; Data : Unsigned_8) is
   begin
      Asm(
          "out %0, %1",
          Inputs => (Unsigned_8'Asm_Input("a", Data),	
                    Unsigned_16'Asm_Input("d", Port)),
          Volatile => True);
   end WritePort_Byte;
   
   function ReadPort_Byte(Port : Unsigned_16) return Unsigned_8 is
      Data : Unsigned_8;
   begin
      Asm(
          "in %1, %0",
          Inputs => (Unsigned_16'Asm_Input("d", Port)),
          Outputs => (Unsigned_8'Asm_Output("=a", Data)),
          Volatile => True);
      return Data;
   end ReadPort_Byte;
   
   procedure DisableInterrupts(DisableNMI: Boolean := False) is
      discard : Unsigned_8;
   begin
      Asm("cli", Volatile => True);
      if DisableNMI then
         WritePort_Byte(CMOS_NMIPort, ReadPort_Byte(CMOS_NMIPort) or 16#80#);
         discard := ReadPort_Byte(CMOS_DataPort);
      end if;
   end DisableInterrupts;
   
   procedure EnableInterrupts(EnableNMI: Boolean := False) is
      discard : Unsigned_8;
   begin
      Asm("sti", Volatile => True);
      if EnableNMI then
         WritePort_Byte(CMOS_NMIPort, ReadPort_Byte(CMOS_NMIPort) and 16#7F#);
         discard := ReadPort_Byte(CMOS_DataPort);
      end if;
   end EnableInterrupts;

end KernelOps;
