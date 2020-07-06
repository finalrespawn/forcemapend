#include <sourcemod>
#include <cstrike>
#include <colours>

public Plugin myinfo = {
	name = "Force Map End",
	author = "Clarkey",
	description = "Forces the map end, and stops it from ending otherwise.",
	version = "1.0",
	url = "http://finalrespawn.com"
};

char g_Map[PLATFORM_MAX_PATH];

public void OnMapStart()
{
	CreateTimer(1.0, Timer_TimeLeft, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	GetCurrentMap(g_Map, sizeof(g_Map));
}

public Action Timer_TimeLeft(Handle timer)
{
	int TimeLeft;
	GetMapTimeLeft(TimeLeft);
	
	switch (TimeLeft) {
		case 1800:CPrintToChatAll(" {lightred}[Map]{default} Time Left: {green}30 Minutes");
		case 1200:CPrintToChatAll(" {lightred}[Map]{default} Time Left: {green}20 Minutes");
		case 600:CPrintToChatAll(" {lightred}[Map]{default} Time Left: {green}10 Minutes");
		case 300:CPrintToChatAll(" {lightred}[Map]{default} Time Left: {green}5 Minutes");
		case 120:CPrintToChatAll(" {lightred}[Map]{default} Time Left: {green}2 Minutes");
		case 60:CPrintToChatAll(" {lightred}[Map]{default} Time Left: {green}1 Minute");
		case 30:CPrintToChatAll(" {lightred}[Map]{default} Time Left: {green}30 Seconds");
		case 10:CPrintToChatAll(" {lightred}[Map]{default} Time Left: {green}10 Seconds");
		case 3:CPrintToChatAll(" {lightred}[Map]{default} {green}3 Seconds...");
		case 2:CPrintToChatAll(" {lightred}[Map]{default} {green}2 Seconds...");
		case 1:CPrintToChatAll(" {lightred}[Map]{default} {green}1 Second...");
		case 0:CreateTimer(1.0, Timer_EndGame);
	}
}

public Action Timer_EndGame(Handle timer)
{
	float RoundDelay = GetConVarFloat(FindConVar("mp_round_restart_delay"));
	CS_TerminateRound(RoundDelay, CSRoundEnd_Draw, true);
	CreateTimer(30.0, Timer_CheckMap, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
}

public Action Timer_CheckMap(Handle timer, any data)
{
	char Map[PLATFORM_MAX_PATH];
	GetCurrentMap(Map, sizeof(Map));
	if (StrEqual(g_Map, Map))
	{
		char NextMap[PLATFORM_MAX_PATH];
		GetNextMap(NextMap, sizeof(NextMap));
		ServerCommand("changelevel %s", NextMap);
	}
}

public Action CS_OnTerminateRound(float &delay, CSRoundEndReason &reason)
{
	return Plugin_Handled;
}