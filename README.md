# SM-NT-BlockSpawning
Sourcemod plugin for Neotokyo that blocks players spawning in after freezetime, **very experimental**.  

Uses a very hacky workaround to trick the game into thinking approximately 16 seconds have passed after the freezetime ends, so it automatically stops players from being able to spawn in, as that is the approximate time that the game allows spawning in by default after freezetime ends.  

This plugin should work properly with the competitive plugin as long as the freeze time duration is not changed, otherwise the comp plugin will probably need modification to account for non-standard freeze times.
