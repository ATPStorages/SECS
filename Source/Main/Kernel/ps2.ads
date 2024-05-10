package PS2 is
   pragma Elaborate_Body;
   -- Port2 in the records below represent chipset-specific data if only 1 PS/2 port is available
   type ControllerConfiguration is record
      Port1Interrupt : Boolean;
      Port2Interrupt : Boolean;
      SystemPOST     : Boolean :=  True;
      Unused1        : Boolean := False;
      Port1ClockOn   : Boolean;
      Port2ClockOn   : Boolean;
      Port1Translate : Boolean;
      Unused2        : Boolean := False;
   end record with Pack;
   
   --function  ReadConfiguration return ControllerConfiguration;
   --procedure WriteConfiguration(Data: ControllerConfiguration);
   
   type ControllerData is record
      SystemReset  : Boolean := True;
      A20Gate      : Boolean;
      Port2Clock   : Boolean;
      Port2Data    : Boolean;
      BufferFullP1 : Boolean;
      BufferFullP2 : Boolean;
      Port1Clock   : Boolean;
      Port1Data    : Boolean;
   end record with Pack;
   
   --function  ReadData return ControllerData;
   --procedure WriteData(Data: ControllerData);
end PS2;
