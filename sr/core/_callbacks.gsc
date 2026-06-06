#include sr\sys\_events;
#include sr\utils\_common;

playerConnect()
{
	self endon("connect");
	self endon("disconnect");
	level notify("connected", self);
	level.player = self;

	self.enable3DWaypoints = true;
	self.enableDeathIcons = true;
	self.classType = undefined;
	self.selectedClass = false;
	self.teamKill = false;
	self.hidden = false;

	if (game["state"] == "end")
		return;

	self.pers["score"] = 0;
	self.pers["kills"] = 0;
	self.pers["deaths"] = 0;
	self.pers["assists"] = 0;
	self.pers["lifes"] = 0;
	self.pers["headshots"] = 0;
	self.pers["knifes"] = 0;
	self.pers["activator"] = 0;
	self.pers["isDog"] = false;

	self openMenu("main_mp");
	self thread serverDvars();
}

playerDisconnect()
{
	level notify("disconnected", self);
	self cleanUp();
}

playerLastStand(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self suicide();
}

playerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if (self.sessionteam == "spectator" || game["state"] == "end")
		return;

	level notify("player_damage", self, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

	iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	self doPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
}

playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self notify("killed_player");
	self notify("death");

	if (self.sessionteam == "spectator" || game["state"] == "end")
		return;

	level notify("player_killed", self, eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	if (sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	if (self.pers["team"] == "allies" && self canSpawn())
		self eventSpawn();
}

playerSpawn()
{
	if (game["state"] == "end")
		return;

	level notify("jumper", self);
	self cleanUp();

	self sr\core\_teams::setHealth();
	self detachAll();

	self setModel("body_mp_usmc_cqb");
	self setViewModel("viewmodel_hands_zombie");

	self.pers["weapon"] = "beretta_mp";

	self spawnPlayer();

	if (self.model == "german_sheperd_dog")
		self.pers["weapon"] = "dog_mp";

	self giveWeapon(self.pers["weapon"]);
	self setSpawnWeapon(self.pers["weapon"]);
	self giveMaxAmmo(self.pers["weapon"]);

	if (isCJ())
	{
		self setActionSlot(4, "weapon", "rpg_mp");
		self giveWeapon("rpg_mp");
		self giveMaxAmmo("rpg_mp");
	}
	if (self getStat(988))
		self setClientDvar("cg_thirdperson", 1);

	self sr\core\_run::start();

	self notify("spawned_player");
	level notify("player_spawn", self);
}

playerSpectator()
{
	self endon("disconnect");

	self cleanUp();
	self spawnSpectator();

	level notify("player_spectator", self);
}

serverDvars()
{
	self endon("disconnect");

	wait 3;
	self setClientDvars(
		"sr_admin_role", "^5Debug",
		"ui_3dwaypointtext", "1",
		"ui_deathicontext", "1",
		"cl_maxpackets", 125,
		"rate", 100000,
		"ip", getDvar("net_ip"),
		"port", getDvar("net_port")
	);
	wait 0.05;
	self setClientDvars(
		"show_hud", "true",
		"hud_enable", 1,
		"cg_drawSpectatorMessages", 1,
		"player_sprintTime", 4,
		"ui_hud_hardcore", 1,
		"ui_uav_client", 0
	);
}
