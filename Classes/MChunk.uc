//=============================================================================
// MChunk.
//
// Adaptable class for every single type of gore chunk.
//=============================================================================
class MChunk extends Actor;

// chunk textures
#exec TEXTURE IMPORT NAME=MChunk FILE=Textures\MChunk.pcx
#exec TEXTURE IMPORT NAME=MChunkG FILE=Textures\MChunkG.pcx
#exec TEXTURE IMPORT NAME=MChunkO FILE=Textures\MChunkO.pcx

var() Texture ChunkTex[3];
var() Mesh ChunkMesh[8];

// TODO Everything

defaultproperties
{
	ChunkTex(0)=Texture'MChunk'
	ChunkTex(1)=Texture'MChunkG'
	ChunkTex(2)=Texture'MChunkO'
	ChunkMesh(0)=LodMesh'Botpack.chunkM'
	ChunkMesh(1)=LodMesh'Botpack.chunk2M'
	ChunkMesh(2)=LodMesh'Botpack.chunk3M'
	ChunkMesh(3)=LodMesh'Botpack.chunk4M'
	ChunkMesh(4)=LodMesh'UnrealI.Chnk1'
	ChunkMesh(5)=LodMesh'UnrealI.Chnk2'
	ChunkMesh(6)=LodMesh'UnrealI.Chnk3'
	ChunkMesh(7)=LodMesh'UnrealI.Chnk4'
}
