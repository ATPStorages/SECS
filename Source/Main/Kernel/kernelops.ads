with Interfaces; use Interfaces;

package KernelOps is
   procedure WritePort_Byte(Port : Unsigned_16; Data: Unsigned_8);
   function   ReadPort_Byte(Port : Unsigned_16) return Unsigned_8;
   
   CMOS_NMIPort  : constant := 16#70#;
   CMOS_DataPort : constant := 16#71#;
   
   procedure DisableInterrupts(DisableNMI : Boolean := False);
   procedure  EnableInterrupts( EnableNMI : Boolean := False);
   
   PS2C_DataPort    : constant := 16#60#;
   PS2C_ControlPort : constant := 16#64#;
end KernelOps;
