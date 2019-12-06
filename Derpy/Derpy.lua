-- Derpy v1.0
-- By Derpderpderp/Noaide of Ragnaros EU (Horde)

-- You are free to redistribute and modify this addon, as long 
-- as you give proper credit to me, the original author.

-- All comments and feature requests via Curse or CurseForge are wildly appreciated.
-- http://wow.curse.com/downloads/wow-addons/details/derpy.aspx
-- http://wow.curseforge.com/addons/derpy/

color = "|cFF66EE66"; -- We like green
original = "|r";
CurrentLevelCap = 85; -- With lack of a function to retrieve this dynamically...

function Derpy_OnLoad() -- Addon loaded
	SLASH_DERPY1, SLASH_DERPY2 = '/derp', '/derpy';
	print(color.."Derpy v1.0 loaded"..original.." (/derp or /derpy)");
	
	local cxp = GetAccountExpansionLevel();
	
	if(cxp == 0) then -- Nag the user for being a cheap bastard
		print("Why haven't you bought "..color.."The Burning Crusade"..original.." yet?");
	elseif(cxp == 1) then
		print("Why haven't you bought "..color.."Wrath of the Lich King"..original.." yet?");
	elseif(cxp == 2) then
		print("Why haven't you bought "..color.."Cataclysm"..original.." yet?");
	end
	
	DerpyFrame:RegisterEvent("VARIABLES_LOADED"); -- So we can detect user preferences
	DerpyFrame:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT"); -- For Auto-GZ function
	DerpyFrame:RegisterEvent("ACHIEVEMENT_EARNED"); -- For Party Achievement function
	DerpyFrame:RegisterEvent("PLAYER_LEVEL_UP"); -- For Guild Ding function
	DerpyFrame:RegisterEvent("PLAYER_UPDATE_RESTING"); -- For Rested function
	DerpyFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE"); -- For Monster Emote function

	DerpyFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED"); -- ZOOOOOOOOOOM
end

function SlashCmdList.DERPY(msg, editbox) -- Event handler for slash commands
	if(msg == "hurr") then
		print(color.."durr"..original); -- derp
	elseif(msg == "wp") then
		ShowWaypointsMenu();
	elseif(msg == "raptor") then
		ShowRaptorMenu();
	elseif(msg == "raptor darting") then
		RaptorWaypoints("darting");
	elseif(msg == "raptor ravasaur") then
		RaptorWaypoints("ravasaur");
	elseif(msg == "fox") then
		FoxWaypoints();
	elseif(msg == "bookclub") then
		HigherLearningWaypoints();
    elseif(msg == "pet") then
		RandomPet(0);
    elseif(msg == "spet") then
		RandomPet(1);
	elseif(msg == "hr") then
		CompactRaidFrameManager:Hide();
    elseif(msg == "shitstorm") then
		InitiateShitstorm();
    elseif(msg == "autogz") then
		togglePassive("AutoGZ");
	elseif(msg == "pop") then
		togglePassive("Pop");
	elseif(msg == "partyachi") then
		togglePassive("PartyAchievement");
	elseif(msg == "rested") then
		togglePassive("FullyRested");
	elseif(msg == "monster") then
		togglePassive("MonsterEmote");
	elseif(msg == "zoom") then
		togglePassive("Zoom");
	elseif(msg == "mshield") then
		togglePassive("MageShield");
	elseif(msg == "bding") then
		togglePassive("BattleDing");
	elseif(msg == "gding") then
		togglePassive("GuildDing");
    elseif(msg == "passive") then
		ShowPassiveMenu();
    elseif(msg == "dr") then
		SendChatMessage("[Derpy] Raid disbanding!","RAID",nil);
		for i=1,GetNumRaidMembers() do 
			if ("raid"..i=="player") then 
				-- Do nada, gotta remove everyone first
			else 
				UninviteUnit("raid"..i) 
			end 
		end
    elseif(msg == "about") then
        AboutPane:Show();
	elseif(msg == "") then
		ShowUsage();
	else
		ShowUsage();
	end
end

function Derpy_OnEvent(self, event, ...) -- Event handler
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...; -- This shit is stupid, why did they change this?
	if(event=="VARIABLES_LOADED") then
		if AutoGZState == nil then
			AutoGZState = "OFF"; -- Defaults to off, because it's shit and can be wildly annoying to guildies
		end
		if PartyAchievementState == nil then
			PartyAchievementState = "ON"; -- Defaults to on, because it's some hardcore stuff
		end
		if MonsterEmoteState == nil then
			MonsterEmoteState = "ON"; -- Defaults to on, because it's useful
		end
		if GuildDingState == nil then
			GuildDingState = "ON"; -- Defaults to on, because it's useful, braggy and gz-inducing
		end
		if FullyRestedState == nil then
			FullyRestedState = "ON"; -- Defaults to on, because people never pay attention to the resting icon on their character frame
		end
		if ZoomState == nil then
			ZoomState = "ON"; -- Defaults to on, because ZOOOOOOOOOM
		end
		if PopState == nil then
			PopState = "ON"; -- Default to on, because POP
		end
		if MageShieldState == nil then
			MageShieldState = "ON"; -- Defaults to on, because it's useful
		end
		if BattleDingState == nil then
			BattleDingState = "ON"; -- Defaults to on, because it's useful
		end
	elseif(event=="UNIT_SPELLCAST_SUCCEEDED") then -- ZOOOOOOOOOOOOM
		if(ZoomState~="OFF") then
			if(arg1=="player" and arg2 == "Blink") then
				local sayings = {
					"SWOOSH", --1
					"ZOOOOOM",--2
					"BLINK!",--3
					"blinks forward with reckless abandon."--4
				};
				
				local chosen = math.random(4);
				
				local channel;
				if(chosen == 4) then
					channel = "EMOTE";
				else
					channel = "SAY";
				end
				
				SendChatMessage(sayings[chosen], channel, nil);
			end
		end
		if(PopState~="OFF") then
			if(arg1=="player" and arg2 == "Demonic Circle: Teleport") then
				local sayings = {
					"POP", --1
					"BÆRT",--2
					"MAGIC!",--3
					"Now you see me, now you don't.",--4
					"vanishes from sight and suddenly reappears within 40 yards!"--5
				};
				
				local chosen = math.random(5);
				
				local channel;
				if(chosen == 5) then
					channel = "EMOTE";
				else
					channel = "SAY";
				end
				
				SendChatMessage(sayings[chosen], channel, nil);
			end
		end
		if(MageShieldState~="OFF") then
			if(IsAddOnLoaded("DBM-Core") == 1) then
				if(arg1=="player" and arg2 == "Ice Barrier") then
					SendSlash("dbm timer 24 Ice Barrier");
				elseif(arg1=="player" and arg2 == "Mana Shield") then
					local secs = 12; -- Unmodified Mana Shield cooldown
					local count = 1;
					while count <= GetNumGlyphSockets() do -- Check if user has the Mana Shield glyph before doing anything (-2 secs Mana Shield CD)
						enabled, glyphType, glyphTooltipIndex, glyphSpellID = GetGlyphSocketInfo(count);
						if(enabled==1) then -- Skip disabled slots
							if(glyphType==1) then -- Skip Prime and Minor glyphs (MS Glyph is Major)
								if(glyphSpellID~=nil) then -- Skip if the slot is empty
									if(glyphSpellID==70937) then -- Glyph of Mana Shield Spell ID
										secs = 10;
									end
								end
							end
						end
						count = count + 1;
					end
					SendSlash("dbm timer "..secs.." Mana Shield");
				end
			end
		end
	elseif(event=="CHAT_MSG_MONSTER_EMOTE") then -- Monster Emote function
		if(MonsterEmoteState~="OFF") then
			UIErrorsFrame:Clear()
			UIErrorsFrame:AddMessage(string.gsub(arg1, "%%s", arg2), 1.0, 0.5, 0.25, GetChatTypeIndex("MONSTER_EMOTE"), 5);
		end
	elseif(event=="PLAYER_UPDATE_RESTING") then -- Rested function
		if(UnitLevel("player") < CurrentLevelCap) then
			if(FullyRestedState~="OFF") then
				if(IsResting()==1) then
					print(color.."[Derpy]"..original.." You are now resting.");
				elseif(IsResting()==nil) then
					restedXP = GetXPExhaustion();
					if(restedXP == nil) then
						print(color.."[Derpy]"..original.." You are no longer resting, but did not gain any rested XP.");
					else
						print(color.."[Derpy]"..original.." You are no longer resting, and have accumulated "..restedXP.." rested XP.");
					end
				end
			end
		end
	elseif(event=="ACHIEVEMENT_EARNED") then -- Party Achievement function
		if(PartyAchievementState~="OFF") then
			if(GetNumPartyMembers() > 0) then
				partyAchivementLink = GetAchievementLink(arg1);
				SendChatMessage("[Derpy] "..UnitName("player").." earned the achievement "..partyAchivementLink.."!", "PARTY", nil);
				
				if(GetNumRaidMembers() > 0) then
					SendChatMessage("[Derpy] "..UnitName("player").." earned the achievement "..partyAchivementLink.."!", "RAID", nil);
				end
			end
		end
	elseif(event=="PLAYER_LEVEL_UP") then -- Guild Ding function
		if(GuildDingState~="OFF") then
			if(IsInGuild()==1) then
				SendChatMessage("[Derpy] Ding! "..UnitName("player").." just reached level "..arg1.."!","GUILD",nil);
			end
		end
		if(BattleDingState~="OFF") then
			BNSetCustomMessage("Ding! "..UnitName("player").." just reached level "..arg1.."!");
		end
	elseif(event=="CHAT_MSG_GUILD_ACHIEVEMENT") then -- Auto-GZ function
		if(AutoGZState~="OFF") then
			if arg2 ~= UnitName("player") then
				SendChatMessage("gz", "GUILD", nil);
			end
		end
	end
end

function SendSlash(slashCommandToSend) -- Send a slash command
	ChatFrame1EditBox:SetText("");
	ChatFrame1EditBox:Insert("/"..slashCommandToSend);
	ChatEdit_SendText(ChatFrame1EditBox);
end

function ShowUsage() -- Show available functions
	print("Available commands:");
	print(color.."/derp wp"..original.." -- Add waypoints for various stuff (Req. TomTom)");
	print(color.."/derp shitstorm"..original.." -- Initiate a Trade shitstorm, TBC-style");
	print(color.."/derp passive"..original.." -- Toggle/view passive/automatic functions");
	print(color.."/derp pet"..original.." -- Summon a random companion pet "..color.."with"..original.." snazzy summoning dialogue");
	print(color.."/derp spet"..original.." -- Summon a random companion pet "..color.."without"..original.." the snazzy summoning dialogue");
	print(color.."/derp dr"..original.." -- Disband a raid group you are the leader of");
	print(color.."/derp hr"..original.." -- Hide the pesky Blizzard Compact Raid Frames");
	print(color.."/derp about"..original.." -- Show a fancy About-window");
end

function TitleInfo() -- Only a barebones title info function as of yet, not currently good for anything
	if(GetTitleName(GetCurrentTitle())~=nil) then 
		print("You are currently wearing the \""..strtrim(GetTitleName(GetCurrentTitle()), " ").."\" title.") 
	else
		print("You are currently not wearing a title.");
	end
end

function ShowPassiveMenu() -- List states and descriptions of passive functions
	print(color.."Toggle passive features:"..original);
	print(color.."/derp autogz"..original.." -- Toggle guild achievements Auto-GZ (Currently "..AutoGZState..")");
	print(color.."/derp partyachi"..original.." -- Toggle Party Achievement notification (Currently "..PartyAchievementState..")");
	print(color.."/derp gding"..original.." -- Toggle Guild Ding notifications (Currently "..GuildDingState..")");
	print(color.."/derp bding"..original.." -- Toggle BattleNet Ding broadcasts (Currently "..GuildDingState..")");
	print(color.."/derp rested"..original.." -- Toggle resting notifications (Currently "..FullyRestedState..")");
	print(color.."/derp monster"..original.." -- Toggle emphasis of monster emotes in error frame (Currently "..MonsterEmoteState..")");
	print(color.."/derp zoom"..original.." -- Toggle Mage Blink slogans/emotes (Currently "..ZoomState..")");
	print(color.."/derp pop"..original.." -- Toggle Warlock Teleport slogans/emotes (Currently "..PopState..")");
	print(color.."/derp mshield"..original.." -- Toggle Mage Shield timers (Req. Deadly Boss Mods) (Currently "..MageShieldState..")");
end

function RandomPet(silent) -- Summon a random pet with or without funky dialogue
	if(IsFlying()==1) then
		print(color.."[Derpy]"..original.." Silly "..UnitClass("player")..", you can't summon a pet while flying!");
	elseif(UnitIsDeadOrGhost("player")) then
		print(color.."[Derpy]"..original.." Silly "..UnitClass("player")..", you can't summon a pet whilst dead!");
	elseif(GetNumCompanions("CRITTER") == 0 or GetNumCompanions("CRITTER") == nil) then
		print(color.."[Derpy]"..original.." Silly "..UnitClass("player")..", you have no pets to summon!");
	else
		local petId = math.random(GetNumCompanions("CRITTER"));
		local id, creatureName = GetCompanionInfo("CRITTER", petId);
		
		-- These are shit and someone needs to help me come up with more of them
		local sayings = {
			"I summon thee, CRITTER, from the depths of my backpack!", --1
			"How about some CRITTER?",--2
			"Come here, CRITTER!",--3
			"You jelly of my CRITTER?",--4
			"You so jelly of my CRITTER.",--5
			"Who needs friends when you've got CRITTER?",--6
			"I wish CRITTER could join my guild.",--7
			"Oh, how I've missed you, CRITTER!",--8
			"CRITTER is gonna kick your ass.",--9
			"ABRA, KADABRA, ALAKA-CRITTER!",--10
			"Helloooo, CRITTER!",--11
			"CRITTER has arrived, ready to kick some ass!",--12
			"I HAS A CRITTER ^_^",--13
			"summons a ferocious CRITTER from the depths on the Nether!",--14
			"whistles, summoning forth a CRITTER!",--15
			"HELP ME CRITTER I AM DYING OH GOD",--16
			"CRITTER is my favorite. Maybe.",--17
			"My, oh my, is that CRITTER I spy?",--18
			"Y HARO THAR CRITTER"--19
		};
		
		-- COUNT THE ARRAY, HARDCORE STYLE
		i = 0;
		while sayings[i+1] ~= nil do
			i = i + 1;
		end
		
		local sayingId = math.random(i);
		
		-- Turn creature name for certain sayings into upper case.
		if(sayingId == 10 or sayingId == 13 or sayingId == 16 or sayingId == 19) then
			creatureName = strupper(creatureName);
		end
		
		-- Replace creature name tokens with actual creature names
		sayings[sayingId] = string.gsub(sayings[sayingId], "CRITTER", creatureName);
		local petSayingChannel = "SAY";
		
		-- Route certain sayings to EMOTE channel
		if(sayingId == 14 or sayingId == 15) then
			petSayingChannel = "EMOTE";
		end
		
		-- If silent, don't say shit...
		if(silent~=1) then
			if(IsSwimming()==1) then -- ho ho ho, easter eggs!
				SendChatMessage("BLUB BLUB BLUB BLUB "..strupper(creatureName).."!", "SAY", nil);
			elseif(IsFalling()==1) then -- ho ho ho, easter eggs!
				SendChatMessage("OH GOD "..strupper(creatureName).." I AM FALLING TO MY DEATH", "SAY", nil);
			else
				SendChatMessage(sayings[sayingId], petSayingChannel, nil);
			end
		end
		
		-- ... just summon that fucker
		CallCompanion("CRITTER", petId);
	end
end

function togglePassive(which) -- Toggle passive functions on/off
	if(which=="AutoGZ") then
		if(AutoGZState == "ON") then
			AutoGZState = "OFF";
		else
			AutoGZState = "ON";
		end
		print(color.."Auto-GZ is now "..AutoGZState..".");
	elseif(which=="BattleDing") then
		if(BattleDingState == "ON") then
			BattleDingState = "OFF";
		else
			BattleDingState = "ON";
		end
		print(color.."BattleNet Ding is now "..BattleDingState..".");
	elseif(which=="MageShield") then
		if(MageShieldState == "ON") then
			MageShieldState = "OFF";
		else
			MageShieldState = "ON";
		end
		print(color.."Mage Shield is now "..MageShieldState..".");
	elseif(which=="GuildDing") then
		if(GuildDingState == "ON") then
			GuildDingState = "OFF";
		else
			GuildDingState = "ON";
		end
		print(color.."Guild Ding is now "..GuildDingState..".");
	elseif(which=="FullyRested") then
		if(FullyRestedState == "ON") then
			FullyRestedState = "OFF";
		else
			FullyRestedState = "ON";
		end
		print(color.."Rested is now "..FullyRestedState..".");
	elseif(which=="Zoom") then
		if(ZoomState == "ON") then
			ZoomState = "OFF";
		else
			ZoomState = "ON";
		end
		print(color.."ZOOM is now "..ZoomState..".");
	elseif(which=="Pop") then
		if(PopState == "ON") then
			PopState = "OFF";
		else
			PopState = "ON";
		end
		print(color.."POP is now "..PopState..".");
	elseif(which=="MonsterEmote") then
		if(MonsterEmoteState == "ON") then
			MonsterEmoteState = "OFF";
		else
			MonsterEmoteState = "ON";
		end
		print(color.."Monster Emote is now "..MonsterEmoteState..".");
	elseif(which=="PartyAchievement") then
		if(PartyAchievementState == "ON") then
			PartyAchievementState = "OFF";
		else
			PartyAchievementState = "ON";
		end
		print(color.."Party Achievement is now "..PartyAchievementState..".");
	end
end

function InitiateShitstorm() -- Initiate a trade shitstorm by linking [Dirge] in trade. Note: Trade must be channel #2.
	local n, dirgeLink = GetItemInfo(23555);
	
	if(dirgeLink ~= nil) then
		SendChatMessage(dirgeLink, "CHANNEL", nil, 2);
	else
		print(color.."The requested itemLink was unavailable, but should be available now. Please try again."..original);
	end
end

function ShowWaypointsMenu() -- List available TomTom waypoints options
	print(color.."NOTE: These options require that you have the TomTom addon installed!"..original);
	print(color.."/derp raptor"..original.." -- Add waypoints for raptor pets to map");
	print(color.."/derp bookclub"..original.." -- Add waypoints for "..GetAchievementLink(1956).." to map");
	print(color.."/derp fox"..original.." -- Add waypoints for Baradin Foxes in TB to map");
end

function ShowRaptorMenu() -- Show available raptor functions
	local n, ravasaurLink = GetItemInfo(48122);
	local n, dartingLink = GetItemInfo(48112);
	
	if(ravasaurLink == nil or dartingLink == nil) then -- Can't be bothered caching these, just don't show a link if they're not available
		print(color.."/derp raptor ravasaur"..original.." -- Un'Goro Crater waypoints for Ravasaur Hatchling on your map");
		print(color.."/derp raptor darting"..original.." -- Dustwallow Marsh waypoints for Darting Hatchling on your map");
	else
		print(color.."/derp raptor ravasaur"..original.." -- Un'Goro Crater waypoints for "..ravasaurLink.." on your map");
		print(color.."/derp raptor darting"..original.." -- Dustwallow Marsh waypoints for "..dartingLink.." on your map");
	end
end

function RaptorWaypoints(race) -- Set up raptor spawn points on map
	if(IsAddOnLoaded("TomTom") == 1) then
		if(race == "ravasaur") then
			location = "Un'Goro Crater";
			description = "Ravasaur Matriarch's Nest";
			coordinates = {"68.9 61.2", "63.0 63.2", "62.2 65.2", "62.0 73.6", "68.9 66.6"};
		elseif(race == "darting") then
			location = "Dustwallow Marsh";
			description = "Dart's Nest";
			coordinates = {"48.0 14.2", "46.5 17.2", "49.2 17.5", "47.9 19.0"}
		end
		
		local i = 1;
		while coordinates[i] ~= nil do
			SendSlash("way " .. location .. " " .. coordinates[i] .. " " .. description);
			i = i + 1;
		end

		SendSlash("cway");
	else
		print(color.."[Derpy]"..original.." You must have "..color.."TomTom"..original.." installed and enabled to use this function.");
	end
end

function FoxWaypoints()
	if(IsAddOnLoaded("TomTom") == 1) then
		location = "Tol Barad Peninsula";
		description = "Baradin Fox";
		coordinates = {"33.86 42.88", "32.77 47.71", "35.24 55.89", "33.81 59.27", "40.49 54.43", "50.14 67.66", "49.89 74.69", "56.84 72.95", "67.46 76.76", "67.38 65.44", "70.45 61.10", "51.94 58.43", "50.14 46.07", "47.17 42.05", "48.02 35.89", "52.41 39.69"};
		local i = 1;
		while coordinates[i] ~= nil do
			SendSlash("way " .. location .. " " .. coordinates[i] .. " " .. description);
			i = i + 1;
		end

		SendSlash("cway");
	else
		print(color.."[Derpy]"..original.." You must have "..color.."TomTom"..original.." installed and enabled to use this function.");
	end
end

function HigherLearningWaypoints() -- Set up Higher Learning waypoints on map
	if(IsAddOnLoaded("TomTom") == 1) then
		location = "Dalaran";
		description = {"Abjuration", "Transmutation", "Necromancy", "Enchantment", "Conjuration", "Divination", "Introduction", "Illusion"};
		coordinates = {"52.2 54.8", "46.8 40.0", " 46.8 39.1", "43.6 46.7", "31.0 46.7", "26.5 52.2", "56.7 45.5", "64.4 52.4"};
		
		local i = 1;
		while coordinates[i] ~= nil do
			SendSlash("way " .. location .. " " .. coordinates[i] .. " The Schools of Arcane Magic - " .. description[i]);
			i = i + 1;
		end
	else
		print(color.."[Derpy]"..original.." You must have "..color.."TomTom"..original.." installed and enabled to use this function.");
	end
end
