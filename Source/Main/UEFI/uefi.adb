package body UEFI is
   function EFIMain(ImageHandle : EFI_HANDLE; SystemTable : EFI_SYSTEM_TABLE) return EFI_STATUS is
      unused: Unsigned_32;
   begin
      InitializeLib(ImageHandle, SystemTable);
      unused := Print("\0");
      --unused := SystemTable.ConOut.OutputString(SystemTable.ConOut, "Test");
      return 0;
   end;
end UEFI;
