-- Derpy v2.0
-- By Moontits/Kugalskap of Dalaran-WoW
-- Formerly known as Derpderpderp and Noaide of Ragnaros EU

-- You are free to redistribute and modify this addon, as long 
-- as you give proper credit to me, the original author.

color = "|cFF66EE66" -- We like green
highlightColor = "|cFF9BFF00"
original = "|r"
CurrentLevelCap = 80 -- With lack of a function to retrieve this dynamically...
repTrackLastTimestamp = time()
lastInnervateMessageTime = nil

innervateLink = "\124cff71d5ff\124Hspell:29166\124h[Innervate]\124h\124r"

function Derpy_OnLoad() -- Addon loaded
	SLASH_DERPY1, SLASH_DERPY2 = '/derp', '/derpy'
	DerpyPrint("v2.0 loaded (/derp or /derpy)")
	
	DerpyFrame:RegisterEvent("VARIABLES_LOADED") -- So we can detect user preferences
	DerpyFrame:RegisterEvent("ACHIEVEMENT_EARNED") -- For Party Achievement function
	DerpyFrame:RegisterEvent("PLAYER_LEVEL_UP") -- For Guild Ding function
	DerpyFrame:RegisterEvent("PLAYER_UPDATE_RESTING") -- For Rested function
	DerpyFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE") -- For Monster Emote function
	DerpyFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED") -- ZOOOOOOOOOOM
	DerpyFrame:RegisterEvent("COMBAT_TEXT_UPDATE") -- For RepTrack function
	DerpyFrame:RegisterEvent("UNIT_AURA") -- For Innervate function
end

function SlashCmdList.DERPY(msg, editbox) -- Handler for slash commands
	msg = strlower(msg)
	
	if(msg == "hurr") then
		DerpyPrint("durr") -- derp
	elseif(msg == "tf") then
		DerpyPrint("\124cffff8000\124Hitem:19019:0:0:0:0:0:0:0:0\124h[Thunderfury, Blessed Blade of the Windseeker]\124h\124r")
	elseif(msg == "bagworth") then
		BagWorth()
	elseif(msg == "useless") then
		PurgeUselessItems()
	elseif(msg == "gray" or msg == "grey") then
		PurgeGrayItems()
	elseif(msg == "bookclub") then
		HigherLearningWaypoints()
    elseif(msg == "pet") then
		RandomPet(0)
    elseif(msg == "spet") then
		RandomPet(1)
    elseif(msg == "shitstorm") then
		DerpyPrint("\124cffa335ee\124Hitem:23555:0:0:0:0:0:0:0:0\124h[Dirge]\124h\124r")
	elseif(msg == "partyachi") then
		togglePassive("PartyAchievement")
	elseif(msg == "rested") then
		togglePassive("FullyRested")
	elseif(msg == "monster") then
		togglePassive("MonsterEmote")
	elseif(msg == "mshield") then
		togglePassive("MageShield")
	elseif(msg == "gding") then
		togglePassive("GuildDing")
    elseif(msg == "rep") then
		togglePassive("RepTrack")
    elseif(msg == "ivt" or msg == "innervate") then
		togglePassive("Innervate")
    elseif(msg == "passive") then
		ShowPassiveMenu();
    elseif(msg == "dr" or msg == "disband") then
		DisbandRaid()
    elseif(msg == "speed") then
		DerpyPrint("Current speed: "..string.format("%d", (GetUnitSpeed("Player") / 7) * 100).."%")
    elseif(msg == "about") then
        DerpyPrint("was made by Moontits/Kugalskap of Dalaran-WoW, formerly Derpderpderp/Noaide of Ragnaros EU. The author is the same person, but I now play on a WotLK private server.")
	elseif(msg == "" or msg == nil) then
		ShowUsage()
	else
		ShowUsage()
	end
end

function SendSlash(slashCommandToSend) -- Send a slash command
	ChatFrame1EditBox:SetText("")
	ChatFrame1EditBox:Insert("/"..slashCommandToSend)
	ChatEdit_SendText(ChatFrame1EditBox)
end

function has_value (tab, val) -- Shamelessly stolen from Stack Overflow
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function DerpyPrint(msg) -- Print a chat frame message in Derpy format
	print(color.."[Derpy]"..original.." "..msg)
end

function highlight(msg) -- Highlight a piece of text
	return highlightColor..msg..original
end

function ShowUsage() -- Show available functions
	DerpyPrint("Usage: "..color.."/derp "..highlight("<command>"))
	DerpyPrint("Available commands:")
	DerpyPrint(highlight("passive").." -- View and toggle Derpy's passive functions")
	DerpyPrint(highlight("gray/grey").." -- Purge all poor quality (gray) items from your bags")
	DerpyPrint(highlight("useless").." -- Purge useless items from your bags")
	DerpyPrint(highlight("bagworth").." -- Show the total worth of the items in your bags")
	DerpyPrint(highlight("speed").." -- Calculates and outputs your current speed")
	DerpyPrint(highlight("bookclub").." -- Add TomTom waypoints for "..GetAchievementLink(1956).." to map")
	DerpyPrint(highlight("shitstorm").." -- Initiate a chat shitstorm, TBC-style")
	DerpyPrint(highlight("pet").." -- Summon a random companion pet "..highlight("with").." snazzy summoning dialogue")
	DerpyPrint(highlight("spet").." -- Summon a random companion pet "..highlight("without").." the snazzy summoning dialogue")
	DerpyPrint(highlight("dr/disband").." -- Disband a raid group you are the leader of")
	DerpyPrint(highlight("about").." -- Show information on who made this addon")
end

function ShowPassiveMenu() -- List states and descriptions of passive functions
	DerpyPrint("Toggle passive features:"..original)
	DerpyPrint(highlight("partyachi").." -- Toggle Party Achievement notification (Currently "..highlight(PartyAchievementState)..")")
	DerpyPrint(highlight("gding").." -- Toggle Guild Ding notifications (Currently "..highlight(GuildDingState)..")")
	DerpyPrint(highlight("rested").." -- Toggle resting notifications (Currently "..highlight(FullyRestedState)..")")
	DerpyPrint(highlight("monster").." -- Toggle emphasis of monster emotes in error frame (Currently "..highlight(MonsterEmoteState)..")")
	DerpyPrint(highlight("mshield").." -- Toggle Mage Shield timers (Req. Deadly Boss Mods) (Currently "..highlight(MageShieldState)..")")
	DerpyPrint(highlight("rep").." -- Toggle auto-changing watched faction when you gain rep (Currently "..highlight(RepTrackState)..")")
	DerpyPrint(highlight("innervate/ivt").." -- Toggle sending a whisper to the person you cast "..innervateLink.." on (Currently "..highlight(InnervateState)..")")
end

function togglePassive(which) -- Toggle passive functions on/off
	if(which=="RepTrack") then
		if(RepTrackState == "ON") then
			RepTrackState = "OFF"
		else
			RepTrackState = "ON"
		end
		DerpyPrint("RepTrack is now "..RepTrackState..".")
	elseif(which=="Innervate") then
		if(InnervateState == "ON") then
			InnervateState = "OFF"
		else
			InnervateState = "ON"
		end
		DerpyPrint("Innervate whispers are now "..InnervateState..".")
	elseif(which=="MageShield") then
		if(MageShieldState == "ON") then
			MageShieldState = "OFF"
		else
			MageShieldState = "ON"
		end
		DerpyPrint("Mage Shield is now "..MageShieldState..".")
	elseif(which=="GuildDing") then
		if(GuildDingState == "ON") then
			GuildDingState = "OFF"
		else
			GuildDingState = "ON"
		end
		DerpyPrint("Guild Ding is now "..GuildDingState..".")
	elseif(which=="FullyRested") then
		if(FullyRestedState == "ON") then
			FullyRestedState = "OFF"
		else
			FullyRestedState = "ON"
		end
		DerpyPrint("Rested is now "..FullyRestedState..".")
	elseif(which=="MonsterEmote") then
		if(MonsterEmoteState == "ON") then
			MonsterEmoteState = "OFF"
		else
			MonsterEmoteState = "ON"
		end
		DerpyPrint("Monster Emote is now "..MonsterEmoteState..".")
	elseif(which=="PartyAchievement") then
		if(PartyAchievementState == "ON") then
			PartyAchievementState = "OFF"
		else
			PartyAchievementState = "ON"
		end
		DerpyPrint("Party Achievement is now "..PartyAchievementState..".")
	end
end

function Derpy_OnEvent(self, event, ...) -- Event handler
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...;
	if(event=="VARIABLES_LOADED") then
		CombatTextSetActiveUnit("player") -- For RepTrack to work
		
		if PartyAchievementState == nil then
			PartyAchievementState = "OFF" -- Defaults to off, because it's cancerous
		end
		if MonsterEmoteState == nil then
			MonsterEmoteState = "ON" -- Defaults to on, because it's useful
		end
		if GuildDingState == nil then
			GuildDingState = "OFF" -- Defaults to off, because it's cancerous
		end
		if FullyRestedState == nil then
			FullyRestedState = "ON" -- Defaults to on, because people never pay attention to the resting icon on their character frame
		end
		if MageShieldState == nil then
			MageShieldState = "OFF" -- Default to off, because it isn't extremely useful
		end
		if RepTrackState == nil then
			RepTrackState = "ON" -- Defaults to on, because it's useful
		end
		if InnervateState == nil then
			InnervateState = "ON" -- Defaults to on, because it's useful
		end
		
	elseif(event=="UNIT_AURA") then -- Innervate notifier
		if(InnervateState~="OFF") then
			receivingUnit = arg1
			_, _, _, _, _, _, _, unitCaster = UnitAura(receivingUnit, "Innervate")
			if(unitCaster ~= nil and receivingUnit ~= nil and unitCaster == "player" and receivingUnit ~= unitCaster and UnitName(unitCaster) ~= UnitName(receivingUnit)) then
				if(lastInnervateMessageTime == nil or time() - lastInnervateMessageTime > 10) then
					lastInnervateMessageTime = time()
					SendChatMessage("\124cff71d5ff\124Hspell:29166\124h[Innervate]\124h\124r on you!", "WHISPER", nil, GetUnitName(receivingUnit))
				end
			end
		end
	elseif(event=="UNIT_SPELLCAST_SUCCEEDED") then -- Mage Shields
		if(MageShieldState~="OFF") then
			if(IsAddOnLoaded("DBM-Core") == 1) then
				if(arg1=="player" and arg2 == "Ice Barrier") then
					SendSlash("dbm timer 24 Ice Barrier")
				elseif(arg1=="player" and arg2 == "Mana Shield") then
					local secs = 12; -- Unmodified Mana Shield cooldown
					local count = 1;
					while count <= GetNumGlyphSockets() do -- Check if user has the Mana Shield glyph before doing anything (-2 secs Mana Shield CD)
						enabled, glyphType, glyphTooltipIndex, glyphSpellID = GetGlyphSocketInfo(count);
						if(enabled==1) then -- Skip disabled slots
							if(glyphType==1) then -- Skip Prime and Minor glyphs (MS Glyph is Major)
								if(glyphSpellID~=nil) then -- Skip if the slot is empty
									if(glyphSpellID==70937) then -- Glyph of Mana Shield Spell ID
										secs = 10
									end
								end
							end
						end
						count = count + 1
					end
					SendSlash("dbm timer "..secs.." Mana Shield")
				end
			end
		end
		
	elseif(event=="CHAT_MSG_MONSTER_EMOTE") then -- Monster Emote function
		if(MonsterEmoteState~="OFF") then
			UIErrorsFrame:Clear()
			UIErrorsFrame:AddMessage(string.gsub(arg1, "%%s", arg2), 1.0, 0.5, 0.25, GetChatTypeIndex("MONSTER_EMOTE"), 5)
		end
		
	elseif(event=="PLAYER_UPDATE_RESTING") then -- Rested function
		if(FullyRestedState~="OFF") then
			if(IsResting()==1) then
				DerpyPrint("You are now resting.")
			elseif(IsResting()==nil) then
				restedXP = GetXPExhaustion()
				
				if restedXP == nil then restedXP = 0 end
				if(UnitLevel("player") < CurrentLevelCap) then
					DerpyPrint("You are no longer resting ("..restedXP.." rested XP).")
				else
					DerpyPrint("You are no longer resting.")
				end
			end
		end
		
	elseif(event=="ACHIEVEMENT_EARNED") then -- Party Achievement function
		if(PartyAchievementState~="OFF") then
			partyAchivementLink = GetAchievementLink(arg1)

			if(GetNumPartyMembers() > 0) then
				SendChatMessage(UnitName("player").." earned the achievement "..partyAchivementLink.."!", "PARTY", nil)
			elseif(GetNumRaidMembers() > 0) then
				SendChatMessage(UnitName("player").." earned the achievement "..partyAchivementLink.."!", "RAID", nil)
			end
		end
		
	elseif(event=="PLAYER_LEVEL_UP") then -- Guild Ding function
		if(GuildDingState~="OFF") then
			if(IsInGuild()==1) then
				SendChatMessage("Ding! "..UnitName("player").." just reached level "..arg1.."!","GUILD",nil)
			end
		end
		
	elseif(event=="COMBAT_TEXT_UPDATE") then -- RepTrack - Automatically change watched faction when you gain rep
		if(RepTrackState~="OFF") then
			if(arg1=="FACTION") then
				currGainedFaction = arg2
				repGain = arg3
				if(repGain > 0) then -- Ignore negative reputation
					if(difftime(time(), repTrackLastTimestamp) > 1) then -- Avoids changing watched faction rapidly on multiple gains within a couple of seconds
						numFactions = GetNumFactions()
						for factionCounter = 0, numFactions, 1
						do
							factionName = GetFactionInfo(factionCounter)
							if(factionName == currGainedFaction) then
								currWatched = GetWatchedFactionInfo()
								if(currGainedFaction~=currWatched) then
									DerpyPrint("Changed watched faction to "..factionName.."!")
								end
								
								SetWatchedFactionIndex(factionCounter)
								repTrackLastTimestamp = time() -- Record timestamp of last watched faction change time
								break
							end
						end
					end
				end				
			end
		end
	end
end

function PurgeGrayItems() -- Delete all gray items from bags
	purgeCount = 0
	slotCount = 0
	wastedGoldCount = 0
	
	for bag=0,4 
	do 
		for slot = 1,GetContainerNumSlots(bag) 
		do 
			link = GetContainerItemLink(bag, slot)
			_, itemCount = GetContainerItemInfo(bag, slot)
			
			if link then
				itemInfo = {GetItemInfo(link)}
				rarity = select(3, unpack(itemInfo))
				itemSellPrice = select(11, unpack(itemInfo))
				
				if (rarity == 0) then -- It's a gray item
					PickupContainerItem(bag, slot) 
					DeleteCursorItem() 
					purgeCount = purgeCount + itemCount
					slotCount = slotCount + 1
					wastedGoldCount = wastedGoldCount + (itemSellPrice * itemCount)
				end
			end 
		end 
	end
	
	if(purgeCount > 0) then
		DerpyPrint("Purged "..purgeCount.." |4gray item from your bags. If you had sold this item:gray items (taking up "..slotCount.." slots) from your bags . If you had sold these items; to a vendor instead, you would have made "..GetCoinTextureString(wastedGoldCount)..".")
	else
		DerpyPrint("You have no gray items in your bags.")
	end
end

function PurgeUselessItems()
	uselessItems = { 
		"A Guide to Northern Cloth Scavenging",
		"Manual: Heavy Frostweave Bandage"
	}
	purgeCount = 0
	
	for bag=0,4 
	do 
		for slot = 1,GetContainerNumSlots(bag) 
		do 
			link = GetContainerItemLink(bag, slot)
			_, itemCount = GetContainerItemInfo(bag, slot)
			
			if link then
				itemInfo = {GetItemInfo(link)}
				itemName = select(1, unpack(itemInfo))
				rarity = select(3, unpack(itemInfo))
				itemSellPrice = select(11, unpack(itemInfo))
				
				if(has_value(uselessItems, itemName)) then -- It's a useless item
					DerpyPrint("Purging "..link)
					PickupContainerItem(bag, slot) 
					DeleteCursorItem() 
					purgeCount = purgeCount + itemCount
				end
			end 
		end 
	end
	
	if(purgeCount > 0) then
		DerpyPrint("Purged "..purgeCount.." |4useless item:useless items; from your bag.")
	else
		DerpyPrint("You have no \"useless\" items in your bags.")
	end
end

function BagWorth() -- Not a reappropriation of PurgeGrayItems() at all, no sir, not on my watch
	totalItemCount = 0
	runningGoldCount = 0
	
	for bag=0,4 
	do 
		for slot = 1,GetContainerNumSlots(bag) 
		do 
			link = GetContainerItemLink(bag, slot)
			_, itemCount = GetContainerItemInfo(bag, slot)
			
			if link then
				totalItemCount = totalItemCount + itemCount
				itemSellPrice = select(11, GetItemInfo(link))
				runningGoldCount = runningGoldCount + (itemSellPrice * itemCount)
			end 
		end 
	end
	
	if(totalItemCount > 0) then
		DerpyPrint("You have "..totalItemCount.." |4item in your bags. If you had sold it:items in your bags. If you had sold them; to a vendor, you would have made "..GetCoinTextureString(runningGoldCount)..".")
	else
		DerpyPrint("You have no items in your bags.")
	end
end

function DisbandRaid() -- Remove all raid members
	numRaidMems = GetNumRaidMembers()
	if(numRaidMems > 1 and numRaidMems ~= nil) then
		SendChatMessage("Raid disbanding!","RAID",nil);
		for i = 1, GetNumRaidMembers() do 
			if("raid"..i~="player") then 
				UninviteUnit("raid"..i)
			end
		end
	end
end

function RandomPet(silent) -- Summon a random pet with or without funky dialogue
	if(IsFlying()==1) then
		DerpyPrint("Silly "..UnitClass("player")..", you can't summon a pet while flying!");
	elseif(UnitIsDeadOrGhost("player")) then
		DerpyPrint("Silly "..UnitClass("player")..", you can't summon a pet whilst dead!");
	elseif(GetNumCompanions("CRITTER") == 0 or GetNumCompanions("CRITTER") == nil) then
		DerpyPrint("Silly "..UnitClass("player")..", you have no pets to summon!");
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
		}
		
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

function HigherLearningWaypoints() -- Set up Higher Learning waypoints on map
	if(IsAddOnLoaded("TomTom") == 1) then
		location = "Dalaran"
		description = {"Abjuration", "Transmutation", "Necromancy", "Enchantment", "Conjuration", "Divination", "Introduction", "Illusion"}
		coordinates = {"52.2 54.8", "46.8 40.0", " 46.8 39.1", "43.6 46.7", "31.0 46.7", "26.5 52.2", "56.7 45.5", "64.4 52.4"}
		
		local i = 1
		while coordinates[i] ~= nil
		do
			SendSlash("way " .. location .. " " .. coordinates[i] .. " The Schools of Arcane Magic - " .. description[i])
			i = i + 1
		end
	else
		DerpyPrint("You must have "..highlight("TomTom").." installed and enabled to use this function.")
	end
end
