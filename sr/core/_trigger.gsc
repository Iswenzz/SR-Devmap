#include sr\utils\_common;
#include sr\utils\_math;
#include sr\utils\_hud;
#include sr\sys\_events;

main()
{
	if (!getDvarInt("developer"))
		return;

	event("spawn", ::onSpawn);
	event("death", ::clear);
}

onSpawn()
{
	self endon("spawned");
	self endon("death");
	self endon("disconnect");

	self clear();

	self.huds["trigger"] = [];
	self.huds["trigger"]["controls"] = addHud(self, 0, -80, 1, "left", "bottom");
	self.huds["trigger"]["controls"] setText("^5Spawn: ^7[{+melee}]\n^5Width: ^7[{+activate}]\n^5Height: ^7[{+frag}]\n^5Solid: ^7[{+smoke}]");

	while (true)
	{
		wait 0.2;
		if (self meleeButtonPressed())
		{
			if (isDefined(self.trigger))
				self.trigger delete();
			self.trigger = self placeTrigger(self.origin, 10, 10, 0);
		}
		if (!isDefined(self.trigger))
		{
			wait 0.05;
			continue;
		}
		if (self secondaryOffhandButtonPressed())
		{
			self.trigger.solid = !self.trigger.solid;
			continue;
		}
		if (self useButtonPressed())
		{
			width = self.trigger.width + 5;
			height = self.trigger.height;
			origin = self.trigger.origin;
			solid = self.trigger.solid;

			self.trigger delete();
			self.trigger = self placeTrigger(origin, width, height, solid);
		}
		if (self fragButtonPressed())
		{
			width = self.trigger.width;
			height = self.trigger.height + 5;
			origin = self.trigger.origin;
			solid = self.trigger.solid;

			self.trigger delete();
			self.trigger = self placeTrigger(origin, width, height, solid);
		}
	}
}

placeTrigger(origin, width, height, solid)
{
	trigger = spawn("trigger_radius", origin, 0, width, height);
	trigger.width = width;
	trigger.height = height;
	trigger.solid = solid;
	trigger thread triggerLoop();
	return trigger;
}

triggerLoop()
{
	while (isDefined(self))
	{
		thread drawCircle(self.origin, self.width, self.height, 0.05, (0, 0.3, 1));

		print3D(self.origin, "Trigger", (0, 1, 1), 1, 0.4);
		print3D(self.origin + (0, 0, 7), "" + self.width + "x" + self.height, (0, 1, 0), 1, 0.2);

		self setContents(self.solid);
		if (self.solid)
			print3D(self.origin + (0, 0, 10), "SOLID", (1, 0, 0), 1, 0.2);

		wait 0.05;
	}
}

save()
{
	trigger = self.trigger;

	if (!isDefined(trigger))
		return;

	origin = trigger.origin;
	width = trigger.width;
	height = trigger.height;
	solid = trigger.solid;

	logPrint("trigger = spawn(\"trigger_radius\", " + origin + ", 0, " + width + ", " + height + ");\n");
	if (solid) logPrint("trigger setContents(true);\n");
}

clear()
{
	self endon("disconnect");

	if (isDefined(self.huds["trigger"]))
	{
		huds = getArrayKeys(self.huds["trigger"]);
		for (i = 0; i < huds.size; i++)
		{
			if (isDefined(self.huds["trigger"][huds[i]]))
				self.huds["trigger"][huds[i]] destroy();
		}
	}
}
