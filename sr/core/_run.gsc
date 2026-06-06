#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	event("map", ::endmapTrigger);
}

endmapTrigger()
{
	waitMapLoad(3);

	array = getEntArray("endmap_trig", "targetname");
	if (!array.size)
	{
		iPrintLn("^1Error: No endmap_trig found.");
		return;
	}

	trigger = array[0];
	thread sr\fx\_trigger::effect(trigger, "red");
	while (true)
	{
		trigger waittill("trigger", player);
		player thread endTimer();
	}
}

start()
{
	self.finishedMap = false;
	self.sr_mode = self getLastMode();
	self.sr_way = "normal_0";

	switch (self.sr_mode)
	{
		case "190":
			self.speed = sr\api\_map::getSpeed(190);
			self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.05);
			break;
		case "210":
			self.speed = sr\api\_map::getSpeed(210);
			self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.12);
			break;
		case "Q3":
		case "Q3CPM":
		case "Q3CPMW":
			self.speed = sr\api\_map::getSpeed(320);
			self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.0);
			break;
		case "CS":
		case "Portal":
			self.speed = sr\api\_map::getSpeed(250);
			self.moveSpeedScale = sr\api\_map::getMoveSpeedScale(1.0);
			break;
	}
	self.gravity = sr\api\_map::getGravity(800);
	self.jumpHeight = sr\api\_map::getJumpHeight(39);

	self.spawnMoveSpeedScale = self.moveSpeedScale;
	self.spawnGravity = self.gravity;
	self.spawnJumpHeight = self.jumpHeight;
	self.spawnSpeed = self.speed;

	self thread playerTimer();
}

getLastMode()
{
	switch (self getStat(1700))
	{
		case 1: return "190";
		case 2: return "210";
		case 3: return "Q3";
		case 4: return "Q3CPM";
		case 5: return "Q3CPMW";
		case 6: return "CS";
		case 7: return "Portal";
	}
	return "190";
}

getLastModeStat()
{
	switch (self.sr_mode)
	{
		case "190": return 1;
		case "210": return 2;
		case "Q3": return 3;
		case "Q3CPM": return 4;
		case "Q3CPMW": return 5;
		case "CS": return 6;
		case "Portal": return 7;
	}
	return 1;
}

playerTimer()
{
	self endon("spawned");
	self endon("disconnect");
	self endon("death");

	if (self.finishedMap)
		return;
	self.time = undefined;

	// Spastic delay caused by bad modding, too bad...
	wait 0.1;

	self sr\huds\_speedrun::updateTime();
	self.time = originToTime(getTime());
}

endTimer()
{
	if (!self isPlaying() || !isDefined(self.time) || self.finishedMap)
		return;
	self.finishedMap = true;

	self.time = originToTime(getTime() - self.time.origin);
	self sr\huds\_speedrun::updateTime();
}
