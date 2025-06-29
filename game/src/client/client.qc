static vector view_origin;

void CSQC_Init (float apilevel, string enginename, float engineversion)
{
	precache_common ();
}

float CSQC_InputEvent (float evtype, float scanx, float chary, float devid)
{
	return FALSE;
}

void CSQC_Input_Frame (void)
{
}

void CSQC_UpdateView (float width, float height, float menushown)
{
	clearscene ();
	addentities (MASK_ENGINE);
	setproperty (VF_ORIGIN, view_origin);
	setproperty (VF_ANGLES, view_angles);
	renderscene ();
}

static void RunPlayerPrediction (void)
{
	self.movetype = self.pmovetype;
	for (int i = servercommandframe + 1; i <= clientcommandframe; i++)
	{
		if (!getinputstate (i))
		{
			continue;
		}
		if (input_timelength <= 0)
		{
			break;
		}
		runstandardplayerphysics (self);
	}
	self.movetype = MOVETYPE_NONE;
}

static float PreDrawPlayer (void)
{
	if (self.entnum != player_localentnum)
	{
		// push state
		vector restore_angles = self.angles;

		self.angles = [0, self.angles_y, 0];

		addentity (self);

		// pop state
		self.angles = restore_angles;

		return PREDRAW_NEXT;
	}

	// push state
	vector restore_origin = self.origin;
	vector restore_angles = self.angles;
	vector restore_velocity = self.velocity;
	int restore_flags = self.flags;

	RunPlayerPrediction ();

	view_origin = self.origin + [0, 0, getstatf (STAT_VIEWHEIGHT)];

	self.angles = [0, view_angles_y, 0];
	self.renderflags = RF_EXTERNALMODEL;

	addentity (self);

	// pop state
	self.origin = restore_origin;
	self.angles = restore_angles;
	self.velocity = restore_velocity;
	self.flags = restore_flags;

	return PREDRAW_NEXT;
}

static void RecvPlayer (float isnew)
{
	if (isnew)
	{
		self.predraw = PreDrawPlayer;
		self.drawmask = MASK_ENGINE;
		self.classname = "player";
		self.solid = SOLID_SLIDEBOX;
		setmodel (self, "models/player/player.iqm");
		setsize (self, [-16, -16, -24], [16, 16, 32]);
	}
	self.origin_x = readcoord ();
	self.origin_y = readcoord ();
	self.origin_z = readcoord ();
	self.angles_x = readcoord ();
	self.angles_y = readcoord ();
	self.angles_z = readcoord ();
	self.velocity_x = readfloat ();
	self.velocity_y = readfloat ();
	self.velocity_z = readfloat ();
	self.pmovetype = readbyte ();
	self.flags = readshort ();
}

void CSQC_Ent_Update (float isnew)
{
	self.classindex = readbyte ();
	switch (self.classindex)
	{
	case CLASS_PLAYER:
	{
		RecvPlayer (isnew);
		break;
	}
	}
}
