//=============================================================================
// MDecal.
//
// All-in-one class for everything decal related in MBAG 7.
//=============================================================================
class MDecal extends Decal;

// decal textures
#exec TEXTURE IMPORT NAME=MDecal0 FILE=Textures\MDecal0.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecal1 FILE=Textures\MDecal1.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecal2 FILE=Textures\MDecal2.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecal3 FILE=Textures\MDecal3.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecal4 FILE=Textures\MDecal4.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecal5 FILE=Textures\MDecal5.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecal6 FILE=Textures\MDecal6.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecal7 FILE=Textures\MDecal7.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalG0 FILE=Textures\MDecalG0.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalG1 FILE=Textures\MDecalG1.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalG2 FILE=Textures\MDecalG2.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalG3 FILE=Textures\MDecalG3.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalG4 FILE=Textures\MDecalG4.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalG5 FILE=Textures\MDecalG5.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalG6 FILE=Textures\MDecalG6.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalG7 FILE=Textures\MDecalG7.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalO0 FILE=Textures\MDecalO0.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalO1 FILE=Textures\MDecalO1.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalO2 FILE=Textures\MDecalO2.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalO3 FILE=Textures\MDecalO3.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalO4 FILE=Textures\MDecalO4.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalO5 FILE=Textures\MDecalO5.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalO6 FILE=Textures\MDecalO6.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MDecalO7 FILE=Textures\MDecalO7.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecal0 FILE=Textures\MCDecal0.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecal1 FILE=Textures\MCDecal1.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecal2 FILE=Textures\MCDecal2.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecal3 FILE=Textures\MCDecal3.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecal4 FILE=Textures\MCDecal4.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecal5 FILE=Textures\MCDecal5.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecal6 FILE=Textures\MCDecal6.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecal7 FILE=Textures\MCDecal7.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalG0 FILE=Textures\MCDecalG0.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalG1 FILE=Textures\MCDecalG1.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalG2 FILE=Textures\MCDecalG2.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalG3 FILE=Textures\MCDecalG3.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalG4 FILE=Textures\MCDecalG4.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalG5 FILE=Textures\MCDecalG5.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalG6 FILE=Textures\MCDecalG6.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalG7 FILE=Textures\MCDecalG7.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalO0 FILE=Textures\MCDecalO0.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalO1 FILE=Textures\MCDecalO1.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalO2 FILE=Textures\MCDecalO2.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalO3 FILE=Textures\MCDecalO3.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalO4 FILE=Textures\MCDecalO4.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalO5 FILE=Textures\MCDecalO5.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalO6 FILE=Textures\MCDecalO6.pcx Modulated=On
#exec TEXTURE IMPORT NAME=MCDecalO7 FILE=Textures\MCDecalO7.pcx Modulated=On

var() Texture DecalTex[24];
var() Texture CDecalTex[24];

// TODO Everything

defaultproperties
{
	DecalTex(0)=Texture'MDecal0'
	DecalTex(1)=Texture'MDecal1'
	DecalTex(2)=Texture'MDecal2'
	DecalTex(3)=Texture'MDecal3'
	DecalTex(4)=Texture'MDecal4'
	DecalTex(5)=Texture'MDecal5'
	DecalTex(6)=Texture'MDecal6'
	DecalTex(7)=Texture'MDecal7'
	DecalTex(8)=Texture'MDecalG0'
	DecalTex(9)=Texture'MDecalG1'
	DecalTex(10)=Texture'MDecalG2'
	DecalTex(11)=Texture'MDecalG3'
	DecalTex(12)=Texture'MDecalG4'
	DecalTex(13)=Texture'MDecalG5'
	DecalTex(14)=Texture'MDecalG6'
	DecalTex(15)=Texture'MDecalG7'
	DecalTex(16)=Texture'MDecalO0'
	DecalTex(17)=Texture'MDecalO1'
	DecalTex(18)=Texture'MDecalO2'
	DecalTex(19)=Texture'MDecalO3'
	DecalTex(20)=Texture'MDecalO4'
	DecalTex(21)=Texture'MDecalO5'
	DecalTex(22)=Texture'MDecalO6'
	DecalTex(23)=Texture'MDecalO7'
	CDecalTex(0)=Texture'MCDecal0'
	CDecalTex(1)=Texture'MCDecal1'
	CDecalTex(2)=Texture'MCDecal2'
	CDecalTex(3)=Texture'MCDecal3'
	CDecalTex(4)=Texture'MCDecal4'
	CDecalTex(5)=Texture'MCDecal5'
	CDecalTex(6)=Texture'MCDecal6'
	CDecalTex(7)=Texture'MCDecal7'
	CDecalTex(8)=Texture'MCDecalG0'
	CDecalTex(9)=Texture'MCDecalG1'
	CDecalTex(10)=Texture'MCDecalG2'
	CDecalTex(11)=Texture'MCDecalG3'
	CDecalTex(12)=Texture'MCDecalG4'
	CDecalTex(13)=Texture'MCDecalG5'
	CDecalTex(14)=Texture'MCDecalG6'
	CDecalTex(15)=Texture'MCDecalG7'
	CDecalTex(16)=Texture'MCDecalO0'
	CDecalTex(17)=Texture'MCDecalO1'
	CDecalTex(18)=Texture'MCDecalO2'
	CDecalTex(19)=Texture'MCDecalO3'
	CDecalTex(20)=Texture'MCDecalO4'
	CDecalTex(21)=Texture'MCDecalO5'
	CDecalTex(22)=Texture'MCDecalO6'
	CDecalTex(23)=Texture'MCDecalO7'
}
