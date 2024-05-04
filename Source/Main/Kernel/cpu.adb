with System.Machine_Code; use System.Machine_Code;
with Utilities;           use Utilities;

package body CPU is
   function CPUID(Leaf: Unsigned_32) return CPUIDResult is
      Result : CPUIDResult;
   begin
      Asm ("cpuid",
           Inputs =>
             (
              Unsigned_32'Asm_Input ("a", Leaf)
             ),
           Outputs =>
             (
              Unsigned_32'Asm_Output ("=a", Result.EAX),
              Unsigned_32'Asm_Output ("=d", Result.EDX),
              Unsigned_32'Asm_Output ("=c", Result.ECX),
              Unsigned_32'Asm_Output ("=b", Result.EBX)
             ),
           Volatile => True
          );
      return Result;
   end CPUID;
   -- -- --
   
   
   function CreateProcessorVersionInformation(EAX: in out Unsigned_32) return ProcessorVersionInformation is
   begin
      return (
              ReservedA        => Unsigned_4'Val(Shift_Right(EAX                                        , 28)),
              ExtendedFamilyID => Unsigned_8'Val(Shift_Right(EAX and 2#00001111111100000000000000000000#, 20)),
              ExtendedModelID  => Unsigned_4'Val(Shift_Right(EAX and 2#00000000000011110000000000000000#, 16)),
              ReservedB        => Unsigned_2'Val(Shift_Right(EAX and 2#00000000000000001100000000000000#, 14)),
              ProcessorType    => Unsigned_2'Val(Shift_Right(EAX and 2#00000000000000000011000000000000#, 12)),
              FamilyID         => Unsigned_4'Val(Shift_Right(EAX and 2#00000000000000000000111100000000#, 8)),
              Model            => Unsigned_4'Val(Shift_Right(EAX and 2#00000000000000000000000011110000#, 4)),
              SteppingID       => Unsigned_4'Val(            EAX and 2#00000000000000000000000000001111#)
             );
   end CreateProcessorVersionInformation;
   -- -- --
   Store : CPUIDResult;
begin
   Store := CPUID(0);
   CPUIDHighestBasicFunctionParameter := Store.EAX;
   CPUIDManufacturerID := UnsignedToBytesStr(Store.EBX) & UnsignedToBytesStr(Store.EDX) & UnsignedToBytesStr(Store.ECX);
   Store := CPUID(1);
   CPUIDVersionInformation := CreateProcessorVersionInformation(Store.EAX); 
   if True then
      CPUIDMiscellaneousInformation := (
                                        LocalAPICID           => Unsigned_8'Val(Shift_Right(Store.EBX, 24)),
                                        LogicalProcessorCount => Unsigned_8'Val(Shift_Right(Store.EBX and 2#00000000111111110000000000000000#, 16)),
                                        CLFlushSize           => Unsigned_8'Val(Shift_Right(Store.EBX and 2#00000000000000001111111100000000#, 8)),
                                        BrandID               => Unsigned_8'Val(            Store.EBX and 2#00000000000000000000000011111111#)
                                       );
      --CPUIDProcessorFeaturesECX := AMDProcessorFeaturesArrayECX with Address => Store.ECX'Address, Import, Volatile;
      Store := CPUID(16#8000_0002#);
      --  CPUIDProcessorName(1..16) :=
      --    UnsignedToBytesStr(Store.EAX) & UnsignedToBytesStr(Store.EBX) & UnsignedToBytesStr(Store.ECX) & UnsignedToBytesStr(Store.EDX);
      --  Store := CPUID(16#8000_0003#);
      --  CPUIDProcessorName(17..32) :=
      --    UnsignedToBytesStr(Store.EAX) & UnsignedToBytesStr(Store.EBX) & UnsignedToBytesStr(Store.ECX) & UnsignedToBytesStr(Store.EDX);
      --  Store := CPUID(16#8000_0004#);
      --  CPUIDProcessorName(33..48) :=
      --    UnsignedToBytesStr(Store.EAX) & UnsignedToBytesStr(Store.EBX) & UnsignedToBytesStr(Store.ECX) & UnsignedToBytesStr(Store.EDX);
   else
      
      null;
   end if;
end CPU;
