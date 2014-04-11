//=============================================================================
// MBlood.
//
// All-in-one class for everything blood related in MBAG 7.
//=============================================================================
class MBlood extends Actor;

// single droplet texture
#exec TEXTURE IMPORT NAME=MDrop FILE=Textures\MDrop.pcx Additive=On
#exec TEXTURE IMPORT NAME=MDropG FILE=Textures\MDropG.pcx Additive=On
#exec TEXTURE IMPORT NAME=MDropO FILE=Textures\MDropO.pcx Modulated=On
// burst textures
#exec TEXTURE IMPORT NAME=MBurst0 FILE=Textures\MBurst0.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurst1 FILE=Textures\MBurst1.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurst2 FILE=Textures\MBurst2.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurst3 FILE=Textures\MBurst3.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurst4 FILE=Textures\MBurst4.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurst5 FILE=Textures\MBurst5.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurst6 FILE=Textures\MBurst6.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurst7 FILE=Textures\MBurst7.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurstG0 FILE=Textures\MBurstG0.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurstG1 FILE=Textures\MBurstG1.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurstG2 FILE=Textures\MBurstG2.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurstG3 FILE=Textures\MBurstG3.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurstG4 FILE=Textures\MBurstG4.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurstG5 FILE=Textures\MBurstG5.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurstG6 FILE=Textures\MBurstG6.pcx Additive=On
#exec TEXTURE IMPORT NAME=MBurstG7 FILE=Textures\MBurstG7.pcx Additive=On
// smoke textures
#exec TEXTURE IMPORT NAME=MSmoke0 FILE=Textures\MSmoke0.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmoke1 FILE=Textures\MSmoke1.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmoke2 FILE=Textures\MSmoke2.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmoke3 FILE=Textures\MSmoke3.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmoke4 FILE=Textures\MSmoke4.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmoke5 FILE=Textures\MSmoke5.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmoke6 FILE=Textures\MSmoke6.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmoke7 FILE=Textures\MSmoke7.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmokeG0 FILE=Textures\MSmokeG0.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmokeG1 FILE=Textures\MSmokeG1.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmokeG2 FILE=Textures\MSmokeG2.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmokeG3 FILE=Textures\MSmokeG3.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmokeG4 FILE=Textures\MSmokeG4.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmokeG5 FILE=Textures\MSmokeG5.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmokeG6 FILE=Textures\MSmokeG6.pcx Additive=On
#exec TEXTURE IMPORT NAME=MSmokeG7 FILE=Textures\MSmokeG7.pcx Additive=On

var() Texture DropTex[3];
var() Texture BurstTex[16];
var() Texture SmokeTex[16];

// TODO Everything

defaultproperties
{
	DropTex(0)=Texture'MDrop'
	DropTex(1)=Texture'MDropG'
	DropTex(2)=Texture'MDropO'
	BurstTex(0)=Texture'MBurst0'
	BurstTex(1)=Texture'MBurst1'
	BurstTex(2)=Texture'MBurst2'
	BurstTex(3)=Texture'MBurst3'
	BurstTex(4)=Texture'MBurst4'
	BurstTex(5)=Texture'MBurst5'
	BurstTex(6)=Texture'MBurst6'
	BurstTex(7)=Texture'MBurst7'
	BurstTex(8)=Texture'MBurstG0'
	BurstTex(9)=Texture'MBurstG1'
	BurstTex(10)=Texture'MBurstG2'
	BurstTex(11)=Texture'MBurstG3'
	BurstTex(12)=Texture'MBurstG4'
	BurstTex(13)=Texture'MBurstG5'
	BurstTex(14)=Texture'MBurstG6'
	BurstTex(15)=Texture'MBurstG7'
	SmokeTex(0)=Texture'MSmoke0'
	SmokeTex(1)=Texture'MSmoke1'
	SmokeTex(2)=Texture'MSmoke2'
	SmokeTex(3)=Texture'MSmoke3'
	SmokeTex(4)=Texture'MSmoke4'
	SmokeTex(5)=Texture'MSmoke5'
	SmokeTex(6)=Texture'MSmoke6'
	SmokeTex(7)=Texture'MSmoke7'
	SmokeTex(8)=Texture'MSmokeG0'
	SmokeTex(9)=Texture'MSmokeG1'
	SmokeTex(10)=Texture'MSmokeG2'
	SmokeTex(11)=Texture'MSmokeG3'
	SmokeTex(12)=Texture'MSmokeG4'
	SmokeTex(13)=Texture'MSmokeG5'
	SmokeTex(14)=Texture'MSmokeG6'
	SmokeTex(15)=Texture'MSmokeG7'
}
