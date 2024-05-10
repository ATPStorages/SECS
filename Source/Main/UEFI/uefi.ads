with Interfaces; use Interfaces;

with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with System; use System;

package UEFI is
   subtype EFI_STATUS is Unsigned_64;
   type EFI_HANDLE is null record;
   
   type EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL;
   type EFI_TEXT_STRING_PTR is access function (This: EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL; String: wchar_array) return EFI_STATUS;
   
   type EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL is record
      Reset        : Address;
      OutputString : EFI_TEXT_STRING_PTR;
   end record with Pack;
   
   type EFI_TABLE_HEADER is record
      Signature  : Unsigned_64;
      Revision   : Unsigned_32;
      HeaderSize : Unsigned_32;
      CRC32      : Unsigned_32;
      Reserved   : Unsigned_32;
   end record with Pack;
   type EFI_SYSTEM_TABLE is record
      HDR                  : EFI_TABLE_HEADER               ;
      FirmwareVendor       : char_array_access              ;
      FirmwareRevision     : Unsigned_32                    ;
      ConsoleInHandle      : EFI_HANDLE                     ;
      ConIn                : Address                        ;
      ConsoleOutHandle     : EFI_HANDLE                     ;
      ConOut               : EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL;
      StandardErrorHandle  : EFI_HANDLE                     ;
      StdErr               : Address                        ;
      RuntimeServices      : Address                        ;
      BootServices         : Address                        ;
      NumberOfTableEntries : Unsigned_64                    ;
      ConfigurationTable   : Address                        ;
   end record with Pack;
   
   function EFIMain(ImageHandle : EFI_HANDLE; SystemTable : EFI_SYSTEM_TABLE) return EFI_STATUS
     with
       Export => True,
       Convention => C,
       External_Name => "efi_main";
   
   procedure InitializeLib(ImageHandle : EFI_HANDLE; SystemTable : EFI_SYSTEM_TABLE)
     with
       Import => True,
       Convention => C,
       External_Name => "InitializeLib";
   
   function Print(String: char16_array) return Unsigned_32
     with
       Import => True,
       Convention => C,
       External_Name => "Print";
   
   type EFI_RESET_TYPE is (EfiResetCold, EfiResetWarm, EfiResetShutdown, EfiResetPlatformSpecific) with Convention => C;
   procedure ResetSystem(ResetType : EFI_RESET_TYPE; ResetStatus : Unsigned_64; DataSize: Unsigned_64; ResetData: Address)
     with
       Import => True,
       Convention => C,
       External_Name => "ResetSystem";
end UEFI;
