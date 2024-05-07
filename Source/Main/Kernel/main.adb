with System.Storage_Elements;
with PNG;

procedure Main is

   --  Suppress some checks to prevent undefined references during linking to
   --
   --    __gnat_rcheck_CE_Range_Check
   --    __gnat_rcheck_CE_Overflow_Check
   --
   --  These are Ada Runtime functions (see also GNAT's a-except.adb).

   pragma Suppress (Index_Check);
   pragma Suppress (Overflow_Check);


   --  See also:
   --    https://en.wikipedia.org/wiki/VGA-compatible_text_mode
   --    https://en.wikipedia.org/wiki/Color_Graphics_Adapter#Color_palette

   type Color is (BLACK, BLUE, GREEN, CYAN, RED, MAGENTA, BROWN, WHITE);

   for Color'Size use 3;
   for Color use (BLACK => 2#000#, BLUE => 2#001#, GREEN => 2#010#, CYAN => 2#011#, RED => 2#100#, MAGENTA => 2#101#, BROWN => 2#110#, WHITE => 2#111#);

   type Text_Buffer_Char is
      record
                Ch : Character;
                Fg : Color;
         IntenseFg : Boolean;
                Bg : Color;
         IntenseBg : Boolean;
      end record;   

   for Text_Buffer_Char use
      record
                Ch at 0 range 0 .. 7;
                Fg at 1 range 0 .. 2;
         IntenseFg at 1 range 3 .. 3;
                Bg at 1 range 4 .. 6;
         IntenseBg at 1 range 7 .. 7;
      end record;


   type Text_Buffer is
     array (Natural range <>) of Text_Buffer_Char;


   COLS : constant := 80;
   ROWS : constant := 24;   

   subtype Col is Natural range 0 .. COLS - 1;
   subtype Row is Natural range 0 .. ROWS - 1;


   Output : Text_Buffer (0 .. (COLS * ROWS) - 1);
   for Output'Address use System.Storage_Elements.To_Address (16#B8000#);


   --------------
   -- Put_Char --
   --------------

   procedure Put_Char (X : Col; Y : Row; Fg, Bg : Color; IntenseFg, IntenseBg : Boolean; Ch : Character) is
   begin
      Output (Y * COLS + X) := (Ch, Fg, IntenseFg, Bg, IntenseBg);
   end Put_Char;

   ----------------
   -- Put_String --
   ----------------

   procedure Put_String (X : Col; Y : Row; Fg, Bg : Color; IntenseFg, IntenseBg : Boolean; S : String) is
      C : Natural := 0;
   begin
      for I in S'Range loop
         Put_Char (X + C, Y, Fg, Bg, IntenseFg, IntenseBg, S (I));
         C := C + 1;
      end loop;
   end Put_String;

   -----------
   -- Clear --
   -----------

   procedure Clear (Bg : Color; Intense: Boolean) is
   begin
      for X in Col'Range loop
         for Y in Row'Range loop
            Put_Char (X, Y, Bg, Bg, Intense, Intense, ' ');
         end loop;
      end loop;
   end Clear;
begin
   Clear (BLACK, False);
   Put_String(0,0,WHITE,BLACK,True,False,"ELF");
   --  Loop forever.
   while (True) loop
      null;
   end loop;

end Main;
