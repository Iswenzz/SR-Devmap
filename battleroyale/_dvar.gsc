#include sr\sys\_dvar;

initDvars()
{
	addDvar("rounds", "br_rounds", 4, 1, 10, "int");
	addDvar("debug", "br_debug", 0, 0, 1, "int");
	addDvar("lobby_countdown", "br_lobby_countdown", 10, 0, 60, "int");
	addDvar("spawn_time", "br_spawn_time", 4, 1, 30, "int");
	addDvar("zone_time", "br_zone_time", 120, 1, 1000, "int");
	addDvar("zone_levels", "br_zone_levels", 0, 0, 4, "int");
	addDvar("plane_duration", "br_plane_seconds", 15, 1, 120, "int");
	addDvar("randomize", "br_randomize", 1, 0, 1, "int");
}
