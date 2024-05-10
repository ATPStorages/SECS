with Interfaces; use Interfaces;

package ACPI is
   pragma Elaborate_Body;
   type SystemDesctiptorTable is tagged null record;
   
   type SystemDescriptorTableStem is new SystemDesctiptorTable with record
      Signature : String(1..8);
      Checksum  : Unsigned_8  ;
      OEMID     : String(1..6);
      Revision  : Unsigned_8  ;
   end record with Pack;
   
   type BasicSystemDescriptorTable is new SystemDescriptorTableStem with record
     RSDTAddress : Unsigned_32;
   end record with Pack;
   
   type XSDTReserved is array (1..4) of Unsigned_8;
   -- For versions > 2.0. Do not use RSDTAddress.
   type ExtendedSystemDescriptorTable is new BasicSystemDescriptorTable with record
      Length           : Unsigned_32 ;
      XSDTAddress      : Unsigned_64 ;
      ExtendedChecksum : Unsigned_8  ;
      Reserved         : XSDTReserved;
   end record with Pack;
end ACPI;
