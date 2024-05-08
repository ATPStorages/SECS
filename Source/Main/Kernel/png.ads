with Interfaces; use Interfaces;

package PNG is
   type PNGChunkType is record
      Literal       : String (1..4);
      Critical      : Boolean      ;
      Specification : Boolean      ;
      Reserved      : Boolean      ;
      SafeToCopy    : Boolean      ;
   end record;
   
   type PNGChunk is record
      Length    : Unsigned_32 ;
      ChunkType : PNGChunkType;
      CRC32     : Unsigned_32 ;
   end record;
   
   type ChunkArray is array (Integer range <>) of PNGChunk;
   type PNGFile (ChunkCount: Integer) is record
      Chunks : ChunkArray(1..ChunkCount);
   end record;

end PNG;
