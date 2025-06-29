void worldspawn (void)
{
	precache_common ();
}

void info_player_start (void)
{
}

enumflags
{
	SF_LIGHT_OFF,
};

void light (void)
{
	remove (self);
}

void light_spot (void)
{
	light ();
}

void info_null (void)
{
	remove (self);
}

void prop_static (void)
{
	precache_model (self.model);
	setmodel (self, self.model);
	makestatic (self);
}

void ambient_sound (void)
{
	// default values
	if (!self.health)
	{
		self.health = 0.5;
	}
	if (!self.speed)
	{
		self.speed = ATTN_STATIC;
	}

	precache_sound (self.message);
	ambientsound (self.origin, self.message, self.health, self.speed);
	remove (self);
}
