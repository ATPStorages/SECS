with Interfaces; use Interfaces;

package PNG is
   pragma Elaborate_Body;
   
   type PNGChunkType is record
      Literal       : String (1..4);
      Critical      : Boolean      ;
      Specification : Boolean      ;
      Reserved      : Boolean      ;
      SafeToCopy    : Boolean      ;
   end record;
   
   type PNGChunkData (DataSize : Natural) is record
      Literal : String(1..DataSize);
   end record;
   
   type PNGChunk (DataSize : Natural) is record
      Length    : Unsigned_32           ;
      ChunkType : PNGChunkType          ;
      Data      : PNGChunkData(DataSize);
      CRC32     : Unsigned_32           ;
   end record;
   
   type ChunkArray is array (Natural range <>) of access PNGChunk;
   
   type PNGFile (ChunkCount: Natural) is record
      Chunks : ChunkArray(1..ChunkCount);
   end record;
   
   --function Decode(Data : String) return PNGFile;
end PNG;
