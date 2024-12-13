#include <sourcemod>
#include <sdktools>
#include <neotokyo>

#pragma semicolon 1
#pragma newdecls required

ConVar g_roundTime;
Handle unfreezeTimer;
Handle notifyTimer;
int g_seconds;

public Plugin myinfo = {
	name = "NT block spawning",
	author = "bauxite",
	description = "Blocks players from spawning outside freezetime for comp",
	version = "0.1.0",
	url = "",
};

public void OnPluginStart()	
{
	HookEvent("game_round_start", OnRoundStartPre, EventHookMode_Pre);
	HookEvent("game_round_start", OnRoundStartPost, EventHookMode_Post);
	HookEvent("game_round_end", OnRoundEndPost, EventHookMode_Post);
	
	g_roundTime = FindConVar("neo_round_timelimit");
}

public void OnConfigsExecuted()
{
}

public void OnMapEnd()
{
	g_seconds = 0;
	g_roundTime.FloatValue = 2.26;
}

public void OnMapStart()
{
	g_seconds = 0;
	g_roundTime.FloatValue = 2.26;
}

public void OnRoundEndPost(Event event, const char[] name, bool dontBroadcast)
{
	g_roundTime.FloatValue = 2.26;
}

public Action OnRoundStartPre(Event event, const char[] name, bool dontBroadcast)
{
	g_roundTime.FloatValue = 2.55;
	return Plugin_Continue;
}

public void OnRoundStartPost(Event event, const char[] name, bool dontBroadcast)
{
	g_seconds = 0;
	
	if(IsValidHandle(notifyTimer))
	{
		delete notifyTimer;
	}

	notifyTimer = CreateTimer(1.0, Notify, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	
	if(IsValidHandle(unfreezeTimer))
	{
		delete unfreezeTimer;
	}
	
	unfreezeTimer = CreateTimer(16.0, UnFreeze, _, TIMER_FLAG_NO_MAPCHANGE);
}

public Action Notify(Handle timer)
{
	if(!GameRules_GetProp("m_bFreezePeriod"))
	{
		return Plugin_Stop;
	}
	
	++g_seconds;
	
	if(g_seconds < 16)
	{
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && IsPlayerAlive(i))
			{
				PrintCenterText(i, "Freeze time: %d seconds", (16 - g_seconds));
			}
		}
	}
	
	if(g_seconds == 15)
	{
		CreateTimer(0.25, ClearNotifyMessage, _, TIMER_FLAG_NO_MAPCHANGE);
	}
	
	return Plugin_Continue;
}

public Action ClearNotifyMessage(Handle timer)
{
	PrintCenterTextAll("\0");
	return Plugin_Stop;
}

public Action UnFreeze(Handle timer)
{
	if(!GameRules_GetProp("m_bFreezePeriod"))
	{
		return Plugin_Stop;
	}
	else
	{
		GameRules_SetProp("m_bFreezePeriod", 0);
		GameRules_SetPropFloat("m_fRoundTimeLeft", 120.0);
		g_roundTime.FloatValue = 2.26;
	}
	
	return Plugin_Stop;
}

public void OnGameFrame()
{
	if(!GameRules_GetProp("m_bFreezePeriod"))
	{
		return;
	}

	GameRules_SetPropFloat("m_fRoundTimeLeft", 153.0);
}
