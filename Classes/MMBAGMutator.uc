//=============================================================================
// MMBAGMutator.
//
// Blood for the blood god, skulls for the skull throne.
//=============================================================================
class MMBAGMutator extends Mutator config(MBAG7);

// CVars
var() config float BloodMultiplier,BloodMomentumMultiplier,GoreMultiplier,
	GoreMomentumMultiplier;
var() config int DamageCap;
var() config Name RoboticTypes[64];
var() config Name NoBleeding[64];
var() config int FunMode;
// Fun modes:
//  0 = nofun mode (just the normal mode)
//  1 = brutal mode (hue)
//  2 = tarantino mode (high pressure ahead)
//  3 = wat mode (no words can describe it)

var bool bInitialized;

// Set up
function PostBeginPlay()
{
	if ( bInitialized )
		return;
	Level.Game.RegisterDamageMutator(self);
	bInitialized = true;
}

// Is robotic?
static function bool CheckRobot( Actor A )
{
	local int i;
	if ( A == None )
		return false;
	for ( i=0; Default.RoboticTypes[i]!=''; i++ )
		if ( A.IsA(Default.RoboticTypes[i]) )
			return true;
	return false;
}

// Return blood type (0 = red, 1 = green, 2 = robot)
static function int BloodType( Pawn P )
{
	if ( CheckRobot(P) )
		return 2;
	if ( P.IsA('Bot') && Bot(P).bGreenBlood )
		return 1;
	if ( P.IsA('ScriptedPawn') && ScriptedPawn(P).bGreenBlood )
		return 1;
	if ( P.IsA('Bloblet') )
		return 1;
	return 0;
}

// Damage type causes bleeding?
static function bool BleedDamage( Name DamageType )
{
	local int i;
	if ( DamageType == '' )
		return true;
	for ( i=0; Default.NoBleeding[i]!=''; i++ )
		if ( DamageType == Default.NoBleeding[i] )
			return false;
	return true;
}

// Death function override
function PseudoDeath( Pawn Victim, Pawn Killer, Name DamageType )
{
	local Pawn Other;
	local Actor A;
	Victim.Health = 0;
	for ( Other=Level.PawnList; Other!=None; Other=Other.nextPawn )
		Other.Killed(Killer,Victim,DamageType);
	if ( Victim.CarriedDecoration != None )
		Victim.DropDecoration();
	Level.Game.Killed(Killer,Victim,DamageType);
	if ( Victim.Event != '' )
		ForEach AllActors(Class'Actor',A,Victim.Event)
			A.Trigger(Victim,Killer);
	Level.Game.DiscardInventory(Victim);
	Victim.Velocity *= 0;
	Victim.Acceleration *= 0;
	Victim.SetPhysics(PHYS_None);
	Victim.bHidden = true;
	if ( Victim.bIsPlayer )
		Victim.HidePlayer();
	else
		Victim.Destroy();
	if ( Level.Game.bGameEnded )
		return;
	Victim.GotoState('Dying');
}

function Vector RandomBodySpot( Pawn P )
{
	local Mesh M;
	local int num;
	local Vector rv;
	if ( (P.DrawType != DT_Mesh) || (P.Mesh == None) )
	{
		rv.x = (1-(FRand()*2))*P.CollisionRadius;
		rv.y = (1-(FRand()*2))*P.CollisionRadius;
		rv.z = (1-(FRand()*2))*P.CollisionHeight;
		return P.Location+rv;
	}
	M = P.Mesh;
	num = Class'VertUtil'.Static.GetVertexCount(M);
	if ( M.IsA('LodMesh') )
		return Class'VertUtil'.Static.GetVertexLocationLOD(LodMesh(M),
			P,Rand(num));
	return Class'VertUtil'.Static.GetVertexLocation(M,P,Rand(num));
}

function Vector ClosestBodySpot( Pawn P, Vector V )
{
	local Mesh M;
	M = P.Mesh;
	if ( M.IsA('LodMesh') )
		return Class'VertUtil'.Static.GetVertexLocationLOD(LodMesh(M),
			P,Class'VertUtil'.Static.GetClosestVertex(M,P,V));
	return Class'VertUtil'.Static.GetVertexLocation(M,P,
		Class'VertUtil'.Static.GetClosestVertex(M,P,V));
}

// Cheap fix for invisible untouchable players bug
function Timer()
{
	local Pawn P;
	for ( P=Level.PawnList; P!=None; P=P.nextPawn )
	{
		if ( !P.IsInState('Dying') && (P.Health > 0) && P.bHidden
			&& !P.bCollideActors )
		{
			if ( P.PlayerReplicationInfo != None )
				Log(self$": [GROSS HACK]"@P
					.PlayerReplicationInfo.PlayerName
					@"needs re-kill");
			else
				Log(self$": [GROSS HACK]"@P@"needs re-kill");
			P.Health = 0;
			if ( !Level.Game.bGameEnded )
				P.GotoState('Dying');
		}
	}
}

// Carcass and gib hook
function bool PreventDeath( Pawn Killed, Pawn Killer, Name DamageType,
	Vector HitLocation )
{
	local MChunk meat;
	local MCarcass body;
	local Vector GibLocation;
	local int i, num;
	// Initiate terrible fix
	SetTimer(0.01,false);
	num = Min(-Killed.Health,DamageCap)*GoreMultiplier;
	// Decapitation is a special case
	if ( DamageType == 'Decapitated' )
	{
		Killed.PlayDying(DamageType,HitLocation);
		Killed.Health = 0;
		if ( Killed.IsA('Bot') )
			Bot(Killed).PlayDyingSound();
		if ( Killed.IsA('TournamentPlayer') )
			TournamentPlayer(Killed).PlayDyingSound();
		body = Spawn(class'MCarcass',,,Killed.Location);
		if ( body != None )
		{
			body.Setup(Killed);
			body.Velocity *= 0.05;
			body.Decap();
		}
		PseudoDeath(Killed,Killer,DamageType);
		return true;
	}
	// Gib Level 3
	if ( Killed.Health < -200 )
	{
		for ( i=0; i<num*1.4; i++ )
		{
			GibLocation = RandomBodySpot(Killed);
			if ( GibLocation == vect(0,0,0) )
				GibLocation = Killed.Location;
			meat = Spawn(class'MChunk',,,GibLocation);
			if ( meat == None )
				continue;
			meat.Setup(Killed);
			meat.Smoky();
			meat.Velocity *= 1.5*GoreMomentumMultiplier;
			meat.Velocity.Z += RandRange(200,300)
				*GoreMomentumMultiplier;
		}
		PseudoDeath(Killed,Killer,DamageType);
		return true;
	}
	// Gib Level 2
	if ( Killed.Health < -100 )
	{
		for ( i=0; i<num*1.2; i++ )
		{
			GibLocation = RandomBodySpot(Killed);
			if ( GibLocation == vect(0,0,0) )
				GibLocation = Killed.Location;
			meat = Spawn(class'MChunk',,,GibLocation);
			if ( meat == None )
				continue;
			meat.Setup(Killed);
			meat.Hazy();
			meat.Velocity *= 1.2*GoreMomentumMultiplier;
			meat.Velocity.Z += RandRange(150,250)
				*GoreMomentumMultiplier;
		}
		PseudoDeath(Killed,Killer,DamageType);
		return true;
	}
	// Gib Level 1
	if ( Killed.Health < -20 )
	{
		for ( i=0; i<num; i++ )
		{
			GibLocation = RandomBodySpot(Killed);
			if ( GibLocation == vect(0,0,0) )
				GibLocation = Killed.Location;
			meat = Spawn(class'MChunk',,,GibLocation);
			if ( meat == None )
				continue;
			meat.Setup(Killed);
			meat.Velocity *= GoreMomentumMultiplier;
			meat.Velocity.Z += RandRange(50,150)
				*GoreMomentumMultiplier;
		}
		PseudoDeath(Killed,Killer,DamageType);
		return true;
	}
	// Normal
	Killed.Health = 0;
	Killed.PlayDying(DamageType,HitLocation);
	if ( Killed.IsA('Bot') )
		Bot(Killed).PlayDyingSound();
	if ( Killed.IsA('TournamentPlayer') )
		TournamentPlayer(Killed).PlayDyingSound();
	body = Spawn(class'MCarcass',,,Killed.Location);
	if ( body != None )
		body.Setup(Killed);
	PseudoDeath(Killed,Killer,DamageType);
	return true;
}

// Bleeding goes here
function MutatorTakeDamage( out int ActualDamage, Pawn Victim,
	Pawn InstigatedBy, out Vector HitLocation, out Vector Momentum,
	Name DamageType )
{
	local Vector BleedSpot;
	local MBlood blud;
	local int i;
	// Some damage types should cause no bleeding
	if ( !BleedDamage(DamageType) )
		if ( NextDamageMutator != None )
			NextDamageMutator.MutatorTakeDamage(ActualDamage,
				Victim,InstigatedBy,HitLocation,Momentum,
				DamageType);
	// Find closest vertex to hit location
	if ( (Victim.DrawType != DT_Mesh) || (Victim.Mesh == None) )
		BleedSpot = HitLocation;
	else
		BleedSpot = ClosestBodySpot(Victim,HitLocation);
	if ( BleedSpot == vect(0,0,0) )
		BleedSpot = Victim.Location;
	// Let there be blood!
	blud = Spawn(class'MBlood',,,BleedSpot);
	if ( blud != None )
		blud.DoPuff(ActualDamage,Victim,Momentum);
	for ( i=0; i<(Min(ActualDamage,DamageCap)*BloodMultiplier); i++ )
	{
		blud = Spawn(class'MBlood',,,BleedSpot+VRand()*3.0);
		if ( blud != None )
			blud.DoDrop(ActualDamage,Victim,Momentum);
	}
	if ( NextDamageMutator != None )
		NextDamageMutator.MutatorTakeDamage(ActualDamage,Victim,
			InstigatedBy,HitLocation,Momentum,DamageType);
}

// Original blood effect hider
function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
	if ( Other.IsA('Blood2') || Other.IsA('UT_Blood2')
		|| Other.IsA('UT_BloodPuff') || Other.IsA('BloodPuff')
		|| Other.IsA('UT_GreenBloodPuff')
		|| Other.IsA('GreenBloodPuff') )
		Other.bHidden = True;
	bSuperRelevant = 0;
	return true;
}

defaultproperties
{
	BloodMultiplier=0.6
	BloodMomentumMultiplier=0.5
	GoreMultiplier=0.2
	GoreMomentumMultiplier=0.8
	DamageCap=40
	RoboticTypes(0)=TBoss
	RoboticTypes(1)=TBossBot
	RoboticTypes(2)=TBossCarcass
	RoboticTypes(3)=WarBoss
	RoboticTypes(4)=WarBossBot
	RoboticTypes(5)=XanMk2
	RoboticTypes(6)=XanMk2Bot
	NoBleeding(0)=Exploded
	NoBleeding(1)=RocketDeath
	NoBleeding(2)=FlakDeath
	NoBleeding(3)=GrenadeDeath
	NoBleeding(4)=RipperAltDeath
	NoBleeding(5)=RedeemerDeath
	NoBleeding(6)=Vaporized
	NoBleeding(7)=Burned
	NoBleeding(8)=Drowned
	NoBleeding(9)=Corroded
	NoBleeding(10)=Frozen
	NoBleeding(11)=Fell
	NoBleeding(12)=Stomped
	NoBleeding(13)=Crushed
	FunMode=0
}
