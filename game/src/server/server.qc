void main (void)
{
}

void StartFrame (void)
{
}

void PlayerPreThink (void)
{
}

void PlayerPostThink (void)
{
	self.SendFlags = U_ALL;
}

void ClientKill (void)
{
}

void ClientConnect (void)
{
}

static float SendPlayer (entity playerent, float changedflags)
{
	WriteByte (MSG_ENTITY, self.classindex);
	WriteCoord (MSG_ENTITY, self.origin_x);
	WriteCoord (MSG_ENTITY, self.origin_y);
	WriteCoord (MSG_ENTITY, self.origin_z);
	WriteCoord (MSG_ENTITY, self.angles_x);
	WriteCoord (MSG_ENTITY, self.angles_y);
	WriteCoord (MSG_ENTITY, self.angles_z);
	WriteFloat (MSG_ENTITY, self.velocity_x);
	WriteFloat (MSG_ENTITY, self.velocity_y);
	WriteFloat (MSG_ENTITY, self.velocity_z);
	WriteByte (MSG_ENTITY, self.movetype);
	WriteShort (MSG_ENTITY, self.flags);
	return TRUE;
}

void PutClientInServer (void)
{
	self.classindex = CLASS_PLAYER;
	self.SendEntity = SendPlayer;
	self.classname = "player";
	self.flags = FL_CLIENT;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	setmodel (self, "models/player/player.iqm");
	setsize (self, [-16, -16, -24], [16, 16, 32]);
	self.view_ofs = [0, 0, 22];
	entity start = find (world, classname, "info_player_start");
	setorigin (self, start.origin + [0, 0, 1 - self.mins_z]);
	self.angles = start.angles;
	self.fixangle = 3;
	self.health = 100;
}

void ClientDisconnect (void)
{
}

void SetNewParms (void)
{
}

void SetChangeParms (void)
{
}

void SV_RunClientCommand (void)
{
	runstandardplayerphysics (self);
}
