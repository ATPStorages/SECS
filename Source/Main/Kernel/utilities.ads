with Interfaces; use Interfaces;

package Utilities is
   subtype String32Bit is String(1..4);
   subtype Bits32 is Natural range 0..Unsigned_32'Size;
   subtype Bits8  is Natural range 0.. Unsigned_8'Size;
   -- -- --
   function UnsignedToBytesStr(N: Unsigned_32) return String32Bit;
   function Extract(N: Unsigned_32; Bits: Bits32 := 1; StartBit: Bits32 := 0) return Unsigned_32;
   function Extract(N: Unsigned_8 ; Bits: Bits8  := 1; StartBit: Bits8  := 0) return  Unsigned_8;
end Utilities;
