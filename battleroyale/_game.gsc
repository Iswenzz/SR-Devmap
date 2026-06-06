givePlayerAmmo(entity)
{
	item = entity.item;
	self iPrintLnBold(item.id);
}

givePlayerWeapon(entity)
{
	item = entity.item;

	self iPrintLnBold(item.id);
	self giveWeapon(item.weapon);
	self switchToWeapon(item.weapon);
	self playSound(item.sound);
}

givePlayerGrenade(entity)
{
	item = entity.item;

	self iPrintLnBold(item.id);
	self giveWeapon(item.weapon);
	self playSound(item.sound);
	self setWeaponAmmoStock(item.weapon, 1);
}

givePlayerSpecial(entity)
{
	self iPrintLnBold(entity.item.id);
}
