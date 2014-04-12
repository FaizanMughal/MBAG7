//=============================================================================
// MChunk.
//
// Adaptable class for every single type of gore chunk.
//=============================================================================
class MChunk extends Actor config(MBAG7);

// chunk textures
#exec TEXTURE IMPORT NAME=MChunk FILE=Textures\MChunk.pcx
#exec TEXTURE IMPORT NAME=MChunkG FILE=Textures\MChunkG.pcx
#exec TEXTURE IMPORT NAME=MChunkO FILE=Textures\MChunkO.pcx

var() Texture ChunkTex[3];
var() Mesh ChunkMesh[8];
var() config float MeatBounce,GibSpan;
var() Sound HitSound[5];
var() Sound HitSoundO[3];

var float timbleeds, lifetime;
var Pawn Bleeder;
var int Health;
var int btype;

function Setup( Pawn Other )
{
	local MBlood blud;
	local int i;
	Bleeder = Other;
	Velocity = Bleeder.Velocity*0.4;
	Velocity += VRand()*RandRange(80,180);
	Health = 20+Rand(60);
	Mesh = ChunkMesh[Rand(8)];
	DrawScale = 0.3+Frand()*0.7;
	Texture = ChunkTex[Class'MMBAGMutator'.Static.BloodType(Other)];
	MultiSkins[1] = Texture;
}

function Smoky()
{
	local int i;
	local MBlood blud;
	Velocity *= 2;
	if ( FRand() < 0.4 )
		return;
	for ( i=0; i<2; i++ )
	{
		blud = Spawn(class'MBlood');
		if ( blud == None )
			continue;
		blud.DoSmoke(Bleeder);
	}
}

function Hazy()
{
	local MBlood blud;
	Velocity *= 1.5;
	if ( FRand() < 0.3 )
		return;
	blud = Spawn(class'MBlood');
	if ( blud != None )
		blud.DoSmoke(Bleeder);
}

event Tick( float deltatime )
{
	local MBlood blud;
	local int i;
	lifetime += deltatime;
	if ( lifetime > GibSpan*DrawScale )
		Destroy();
	timbleeds += deltatime;
	if ( (timbleeds <= 0.05) || (VSize(Velocity) < 10) )
		return;
	timbleeds = 0;
	if ( FRand() < 0.2 )
		return;
	blud = Spawn(class'MBlood',,,Location+VRand()*4*DrawScale);
	if ( blud != None )
		blud.DoTrail(Bleeder,-Velocity);
}

event bool PreTeleport( Teleporter InTeleporter )
{
	InTeleporter.PlayTeleportEffect(self,false);
	return Super.PreTeleport(InTeleporter);
}

event PostTeleport( Teleporter OutTeleporter )
{
	OutTeleporter.PlayTeleportEffect(self,true);
	Super.PostTeleport(OutTeleporter);
}

event TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation,
	Vector Momentum, Name DamageType )
{
	local MBlood blud;
	SetPhysics(PHYS_Falling);
	Velocity += Momentum/Mass;
	RotationRate.Pitch = FRand()*34000*(VSize(Velocity)/200);
	RotationRate.Yaw = FRand()*42000*(VSize(Velocity)/200);
	RotationRate.Roll = FRand()*56000*(VSize(Velocity)/200);
	Health -= Damage;
	if ( Class'MMBAGMutator'.Static.BleedDamage(DamageType) )
	{
		if ( btype == 2 )
			PlaySound(HitSoundO[Rand(3)],SLOT_Interact,0.5);
		else
			PlaySound(HitSound[Rand(5)],SLOT_Interact,0.5);
		blud = Spawn(class'MBlood',,,HitLocation);
		if ( blud != None )
			blud.DoPuff(Damage,Bleeder,Momentum);
	}
	if ( Health <= 0 )
		Destroy();
}

event Landed( Vector HitNormal )
{
	HitWall(HitNormal,Level);
}

event Touch( Actor Other )
{
	if ( Other.IsA('MChunk') )
		return;
	SetPhysics(PHYS_Falling);
	Velocity += (Other.Velocity*Other.Mass)/(100*Mass);
	Velocity.Z += RandRange(20,80);
	RotationRate.Pitch = FRand()*34000*(VSize(Velocity)/200);
	RotationRate.Yaw = FRand()*42000*(VSize(Velocity)/200);
	RotationRate.Roll = FRand()*56000*(VSize(Velocity)/200);
}

event HitWall( Vector HitNormal, Actor Wall )
{
	local Vector RealHitNormal,X,Y,Z;
	local MDecal dec;
	local MBlood blud;
	dec = Spawn(class'MDecal',,,Location+HitNormal*8,Rotator(HitNormal));
	if ( dec != None )
		dec.Splat(Bleeder,Velocity);
	blud = Spawn(class'MBlood');
	if ( blud != None )
		blud.DoPuff(VSize(Velocity),Bleeder,-Velocity);
	if ( btype == 2 )
		PlaySound(HitSoundO[Rand(3)],SLOT_Interact,0.5);
	else
		PlaySound(HitSound[Rand(5)],SLOT_Interact,0.5);
	RealHitNormal = HitNormal;
	HitNormal = Normal(HitNormal+0.3*VRand());
	if ( (HitNormal dot RealHitNormal) < 0 )
		HitNormal *= -0.5;
	Velocity = MeatBounce*(Velocity-2*HitNormal*(Velocity dot HitNormal));
	if ( Wall != None )
		Velocity += Wall.Velocity*0.5;
	SetPhysics(PHYS_Falling);
	RotationRate.Pitch = FRand()*34000*(VSize(Velocity)/200);
	RotationRate.Yaw = FRand()*42000*(VSize(Velocity)/200);
	RotationRate.Roll = FRand()*56000*(VSize(Velocity)/200);
	if ( VSize(Velocity) > 40 )
		return;
	if ( HitNormal.Z < 0.6 )
	{
		GetAxes(Rotator(Velocity),X,Y,Z);
		X = Y cross RealHitNormal;
		Velocity = VSize(Velocity)*X+HitNormal*45;
		return;
	}
	Velocity *= 0;
	RotationRate *= 0;
	SetPhysics(PHYS_None);
}

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
	HitSound(0)=Sound'UnrealI.gibP1'
	HitSound(1)=Sound'UnrealI.gibP3'
	HitSound(2)=Sound'UnrealI.gibP4'
	HitSound(3)=Sound'UnrealI.gibP5'
	HitSound(4)=Sound'UnrealI.gibP6'
	HitSoundO(0)=Sound'UnrealI.Hit1'
	HitSoundO(1)=Sound'UnrealI.Hit3'
	HitSoundO(2)=Sound'UnrealI.Hit5'
	MeatBounce=0.6
	GibSpan=40.0
	Mass=50.0
	Buoyancy=51.0
	Physics=PHYS_Falling
	bHidden=False
	DrawType=DT_Mesh
	bCollideActors=True
	bCollideWorld=True
	bProjTarget=True
	bBounce=True
	bFixedRotationDir=True
	bGameRelevant=True
	bUnlit=False
	CollisionRadius=4.0
	CollisionHeight=4.0
}
