#include sr\sys\_events;
#include sr\utils\_hud;
#include sr\utils\_common;
#include sr\utils\_math;

main()
{
	if (!getDvarInt("developer"))
		return;

	if (!getDvarInt("developer_script"))
		iPrintLn("^1ERROR: developer_script must be set to 1.");

	event("map", ::visualizer);
	event("map", ::triggers);
	event("spawn", ::onSpawn);
	event("death", ::clean);

	menu("debug", "mode", ::menu_DebugMode);
}

onSpawn()
{
	self endon("spawned");
	self endon("death");
	self endon("disconnect");

	self huds();
	self vars();

	while (true)
	{
		wait 0.05;

		self cleanMode();

		switch (self.debugMode)
		{
			case 0: 	self debugEntities(); 	break;
			case 1: 	self debugWeapons(); 	break;
			case 2: 	self debugMaterials(); 	break;
			case 3: 	self debugSounds(); 	break;
			case 4: 	self debugMenus(); 		break;
		}
	}
}

menu_DebugMode(arg)
{
	self.debugMode = intRange(self.debugMode, 0, 4);
	self notify("debug_change");
}

debugMenus()
{
	self endon("debug_change");
	self setClientDvar("ui_showlist", 1);
}

debugSounds()
{
	self endon("debug_change");

	labels = strTok("3D,Stream,2D", ",");
	self setClientDvar("snd_draw3D", 3);

	groups = 0;
	prevGroups = -1;

	while (true)
	{
		if (self meleeButtonPressed())
		{
			while (self meleeButtonPressed())
				wait 0.05;
			groups = intRange(groups, 0, 2);
		}

		if (groups != prevGroups)
		{
			self setClientDvar("snd_drawinfo", groups + 1);
			setAction(0, "^8" + labels[groups] + ": ^7[{+melee}]");
		}
		wait 0.05;
	}
}

debugMaterials()
{
	self endon("debug_change");
	self setClientDvar("cg_drawmaterial", 3);
}

debugEntities()
{
	self endon("debug_change");

	render = 0;
	prevEnt = undefined;

	while (true)
	{
		wait 0.05;
		render = intRange(render, 0, 5);

		start = self getEye();
		end = start + vectorScale(anglesToForward(self getPlayerAngles()), 99999999);
		trace = bulletTrace(start, end, false, self);
		ent = trace["entity"];

		if (!isDefined(ent))
			continue;

		targetname = IfUndef(ent.targetname, "");
		model = IfUndef(ent.model, "");

		if (isDefined(prevEnt) && ent != prevEnt)
		{
			self setInfo(5, "^2Targetname:^7", targetname);
			self setInfo(6, "^2Model:^7", model);
		}
		prevEnt = ent;
	}
}

debugWeapons()
{
	self endon("debug_change");
	prevWeapon = "";

	while (true)
	{
		wait 0.05;

		weapon = self GetCurrentWeapon();
		model = GetWeaponModel(weapon, 0);

		if (weapon != prevWeapon)
		{
			self setInfo(0, "^5Weapon:^7", weapon);
			self setInfo(1, "^5Model:^7", model);
		}
		prevWeapon = weapon;
	}
}

visualizer()
{
	ents = [];
	ents[ents.size] = getEntArray("trigger_damage", "classname");
	ents[ents.size] = getEntArray("trigger_disk", "classname");
	ents[ents.size] = getEntArray("trigger_friendlychain", "classname");
	ents[ents.size] = getEntArray("trigger_hurt", "classname");
	ents[ents.size] = getEntArray("trigger_lookat", "classname");
	ents[ents.size] = getEntArray("trigger_multiple", "classname");
	ents[ents.size] = getEntArray("trigger_once", "classname");
	ents[ents.size] = getEntArray("trigger_radius", "classname");
	ents[ents.size] = getEntArray("trigger_use", "classname");
	ents[ents.size] = getEntArray("trigger_use_touch", "classname");
	ents[ents.size] = getEntArray("script_brushmodel","classname");
    ents[ents.size] = getEntArray("script_model","classname");
    ents[ents.size] = getEntArray("script_origin","classname");
    ents[ents.size] = getEntArray("script_struct","classname");
    ents[ents.size] = getEntArray("script_vehicle","classname");
    ents[ents.size] = getEntArray("script_vehicle_mp","classname");

	for (i = 0; i < ents.size; i++)
	{
		for (t = 0; t < ents[i].size; t++)
			ents[i][t] thread visualizerLoop(t);
	}
}

visualizerLoop(index)
{
	color = (0.0, 1.0, 1.0);
	if (isSubStr(self.classname, "trigger_"))
        color = (0.0, 1.0, 0.0);

	id = "[" + index + "] " + self.classname;

	targetname = self.targetname;
	if (!isDefined(targetname))
		targetname = "<unassigned>";

    while (isDefined(self))
    {
        if (isDefined(level.player) && distance(level.player getOrigin(), self getOrigin()) < 1000)
        {
            print3d(self getOrigin(), id, color, 1, 0.4, 1);
            print3d(self getOrigin() - (0, 0, 7), targetname, (1.0, 1.0, 1.0), 1, 0.4, 1);
        }
        wait 0.05;
    }
}

triggers()
{
	triggers = [];
	triggers[triggers.size] = getEntArray("trigger_damage", "classname");
	triggers[triggers.size] = getEntArray("trigger_disk", "classname");
	triggers[triggers.size] = getEntArray("trigger_friendlychain", "classname");
	triggers[triggers.size] = getEntArray("trigger_hurt", "classname");
	triggers[triggers.size] = getEntArray("trigger_lookat", "classname");
	triggers[triggers.size] = getEntArray("trigger_multiple", "classname");
	triggers[triggers.size] = getEntArray("trigger_once", "classname");
	triggers[triggers.size] = getEntArray("trigger_radius", "classname");
	triggers[triggers.size] = getEntArray("trigger_use", "classname");
	triggers[triggers.size] = getEntArray("trigger_use_touch", "classname");

	for (i = 0; i < triggers.size; i++)
	{
		for (t = 0; t < triggers[i].size; t++)
			triggers[i][t] thread triggerPlayerLoop();
	}
}

triggerPlayerLoop()
{
	while (isDefined(self))
	{
		self waittill("trigger", player);

		if (!isDefined(player.debugMode) || player.debugMode != 0)
			continue;

		player setInfo(7, "^1Classname:^7", self.classname);
		player setInfo(8, "^1Trigger:^7", self.targetname);
		player setInfo(9, "^1Target:^7", self.target);

		wait 0.05;
	}
}

setAction(index, name)
{
	action = spawnStruct();
	action.name = name;
	action.value = " ";

	if (!isDefined(self.debugActions))
		self.debugActions = [];

	self.debugActions[index] = action;
	self.huds["debug"]["actions"] setText(buildString(self.debugActions));
}

setInfo(index, name, value)
{
	info = spawnStruct();
	info.name = name;
	info.value = "" + IfUndef(value, "");

	if (!isDefined(self.debugInfos))
		self.debugInfos = [];

	self.debugInfos[index] = info;
	self.huds["debug"]["infos"] setText(buildString(self.debugInfos));
}

buildString(entries)
{
	string = "";
	keys = getArrayKeys(entries);
	for (i = 0; i < keys.size; i++)
	{
		entry = entries[keys[i]];
		if (!IsNullOrEmpty(entry.name) && !IsNullOrEmpty(entry.value))
			string += entry.name + " " + entry.value;
		string += "\n";
	}
	return string;
}

cleanMode()
{
	self.debugActions = [];
	self.debugInfos = [];

	if (isDefined(self.huds["debug"]["actions"]))
		self.huds["debug"]["actions"] setText("");
	if (isDefined(self.huds["debug"]["infos"]))
		self.huds["debug"]["infos"] setText("");

	self setClientDvar("cg_drawmaterial", 0);
	self setClientDvar("snd_draw3D", 0);
	self setClientDvar("snd_drawinfo", 0);
	self setClientDvar("ui_showlist", 0);
}

vars()
{
	self setClientDvars("developer", 2);
	self setClientDvars("cl_showServerCommands", 1);
	self.debugMode = 0;
}

huds()
{
	self.huds["debug"] = [];
	self.huds["debug"]["actions"] = addHud(self, -3, 80, 1, "right", "top", 1.4, 90, true);
	self.huds["debug"]["infos"] = addHud(self, 3, -200, 1, "left", "bottom", 1.4, 90, true);
}

clean()
{
	if (isDefined(self.huds["debug"]))
	{
		self cleanMode();
		self.debugMode = undefined;
		self setClientDvar("developer", 0);
		keys = getArrayKeys(self.huds["debug"]);

		for (i = 0; i < keys.size; i++)
		{
			if (isDefined(self.huds["debug"][keys[i]]))
				self.huds["debug"][keys[i]] destroy();
		}
	}
}
