#include sr\sys\_events;
#include sr\utils\_common;
#include sr\utils\_hud;

main()
{
	event("spawn", ::hud);
	event("death", ::clear);
}

hud()
{
	self endon("spawned");
	self endon("death");
	self endon("disconnect");

	self clear();

	self.huds["speedrun"] = [];
 	self.huds["speedrun"]["background"] = addHud(self, 0, -60, 1, "left", "top", 1.8, 90, true);
	self.huds["speedrun"]["background"] setShader("time_hud", 142, 80);
	self.huds["speedrun"]["background"].color = (0, 0, 0);
	self.huds["speedrun"]["background"].glowAlpha = 1;
	self.huds["speedrun"]["mode"] = addHud(self, 4, 0, 1, "left", "top", 1.8, 99, true);
	self.huds["speedrun"]["mode"] setText("^5SR");
	self.huds["speedrun"]["row1"] = addHud(self, 72, 0, 1, "left", "top", 1.8, 99, true);
	self.huds["speedrun"]["row1"] setText("^50:00.0");
}

updateTime()
{
	if (isDefined(self.time))
	{
		self.huds["speedrun"]["row1"] setText(self.time.min + ":" + self.time.sec + "." + self.time.ms);
		self.huds["speedrun"]["row1"].fontScale = 1.4;
		self.huds["speedrun"]["row1"].x = 73;
		self.huds["speedrun"]["row1"].y = 3;
	}
	else
	{
		self.huds["speedrun"]["row1"].label = &"^5&&1";
		self.huds["speedrun"]["row1"] setTenthsTimerUp(0.0001);
	}
}

clear()
{
	self endon("disconnect");

	if (isDefined(self.huds["speedrun"]))
	{
		huds = getArrayKeys(self.huds["speedrun"]);
		for (i = 0; i < huds.size; i++)
		{
			if (isDefined(self.huds["speedrun"][huds[i]]))
				self.huds["speedrun"][huds[i]] destroy();
		}
	}
}
