#include sr\sys\_events;
#include sr\utils\_common;

main()
{
	level.allowSpawn = true;
	level.huds["match"] = [];

	game["roundStarted"] = false;
	game["state"] = "readyup";

	event("map", ::start);
}

start()
{
	game["roundsplayed"] = IfUndef(game["roundsplayed"], 0) + 1;
	level notify("round_started", game["roundsplayed"]);
	level notify("game started");
	game["state"] = "playing";
	game["roundStarted"] = true;

	visionSetNaked(toLower(level.map), 2);
}
