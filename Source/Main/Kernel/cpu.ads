with Interfaces; use Interfaces;

package CPU is
   type CPUIDResult is record
      EAX: Unsigned_32;
      EBX: Unsigned_32;
      EDX: Unsigned_32;
      ECX: Unsigned_32;
   end record;
   
   function CPUID(Leaf: Unsigned_32) return CPUIDResult;
   -- -- --
   type Unsigned_4 is new Unsigned_8 range 0 .. 15;
   type Unsigned_2 is new Unsigned_8 range 0 .. 3 ;
   -- -- --
   type AMDProcessorFeaturesECX is (
                                    UNDER_VM, RESERVED_A, F16C, AVX, OSXSAVE, XSAVE, 
                                    AES, RESERVED_B, POPCNT, RESERVED_C, RESERVED_D,
                                    SSE42, SSE41, RESERVED_E, RESERVED_F, RESERVED_G,
                                    RESERVED_H, CMPXCHG16B, FMA, RESERVED_I, RESERVED_J,
                                    SSSE3, RESERVED_K, RESERVED_L, RESERVED_M, RESERVED_N,
                                    MONITOR, RESERVED_O, PCLMULQDQ, SSE3
                                   );
   type AMDProcessorFeaturesEDX is (
                                    RESERVED_A, RESERVED_B, RESERVED_C, HYPER_THREADING, RESERVED_D,
                                    SSE2, SSE, FXSR, MMX, RESERVED_E, RESERVED_F, RESERVED_G, CLFSH,
                                    RESERVED_H, PSE36, PAT, CMOV, MCA, PGE, MTRR, SYSENTEREXIT, RESERVED_I,
                                    APIC, CMPXCHG8B, MCE, PAE, MSR, TSC, PSE, DE, VME, FPU
                                   );
   
   type AMDProcessorMiscellaneous is record
      LocalAPICID          : Unsigned_8;
      LogicalProcessorCount: Unsigned_8;
      CLFlushSize          : Unsigned_8;
      BrandID              : Unsigned_8;
   end record with Pack;
   
   type AMDProcessorMonitorInfo is record
      MonitorLineSizeMinimum    : Unsigned_16;
      MonitorLineSizeMaximum    : Unsigned_16;
      InterruptBreakEven        : Boolean;
      EnumerateMonitorExtensions: Boolean;
   end record with Pack;
   
   type AMDProcessorFeaturesArrayECX is array (AMDProcessorFeaturesECX) of Boolean with Pack;
   type AMDProcessorFeaturesArrayEDX is array (AMDProcessorFeaturesEDX) of Boolean with Pack;
   -- -- --
   type ProcessorVersionInformation is record
      ReservedA       : Unsigned_4;
      ExtendedFamilyID: Unsigned_8;
      ExtendedModelID : Unsigned_4;
      ReservedB       : Unsigned_2;
      ProcessorType   : Unsigned_2;
      FamilyID        : Unsigned_4;
      Model           : Unsigned_4;
      SteppingID      : Unsigned_4;
   end record with Pack;
   
   for ProcessorVersionInformation use record
      ReservedA        at 0 range 0..3;
      ExtendedFamilyID at 0 range 4..11;
      ExtendedModelID  at 0 range 12..15;
      ReservedB        at 0 range 16..17;
      ProcessorType    at 0 range 18..19;
      FamilyID         at 0 range 20..23;
      Model            at 0 range 24..27;
      SteppingID       at 0 range 28..31;
   end record;
   -- -- --
   CPUIDHighestBasicFunctionParameter   : Unsigned_32;
   CPUIDHighestExtendedFunctionParameter: Unsigned_32;
   CPUIDManufacturerID                  : String(1..12);
   --CPUIDProcessorName                   : String(1..48);
   
   CPUIDMiscellaneousInformation        : AMDProcessorMiscellaneous;
   CPUIDVersionInformation              : ProcessorVersionInformation;
   CPUIDProcessorFeaturesEDX            : AMDProcessorFeaturesArrayEDX;
   CPUIDProcessorFeaturesECX            : AMDProcessorFeaturesArrayECX;
private
   
   -- -- --
   function CreateProcessorVersionInformation(EAX: in out Unsigned_32) return ProcessorVersionInformation;
end CPU;
