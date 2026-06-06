#include sr\utils\_common;

createNormalWays(token)
{

}

createSecretWays(token)
{

}

createEndMap(origin, width, height, way)
{
	if (!isDefined(way))
		return sr\api\_map::createEndMap(origin, width, height);

	trigger = spawn("trigger_radius", origin, 0, width, height);
	trigger.radius = width;
	trigger.targetname = "sr_" + way;

	thread watchTriggerEndMap(trigger, way);
	thread sr\fx\_trigger::effect(trigger, "red");
	return trigger;
}

createWay(triggerOrigin, width, height, color, way)
{
	trigger = spawn("trigger_radius", triggerOrigin, 0, width, height);
	trigger.radius = width;
	trigger.targetname = "sr_" + way;

	thread watchWay(trigger, way);
	thread sr\fx\_trigger::effect(trigger, IfUndef(color, "blue"));
	return trigger;
}

createTeleporter(triggerOrigin, width, height, origin, angles, state, color, way)
{
	if (!isDefined(way))
		return sr\api\_map::createTeleporter(triggerOrigin, width, height, origin, angles, state, color);

	trigger = spawn("trigger_radius", triggerOrigin, 0, width, height);
	trigger.radius = width;
	trigger.targetname = "sr_" + way;

	thread watchTeleporter(trigger, origin, angles, state, way);
	thread sr\fx\_trigger::effect(trigger, IfUndef(color, "blue"));
	return trigger;
}

watchTriggerEndMap(trig, way)
{
	while (true)
	{
		trig waittill("trigger", player);
		player finishWay(way);
	}
}

watchWay(trigger, way)
{
	while (true)
	{
		trigger waittill("trigger", player);

		if (isDefined(way))
			player changeWay(way);
	}
}

watchTeleporter(trigger, origin, angles, state, way)
{
	while (true)
	{
		trigger waittill("trigger", player);

		if (isDefined(way))
			player changeWay(way);

		player thread playerTeleport(origin, angles, state);
	}
}

order()
{
	return true;
}

changeWay(way)
{
	self thread sr\libs\portal\_portal_gun::resetPortals();

	self.sr_way = way;
	self playLocalSound("change_way");
	self iPrintLnBold(way);
}

finishWay(way)
{
	if (self.sr_way == way)
		self thread sr\core\_run::endTimer();
}
