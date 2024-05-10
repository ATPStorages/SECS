package body Utilities is
   function Extract(N: Unsigned_32; Bits: Bits32 := 1; StartBit: Bits32 := 0) return Unsigned_32 is
      Mask: constant Unsigned_32 := Shift_Left((Shift_Left(1, Bits) - 1), StartBit);
   begin
      return N and Mask;
   end Extract;
   
   function Extract(N: Unsigned_8; Bits: Bits8 := 1; StartBit: Bits8 := 0) return Unsigned_8 is
   begin
      return Unsigned_8'Val(Extract(Unsigned_32'Val(N), Bits, StartBit));
   end Extract;
   
   function UnsignedToBytesStr(N: Unsigned_32) return String32Bit is
   begin
      return Character'Val(N and 16#FF000000#) & Character'Val(N and 16#00FF0000#) & Character'Val(N and 16#0000FF00#) & Character'Val(N and 16#000000FF#);
   end UnsignedToBytesStr;
end Utilities;
