-- Derpy v2.3
-- By Moontits/Kugalskap of Dalaran-WoW
-- Also known as Cursetits/Poodle on Apollo 2
-- Formerly known as Derpderpderp and Noaide of Ragnaros EU

-- You are free to redistribute and modify this addon, as long 
-- as you give proper credit to me, the original author.

local color = "|cFF66EE66" -- We like green
local highlightColor = "|cFF9BFF00"
local original = "|r"
local CurrentLevelCap = 85 -- With lack of a function to retrieve this dynamically...
local repTrackLastTimestamp = time()
local antiShitterLastTimestamp = time()
local lastInnervateMessageTime = nil
local lastWebWrapMessageTime = nil
local lastAvgItemLevel = nil

local innervateLink = "\124cff71d5ff\124Hspell:29166\124h[Innervate]\124h\124r"

factionStandingColors = {
	["Hated"] = "cc2222",
	["Hostile"] = "ff0000",
	["Unfriendly"] = "ee6622",
	["Neutral"] = "ffff00",
	["Friendly"] = "bfff00",
	["Honored"] = "00ff88",
	["Revered"] = "00ffcc",
	["Exalted"] = "00ffff"
}

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

function Derpy_OnLoad() -- Addon loaded
	SLASH_DERPY1, SLASH_DERPY2, SLASH_DERPY3 = '/derp', '/derpy', '/dr'
	DerpyPrint("v2.3-Cata loaded (/derpy, /derp, /dr)")
	
	DerpyFrame:RegisterEvent("ADDON_LOADED") -- So we can detect user preferences
	DerpyFrame:RegisterEvent("ACHIEVEMENT_EARNED") -- For Party Achievement function
	DerpyFrame:RegisterEvent("PLAYER_LEVEL_UP") -- For Guild Ding function
	DerpyFrame:RegisterEvent("PLAYER_UPDATE_RESTING") -- For Rested function
	DerpyFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE") -- For Monster Emote function
	DerpyFrame:RegisterEvent("COMBAT_TEXT_UPDATE") -- For RepTrack and RepCalc functions
	DerpyFrame:RegisterEvent("CHAT_MSG_SYSTEM") -- For RepAnnounce function
	DerpyFrame:RegisterEvent("UNIT_AURA") -- For Innervate and SpiderBurrito function
	DerpyFrame:RegisterEvent("BAG_UPDATE") -- For AutoPurge
	DerpyFrame:RegisterEvent("PARTY_MEMBERS_CHANGED") -- For AntiShitter
	DerpyFrame:RegisterEvent("RAID_ROSTER_UPDATE") -- For AntiShitter
	DerpyFrame:RegisterEvent("MERCHANT_UPDATE") -- For SetRescue
	DerpyFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") -- For iLvLUpdate	
	DerpyFrame:RegisterEvent("PLAYER_ENTERING_WORLD") -- For iLvLUpdate	to get accurate average item level upon login
	
	DerpyRepFrame = CreateFrame("Frame", "DerpyRepFrame", UIParent)
	DerpyRepFrame:Hide()
	DerpyRepFrame:ClearAllPoints()
	DerpyRepFrame:SetPoint("TOP", UIParent, "CENTER", 0, 300)
	DerpyRepFrame:SetWidth(350)
	DerpyRepFrame:SetHeight(80)
	DerpyRepFrame:SetFrameStrata("DIALOG")
	DerpyRepFrame:SetBackdrop({
		  bgFile = [[Interface\GLUES\MODELS\UI_NightElf\aa_NE_sky]], 
		  edgeFile = [[Interface\DialogFrame\UI-DialogBox-Gold-Border]], 
		  tile = 0,
		  edgeSize = 16,
		  insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})

	DerpyRepFrame.text = DerpyRepFrame:CreateFontString(nil, "ARTWORK")
	DerpyRepFrame.text:SetFont("Fonts\\FRIZQT__.TTF", 14)
	DerpyRepFrame.text:SetTextColor(1, 1, 1)
	DerpyRepFrame.text:SetAllPoints()
end

function SlashCmdList.DERPY(msg, editbox) -- Handler for slash commands
	local message = strlower(trim(msg)) -- Easier this way...
	
	if(message == "hurr") then
		DerpyPrint("durr") -- derp
	elseif(starts_with(message, "autopurge")) then
		AutoPurgeHandler(message)
	elseif(message == "options") then
		if(DerpyOptionsFrame:IsShown()) then
			DerpyOptionsFrame:Hide()
		else
			DerpyOptionsFrame:Show()
		end
	elseif(message == "tf") then
		DerpyPrint("\124cffff8000\124Hitem:19019:0:0:0:0:0:0:0:0\124h[Thunderfury, Blessed Blade of the Windseeker]\124h\124r")
	elseif(message == "bagworth") then
		BagWorth()
	elseif(message == "lowgray" or message == "lowgrey") then
		PurgeLowestValueGray()
	elseif(message == "gray" or message == "grey") then
		PurgeGrayItems(true)
	elseif(message == "bookclub") then
		HigherLearningWaypoints()
    elseif(message == "pet") then
		RandomPet(0)
    elseif(message == "spet") then
		RandomPet(1)
    elseif(message == "shitstorm") then
		DerpyPrint("\124cffa335ee\124Hitem:23555:0:0:0:0:0:0:0:0\124h[Dirge]\124h\124r")
	elseif(message == "partyachi") then
		togglePassive("PartyAchievement", 1)
	elseif(message == "rested") then
		togglePassive("FullyRested", 1)
	elseif(message == "monster") then
		togglePassive("MonsterEmote", 1)
	elseif(starts_with(message, "pony")) then
		PonyTime(message)
	elseif(message == "gding") then
		togglePassive("GuildDing", 1)
    elseif(message == "repa") then
		togglePassive("RepAnnounce", 1)
    elseif(message == "repc") then
		togglePassive("RepCalc", 1)
    elseif(message == "rep") then
		togglePassive("RepTrack", 1)
    elseif(message == "ivt" or message == "innervate") then
		togglePassive("Innervate", 1)
    elseif(message == "sb" or message == "spiderburrito") then
		togglePassive("SpiderBurrito", 1)
    elseif(message == "antishitter") then
		togglePassive("AntiShitter", 1)
    elseif(message == "setrescue") then
		togglePassive("SetRescue", 1)
    elseif(message == "ilvlupdate") then
		togglePassive("iLvLUpdate", 1)
    elseif(message == "passive") then
		ShowPassiveMenu();
    elseif(message == "dr" or message == "disband") then
		DisbandRaid()
    elseif(message == "speed") then
		DerpyPrint("Current speed: "..string.format("%d", (GetUnitSpeed("Player") / 7) * 100).."%")
    elseif(message == "about") then
        DerpyPrint("was made by Cursetits/Poodle of Apollo 2, formerly Derpderpderp/Noaide of Ragnaros EU. The author is the same person, but I now play on a WotLK private server.")
	elseif(message == "" or message == nil or message == " ") then
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

function table_index(whichTable, whichValue)
	local index={}
	for k,v in pairs(whichTable) do
	   index[v]=k
	end
	return index[whichValue]
end

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function DerpyPrint(msg) -- Print a chat frame message in Derpy format
	print(color.."[Derpy]"..original.." "..msg)
end

function highlight(msg) -- Highlight a piece of text
	if(msg~=nil) then
		return highlightColor..msg..original
	end
end

function ShowUsage() -- Show available functions
	DerpyPrint("Usage: "..color.."/derp "..highlight("<command>"))
	DerpyPrint("(/derp can be substituted for /dr or /derpy)")
	DerpyPrint("Available commands:")
	DerpyPrint(highlight("options").." -- Show the graphical options window")
	DerpyPrint(highlight("passive").." -- View and toggle Derpy's passive functions")
	DerpyPrint(highlight("gray/grey").." -- Purge all poor quality (gray) items from your bags")
	DerpyPrint(highlight("lowgray/lowgrey").." -- Purge the lowest value gray item slot from your bags")
	DerpyPrint(highlight("bagworth").." -- Show the total worth of the items in your bags")
	DerpyPrint(highlight("pony [raid|party]").." -- Tattle on who has \124cff71d5ff\124Hspell:32223\124h[Crusader Aura]\124h\124r enabled")
	DerpyPrint(highlight("speed").." -- Calculates and outputs your current speed")
	DerpyPrint(highlight("bookclub").." -- Add TomTom waypoints for "..GetAchievementLink(1956).." to map")
	DerpyPrint(highlight("shitstorm").." -- Initiate a chat shitstorm, TBC-style")
	DerpyPrint(highlight("pet").." -- Summon a random companion pet "..highlight("with").." snazzy summoning dialogue")
	DerpyPrint(highlight("spet").." -- Summon a random companion pet "..highlight("without").." the snazzy summoning dialogue")
	DerpyPrint(highlight("dr/disband").." -- Disband a raid group you are the leader of")
	DerpyPrint(highlight("about").." -- Show information on who made this addon")
end

function ShowPassiveMenu() -- List states and descriptions of passive functions
	DerpyPrint("Usage: "..color.."/derp "..highlight("<command>"))
	DerpyPrint("(/derp can be substituted for /dr or /derpy)")
	DerpyPrint("Toggle passive features:"..original)
	DerpyPrint(highlight("autopurge").." -- (Submenu) Automatically purge specified items (Currently "..highlight(AutoPurgeState)..")")
	DerpyPrint(highlight("partyachi").." -- Toggle Party Achievement notification (Currently "..highlight(PartyAchievementState)..")")
	DerpyPrint(highlight("gding").." -- Toggle Guild Ding notifications (Currently "..highlight(GuildDingState)..")")
	DerpyPrint(highlight("rested").." -- Toggle resting notifications (Currently "..highlight(FullyRestedState)..")")
	DerpyPrint(highlight("monster").." -- Toggle emphasis of monster emotes in error frame (Currently "..highlight(MonsterEmoteState)..")")
	DerpyPrint(highlight("rep").." -- Toggle auto-changing watched faction when you gain rep (Currently "..highlight(RepTrackState)..")")
	DerpyPrint(highlight("repa").." -- Toggle announce window when your faction standing changes (Currently "..highlight(RepAnnounceState)..")")
	DerpyPrint(highlight("repc").." -- Toggle showing you progress to the next reputation level whenever you gain rep (Currently "..highlight(RepCalcState)..")")
	DerpyPrint(highlight("antishitter").." -- Toggle notification when you join a party/raid with an ignored player (Currently "..highlight(AntiShitterState)..")")
	DerpyPrint(highlight("setrescue").." -- Toggle automatic buyback of equipment set items when at a vendor (Currently "..highlight(SetRescueState)..")")
	DerpyPrint(highlight("ilvlupdate").." -- Toggle notifying when your average item level changes (Currently "..highlight(iLvLUpdateState)..")")
	DerpyPrint(highlight("innervate/ivt").." -- Toggle sending a whisper to the person you cast \124cff71d5ff\124Hspell:29166\124h[Innervate]\124h\124r on (Currently "..highlight(InnervateState)..")")
	DerpyPrint(highlight("sb/spiderburrito").." -- Toggle notifying people when you are \124cff71d5ff\124Hspell:52086\124h[Web Wrap]\124h\124rped (Currently "..highlight(SpiderBurritoState)..")")
end

function togglePassive(which, verbose) -- Toggle passive functions on/off
	if(which=="RepTrack") then
		if(RepTrackState == "ON") then
			RepTrackState = "OFF"
		else
			RepTrackState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("RepTrack is now "..RepTrackState..".") 
		end
	elseif(which=="RepAnnounce") then
		if(RepAnnounceState == "ON") then
			RepAnnounceState = "OFF"
		else
			RepAnnounceState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("RepAnnounce is now "..RepAnnounceState..".")
		end
	elseif(which=="RepCalc") then
		if(RepCalcState == "ON") then
			RepCalcState = "OFF"
		else
			RepCalcState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("RepCalc is now "..RepCalcState..".")
		end
	elseif(which=="AutoPurge") then
		if(AutoPurgeState == "ON") then
			AutoPurgeState = "OFF"
		else
			AutoPurgeState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("AutoPurge is now "..AutoPurgeState..".")
		end
	elseif(which=="AutoPurgeVerbose") then
		if(AutoPurgeVerbose == "ON") then
			AutoPurgeVerbose = "OFF"
		else
			AutoPurgeVerbose = "ON"
		end
		if(verbose==1) then
			DerpyPrint("AutoPurge verbose mode is now "..AutoPurgeVerbose..".")
		end
	elseif(which=="Innervate") then
		if(InnervateState == "ON") then
			InnervateState = "OFF"
		else
			InnervateState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("Innervate whispers are now "..InnervateState..".")
		end
	elseif(which=="SpiderBurrito") then
		if(SpiderBurritoState == "ON") then
			SpiderBurritoState = "OFF"
		else
			SpiderBurritoState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("SpiderBurrito is now "..SpiderBurritoState..".")
		end
	elseif(which=="AntiShitter") then
		if(AntiShitterState == "ON") then
			AntiShitterState = "OFF"
		else
			AntiShitterState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("AntiShitter is now "..AntiShitterState..".")
		end
	elseif(which=="SetRescue") then
		if(SetRescueState == "ON") then
			SetRescueState = "OFF"
		else
			SetRescueState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("SetRescue is now "..SetRescueState..".")
		end
	elseif(which=="iLvLUpdate") then
		if(iLvLUpdateState == "ON") then
			iLvLUpdateState = "OFF"
		else
			iLvLUpdateState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("iLvLUpdate is now "..iLvLUpdateState..".")
		end
	elseif(which=="GuildDing") then
		if(GuildDingState == "ON") then
			GuildDingState = "OFF"
		else
			GuildDingState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("Guild Ding is now "..GuildDingState..".")
		end
	elseif(which=="FullyRested") then
		if(FullyRestedState == "ON") then
			FullyRestedState = "OFF"
		else
			FullyRestedState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("Rested is now "..FullyRestedState..".")
		end
	elseif(which=="MonsterEmote") then
		if(MonsterEmoteState == "ON") then
			MonsterEmoteState = "OFF"
		else
			MonsterEmoteState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("Monster Emote is now "..MonsterEmoteState..".")
		end
	elseif(which=="PartyAchievement") then
		if(PartyAchievementState == "ON") then
			PartyAchievementState = "OFF"
		else
			PartyAchievementState = "ON"
		end
		if(verbose==1) then
			DerpyPrint("Party Achievement is now "..PartyAchievementState..".")
		end
	end
end

function Derpy_OnEvent(self, event, ...) -- Event handler
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...;
	if(event=="ADDON_LOADED") then
		if(arg1=="Derpy") then
			CombatTextSetActiveUnit("player") -- For RepTrack to work
			
			if(AutoPurgeItems == nil) then -- Initialize the autopurge item lists
				AutoPurgeItems = {}
			end
			if(GlobalAutoPurgeItems == nil) then
				GlobalAutoPurgeItems = {}
			end
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
			if RepTrackState == nil then
				RepTrackState = "ON" -- Defaults to on, because it's useful
			end
			if RepAnnounceState == nil then
				RepAnnounceState = "ON" -- Defaults to on, because it's useful
			end
			if RepCalcState == nil then
				RepCalcState = "OFF" -- Defaults to off, because it's spammy
			end
			if AntiShitterState == nil then
				AntiShitterState = "ON" -- Defaults to on, because it's useful
			end
			if SetRescueState == nil then
				SetRescueState = "ON" -- Defaults to on, because it's useful
			end
			if iLvLUpdateState == nil then
				iLvLUpdateState = "OFF" -- Defaults to off, because it can be spammy
			end
			if InnervateState == nil then
				InnervateState = "ON" -- Defaults to on, because it's useful
			end
			if SpiderBurritoState == nil then
				SpiderBurritoState = "ON" -- Defaults to on, because it's useful
			end
			if AutoPurgeState == nil then
				AutoPurgeState = "OFF" -- Defaults to off, because it's dangerous
			end
			if AutoPurgeVerbose == nil then
				AutoPurgeVerbose = "OFF" -- Defaults to off, because it's annoying
			end
		end
		
	elseif(event=="PLAYER_ENTERING_WORLD") then -- All data should be loaded, update last seen average itemlevel
		lastAvgItemLevel = math.floor(select(2, GetAverageItemLevel()))
		
	elseif(event=="PARTY_MEMBERS_CHANGED" or event=="RAID_ROSTER_UPDATE") then -- AntiShitter
		if(AntiShitterState~="OFF") then
			if(difftime(time(), antiShitterLastTimestamp) > 29) then -- Avoids notifying more often than every 30 seconds
				-- Build refreshed table of ignored players
				local ignoredPlayers = {} 
				local numIgnored = GetNumIgnores() 
				for i = 1, numIgnored, 1 do 
					table.insert(ignoredPlayers, GetIgnoreName(i))
				end
			
				if(GetNumRaidMembers() > 0) then
					local raidMembers = GetNumRaidMembers()
					
					for i = 1, raidMembers, 1 do
						if(has_value(ignoredPlayers, UnitName("raid"..i))) then
							-- freak out
							DerpyPrint("Ignored player "..highlight(UnitName("raid"..i)).." detected in your raid group!")
							antiShitterLastTimestamp = time() -- Record timestamp of last notification
						end
					end
				elseif(GetNumPartyMembers() > 0) then
					local partyMembers = GetNumPartyMembers()
					
					for i = 1, partyMembers, 1 do
						if(has_value(ignoredPlayers, UnitName("party"..i))) then
							-- freak out
							DerpyPrint("Ignored player "..highlight(UnitName("party"..i)).." detected in your party!")
							antiShitterLastTimestamp = time() -- Record timestamp of last notification
						end
					end
				end
			end
		end
	elseif(event=="PLAYER_EQUIPMENT_CHANGED") then -- iLvLUpdate
		if(iLvLUpdateState~="OFF") then
			local newItemLevel = math.floor(select(2, GetAverageItemLevel()))
			if(lastAvgItemLevel ~= newItemLevel) then
				if(lastAvgItemLevel ~= 0) then
					local ilvlString = ""
				
					if(newItemLevel > lastAvgItemLevel) then
						ilvlString = "|cFFFF0000"..lastAvgItemLevel.."|r -> |cFF00FF00"..newItemLevel.."|r"
					else
						ilvlString = "|cFF00FF00"..lastAvgItemLevel.."|r -> |cFFFF0000"..newItemLevel.."|r"
					end
					
					DerpyPrint(highlight("iLvLUpdate: ").."Avg. equipped ilvl has changed: "..ilvlString)
				end
				lastAvgItemLevel = newItemLevel
			end
		end
		
	elseif(event=="MERCHANT_UPDATE") then -- SetRescue
		if(SetRescueState~="OFF") then
			local eqSetCount = GetNumEquipmentSets()
				
			for i = 1, eqSetCount, 1 do 
				local eqSetName = GetEquipmentSetInfo(i)
				local eqSetItems = GetEquipmentSetItemIDs(eqSetName)
				for j = 1, 19 do
					if eqSetItems[j] then
						local eqSetItemName = (GetItemInfo(eqSetItems[j]))
						if(eqSetItemName ~= nil) then
							for k = 1, GetNumBuybackItems() do
								local link = GetBuybackItemLink(k)

								if link then
									local buyBackItemName = (GetItemInfo(link:match("item:(%d+):")))
									
									if buyBackItemName == eqSetItemName then
										BuybackItem(k)
										DerpyPrint(highlight("SetRescue Warning: ")..link.." is a part of the equipment set \""..eqSetName.."\", and has been automatically bought back from the vendor.")
										return -- we no likey recursion
									end
								end
							end
						end
					end
				end
			end
		end
		
	elseif(event=="BAG_UPDATE") then -- AutoPurge
		if(AutoPurgeState~="OFF") then
			if(InCombatLockdown()==nil) then -- Do nothing in combat to avoid fuckery
				DoAutoPurge()
			end
		end
		
	elseif(event=="UNIT_AURA") then
		receivingUnit = arg1
		
		-- Innervate notifier
		if(InnervateState~="OFF") then
			_, _, _, _, _, _, _, unitCaster = UnitAura(receivingUnit, "Innervate")
			if(unitCaster ~= nil and receivingUnit ~= nil and unitCaster == "player" and receivingUnit ~= unitCaster and UnitName(unitCaster) ~= UnitName(receivingUnit)) then
				if(lastInnervateMessageTime == nil or time() - lastInnervateMessageTime > 10) then
					lastInnervateMessageTime = time()
					SendChatMessage("\124cff71d5ff\124Hspell:29166\124h[Innervate]\124h\124r on you!", "WHISPER", nil, GetUnitName(receivingUnit))
				end
			end
		end
		
		-- Spider burrito notifier
		if(SpiderBurritoState~="OFF") then
			local name = UnitDebuff(receivingUnit, "Web Wrap") 
			if(name ~= nil and receivingUnit == "player") then
				if(lastWebWrapMessageTime == nil or time() - lastWebWrapMessageTime > 10) then
					lastWebWrapMessageTime = time()
					SendChatMessage("I am a spider burrito! Help me!", "SAY")
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
	
	elseif(event=="CHAT_MSG_SYSTEM") then -- RepAnnounce
		if(RepAnnounceState~="OFF") then
			currentChatMessage = arg1
			
			if(starts_with(currentChatMessage, "You are now ")) then
				newLevel, factionName = strmatch(currentChatMessage, "You are now (%a+) with (.*)\.")
				if(newLevel ~= nil and factionName ~= nil) then
					DerpyRepFrame.text:SetText("You are now |cFF"..factionStandingColors[newLevel]..newLevel.."|r with\n|cFFFFF569"..factionName.."|r!")
					UIFrameFadeIn(DerpyRepFrame, 1, 0, 1)
					PlaySoundFile("Sound\\Spells\\DivineStormDamage1.wav", "master")
					
					local t = 5
					DerpyRepFrame:SetScript("OnUpdate", function(self, elapsed)
						 t = t - elapsed
						 if t <= 0 then
							DerpyRepFrame:SetScript("OnUpdate", nil)
							UIFrameFadeOut(DerpyRepFrame, 1, 1, 0)
						 end
					end)
				end
			end
		end
		
	elseif(event=="COMBAT_TEXT_UPDATE") then -- RepTrack and RepCalc
		if(arg1=="FACTION") then
			local currGainedFaction = arg2
			local repGain = arg3
			if(repGain > 0) then -- Ignore negative reputation					
				if(RepTrackState~="OFF") then -- RepTrack - Automatically change watched faction when you gain rep
					if(difftime(time(), repTrackLastTimestamp) > 1) then -- Avoids changing watched faction rapidly on multiple gains within a couple of seconds
						local numFactions = GetNumFactions()
						for factionCounter = 0, numFactions, 1
						do
							local factionName = GetFactionInfo(factionCounter)
							if(factionName == currGainedFaction) then
								if(factionName ~= "Guild") then
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
					
				if(RepCalcState~="OFF") then -- RepCalc - Show progress to next reputation standing level whenever you gain rep
					local numFactions = GetNumFactions()
					for factionCounter = 0, numFactions, 1
					do
						local factionName, _, standingId, bottomValue, topValue, earnedValue = GetFactionInfo(factionCounter)
						if(factionName == currGainedFaction) then
							if(factionName ~= "Guild") then
								local currentRep = earnedValue - bottomValue
								local currentCeiling = topValue - bottomValue
								local missingRepForNextLevel = currentCeiling - currentRep
								local additionalGains = math.ceil(missingRepForNextLevel / repGain)
								
								if(standingId < 8 and standingId > 0) then -- Ignore Exalted and Unknown levels
									local nextRepLevel = getglobal("FACTION_STANDING_LABEL"..standingId+1)
									DerpyPrint(highlight("RepCalc: ")..additionalGains.." |4more gain:more gains; like that until you hit |cFF"..factionStandingColors[nextRepLevel]..nextRepLevel.."|r with |cFFFFF569"..factionName.."|r!")
								end
								
								break
							end
						end
					end
				end
			end
		end
	end
end

function PonyTime(msg)
	name, _, _, _, _, _, _, unitCaster = UnitBuff("player", "Crusader Aura")
	if(name~=nil and unitCaster~=nil) then
		if(msg == "pony") then
			DerpyPrint(UnitName(unitCaster) .. " has Crusader Aura on!")
		elseif(msg == "pony raid") then
			if(GetNumRaidMembers() > 0) then
				SendChatMessage("[ "..UnitName(unitCaster) .. " has Crusader Aura on! ]", "RAID")
			else
				DerpyPrint("You must be in a raid group to use Pony Raid.")
			end
		elseif(msg == "pony party") then
			if(GetNumPartyMembers() > 0) then
				SendChatMessage("[ "..UnitName(unitCaster) .. " has Crusader Aura on! ]", "PARTY")
			else
				DerpyPrint("You must be in a party to use Pony Party.")
			end
		else
			DerpyPrint("Valid options for Pony are \"pony\", \"pony raid\", or \"pony party\"")
		end
	else
		DerpyPrint("Couldn't find any Crusader Aura.")
	end
end

function AutoPurgeHandler(message)
	local inputString = message
	
	if(starts_with(inputString, "autopurge list")) then
		local itemNo = 0
		local totalItems = table.getn(AutoPurgeItems)
		if totalItems > 0 then
			DerpyPrint("Items currently in the autopurge list for "..UnitName("player")..":")
			for itemNo=0,totalItems
			do
				local currentItem = AutoPurgeItems[itemNo]
				if(currentItem~=nil) then
					DerpyPrint(itemNo..": "..currentItem)
				end
			end
		else
			DerpyPrint("There are currently no items in the autopurge list for "..UnitName("player").."!")
		end		
	elseif(starts_with(inputString, "autopurge glist")) then
		local itemNo = 0
		local totalItems = table.getn(GlobalAutoPurgeItems)
		if totalItems > 0 then
			DerpyPrint("Items currently in the global autopurge list:")
			for itemNo=0,totalItems
			do
				local currentItem = GlobalAutoPurgeItems[itemNo]
				if(currentItem~=nil) then
					DerpyPrint(itemNo..": "..currentItem)
				end
			end
		else
			DerpyPrint("There are currently no items in the global autopurge list!")
		end	
	elseif(starts_with(inputString, "autopurge add")) then
		local item = trim(string.sub(inputString, 14))
		
		if(item == nil or item == "") then
			DerpyPrint("Please specify a valid item name or item link")
			DerpyPrint("For example: "..highlight("/derp autopurge add stormwind brie"))
		elseif(starts_with(item, "|c")) then
			itemName = GetItemInfo(item)
			itemName = strlower(itemName)
			
			if(has_value(AutoPurgeItems, itemName)) then
				DerpyPrint("\""..itemName.."\" is already in the autopurge list!")
			else
				table.insert(AutoPurgeItems, itemName)
				DerpyPrint("Added \""..itemName.."\" to the autopurge list!")
			end
		else
			if(has_value(AutoPurgeItems, item)) then
				DerpyPrint("\""..item.."\" is already in the autopurge list!")
			else
				table.insert(AutoPurgeItems, item)
				DerpyPrint("Added \""..item.."\" to the autopurge list!")
			end
		end
	elseif(starts_with(inputString, "autopurge gadd")) then
		local item = trim(string.sub(inputString, 15))
		
		if(item == nil or item == "") then
			DerpyPrint("Please specify a valid item name.")
			DerpyPrint("For example: "..highlight("/derp autopurge gadd stormwind brie"))
		elseif(starts_with(item, "|c")) then
			itemName = GetItemInfo(item)
			itemName = strlower(itemName)
			
			if(has_value(GlobalAutoPurgeItems, itemName)) then
				DerpyPrint("\""..itemName.."\" is already in the autopurge list!")
			else
				table.insert(GlobalAutoPurgeItems, itemName)
				DerpyPrint("Added \""..itemName.."\" to the autopurge list!")
			end
		else
			if(has_value(GlobalAutoPurgeItems, item)) then
				DerpyPrint("\""..item.."\" is already in the global autopurge list!")
			else
				table.insert(GlobalAutoPurgeItems, item)
				DerpyPrint("Added \""..item.."\" to the global autopurge list!")
			end
		end
	elseif(starts_with(inputString, "autopurge remove")) then
		local item = trim(string.sub(inputString, 17))
		
		if(item == nil or item == "") then
			DerpyPrint("Please specify a valid item name.")
			DerpyPrint("For example: "..highlight("/derp autopurge remove sweet nectar"))
		elseif(starts_with(item, "|c")) then
			itemName = GetItemInfo(item)
			itemName = strlower(itemName)
			
			if(has_value(AutoPurgeItems, itemName)) then
				local itemIndex = table_index(AutoPurgeItems, itemName)
				table.remove(AutoPurgeItems, itemIndex)
				DerpyPrint("Removed \""..itemName.."\" from the autopurge list!")
			else
				DerpyPrint("\""..itemName.."\" was not found in the autopurge list!")
			end
		else
			if(has_value(AutoPurgeItems, item)) then
				local itemIndex = table_index(AutoPurgeItems, item)
				table.remove(AutoPurgeItems, itemIndex)
				DerpyPrint("Removed \""..item.."\" from the autopurge list!")
			else
				DerpyPrint("\""..item.."\" was not found in the autopurge list!")
			end
		end
	elseif(starts_with(inputString, "autopurge gremove")) then
		local item = trim(string.sub(inputString, 18))
		
		if(item == nil or item == "") then
			DerpyPrint("Please specify a valid item name.")
			DerpyPrint("For example: "..highlight("/derp autopurge gremove sweet nectar"))
		elseif(starts_with(item, "|c")) then
			itemName = GetItemInfo(item)
			itemName = strlower(itemName)
			
			if(has_value(GlobalAutoPurgeItems, itemName)) then
				local itemIndex = table_index(GlobalAutoPurgeItems, itemName)
				table.remove(GlobalAutoPurgeItems, itemIndex)
				DerpyPrint("Removed \""..itemName.."\" from the autopurge list!")
			else
				DerpyPrint("\""..itemName.."\" was not found in the autopurge list!")
			end
		else
			if(has_value(GlobalAutoPurgeItems, item)) then
				local itemIndex = table_index(GlobalAutoPurgeItems, item)
				table.remove(GlobalAutoPurgeItems, itemIndex)
				DerpyPrint("Removed \""..item.."\" from the global autopurge list!")
			else
				DerpyPrint("\""..item.."\" was not found in the global autopurge list!")
			end
		end
	elseif(starts_with(inputString, "autopurge clear")) then
		AutoPurgeItems = {}
		DerpyPrint("AutoPurge list for "..UnitName("player").." cleared.")
	elseif(starts_with(inputString, "autopurge gclear")) then
		GlobalAutoPurgeItems = {}
		DerpyPrint("Global AutoPurge list cleared.")
	elseif(starts_with(inputString, "autopurge verbose")) then
		togglePassive("AutoPurgeVerbose", 1)
	elseif(starts_with(inputString, "autopurge toggle")) then
		togglePassive("AutoPurge", 1)
	elseif(starts_with(inputString, "autopurge guide")) then
		DerpyPrint("IMPORTANT NOTES FOR AUTOPURGE:")
		DerpyPrint(highlight("*").." It is |cFFFF0000IMPOSSIBLE TO UNDELETE ITEMS|r purged this way! You have been warned!")
		DerpyPrint(highlight("*").." AutoPurge's on/off state and the regular autopurge item list are saved on a per-character basis.")
		DerpyPrint(highlight("*").." The global autopurge list applies to all characters on your account.")
		DerpyPrint(highlight("*").." Items are added by name or by item link.")
		DerpyPrint(highlight("*").." The character case of the item name to be added or removed doesn't matter.")
		DerpyPrint(highlight("*").." Autopurging will not happen while you are in combat.")
		DerpyPrint(highlight("*").." If you loot autopurged items in combat, they will be purged the next time your bags are updated.")
		DerpyPrint("Examples:")
		DerpyPrint(highlight("/dr autopurge add goldenbark apple").." -- Adds Goldenbark Apple to the autopurge list")
		DerpyPrint(highlight("/dr autopurge gremove tel'abim banana").." -- Removes Tel'Abim Banana from the global autopurge list")
	else
		DerpyPrint("|cFFFF0000Autopurged items are not recoverable!|r")
		DerpyPrint("Usage: "..color.."/derp autopurge "..highlight("<command>"))
		DerpyPrint("(/derp can be substituted for /dr or /derpy)")
		DerpyPrint("Available commands:")
		DerpyPrint(highlight("guide").." -- Read this! Show IMPORTANT notes and help for AutoPurge")
		DerpyPrint(highlight("toggle").." -- Turn AutoPurge on/off (Currently "..highlight(AutoPurgeState)..")")
		DerpyPrint(highlight("verbose").." -- Toggle verbose mode (Currently "..highlight(AutoPurgeVerbose)..")")
		DerpyPrint(highlight("list").." -- List items currently being autopurged")
		DerpyPrint(highlight("add item name").." -- Add the specified item to the autopurge list")
		DerpyPrint(highlight("remove item name").." -- Remove the specified item from the autopurge list")
		DerpyPrint(highlight("clear").." -- Remove ALL items from the autopurge list")
		DerpyPrint(highlight("glist").." -- List items currently being globally autopurged")
		DerpyPrint(highlight("gadd item name").." -- Add the specified item to the global autopurge list")
		DerpyPrint(highlight("gremove item name").." -- Remove the specified item from the global autopurge list")
		DerpyPrint(highlight("gclear").." -- Remove ALL items from the global autopurge list")
		
	end
end

function DoAutoPurge()
	for bag=0,4 -- Searching all bags instead of only the updated one, in order to catch items collected in combat
	do
		for slot = 1,GetContainerNumSlots(bag) 
		do 
			local link = GetContainerItemLink(bag, slot)
			
			if link then
				local itemName = GetItemInfo(link)
				
				if itemName ~= nil then
					itemName = strlower(itemName)
					
					if(has_value(GlobalAutoPurgeItems, itemName)) then -- It's in the global autopurge list
						PickupContainerItem(bag, slot)
						DeleteCursorItem()
						if(AutoPurgeVerbose=="ON") then
							DerpyPrint("Global AutoPurge: "..itemName)
						end
					elseif(has_value(AutoPurgeItems, itemName)) then -- It's in the character specific autopurge list
						PickupContainerItem(bag, slot)
						DeleteCursorItem()
						if(AutoPurgeVerbose=="ON") then
							DerpyPrint("AutoPurge: "..itemName)
						end
					end
				end
			end 
		end
	end
end

function PurgeLowestValueGray()
	grayCount = 0
	lowValGold = 99999999
	lowValBag = nil
	lowValSlot = nil
	lowValCount = nil
	
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
					grayCount = grayCount + 1
					if itemSellPrice * itemCount < lowValGold then
						lowValGold = itemSellPrice * itemCount
						lowValBag = bag
						lowValSlot = slot
						lowValCount = itemCount
					end
				end
			end 
		end 
	end
	
	if grayCount > 0 then
		purgeLink = GetContainerItemLink(lowValBag, lowValSlot)
		DerpyPrint("Purged lowest value gray item slot in your bag:")
		DerpyPrint(purgeLink.." x"..lowValCount.." - Total value "..GetCoinTextureString(lowValGold))
		PickupContainerItem(lowValBag, lowValSlot) 
		DeleteCursorItem() 
	else
		DerpyPrint("There are no gray items in your bags.")
	end 
end

function PurgeGrayItems(dryRun) -- Delete all gray items from bags
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
					if(dryRun == false) then
						PickupContainerItem(bag, slot) 
						DeleteCursorItem() 
					end
					
					purgeCount = purgeCount + itemCount
					slotCount = slotCount + 1
					wastedGoldCount = wastedGoldCount + (itemSellPrice * itemCount)
				end
			end 
		end 
	end
	
	if(purgeCount > 0) then
		if(dryRun == true) then
			StaticPopupDialogs["ConfirmDeleteAllGrayItems"] = {
				text = "Are you sure you want to purge the "..purgeCount.." |4gray item:gray items; in your bags? This action cannot be undone.\n\nTotal vendor worth:\n"..GetCoinTextureString(wastedGoldCount),
				button1 = "Yes",
				button2 = "No",
				OnAccept = function()
				  PurgeGrayItems(false)
				end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3
			}
			
			StaticPopup_Show("ConfirmDeleteAllGrayItems")
		else
			DerpyPrint("Purged "..purgeCount.." |4gray item from your bags. If you had sold this item:gray items (taking up "..slotCount.." slots) from your bags. If you had sold these items; to a vendor instead, you would have made "..GetCoinTextureString(wastedGoldCount)..".")
		end
	else
		DerpyPrint("You have no gray items in your bags.")
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

-- Options window functions
function DerpyOptions_OnLoad()
	DerpyOptionsFrame:RegisterEvent("ADDON_LOADED")
end

function DerpyOptions_OnEvent(self, event, ...) -- Event handler
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...;
	if(event=="ADDON_LOADED") then
		if(arg1=="Derpy") then
			if PartyAchievementState == "ON" then
				DerpyCheckBoxPartyAchievement:SetChecked(true)
			end
			if MonsterEmoteState == "ON" then
				DerpyCheckBoxMonsterEmote:SetChecked(true)
			end
			if GuildDingState == "ON" then
				DerpyCheckBoxGuildDing:SetChecked(true)
			end
			if FullyRestedState == "ON" then
				DerpyCheckBoxRestedNotifier:SetChecked(true)
			end
			if RepTrackState == "ON" then
				DerpyCheckBoxRepTrack:SetChecked(true)
			end
			if RepAnnounceState == "ON" then
				DerpyCheckBoxRepAnnounce:SetChecked(true)
			end
			if RepCalcState == "ON" then
				DerpyCheckBoxRepCalc:SetChecked(true)
			end
			if AntiShitterState == "ON" then
				DerpyCheckBoxAntiShitter:SetChecked(true)
			end
			if SetRescueState == "ON" then
				DerpyCheckBoxSetRescue:SetChecked(true)
			end
			if iLvLUpdateState == "ON" then
				DerpyCheckBoxiLvLUpdate:SetChecked(true)
			end
			if InnervateState == "ON" then
				DerpyCheckBoxInnervateNotifier:SetChecked(true)
			end
			if SpiderBurritoState == "ON" then
				DerpyCheckBoxSpiderBurrito:SetChecked(true)
			end
			if AutoPurgeState == "ON" then
				DerpyCheckBoxAutoPurge:SetChecked(true)
			end
		end
	end
end

function DerpyOptionsFrameCloseButton_OnClick()
	PlaySound("GAMEDIALOGCLOSE","master")
	DerpyOptionsFrame:Hide()
end

function DerpyCheckBoxAntiShitter_OnClick()
	togglePassive("AntiShitter", 0)
end

function DerpyCheckBoxGuildDing_OnClick()
	togglePassive("GuildDing", 0)
end

function DerpyCheckBoxInnervateNotifier_OnClick()
	togglePassive("Innervate", 0)
end

function DerpyCheckBoxPartyAchievement_OnClick()
	togglePassive("PartyAchievement", 0)
end

function DerpyCheckBoxRepAnnounce_OnClick()
	togglePassive("RepAnnounce", 0)
end

function DerpyCheckBoxRestedNotifier_OnClick()
	togglePassive("FullyRested", 0)
end

function DerpyCheckBoxSetRescue_OnClick()
	togglePassive("SetRescue", 0)
end

function DerpyCheckBoxiLvLUpdate_OnClick()
	togglePassive("iLvLUpdate", 0)
end

function DerpyCheckBoxAutoPurge_OnClick()
	togglePassive("AutoPurge", 0)
end

function DerpyCheckBoxMonsterEmote_OnClick()
	togglePassive("MonsterEmote", 0)
end

function DerpyCheckBoxRepTrack_OnClick()
	togglePassive("RepTrack", 0)
end

function DerpyCheckBoxRepCalc_OnClick()
	togglePassive("RepCalc", 0)
end

function DerpyCheckBoxSpiderBurrito_OnClick()
	togglePassive("SpiderBurrito", 0)
end


function DerpyButtonAutoPurgeAddItem_OnClick()
	StaticPopupDialogs["DerpyAutoPurgeAddItem"] = {
		text = "Please enter the name of the item you would like to add to your AutoPurge list:",
		button1 = "Add item",
		button2 = "Cancel",
		hasEditBox = true,
		timeout = 0,
		enterClicksFirstButton = true,
		whileDead = true,
		hideOnEscape = true,
		OnAccept = function(self)
		  AutoPurgeHandler("autopurge add "..strlower(trim(self.editBox:GetText())))
		end
	}
	
	StaticPopup_Show("DerpyAutoPurgeAddItem")
end

function DerpyButtonAutoPurgeRemoveItem_OnClick()
	StaticPopupDialogs["DerpyAutoPurgeRemoveItem"] = {
		text = "Please enter the name of the item you would like to remove from your AutoPurge list:",
		button1 = "Remove item",
		button2 = "Cancel",
		hasEditBox = true,
		timeout = 0,
		enterClicksFirstButton = true,
		whileDead = true,
		hideOnEscape = true,
		OnAccept = function(self)
		  AutoPurgeHandler("autopurge remove "..strlower(trim(self.editBox:GetText())))
		end
	}
	
	StaticPopup_Show("DerpyAutoPurgeRemoveItem")
end

function DerpyButtonAutoPurgeListItems_OnClick()
	AutoPurgeHandler("autopurge list")
end

function DerpyButtonAutoPurgeClearItems_OnClick()
	StaticPopupDialogs["DerpyAutoPurgeClearItems"] = {
		text = "Are you sure you want to clear your character specific AutoPurge list? This action cannot be undone!",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
		  AutoPurgeHandler("autopurge clear")
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	
	StaticPopup_Show("DerpyAutoPurgeClearItems")
end

function DerpyButtonAutoPurgeGlobalAddItem_OnClick()
	StaticPopupDialogs["DerpyAutoPurgeGlobalAddItem"] = {
		text = "Please enter the name of the item you would like to add to the global AutoPurge list:",
		button1 = "Add item",
		button2 = "Cancel",
		hasEditBox = true,
		timeout = 0,
		enterClicksFirstButton = true,
		whileDead = true,
		hideOnEscape = true,
		OnAccept = function(self)
		  AutoPurgeHandler("autopurge gadd "..strlower(trim(self.editBox:GetText())))
		end
	}
	
	StaticPopup_Show("DerpyAutoPurgeGlobalAddItem")
end

function DerpyButtonAutoPurgeGlobalRemoveItem_OnClick()
	StaticPopupDialogs["DerpyAutoPurgeGlobalRemoveItem"] = {
		text = "Enter the name of the item you would like to remove from the global AutoPurge list:",
		button1 = "Remove item",
		button2 = "Cancel",
		hasEditBox = true,
		timeout = 0,
		enterClicksFirstButton = true,
		whileDead = true,
		hideOnEscape = true,
		OnAccept = function(self)
		  AutoPurgeHandler("autopurge gremove "..strlower(trim(self.editBox:GetText())))
		end
	}
	
	StaticPopup_Show("DerpyAutoPurgeGlobalRemoveItem")
end

function DerpyButtonAutoPurgeGlobalListItems_OnClick()
	AutoPurgeHandler("autopurge glist")
end

function DerpyButtonAutoPurgeGlobalClearItems_OnClick()
	StaticPopupDialogs["DerpyAutoPurgeGlobalClearItems"] = {
		text = "Are you sure you want to clear your global AutoPurge list? This action cannot be undone!",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
		  AutoPurgeHandler("autopurge gclear")
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	
	StaticPopup_Show("DerpyAutoPurgeGlobalClearItems")
end
