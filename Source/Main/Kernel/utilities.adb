with Interfaces; use Interfaces;

package body Utilities is
   function Extract(N: in out Unsigned_32; Bits: U32Bits; StartBit: U32Bits) return Unsigned_32 is
      Mask : Unsigned_32 := Shift_Left((Shift_Left(1, Bits) - 1), StartBit);
   begin
      return N and Mask;
   end Extract;
   
   function UnsignedToBytesStr(Val: in out Unsigned_32) return Byte_Array is
      Bytes : Byte_Array;
   begin
      for I in 0 .. 3 loop
         Bytes(I + 1) := Character'Val(Val mod 256);
         Val := Val / 256;
      end loop;
      
      return Bytes;
   end UnsignedToBytesStr;
end Utilities;
