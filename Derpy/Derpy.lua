-- Derpy v2.4
-- By Moontits/Kugalskap of Dalaran-WoW
-- Also known as Cursetits/Poodle on Apollo 2
-- Formerly known as Derpderpderp and Noaide of Ragnaros EU

-- You are free to redistribute and modify this addon, as long 
-- as you give proper credit to me, the original author.

local color = "|cFF66EE66" -- We like green
local highlightColor = "|cFF9BFF00"
local original = "|r"
local CurrentLevelCap = 70 -- With lack of a function to retrieve this dynamically...
local repTrackLastTimestamp = time()
local antiShitterLastTimestamp = time()
local lastInnervateMessageTime = nil

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
	DerpyPrint("v2.4-TBC loaded (/derpy, /derp, /dr)")
	
	DerpyFrame:RegisterEvent("ADDON_LOADED") -- So we can detect user preferences
	DerpyFrame:RegisterEvent("PLAYER_LEVEL_UP") -- For Guild Ding function
	DerpyFrame:RegisterEvent("PLAYER_UPDATE_RESTING") -- For Rested function
	DerpyFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE") -- For Monster Emote function
	DerpyFrame:RegisterEvent("COMBAT_TEXT_UPDATE") -- For RepTrack and RepCalc functions
	DerpyFrame:RegisterEvent("CHAT_MSG_SYSTEM") -- For RepAnnounce function
	DerpyFrame:RegisterEvent("BAG_UPDATE") -- For AutoPurge
	DerpyFrame:RegisterEvent("PARTY_MEMBERS_CHANGED") -- For AntiShitter
	DerpyFrame:RegisterEvent("RAID_ROSTER_UPDATE") -- For AntiShitter
	
	DerpyFrame:SetScript("OnEvent", Derpy_OnEvent)
	
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
	elseif(message == "tf") then
		DerpyPrint("\124cffff8000\124Hitem:19019:0:0:0:0:0:0:0:0\124h[Thunderfury, Blessed Blade of the Windseeker]\124h\124r")
	elseif(message == "bagworth") then
		BagWorth()
	elseif(message == "lowgray" or message == "lowgrey") then
		PurgeLowestValueGray()
	elseif(message == "gray" or message == "grey") then
		PurgeGrayItems(true)
    elseif(message == "shitstorm") then
		DerpyPrint("\124cffa335ee\124Hitem:23555:0:0:0:0:0:0:0:0\124h[Dirge]\124h\124r")
	elseif(message == "rested") then
		togglePassive("FullyRested", 1)
	elseif(message == "monster") then
		togglePassive("MonsterEmote", 1)
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
    elseif(message == "antishitter") then
		togglePassive("AntiShitter", 1)
    elseif(message == "passive") then
		ShowPassiveMenu();
	    elseif(message == "skin") then
		local highestLevelMob = 0

		for i = 1, GetNumSkillLines(), 1
		do 
			local name, _, _, level = GetSkillLineInfo(i)
			if(name == "Skinning")then
				if(level < 100) then
					highestLevelMob = math.floor(((level) / 10) + 10)
				else
					highestLevelMob = math.floor(level/5)
				end

				DerpyPrint("With a \124cff71d5ff\124Hspell:8613\124h[Skinning]\124h\124r skill of " .. level .. ", the highest level mob you can skin is " .. highestLevelMob .. ".") 
				break
			end
		end

		if(highestLevelMob == 0) then
			DerpyPrint("You need to have the \124cff71d5ff\124Hspell:8613\124h[Skinning]\124h\124r skill in order to use this function.")
		end
    elseif(message == "dr" or message == "disband") then
		DisbandRaid()
    elseif(message == "about") then
        DerpyPrint("was made by Noaide of Atlantiss-Karazhan, formerly Derpderpderp/Noaide of Ragnaros EU. The author is the same person, but I now play on private servers.")
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
	DEFAULT_CHAT_FRAME:AddMessage(color.."[Derpy]"..original.." "..msg)
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
	DerpyPrint(highlight("skin").." -- Outputs highest level monster you can skin (Requires \124cff71d5ff\124Hspell:8613\124h[Skinning]\124h\124r)")
	DerpyPrint(highlight("shitstorm").." -- Initiate a chat shitstorm, TBC-style")
	DerpyPrint(highlight("dr/disband").." -- Disband a raid group you are the leader of")
	DerpyPrint(highlight("about").." -- Show information on who made this addon")
end

function ShowPassiveMenu() -- List states and descriptions of passive functions
	DerpyPrint("Usage: "..color.."/derp "..highlight("<command>"))
	DerpyPrint("(/derp can be substituted for /dr or /derpy)")
	DerpyPrint("Toggle passive features:"..original)
	DerpyPrint(highlight("autopurge").." -- (Submenu) Automatically purge specified items (Currently "..highlight(AutoPurgeState)..")")
	DerpyPrint(highlight("gding").." -- Toggle Guild Ding notifications (Currently "..highlight(GuildDingState)..")")
	DerpyPrint(highlight("rested").." -- Toggle resting notifications (Currently "..highlight(FullyRestedState)..")")
	DerpyPrint(highlight("monster").." -- Toggle emphasis of monster emotes in error frame (Currently "..highlight(MonsterEmoteState)..")")
	DerpyPrint(highlight("rep").." -- Toggle auto-changing watched faction when you gain rep (Currently "..highlight(RepTrackState)..")")
	DerpyPrint(highlight("repa").." -- Toggle announce window when your faction standing changes (Currently "..highlight(RepAnnounceState)..")")
	DerpyPrint(highlight("repc").." -- Toggle showing you progress to the next reputation level whenever you gain rep (Currently "..highlight(RepCalcState)..")")
	DerpyPrint(highlight("antishitter").." -- Toggle notification when you join a party/raid with an ignored player (Currently "..highlight(AntiShitterState)..")")
	DerpyPrint(highlight("innervate/ivt").." -- Toggle sending a whisper to the person you cast \124cff71d5ff\124Hspell:29166\124h[Innervate]\124h\124r on (Currently "..highlight(InnervateState)..")")
end

function togglePassive(which, verbose) -- Toggle passive functions on/off
	if(which=="RepTrack") then
		if(RepTrackState == "ON") then
			RepTrackState = "OFF"
		else
			RepTrackState = "ON"
		end
		if(verbose==1) then
			DerpyPrint(highlight("RepTrack").." is now "..RepTrackState..".") 
		end
	elseif(which=="RepAnnounce") then
		if(RepAnnounceState == "ON") then
			RepAnnounceState = "OFF"
		else
			RepAnnounceState = "ON"
		end
		if(verbose==1) then
			DerpyPrint(highlight("RepAnnounce").." is now "..RepAnnounceState..".")
		end
	elseif(which=="RepCalc") then
		if(RepCalcState == "ON") then
			RepCalcState = "OFF"
		else
			RepCalcState = "ON"
		end
		if(verbose==1) then
			DerpyPrint(highlight("RepCalc").." is now "..RepCalcState..".")
		end
	elseif(which=="AutoPurge") then
		if(AutoPurgeState == "ON") then
			AutoPurgeState = "OFF"
		else
			AutoPurgeState = "ON"
		end
		if(verbose==1) then
			DerpyPrint(highlight("AutoPurge").." is now "..AutoPurgeState..".")
		end
	elseif(which=="AutoPurgeGray") then
		if(AutoPurgeGrayState == "ON") then
			AutoPurgeGrayState = "OFF"
			if(verbose==1) then
				DerpyPrint(highlight("AutoPurge_Gray").." is now "..AutoPurgeGrayState..".")
			end
		else
			AutoPurgeGrayState = "ON"
			if(verbose==1) then
				DerpyPrint(highlight("AutoPurge_Gray").." is now "..AutoPurgeGrayState..". Items worth less than "..GetCoinString(AutoPurgeGrayValue).." will be autopurged. You can change this value using "..highlight("/dr autopurge gray XX")..", where "..highlight("XX").." is replaced with the value treshold expressed in copper (for example, '10000' is "..GetCoinString(10000).." and '5000' is "..GetCoinString(5000)..").")
			end
		end
	elseif(which=="AutoPurgeVerbose") then
		if(AutoPurgeVerbose == "ON") then
			AutoPurgeVerbose = "OFF"
		else
			AutoPurgeVerbose = "ON"
		end
		if(verbose==1) then
			DerpyPrint(highlight("AutoPurge verbose mode").." is now "..AutoPurgeVerbose..".")
		end
	elseif(which=="Innervate") then
		if(InnervateState == "ON") then
			InnervateState = "OFF"
		else
			InnervateState = "ON"
		end
		if(verbose==1) then
			DerpyPrint(highlight("Innervate whispers").." are now "..InnervateState..".")
		end
	elseif(which=="AntiShitter") then
		if(AntiShitterState == "ON") then
			AntiShitterState = "OFF"
		else
			AntiShitterState = "ON"
		end
		if(verbose==1) then
			DerpyPrint(highlight("AntiShitter").." is now "..AntiShitterState..".")
		end
	elseif(which=="GuildDing") then
		if(GuildDingState == "ON") then
			GuildDingState = "OFF"
		else
			GuildDingState = "ON"
		end
		if(verbose==1) then
			DerpyPrint(highlight("Guild Ding").." is now "..GuildDingState..".")
		end
	elseif(which=="FullyRested") then
		if(FullyRestedState == "ON") then
			FullyRestedState = "OFF"
		else
			FullyRestedState = "ON"
		end
		if(verbose==1) then
			DerpyPrint(highlight("Rested").." is now "..FullyRestedState..".")
		end
	elseif(which=="MonsterEmote") then
		if(MonsterEmoteState == "ON") then
			MonsterEmoteState = "OFF"
		else
			MonsterEmoteState = "ON"
		end
		if(verbose==1) then
			DerpyPrint(highlight("Monster Emote").." is now "..MonsterEmoteState..".")
		end
	end
end

function Derpy_OnEvent(self, event, ...) -- Event handler
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...;
	if(event=="ADDON_LOADED") then
		if(arg1=="Derpy") then
			if(AutoPurgeItems == nil) then -- Initialize the autopurge item lists
				AutoPurgeItems = {}
			end
			if(GlobalAutoPurgeItems == nil) then
				GlobalAutoPurgeItems = {}
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
			if InnervateState == nil then
				InnervateState = "ON" -- Defaults to on, because it's useful
			end
			if AutoPurgeState == nil then
				AutoPurgeState = "OFF" -- Defaults to off, because it's dangerous
			end
			if AutoPurgeGrayState == nil then
				AutoPurgeGrayState = "OFF" -- Defaults to off, because it's dangerous
			end
			if AutoPurgeGrayValue == nil then
				AutoPurgeGrayValue = 1 -- Defaults to 1 copper
			end
			if AutoPurgeVerbose == nil then
				AutoPurgeVerbose = "OFF" -- Defaults to off, because it's annoying
			end
		end
		
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
							DerpyPrint(highlight("AntiShitter: ").."Ignored player "..highlight(UnitName("raid"..i)).." detected in your raid group!")
							antiShitterLastTimestamp = time() -- Record timestamp of last notification
						end
					end
				elseif(GetNumPartyMembers() > 0) then
					local partyMembers = GetNumPartyMembers()
					
					for i = 1, partyMembers, 1 do
						if(has_value(ignoredPlayers, UnitName("party"..i))) then
							-- freak out
							DerpyPrint(highlight("AntiShitter: ").."Ignored player "..highlight(UnitName("party"..i)).." detected in your party!")
							antiShitterLastTimestamp = time() -- Record timestamp of last notification
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
		
	elseif(event=="CHAT_MSG_MONSTER_EMOTE") then -- Monster Emote function
		if(MonsterEmoteState~="OFF") then
			UIErrorsFrame:Clear()
			UIErrorsFrame:AddMessage(string.gsub(arg1, "%%s", arg2), 1.0, 0.5, 0.25, GetChatTypeIndex("MONSTER_EMOTE"), 5)
		end
		
	elseif(event=="PLAYER_UPDATE_RESTING") then -- Rested function
		if(FullyRestedState~="OFF") then
			if(IsResting()==1) then
				DerpyPrint(highlight("Rested: ").."You are now resting.")
			elseif(IsResting()==nil) then
				restedXP = GetXPExhaustion()
				
				if restedXP == nil then restedXP = 0 end
				if(UnitLevel("player") < CurrentLevelCap) then
					DerpyPrint(highlight("Rested: ").."You are no longer resting ("..restedXP.." rested XP).")
				else
					DerpyPrint(highlight("Rested: ").."You are no longer resting.")
				end
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
					PlaySoundFile("Sound\\Spells\\AntiHoly.wav", "master")
					
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
										DerpyPrint(highlight("RepTrack: ").."Changed watched faction to "..factionName.."!")
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

function AutoPurgeHandler(message)
	local inputString = message
	
	if(starts_with(inputString, "autopurge list")) then
		local itemNo = 0
		local totalItems = table.getn(AutoPurgeItems)
		if totalItems > 0 then
			DerpyPrint(highlight("AutoPurge: ").."Items currently in the autopurge list for "..UnitName("player")..":")
			for itemNo=0,totalItems
			do
				local currentItem = AutoPurgeItems[itemNo]
				if(currentItem~=nil) then
					DerpyPrint(itemNo..": "..currentItem)
				end
			end
		else
			DerpyPrint(highlight("AutoPurge: ").."There are currently no items in the autopurge list for "..UnitName("player").."!")
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
			DerpyPrint(highlight("AutoPurge: ").."There are currently no items in the global autopurge list!")
		end	
	elseif(starts_with(inputString, "autopurge add")) then
		local item = trim(string.sub(inputString, 14))
		
		if(item == nil or item == "") then
			DerpyPrint(highlight("AutoPurge: ").."Please specify a valid item name or item link")
			DerpyPrint("For example: "..highlight("/derp autopurge add stormwind brie"))
		elseif(starts_with(item, "|c")) then
			itemName = GetItemInfo(item)
			itemName = strlower(itemName)
			
			if(has_value(AutoPurgeItems, itemName)) then
				DerpyPrint(highlight("AutoPurge: ").."\""..itemName.."\" is already in the autopurge list!")
			else
				table.insert(AutoPurgeItems, itemName)
				DerpyPrint(highlight("AutoPurge: ").."Added \""..itemName.."\" to the autopurge list!")
			end
		else
			if(has_value(AutoPurgeItems, item)) then
				DerpyPrint(highlight("AutoPurge: ").."\""..item.."\" is already in the autopurge list!")
			else
				table.insert(AutoPurgeItems, item)
				DerpyPrint(highlight("AutoPurge: ").."Added \""..item.."\" to the autopurge list!")
			end
		end
	elseif(starts_with(inputString, "autopurge gadd")) then
		local item = trim(string.sub(inputString, 15))
		
		if(item == nil or item == "") then
			DerpyPrint(highlight("AutoPurge: ").."Please specify a valid item name.")
			DerpyPrint("For example: "..highlight("/derp autopurge gadd stormwind brie"))
		elseif(starts_with(item, "|c")) then
			itemName = GetItemInfo(item)
			itemName = strlower(itemName)
			
			if(has_value(GlobalAutoPurgeItems, itemName)) then
				DerpyPrint(highlight("AutoPurge: ").."\""..itemName.."\" is already in the global autopurge list!")
			else
				table.insert(GlobalAutoPurgeItems, itemName)
				DerpyPrint(highlight("AutoPurge: ").."Added \""..itemName.."\" to the global autopurge list!")
			end
		else
			if(has_value(GlobalAutoPurgeItems, item)) then
				DerpyPrint(highlight("AutoPurge: ").."\""..item.."\" is already in the global autopurge list!")
			else
				table.insert(GlobalAutoPurgeItems, item)
				DerpyPrint(highlight("AutoPurge: ").."Added \""..item.."\" to the global autopurge list!")
			end
		end
	elseif(starts_with(inputString, "autopurge remove")) then
		local item = trim(string.sub(inputString, 17))
		
		if(item == nil or item == "") then
			DerpyPrint(highlight("AutoPurge: ").."Please specify a valid item name.")
			DerpyPrint("For example: "..highlight("/derp autopurge remove sweet nectar"))
		elseif(starts_with(item, "|c")) then
			itemName = GetItemInfo(item)
			itemName = strlower(itemName)
			
			if(has_value(AutoPurgeItems, itemName)) then
				local itemIndex = table_index(AutoPurgeItems, itemName)
				table.remove(AutoPurgeItems, itemIndex)
				DerpyPrint(highlight("AutoPurge: ").."Removed \""..itemName.."\" from the autopurge list!")
			else
				DerpyPrint(highlight("AutoPurge: ").."\""..itemName.."\" was not found in the autopurge list!")
			end
		else
			if(has_value(AutoPurgeItems, item)) then
				local itemIndex = table_index(AutoPurgeItems, item)
				table.remove(AutoPurgeItems, itemIndex)
				DerpyPrint(highlight("AutoPurge: ").."Removed \""..item.."\" from the autopurge list!")
			else
				DerpyPrint(highlight("AutoPurge: ").."\""..item.."\" was not found in the autopurge list!")
			end
		end
	elseif(starts_with(inputString, "autopurge gremove")) then
		local item = trim(string.sub(inputString, 18))
		
		if(item == nil or item == "") then
			DerpyPrint(highlight("AutoPurge: ").."Please specify a valid item name.")
			DerpyPrint("For example: "..highlight("/derp autopurge gremove sweet nectar"))
		elseif(starts_with(item, "|c")) then
			itemName = GetItemInfo(item)
			itemName = strlower(itemName)
			
			if(has_value(GlobalAutoPurgeItems, itemName)) then
				local itemIndex = table_index(GlobalAutoPurgeItems, itemName)
				table.remove(GlobalAutoPurgeItems, itemIndex)
				DerpyPrint(highlight("AutoPurge: ").."Removed \""..itemName.."\" from the autopurge list!")
			else
				DerpyPrint(highlight("AutoPurge: ").."\""..itemName.."\" was not found in the autopurge list!")
			end
		else
			if(has_value(GlobalAutoPurgeItems, item)) then
				local itemIndex = table_index(GlobalAutoPurgeItems, item)
				table.remove(GlobalAutoPurgeItems, itemIndex)
				DerpyPrint(highlight("AutoPurge: ").."Removed \""..item.."\" from the global autopurge list!")
			else
				DerpyPrint(highlight("AutoPurge: ").."\""..item.."\" was not found in the global autopurge list!")
			end
		end
	elseif(starts_with(inputString, "autopurge clear")) then
		AutoPurgeItems = {}
		DerpyPrint(highlight("AutoPurge: ").."AutoPurge list for "..UnitName("player").." cleared.")
	elseif(starts_with(inputString, "autopurge gclear")) then
		GlobalAutoPurgeItems = {}
		DerpyPrint(highlight("AutoPurge: ").."Global AutoPurge list cleared.")
	elseif(starts_with(inputString, "autopurge verbose")) then
		togglePassive("AutoPurgeVerbose", 1)
	elseif(starts_with(inputString, "autopurge toggle")) then
		togglePassive("AutoPurge", 1)
	elseif(starts_with(inputString, "autopurge gray")) then
		if(inputString == "autopurge gray") then
			togglePassive("AutoPurgeGray", 1)
		else
			local num = tonumber(strmatch(message, "gray (%d+)"))
			if(num ~= nil) then
				if(num < 1) then
					DerpyPrint(highlight("AutoPurge_Gray: ").."The minimum value for AutoPurge_Gray is 1 ("..GetCoinString("1")..").")
				elseif(num > 3750000) then
					DerpyPrint(highlight("AutoPurge_Gray: ").."The maximum value for AutoPurge_Gray is 3750000 ("..GetCoinString("3750000").."), as no gray items in the game are worth more.")
				else
					AutoPurgeGrayValue = num
					DerpyPrint(highlight("AutoPurge_Gray: ").."Items worth less than "..GetCoinString(num).." will now be autopurged.") 
				end
			else
				DerpyPrint(highlight("AutoPurge_Gray: ")..num.." is not a valid value. Use "..highlight("/dr autopurge gray XX")..", where "..highlight("XX").." is replaced with the value treshold expressed in copper (for example, '10000' is "..GetCoinString(10000).." and '5000' is "..GetCoinString(5000)..").")
			end
		end
	
	elseif(starts_with(inputString, "autopurge guide")) then
		DerpyPrint("IMPORTANT NOTES FOR AUTOPURGE:")
		DerpyPrint(highlight("*").." It is |cFFFF0000IMPOSSIBLE TO UNDELETE ITEMS|r purged this way! You have been warned!")
		DerpyPrint(highlight("*").." AutoPurge for TBC requires the Informant addon, which is a part of the Auctioneer suite of addons.")
		DerpyPrint(highlight("*").." AutoPurge's on/off state and the regular autopurge item list are saved on a per-character basis.")
		DerpyPrint(highlight("*").." The global autopurge list applies to all characters on your account.")
		DerpyPrint(highlight("*").." Items are added by name, or by item link.")
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
		DerpyPrint(highlight("gray").." -- Toggle purging gray quality items based on vendor value (Currently "..highlight(AutoPurgeGrayState)..")")
		DerpyPrint(highlight("gray XX").." -- Set minimum vendor value in copper for AutoPurge_Gray (Currently "..GetCoinString(AutoPurgeGrayValue)..")")
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
	if(IsAddOnLoaded("Informant") == 1) then
		for bag=0,4 -- Searching all bags instead of only the updated one, in order to catch items collected in combat
		do
			for slot = 1,GetContainerNumSlots(bag) 
			do 
				local link = GetContainerItemLink(bag, slot)
				
				if link then
					local itemName = GetItemInfo(link)
					
					if itemName ~= nil then
						local itemInfo = {GetItemInfo(link)}
						local itemName = strlower(select(1, unpack(itemInfo)))
						local rarity = select(3, unpack(itemInfo))
						local itemID = tonumber(link:match("item:(%d+):"))
						local itemSellPrice = Informant.GetItem(itemID).sell
						local done = false
						
						if(GlobalAutoPurgeItems ~= nil) then
							if(has_value(GlobalAutoPurgeItems, itemName)) then -- It's in the global autopurge list
								PickupContainerItem(bag, slot)
								DeleteCursorItem()
								done = true
								if(AutoPurgeVerbose=="ON") then
									DerpyPrint(highlight("AutoPurge: ").."Purging \""..itemName.."\" because it's in the global AutoPurge list")
								end
							end
						end
						
						if(done == false) then
							if(AutoPurgeItems ~= nil) then
								if(has_value(AutoPurgeItems, itemName)) then -- It's in the character specific autopurge list
									PickupContainerItem(bag, slot)
									DeleteCursorItem()
									done = true
									if(AutoPurgeVerbose=="ON") then
										DerpyPrint(highlight("AutoPurge: ").."Purging \""..itemName.."\" because it's in "..UnitName("player").."'s AutoPurge list")
									end
								end
							end
						end
						
						if(done == false) then
							if(AutoPurgeGrayState~="OFF") then -- AutoPurge_Gray is enabled
								if(rarity == 0) then -- It's a gray item
									if(itemSellPrice ~= nil and itemSellPrice ~= 0 and itemSellPrice < AutoPurgeGrayValue) then
										PickupContainerItem(bag, slot)
										DeleteCursorItem()
										
										if(AutoPurgeVerbose=="ON") then
											DerpyPrint(highlight("AutoPurge_Gray: ").."Purging \""..itemName.."\", because it is worth less than the current treshold ("..GetCoinString(itemSellPrice).." is less than "..GetCoinString(AutoPurgeGrayValue)..")")
										end
									end
								end
							end
						end
					end
				end 
			end
		end
	end
end

function PurgeLowestValueGray()
	if(IsAddOnLoaded("Informant") == 1) then
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
					itemID = tonumber(link:match("item:(%d+):"))
					itemSellPrice = Informant.GetItem(itemID).sell
				
					if(rarity == 0) then -- It's a gray item
						if(itemSellPrice ~= nil) then
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
		end
		
		if grayCount > 0 then
			purgeLink = GetContainerItemLink(lowValBag, lowValSlot)
			DerpyPrint(highlight("LowGray: ").."Purged lowest value gray item slot in your bag:")
			DerpyPrint(purgeLink.." x"..lowValCount.." - Total value "..GetCoinString(lowValGold))
			PickupContainerItem(lowValBag, lowValSlot) 
			DeleteCursorItem() 
		else
			DerpyPrint(highlight("LowGray: ").."There are no gray items in your bags.")
		end
	else
		DerpyPrint(highlight("LowGray: ").."The addon "..highlight("Informant").." is required to use this function in the TBC edition of the addon. Informant is part of the Auctioneer suite of addons, and provides Derpy with the needed selling price data for each item.")
	end
end

function PurgeGrayItems(dryRun) -- Delete all gray items from bags
	if(IsAddOnLoaded("Informant") == 1) then
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
					itemID = tonumber(link:match("item:(%d+):"))
					itemSellPrice = Informant.GetItem(itemID).sell
					
					if (rarity == 0) then -- It's a gray item
						if(dryRun == false) then
							PickupContainerItem(bag, slot) 
							DeleteCursorItem() 
						end
						
						purgeCount = purgeCount + itemCount
						slotCount = slotCount + 1
						
						if(itemSellPrice ~= nil) then
							wastedGoldCount = wastedGoldCount + (itemSellPrice * itemCount)
						end
					end
				end 
			end 
		end
		
		if(purgeCount > 0) then
			if(dryRun == true) then
				StaticPopupDialogs["ConfirmDeleteAllGrayItems"] = {
					text = "Are you sure you want to purge the "..purgeCount.." |4gray item:gray items; in your bags? This action cannot be undone.\n\nTotal vendor worth:\n"..GetCoinString(wastedGoldCount),
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
				DerpyPrint(highlight("Gray: ").."Purged "..purgeCount.." |4gray item from your bags. If you had sold this item:gray items (taking up "..slotCount.." slots) from your bags. If you had sold these items; to a vendor instead, you would have made "..GetCoinString(wastedGoldCount)..".")
			end
		else
			DerpyPrint(highlight("Gray: ").."You have no gray items in your bags.")
		end
	else
		DerpyPrint(highlight("LowGray: ").."The addon "..highlight("Informant").." is required to use this function in the TBC edition of the addon. Informant is part of the Auctioneer suite of addons.")
	end
end

function BagWorth() -- Not a reappropriation of PurgeGrayItems() at all, no sir, not on my watch
	if(IsAddOnLoaded("Informant") == 1) then
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
					itemInfo = {GetItemInfo(link)}
					itemID = tonumber(link:match("item:(%d+):"))
					itemSellPrice = Informant.GetItem(itemID).sell
					
					if(itemSellPrice ~= nil) then
						runningGoldCount = runningGoldCount + (itemSellPrice * itemCount)
					end
				end 
			end 
		end
		
		if(totalItemCount > 0) then
			DerpyPrint(highlight("BagWorth: ").."You have "..totalItemCount.." |4item in your bags. If you had sold it:items in your bags. If you had sold them; to a vendor, you would have made "..GetCoinString(runningGoldCount)..".")
		else
			DerpyPrint(highlight("BagWorth: ").."You have no items in your bags.")
		end
	else
		DerpyPrint(highlight("LowGray: ").."The addon "..highlight("Informant").." is required to use this function in the TBC edition of the addon. Informant is part of the Auctioneer suite of addons.")
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

function GetCoinString(copper)
	local goldColor = "|cFFFFFF00"
	local silverColor = "|cFFA6A6A6"
	local copperColor = "|cFFFF8040"

	if(copper > 9999) then
		copper = tostring(copper)
		return goldColor .. strsub(copper, 1, strlen(copper)-4) .. "g " .. silverColor .. strsub(copper, strlen(copper)-3, 3) .. "s " .. copperColor .. strsub(copper, -2) .. "c" .. original
	elseif(copper > 99) then
		copper = tostring(copper)
		return silverColor .. strsub(copper, 1, strlen(copper)-2) .. "s " .. copperColor .. strsub(tostring(copper), -2) .. "c" .. original
	else
		return copperColor .. tostring(copper) .. "c" .. original
	end
end
