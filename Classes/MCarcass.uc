//=============================================================================
// MCarcass.
//
// The new body type for MBAG7.
//=============================================================================
class MCarcass extends Actor;

var Pawn Bleeder;
var int bloodtype;
var float lifetime;

event AnimEnd()
{
	// Zap animation is two-phase
	if ( AnimSequence == 'Dead9' )
		PlayAnim('Dead9B',1.1,0.1);
}

// Called by animations
function LandThump()
{
	SetCollisionSize(Bleeder.CollisionRadius,Bleeder.CollisionHeight*0.2);
	PrePivot.Z = Bleeder.CollisionHeight*0.8;
	SetLocation(Location-PrePivot);
	PlaySound(Sound'UnrealShare.Thump');
}

function Setup( Pawn Other )
{
	local int i;
	for ( i=0; i<8; i++ )
		MultiSkins[i] = Other.MultiSkins[i];
	bMeshEnviroMap = Other.bMeshEnviroMap;
	Mesh = Other.Mesh;
	Skin = Other.Skin;
	Texture = Other.Texture;
	Fatness = Other.Fatness;
	DrawScale = Other.DrawScale;
	SetCollisionSize(Other.CollisionRadius,Other.CollisionHeight);
	SetRotation(Other.Rotation);
	AnimSequence = Other.AnimSequence;
	AnimFrame = Other.AnimFrame;
	AnimRate = Other.AnimRate;
	TweenRate = Other.TweenRate;
	AnimMinRate = Other.AnimMinRate;
	AnimLast = Other.AnimLast;
	bAnimLoop = Other.bAnimLoop;
	bAnimFinished = Other.bAnimFinished;
	Velocity = Other.Velocity;
	Mass = Other.Mass;
	Buoyancy = Mass+1;
	Bleeder = Other;
	bloodtype = Class'MMBAGMutator'.Static.BloodType(Other);
}

function Vector ClosestBodySpot( Vector V )
{
	if ( Mesh.IsA('LodMesh') )
		return Class'VertUtil'.Static.GetVertexLocationLOD(LodMesh
			(Mesh),self,Class'VertUtil'.Static.GetClosestVertex
			(Mesh,self,V));
	return Class'VertUtil'.Static.GetVertexLocation(Mesh,self,
		Class'VertUtil'.Static.GetClosestVertex(Mesh,self,V));
}

// Might implement viewpoint changing... maybe
function Decap()
{
	local int i;
	local Vector GibLoc;
	local MChunk meat;
	for ( i=0; i<16; i++ )
	{
		GibLoc = ClosestBodySpot(Location+vect(0,0,1)*CollisionHeight
			*0.9+VRand()*FRand()*4.0)+VRand()*FRand()*4.0;
		if ( GibLoc == vect(0,0,0) )
			GibLoc = Location+vect(0,0,1)*CollisionHeight*0.9
				+VRand()*FRand()*8.0;
		meat = Spawn(Class'MChunk',,,GibLoc);
		if ( meat == None )
			continue;
		meat.Setup(Bleeder);
		meat.Hazy();
		meat.Velocity *= 0.6;
		meat.Velocity.Z += RandRange(160,320);
	}
}

event Landed( Vector HitNormal )
{
	HitWall(HitNormal,Level);
}

event HitWall( Vector HitNormal, Actor Wall )
{
	// TODO
}

// Cheap cleanup
event Tick( float deltatime )
{
	local Rotator olRot;
	lifetime += deltatime;
	if ( lifetime < 10.0 )
		return;
	ScaleGlow -= deltatime;
	olRot = Rotation;
	olRot.Yaw += 65536*deltatime;
	SetRotation(olRot);
	DrawScale -= deltatime;
	PrePivot.Z -= 8.0*deltatime;
	if ( DrawScale < 0.0 )
		Destroy();
}

defaultproperties
{
	bHidden=False
	DrawType=DT_Mesh
	Physics=PHYS_Falling
	bCollideActors=True
	bCollideWorld=True
	bProjTarget=True
	bBounce=True
	bFixedRotationDir=True
	bGameRelevant=True
	bUnlit=False
}
