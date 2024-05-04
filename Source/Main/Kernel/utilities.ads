with Interfaces; use Interfaces;

package Utilities is
   subtype Byte_Array is String(1 .. 4);
   subtype U32Bits is Integer range 0..31;
   -- -- --
   function UnsignedToBytesStr(Val: in out Unsigned_32) return Byte_Array;
   function Extract(N: in out Unsigned_32; Bits: U32Bits; StartBit: U32Bits) return Unsigned_32;
end Utilities;
