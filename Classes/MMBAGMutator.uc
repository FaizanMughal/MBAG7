//=============================================================================
// MMBAGMutator.
//
// Blood for the blood god, skulls for the skull throne.
//=============================================================================
class MMBAGMutator extends Mutator config(MBAG7);

// CVars
var() config float BloodMultiplier,BloodMomentumMultiplier,GoreMultiplier,
	GoreMomentumMultiplier;
var() config Name RoboticTypes[64];
// Fill this up with pawns that could be considered "robotic"
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

// Death function override
function PseudoDeath( Pawn Victim, Pawn Killer, Name DamageType )
{
	local Pawn Other;
	local Actor A;
	Victim.Health = Min(0,Victim.Health);
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

// Carcass and gib hook
function bool PreventDeath( Pawn Killed, Pawn Killer, Name DamageType,
	Vector HitLocation )
{
	// Gib Level 3
	if ( Killed.Health < -120 )
	{
		// TODO Spawn level 3 gibs
		PseudoDeath(Killed,Killer,DamageType);
		return true;
	}
	// Gib Level 2
	if ( Killed.Health < -60 )
	{
		// TODO Spawn level 2 gibs
		PseudoDeath(Killed,Killer,DamageType);
		return true;
	}
	// Gib Level 1
	if ( Killed.Health < -20 )
	{
		// TODO Spawn level 1 gibs
		PseudoDeath(Killed,Killer,DamageType);
		return true;
	}
	// Normal
	Killed.Health = 0;
	// TODO Spawn new carcass
	PseudoDeath(Killed,Killer,DamageType);
	if ( NextMutator != None )
		return NextMutator.PreventDeath(Killed,Killer,DamageType,
			HitLocation);
	return false;
}

// Bleeding goes here
function MutatorTakeDamage( out int ActualDamage, Pawn Victim,
	Pawn InstigatedBy, out Vector HitLocation, out Vector Momentum,
	Name DamageType )
{
	// TODO Spawn blood
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
	BloodMultiplier=1.0
	BloodMomentumMultiplier=1.0
	GoreMultiplier=1.0
	GoreMomentumMultiplier=1.0
	RoboticTypes(0)=TBoss
	RoboticTypes(1)=TBossBot
	RoboticTypes(2)=TBossCarcass
	RoboticTypes(3)=WarBoss
	RoboticTypes(4)=WarBossBot
	RoboticTypes(5)=XanMk2
	RoboticTypes(6)=XanMk2Bot
}
