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

var Pawn Bleeder;
var int bloodtype;
var int type;

// taken from UnSX QSM (Quick 'n dirty SMoke effect)
var() float GrowRange[2];
var() float InitKick,InitGrow,DecelRate;
var() float LifeRange[2];
var() float Accels[2];
var float AccelZ;
var Vector RealVelocity,UpwardsVelocity;
var float AccelAdd;
var float DLifeSpan,SLifeSpan;

function DoPuff( int Damage, Pawn Other, Vector Momentum )
{
	Bleeder = Other;
	bloodtype = Class'MMBAGMutator'.Static.BloodType(Other);
	if ( bloodtype == 2 )
		Destroy();	// TODO Sparks
	SetPhysics(PHYS_Projectile);
	Velocity += Momentum*0.2;
	DrawScale = 0.08+FRand()*0.04;
	DrawScale += Min(Damage,100)*0.001;
	Texture = BurstTex[Rand(8)+bloodtype*8];
	type = 1;
}

function DoSmoke( Pawn Other )
{
	Bleeder = Other;
	bloodtype = Class'MMBAGMutator'.Static.BloodType(Other);
	if ( bloodtype == 2 )
		Destroy();	// TODO Smoke
	SetPhysics(PHYS_Projectile);
	DrawScale = 0.8+FRand()*0.5;
	Texture = SmokeTex[Rand(8)+bloodtype*8];
	type = 2;
	// QSM initializer
	Accels[0] = Abs(Accels[0]);
	AccelAdd = Accels[1];
	SLifeSpan = RandRange(LifeRange[0],LifeRange[1]);
	DLifeSpan = SLifeSpan;
	Velocity += (InitKick*FRand())*VRand();
	RealVelocity = Velocity;
}

function DoDrop( int Damage, Pawn Other, Vector Momentum )
{
	Bleeder = Other;
	bloodtype = Class'MMBAGMutator'.Static.BloodType(Other);
	DrawScale = 0.06+FRand()*0.08;
	DrawScale += Min(Damage,50)*0.001;
	ScaleGlow = 0.3;
	Velocity += Momentum*0.8+VRand()*FRand()*24;
	Texture = DropTex[bloodtype];
	if ( bloodtype == 2 )
		Style = STY_Modulated;
	type = 0;
}

function DoTrail( Pawn Other, Vector Momentum )
{
	Bleeder = Other;
	bloodtype = Class'MMBAGMutator'.Static.BloodType(Other);
	if ( bloodtype == 2 )
		Destroy();	// TODO Smoke
	SetPhysics(PHYS_Projectile);
	DrawScale = 0.4+FRand()*0.3;
	Texture = SmokeTex[Rand(8)+bloodtype*8];
	type = 2;
	// QSM initializer
	GrowRange[0] *= 0.8;
	GrowRange[1] *= 0.8;
	Accels[0] = Abs(Accels[0]);
	AccelAdd = Accels[1];
	SLifeSpan = RandRange(LifeRange[0]*0.1,LifeRange[1]*0.2);
	DLifeSpan = SLifeSpan;
	Velocity += (InitKick*FRand())*VRand();
	Velocity += 0.01*Momentum+VRand()*8;
	RealVelocity = Velocity;
}

function DoPool( Pawn Other, Vector HitNormal )
{
	// TODO
}

event Tick( float deltatime )
{
	if ( type == 2 )
	{
		AccelZ = FMin(Accels[0],AccelZ+AccelAdd*(0.8+0.4*FRand())
			*deltatime);
		UpwardsVelocity.Z = FMin(Accels[0],UpwardsVelocity.Z+AccelZ
			*(0.8+0.4*FRand())*deltatime);
		ScaleGlow = DLifeSpan/SLifeSpan;
		DLifeSpan -= deltatime;
		DrawScale = FMin(5.0,DrawScale+RandRange(GrowRange[0],
			GrowRange[1])*deltatime);
		RealVelocity *= DecelRate;
		Velocity = RealVelocity+UpwardsVelocity;
		if ( DLifeSpan <= 0.0 )
			Destroy();
	}
	else if ( type == 1 )
	{
		Velocity *= 0.982;
		Velocity.Z -= 70*deltatime;
		DrawScale += RandRange(0.3,0.7)*deltatime;
		ScaleGlow -= RandRange(1.22,2.38)*deltatime;
		if ( ScaleGlow <= 0.0 )
			Destroy();
	}
	else if ( Region.Zone.bWaterZone )
	{
		Velocity *= 0.982;
		DrawScale += RandRange(0.1,0.3)*deltatime;
		ScaleGlow -= RandRange(0.62,0.98)*deltatime;
		if ( ScaleGlow <= 0.0 )
			Destroy();
	}
}

event Landed( Vector HitNormal )
{
	HitWall(HitNormal,Level);
}

event HitWall( Vector HitNormal, Actor Wall )
{
	if ( type == 2 )
	{
		RealVelocity *= 0;
		UpwardsVelocity *= 0;
		if ( Wall != None )
			RealVelocity += 0.5*Wall.Velocity;
		if ( FRand() < 0.2 )
			Destroy();
	}
	else if ( type == 1 )
		Velocity *= 0;
	else
	{
		if ( !Region.Zone.bWaterZone )
			Destroy();
		Velocity = 0.2*(Velocity-2*HitNormal*(Velocity dot HitNormal));
	}
}

defaultproperties
{
	bHidden=False
	bCollideActors=False
	bCollideWorld=True
	CollisionRadius=0
	CollisionHeight=0
	bGameRelevant=True
	bUnlit=False
	DrawType=DT_Sprite
	Style=STY_Translucent
	Texture=Texture'MDrop'
	Physics=PHYS_Falling
	bBounce=True
	bFixedRotationDir=True
	Mass=100
	Buoyancy=100
	DrawScale=0.1
	LifeRange(0)=1.850000
	LifeRange(1)=3.660000
	Accels(0)=39.000000
	Accels(1)=23.000000
	DecelRate=0.981500
	GrowRange(0)=0.333500
	GrowRange(1)=0.674300
	InitKick=64.000000
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
