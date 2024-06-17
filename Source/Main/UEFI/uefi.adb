with ADA.CHARACTERS.LATIN_1;
with Ada.Characters.Conversions;

package body UEFI is
   function EFIMain(ImageHandle : EFI_HANDLE; SystemTable : EFI_SYSTEM_TABLE) return EFI_STATUS is
      unused: Unsigned_32;
   begin
      InitializeLib(ImageHandle, SystemTable);
      unused := Print(Ada.Characters.Conversions.To_Wide_String("Hi" & Ada.Characters.Latin_1.NUL));
      --unused := SystemTable.ConOut.OutputString(SystemTable.ConOut, "Test");
      return 0;
   end;
end UEFI;
