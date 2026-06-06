#include sr\utils\_common;

defaultDvars()
{
	addDvar("mod", "mod_id", "dev");
	setDvar("sv_mapRotationCurrent", "map " + level.map);
	setDvar("mod_author", "Iswenzz");

	setDvar("g_deadchat", 1);
	setDvar("g_knockback", 1000);
	setDvar("g_speed", 190);
	setDvar("g_gravity", 800);
	setDvar("jump_height", 39);
	setDvar("dr_jumpers_speed", 1.05);
	setDvar("dr_activators_speed", 1.05);
	setDvar("jump_slowdownEnable", 0);
	setDvar("bullet_penetrationEnabled", 0);

	makeDvarServerInfo("mod_author", "Iswenzz");
}

addDvar(scriptName, dvarName, defaultValue, min, max, type)
{
	value = getDvar(dvarName);
	type = IfUndef(type, "string");

	switch (type)
	{
		case "int":		definition = Ternary(IsNullOrEmpty(value), defaultValue, getDvarInt(dvarName));		break;
		case "float": 	definition = Ternary(IsNullOrEmpty(value), defaultValue, getDvarFloat(dvarName));	break;
		default: 		definition = Ternary(IsNullOrEmpty(value), defaultValue, value);					break;
	}
	if ((type == "int" || type == "float") && min != 0 && definition < min)
		definition = min;
	if ((type == "int" || type == "float") && max != 0 && definition > max)
		definition = max;

	if (isNullOrEmpty(value))
		setDvar(dvarName, definition);

	// Maps use level.dvar not level.dvars
	if (!isDefined(level.dvar))
		level.dvar = [];
	level.dvar[scriptName] = definition;
	return definition;
}
