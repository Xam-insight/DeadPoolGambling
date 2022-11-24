deadpoolCharInfo = {}
local L = LibStub("AceLocale-3.0"):GetLocale("Deadpool", true)

-- https://wow.gamepedia.com/RaceId
local raceID = {
   ["Human"] = 1,
   ["Orc"] = 2,
   ["Dwarf"] = 3,
   ["Night Elf"] = 4,
   ["Undead"] = 5,
   ["Tauren"] = 6,
   ["Gnome"] = 7,
   ["Troll"] = 8,
   ["Goblin"] = 9,
   ["Blood Elf"] = 10,
   ["Draenei"] = 11,
   ["Fel Orc"] = 12,
   ["Naga"] = 13,
   ["Broken"] = 14,
   ["Skeleton"] = 15,
   ["Vrykul"] = 16,
   ["Tuskarr"] = 17,
   ["Forest Troll"] = 18,
   ["Taunka"] = 19,
   ["Northrend Skeleton"] = 20,
   ["Ice Troll"] = 21,
   ["Worgen"] = 22,
   ["Gilnean"] = 23,
   ["Pandaren"] = 24,
   ["Pandaren"] = 25,
   ["Pandaren"] = 26,
   ["Nightborne"] = 27,
   ["Highmountain Tauren"] = 28,
   ["Void Elf"] = 29,
   ["Lightforged Draenei"] = 30,
   ["Zandalari Troll"] = 31,
   ["Kul Tiran"] = 32,
   ["ThinHuman"] = 33,
   ["Dark Iron Dwarf"] = 34,
   ["Vulpera"] = 35,
   ["Mag'har Orc"] = 36,
   ["Mechagnome"] = 37,
   ["Dracthyr"] = 52,
   ["Dracthyr"] = 70
}

-- UnitRace returns differently for the following races, so need to include exceptions
-- Thanks to MogIt authors: Aelobin (The Maelstrom EU) & Lombra (Defias Brotherhood EU)
raceID["NightElf"] = raceID["Night Elf"]
raceID["Scourge"] = raceID["Undead"]
raceID["BloodElf"] = raceID["Blood Elf"]
raceID["FelOrc"] = raceID["Fel Orc"]
raceID["Naga_"] = raceID["Naga"]
raceID["ForestTroll"] = raceID["Forest Troll"]
raceID["NorthrendSkeleton"] = raceID["Northrend Skeleton"]
raceID["IceTroll"] = raceID["Ice Troll"]
raceID["HighmountainTauren"] = raceID["Highmountain Tauren"]
raceID["VoidElf"] = raceID["Void Elf"]
raceID["LightforgedDraenei"] = raceID["Lightforged Draenei"]
raceID["ZandalariTroll"] = raceID["Zandalari Troll"]
raceID["KulTiran"] = raceID["Kul Tiran"]
raceID["DarkIronDwarf"] = raceID["Dark Iron Dwarf"]
raceID["MagharOrc"] = raceID["Mag'har Orc"]

-- https://wowpedia.fandom.com/wiki/InstanceID
-- https://wowpedia.fandom.com/wiki/DifficultyID
-- https://wowpedia.fandom.com/wiki/LfgDungeonID
local dpInstanceIDList = {
	["249-3"]   = 46,   -- Onyxia's Lair
	["249-4"]   = 257,  -- Onyxia's Lair
	["409-9"]   = 48,   -- Molten Core
	["469-9"]   = 50,   -- Blackwing Lair
	["509-3"]   = 160,  -- Ahn'Qiraj Ruins
	["531-9"]   = 161,  -- Ahn'Qiraj Temple
	["532-3"]   = 175,  -- Karazhan
	["533-3"]   = 159,  -- Naxxramas
	["533-4"]   = 227,  -- Naxxramas
	["534-4"]   = 195,  -- Hyjal Summit
	["544-4"]   = 176,  -- Magtheridon's Lair
	["548-4"]   = 194,  -- Serpentshrine Cavern
	["550-4"]   = 193,  -- Tempest Keep
	["564-4"]   = 196,  -- Black Temple
	["565-4"]   = 177,  -- Gruul's Lair
	["580-4"]   = 199,  -- Sunwell Plateau
	["603-3"]   = 243,  -- Ulduar
	["603-4"]   = 244,  -- Ulduar
	["615-3"]   = 224,  -- The Obsidian Sanctum
	["615-4"]   = 238,  -- The Obsidian Sanctum
	["616-3"]   = 223,  -- The Eye of Eternity
	["616-4"]   = 237,  -- The Eye of Eternity
	["624-3"]   = 239,  -- Vault of Archavon
	["624-4"]   = 240,  -- Vault of Archavon
	["631-3"]   = 279,  -- Icecrown Citadel
	["631-4"]   = 280,  -- Icecrown Citadel
	["649-3"]   = 246,  -- Trial of the Crusader
	["649-4"]   = 248,  -- Trial of the Crusader
	["649-5"]   = 247,  -- Trial of the Crusader
	["649-6"]   = 250,  -- Trial of the Crusader
	["669-3"]   = 313,  -- Blackwing Descent
	["669-4"]   = 314,  -- Blackwing Descent
	["671-3"]   = 315,  -- The Bastion of Twilight
	["671-4"]   = 316,  -- The Bastion of Twilight
	["720-3"]   = 361,  -- Firelands
	["720-4"]   = 362,  -- Firelands
	["724-3"]   = 293,  -- The Ruby Sanctum
	["724-4"]   = 294,  -- The Ruby Sanctum
	["754-3"]   = 317,  -- Throne of the Four Winds
	["754-4"]   = 318,  -- Throne of the Four Winds
	["757-3"]   = 328,  -- Baradin Hold
	["757-4"]   = 329,  -- Baradin Hold
	["967-3"]   = 447,  -- Dragon Soul
	["967-4"]   = 448,  -- Dragon Soul
	["996-3"]   = 535,  -- Terrace of Endless Spring
	["996-4"]   = 536,  -- Terrace of Endless Spring
	["1008-3"]  = 531,  -- Mogu'shan Vaults
	["1008-4"]  = 532,  -- Mogu'shan Vaults
	["1009-3"]  = 533,  -- Heart of Fear
	["1009-4"]  = 534,  -- Heart of Fear
	["1098-3"]  = 633,  -- Throne of Thunder
	["1098-4"]  = 634,  -- Throne of Thunder
	["1136-14"] = 715,  -- Siege of Orgrimmar
	["1136-15"] = 714,  -- Siege of Orgrimmar
	["1136-16"] = 766,  -- Siege of Orgrimmar
	["1205-14"] = 898,  -- Blackrock Foundry
	["1205-15"] = 899,  -- Blackrock Foundry
	["1205-16"] = 900,  -- Blackrock Foundry
	["1228-14"] = 895,  -- Highmaul
	["1228-15"] = 896,  -- Highmaul
	["1228-16"] = 897,  -- Highmaul
	["1448-14"] = 987,  -- Hellfire Citadel
	["1448-15"] = 988,  -- Hellfire Citadel
	["1448-16"] = 989,  -- Hellfire Citadel
	["1520-14"] = 1348, -- The Emerald Nightmare
	["1520-15"] = 1349, -- The Emerald Nightmare
	["1520-16"] = 1350, -- The Emerald Nightmare
	["1530-14"] = 1351, -- The Nighthold
	["1530-15"] = 1352, -- The Nighthold
	["1530-16"] = 1353, -- The Nighthold
	["1648-14"] = 1437, -- Trial of Valor
	["1648-15"] = 1439, -- Trial of Valor
	["1648-16"] = 1438, -- Trial of Valor
	["1676-14"] = 1525, -- Tomb of Sargeras
	["1676-15"] = 1526, -- Tomb of Sargeras
	["1676-16"] = 1527, -- Tomb of Sargeras
	["1712-14"] = 1640, -- Antorus,  the Burning Throne
	["1712-15"] = 1641, -- Antorus,  the Burning Throne
	["1712-16"] = 1642, -- Antorus,  the Burning Throne
	["1861-14"] = 1889, -- Uldir
	["1861-15"] = 1888, -- Uldir
	["1861-16"] = 1887, -- Uldir
	["2070-14"] = 1942, -- Battle of Dazar'alor
	["2070-15"] = 1943, -- Battle of Dazar'alor
	["2070-16"] = 1944, -- Battle of Dazar'alor
	["2096-14"] = 1952, -- Crucible of Storms
	["2096-15"] = 1953, -- Crucible of Storms
	["2096-16"] = 1954, -- Crucible of Storms
	["2164-14"] = 2014, -- The Eternal Palace
	["2164-15"] = 2015, -- The Eternal Palace
	["2164-16"] = 2016, -- The Eternal Palace
	["2217-14"] = 2033, -- Ny'alotha
	["2217-15"] = 2034, -- Ny'alotha
	["2217-16"] = 2035, -- Ny'alotha
	["2296-14"] = 2095, -- Castle Nathria
	["2296-15"] = 2094, -- Castle Nathria
	["2296-16"] = 2093, -- Castle Nathria
	["2450-15"] = 2226, -- Sanctum of Domination
	["2450-15"] = 2227, -- Sanctum of Domination
	["2450-15"] = 2228, -- Sanctum of Domination
	["2481-15"] = 2288, -- Sepulcher of the First Ones
	["2481-15"] = 2289, -- Sepulcher of the First Ones
	["2481-15"] = 2290, -- Sepulcher of the First Ones
}

local willPlay, soundHandle

Deadpool_maxBets = 1

Deadpool_WindowsOptions = "All"

-- Initialize Deadpools Objects
function initDeadpoolBusinessObjects()
	-- DeadpoolData
	local name = Deadpool_playerCharacter() or UNKNOWNOBJECT
	if not DeadpoolData then
		DeadpoolData = {}
	end
	if not DeadpoolGlobal_SessionId then
		playerJoinsDeadpoolSession("DeadpoolSession_"..name, true, true)
	elseif DeadpoolData[DeadpoolGlobal_SessionId] and not DeadpoolData[DeadpoolGlobal_SessionId][name] then
		playerJoinsDeadpoolSession(DeadpoolGlobal_SessionId)
	end

	-- DeadpoolOptionsData
	if not DeadpoolOptionsData then
		DeadpoolOptionsData = {}
	end

	-- DeadpoolWindow
	if not DeadpoolWindow then
		DeadpoolWindow = {}
	end
	if not DeadpoolWindow[Deadpool_WindowsOptions] then
		DeadpoolWindow[Deadpool_WindowsOptions] = {}
	end
	if DeadpoolWindow[name] then
		Deadpool_WindowsOptions = name
	end
	if not DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"] then
		DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"] = 0.7
	end
	if not DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"] then
		DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"] = 24
	end
	if not DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolHeight"] then
		DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolHeight"] = 360
	end
	
	-- DeadpoolTuto
	if not DeadpoolTuto then
		DeadpoolTuto = {}
	end
end

function prepareAndSendSimpleDeadpoolDataToRaid(aSession, aCharacter, anInfo, isOptionData)
	local Temp_DeadpoolData = {}
	if anInfo and not isOptionData then
		local value, dataTime = getDeadpoolData(aSession, aCharacter, anInfo)
		Temp_DeadpoolData[aCharacter] = {}
		local infoToSend = value
		if dataTime then
			infoToSend = infoToSend.."|"..dataTime
		end
		Temp_DeadpoolData[aCharacter][anInfo] = infoToSend
	else
		Temp_DeadpoolData[aCharacter] = DeadpoolData[aSession][aCharacter]
	end
	encodeAndSendSimpleDeadpoolData(Temp_DeadpoolData)
end

-- Get Roster Info
local groupLabel
function getDeadpoolRosterInfo()
	deadpoolCharInfo = {}

	local deadpoolPlayerCharacter = Deadpool_playerCharacter() or UNKNOWNOBJECT
	local deadpoolPlayerVersion = getDeadpoolMainVersion(GetAddOnMetadata("Deadpool", "Version"))

	addCharInList(deadpoolCharInfo, "player", deadpoolPlayerCharacter)

	local cancelBetsOnGonePlayers = true
	local everyoneIsHere = true
	local _, _, _, instanceID = UnitPosition("player")
	if not isInstanceAtLevel(UnitLevel("player")) then
		everyoneIsHere = false
	end
	
	groupLabel = getGroupType()

	local numGroupMembers = GetNumGroupMembers()
    if groupLabel then
		Deadpool_maxBets = floor(numGroupMembers / 2)
        for i = 1, numGroupMembers do
			if UnitExists(groupLabel..i) then
                local name = Deadpool_fullName(groupLabel..i)
				if name then
					local isDeadpoolPlayer = getDeadpoolData(DeadpoolGlobal_SessionId, name, "credits")
					local isDeadpoolPlayerUpToDate = deadpoolPlayerVersion == getDeadpoolMainVersion(getDeadpoolData(DeadpoolGlobal_SessionId, name, DEADPOOLDATA_VERSION))
					addCharInList(deadpoolCharInfo, groupLabel..i, name)
					local _, _, _, instanceIDChar = UnitPosition(groupLabel..i)
					if isDeadpoolPlayer and everyoneIsHere and UnitIsConnected(groupLabel..i)
							and (not isDeadpoolPlayerUpToDate or instanceIDChar ~= instanceID or not isInstanceAtLevel(UnitLevel(groupLabel..i))) then
						everyoneIsHere = false
					end
				else
					cancelBetsOnGonePlayers = false
				end
            end
        end
		loadBets(DeadpoolGlobal_SessionId, DEADPOOL_BANKER)
	end

	if everyoneIsHere then
		addCharInList(deadpoolCharInfo, "boss", "boss")--"|T521748:16:16:0:0|t Prochain boss")--Interface\\Buttons\\UI-Panel-SmallerButton-Up:15:15:0:0:32:32:7:25:8:26
	end

	clearCharacterDeadpoolData(deadpoolPlayerCharacter)

	-- Cancel the bets from players that left
	if cancelBetsOnGonePlayers --[[and groupLabel and numGroupMembers > 1]] and not dpFakeCharInfo then
		if DeadpoolData[DeadpoolGlobal_SessionId] then
			for index,value in pairs(DeadpoolData[DeadpoolGlobal_SessionId]) do
				if "Bank" ~= index and "DeadpoolSessionId" ~= index and not deadpoolAchievements[index] then
					if not deadpoolCharInfo[index] and DEADPOOL_BANKER ~= index then
						setDeadpoolData(DeadpoolGlobal_SessionId, index, "inCombat", "false")
						saveBets(DeadpoolGlobal_SessionId, index)
						saveDressUpModelForReuse(index)
						if index == selectedDeadpoolCharacter then
							selectedDeadpoolLine = nil
							selectedDeadpoolCharacter = nil
						end
					end
					if value["bets"] then
						for index2,value2 in pairs(value["bets"]) do
							if not deadpoolCharInfo[index2] and value2 and Deadpool_tonumberzeroonblankornil(value2["nextDeathBet"]) > 0 then
								saveBets(DeadpoolGlobal_SessionId, index, index2)
							end
						end
					end
				end
			end
		end
	end
	return deadpoolCharInfo
end

function getDeadpoolMainVersion(version)
	local mainVersion = 0
	if version then
		local v1, v2, v3 = strsplit(".", version)
		mainVersion = tonumber(v1) * 100 + v2
	end
	return mainVersion
end

function addCharInList(deadpoolCharInfo, groupRank, name)
	local deadpoolPlayerCharacter = Deadpool_playerCharacter() or UNKNOWNOBJECT
	local _, englishClass = UnitClass(groupRank)
	local _, raceEn = UnitRace(groupRank)
	local gender_code = UnitSex(groupRank)
	deadpoolCharInfo[name] = {}
	deadpoolCharInfo[name]["classFileName"] = englishClass
	deadpoolCharInfo[name]["groupRank"] = groupRank
	local role = 'NONE'
	if UnitGroupRolesAssigned then
		role = UnitGroupRolesAssigned(groupRank)
	end
	deadpoolCharInfo[name]["groupRole"] = role
	deadpoolCharInfo[name]["race"] = (raceEn and raceID[raceEn]) or 1
	deadpoolCharInfo[name]["gender"] = (gender_code and gender_code - 2) or 0
	clearCharacterDeadpoolData(name)

	if groupRank ~= "player" and DeadpoolSavedBets then
		if DeadpoolSavedBets[deadpoolPlayerCharacter] then
			if DeadpoolSavedBets[deadpoolPlayerCharacter][name] then
				local savedBet = DeadpoolSavedBets[deadpoolPlayerCharacter][name]
				if savedBet then
					DeadpoolSavedBets[deadpoolPlayerCharacter][name] = nil
					setDeadpoolBets(DeadpoolGlobal_SessionId, deadpoolPlayerCharacter, name, savedBet)
				end
			end
			if DeadpoolSavedBets[deadpoolPlayerCharacter]["uniqueGamble"] and DeadpoolSavedBets[deadpoolPlayerCharacter]["uniqueGamble"] == name then
				DeadpoolSavedBets[deadpoolPlayerCharacter]["uniqueGamble"] = nil
				setDeadpoolUniqueGamble(DeadpoolGlobal_SessionId, deadpoolPlayerCharacter, name)
			end
		end
		loadBets(DeadpoolGlobal_SessionId, name)
	end
end

function loadBets(aSession, aChar)
	if DeadpoolSavedBets and DeadpoolSavedBets[aChar] then
		local savedBets = DeadpoolSavedBets[aChar]
		for index,value in pairs(savedBets) do
			if value then
				setDeadpoolBetLocally(aSession, aChar, index, value)
			end
			DeadpoolSavedBets[aChar][index] = nil
		end
		for index,value in pairs(DeadpoolSavedBets) do
			if value then
				for index2,value2 in pairs(value) do
					if value2 and index2 == aChar then
						setDeadpoolBetLocally(aSession, index, index2, value2)
					end
				end
			end
			DeadpoolSavedBets[aChar][index] = nil
		end
	end
end

function saveBets(aSession, aChar, aBetChar)
	if not aBetChar then
		local playerBets = DeadpoolData[aSession][aChar]["bets"]
		if playerBets then
			for index,value in pairs(playerBets) do
				if value and Deadpool_tonumberzeroonblankornil(value["nextDeathBet"]) > 0 then
					if not DeadpoolSavedBets then
						DeadpoolSavedBets = {}
					end
					if not DeadpoolSavedBets[aChar] then
						DeadpoolSavedBets[aChar] = {}
					end
					DeadpoolSavedBets[aChar][index] = value["nextDeathBet"]
					if Deadpool_isPlayerCharacter(aChar) then
						setDeadpoolBets(aSession, aChar, index, "0")
					else
						setDeadpoolBetLocally(aSession, aChar, index, "0")
					end
				end
			end
		end
		local uniqueGamble = getDeadpoolData(aSession, aChar, "uniqueGamble")
		if uniqueGamble and uniqueGamble ~= "NO_ONE" then
			if not DeadpoolSavedBets then
				DeadpoolSavedBets = {}
			end
			if not DeadpoolSavedBets[aChar] then
				DeadpoolSavedBets[aChar] = {}
			end
			DeadpoolSavedBets[aChar]["uniqueGamble"] = uniqueGamble
			if Deadpool_isPlayerCharacter(aChar) then
				setDeadpoolUniqueGamble(aSession, aChar, "NO_ONE")
			else
				setDeadpoolBetLocally(aSession, aChar, "uniqueGamble", "NO_ONE")
			end
		end
	else
		local playerBetsOnChar, _, _, playerBetsNumber = getDeadpoolBets(aSession, aChar, aBetChar)
		if playerBetsOnChar > 0 then
			if not DeadpoolSavedBets then
				DeadpoolSavedBets = {}
			end
			if not DeadpoolSavedBets[aChar] then
				DeadpoolSavedBets[aChar] = {}
			end
			DeadpoolSavedBets[aChar][aBetChar] = playerBetsOnChar
			if Deadpool_isPlayerCharacter(aChar) then
				setDeadpoolBets(aSession, aChar, aBetChar, "0")
			else
				setDeadpoolBetLocally(aSession, aChar, aBetChar, "0")
			end
		end
		local uniqueGamble = getDeadpoolData(aSession, aChar, "uniqueGamble")
		if uniqueGamble == aBetChar then
			if not DeadpoolSavedBets then
				DeadpoolSavedBets = {}
			end
			if not DeadpoolSavedBets[aChar] then
				DeadpoolSavedBets[aChar] = {}
			end
			DeadpoolSavedBets[aChar]["uniqueGamble"] = aBetChar
			if Deadpool_isPlayerCharacter(aChar) then
				setDeadpoolUniqueGamble(aSession, aChar, "NO_ONE")
			else
				setDeadpoolBetLocally(aSession, aChar, "uniqueGamble", "NO_ONE")
			end
		end
	end
end

function setDeadpoolBetLocally(aSession, aChar, aBetChar, aNextDeathBet)
	if aBetChar == "uniqueGamble" then
		setDeadpoolData(aSession, aChar, "uniqueGamble", aNextDeathBet)
	else
		local howManyGarmentToLose, afterTransactionCredits, _ = howManyGarmentToLose(aSession, aChar, aBetChar, aNextDeathBet)
		if howManyGarmentToLose == 0 or dpFakeCharInfo then
			local bets = nil
			if Deadpool_tonumberzeroonblankornil(aNextDeathBet) > 0 then
				bets = {}
				bets["dataTime"] = tostring(Deadpool_getTimeUTCinMS())
				bets["nextDeathBet"] = aNextDeathBet
			end
			DeadpoolData[aSession][aChar]["bets"][aBetChar] = bets
			setDeadpoolData(aSession, aChar, "credits", afterTransactionCredits)
		end
	end
end

function getGroupType()
	local newGroupLabel = nil
	if IsInRaid() then
        newGroupLabel = "raid"
    elseif IsInGroup() then
        newGroupLabel = "party"
    else
		DEADPOOL_GROUPJOINED = nil
	end
	return newGroupLabel
end

function getDeadpoolCharInfo(aChar, anInfo)
	local value = nil
	if deadpoolCharInfo and deadpoolCharInfo[aChar] then
		value = deadpoolCharInfo[aChar][anInfo]
	end
	return value
end

function Deadpool_addRealm(aName, aRealm)
	if aName and not string.match(aName, "-") then
		if aRealm and aRealm ~= "" then
			aName = aName.."-"..aRealm
		else
			local realm = GetNormalizedRealmName() or UNKNOWNOBJECT
			aName = aName.."-"..realm
		end
	end
	return aName
end

function Deadpool_fullName(unit)
	local fullName = nil
	if unit then
		local playerName, playerRealm = UnitFullName(unit)
		if playerName and playerName ~= "" and playerName ~= UNKNOWNOBJECT then
			if not playerRealm or playerRealm == "" then
				playerRealm = GetNormalizedRealmName()
			end
			if playerRealm and playerRealm ~= "" then
				fullName = playerName.."-"..playerRealm
			end
		end
	end
	return fullName
end


function Deadpool_delRealm(aName)
	if aName and string.match(aName, "-") then
		aName = strsplit("-", aName)
	end
	return aName
end

function playerNameOrBankerName(fullName)
	if fullName == DEADPOOL_BANKER then
		return DEADPOOL_BANKER_NAME
	elseif fullName == "boss" then
		return L["NEXT_BOSS"]
	else
		return fullName
	end
end

function playerJoinsDeadpoolSession(aSession, isCreator, keepPlayerData)
	local playerCharacter = Deadpool_playerCharacter() or UNKNOWNOBJECT
	if not DeadpoolGlobal_SessionId or DeadpoolGlobal_SessionId ~= aSession or isCreator then
		local playerData = nil
		local bankerData = nil
		local bankData = 0
		if keepPlayerData and DeadpoolGlobal_SessionId and DeadpoolData[DeadpoolGlobal_SessionId] then
			playerData = DeadpoolData[DeadpoolGlobal_SessionId][playerCharacter]
			bankerData = DeadpoolData[DeadpoolGlobal_SessionId][DEADPOOL_BANKER]
			bankData = DeadpoolData[DeadpoolGlobal_SessionId]["Bank"]
		end
		DeadpoolGlobal_SessionId = aSession
		DeadpoolData = {}
		setInitialDeadpoolPlayerData(aSession, playerCharacter)
		setDeadpoolData(aSession, DEADPOOL_BANKER, "credits", DEADPOOL_INITIAL_MONEY)
		DeadpoolData[aSession]["DeadpoolSessionId"] = aSession
		if keepPlayerData and playerData then
			DeadpoolData[aSession][playerCharacter] = playerData
			DeadpoolData[aSession][DEADPOOL_BANKER] = bankerData
			DeadpoolData[DeadpoolGlobal_SessionId]["Bank"] = bankData
		end
		if not isCreator then
			prepareAndSendSimpleDeadpoolDataToRaid(aSession, playerCharacter)
		end
	elseif DeadpoolData and DeadpoolData[DeadpoolGlobal_SessionId] and not DeadpoolData[DeadpoolGlobal_SessionId][playerCharacter] then
		setInitialDeadpoolPlayerData(aSession, playerCharacter)
	else
		setDeadpoolPlayerData(aSession, playerCharacter)
	end
end

function setDeadpoolPlayerData(aSession, aChar)
	setDeadpoolData(aSession, aChar, DEADPOOLDATA_VERSION, GetAddOnMetadata("Deadpool", "Version"))
end

function setInitialDeadpoolPlayerData(aSession, aChar)
	setDeadpoolData(aSession, aChar, "credits", DEADPOOL_INITIAL_MONEY)
	setDeadpoolData(aSession, aChar, DEADPOOLDATA_VERSION, GetAddOnMetadata("Deadpool", "Version"))
end

--[[function isEveryoneDisconnected(aDeadpoolSessionId)
	local everyoneDisconnected = true
	local numGroupMembers = GetNumGroupMembers()
	if numGroupMembers > 0 then
		local i = 1
		while everyoneDisconnected and i <= numGroupMembers do
			local name, _, _, _, _, _, _, online, _, _, _ = GetRaidRosterInfo(i)
			name = Deadpool_addRealm(name)
			if name ~= Deadpool_playerCharacter() and getDeadpoolData(aDeadpoolSessionId, name, "credits") and online then
				everyoneDisconnected = false
			end
			i = i + 1
		end
	end
	return everyoneDisconnected
end--]]

-- Load Received Data
function loadReceivedDeadpoolData(messageType)
	local receivedDataWasObsolete = false
	--Deadpool:Print(time().." - Processing data.")
	if DeadpoolReceivedData then
		if DeadpoolReceivedData["DeadpoolSessionId"] and DeadpoolReceivedData["DeadpoolSessionId"] ~= DeadpoolGlobal_SessionId then
			if messageType == "SimpleData" then
				return
			else
				playerJoinsDeadpoolSession(DeadpoolReceivedData["DeadpoolSessionId"])
			end
		end
		if DeadpoolReceivedData[DeadpoolGlobal_SessionId] then
			checkBetsOnPlayerChanged(DeadpoolGlobal_SessionId, DeadpoolReceivedData)
			for index,value in pairs(DeadpoolReceivedData[DeadpoolGlobal_SessionId]) do
				if index == "DeadpoolSessionId" then -- Update admin config
					local actualData = DeadpoolData[DeadpoolGlobal_SessionId][index]
					local newData = DeadpoolReceivedData[DeadpoolGlobal_SessionId][index]
					local newValue, myValueWasObsolete = Deadpool_getMostRecentTimedValue(actualData, newData)
					DeadpoolData[DeadpoolGlobal_SessionId][index] = newValue
					if actualData ~= newData and not myValueWasObsolete then
						receivedDataWasObsolete = true
					end
					DeadpoolReceivedData[DeadpoolGlobal_SessionId][index] = nil
				elseif deadpoolAchievements[index]
					and DeadpoolReceivedData[DeadpoolGlobal_SessionId][index]
						and DeadpoolReceivedData[DeadpoolGlobal_SessionId][index]["achiever"] then
					local achievementChar = getDeadpoolData(DeadpoolGlobal_SessionId, index, "achiever", DeadpoolReceivedData)
					local precAchievementChar = getDeadpoolData(DeadpoolGlobal_SessionId, index, "achiever")
					if not precAchievementChar or precAchievementChar == "" then
						if not deadpoolAchievements[index][DEADPOOL_ISBESTACHIVERACHIEVEMENT] then
							local noNotif = (not DeadpoolOptionsData and not DeadpoolOptionsData["DeadpoolAchievementAnnounceDisabled"] and not (DeadpoolOptionsData["DeadpoolAchievementAnnounceDisabled"] == true))
								or (UnitGUID("boss1") and DeadpoolOptionsData["DeadpoolNotificationsInBossFightsDisabled"])

								--if not noNotif then
								--	EZBlizzUiPop_ToastFakeAchievementNew(Deadpool, deadpoolAchievements[index]["label"], 3456, true, 15, string.format(L["NEW_TITLE_FOR"], achievementChar), function()  Deadpool:DeadpoolShow()  end)
								--end
							if noNotif then
								Deadpool:Print(string.format(L["NEW_TITLE_FOR"], achievementChar)..L["SPACE_BEFORE_DOT"]..": "..deadpoolAchievements[index]["label"])
							end
							if CustomAchiever and Deadpool_isPlayerCharacter(achievementChar) then
								CustAc_CompleteAchievement(index, nil, noNotif, DeadpoolOptionsData["DeadpoolSoundsDisabled"])
							elseif not noNotif then
								EZBlizzUiPop_ToastFakeAchievementNew(Deadpool, deadpoolAchievements[index]["label"], 3456, not DeadpoolOptionsData["DeadpoolSoundsDisabled"], 4, string.format(L["NEW_TITLE_FOR"], achievementChar), function()  Deadpool:DeadpoolShow()  end)
							end
						else
							setDeadpoolData(DeadpoolGlobal_SessionId, index, "value", getDeadpoolData(DeadpoolGlobal_SessionId, index, "value", DeadpoolReceivedData))
						end
						setDeadpoolData(DeadpoolGlobal_SessionId, index, "achiever", achievementChar)
					end
					DeadpoolReceivedData[DeadpoolGlobal_SessionId][index] = nil
				else -- Update characters list data
					if not DeadpoolData[DeadpoolGlobal_SessionId][index] then -- If player has no data for character
						DeadpoolData[DeadpoolGlobal_SessionId][index] = DeadpoolReceivedData[DeadpoolGlobal_SessionId][index]
						DeadpoolReceivedData[DeadpoolGlobal_SessionId][index] = nil
					else
						for index2, value2 in pairs(DeadpoolReceivedData[DeadpoolGlobal_SessionId][index]) do
							if index2 == "bets" then
								local actualData = DeadpoolData[DeadpoolGlobal_SessionId][index][index2]
								local newData = DeadpoolReceivedData[DeadpoolGlobal_SessionId][index][index2]
								if not actualData or not actualData["dataTime"] then
									DeadpoolData[DeadpoolGlobal_SessionId][index][index2] = newData
								elseif newData then
									local newDataTime = DeadpoolReceivedData[DeadpoolGlobal_SessionId][index][index2]["dataTime"]
									if newDataTime and newDataTime > actualData["dataTime"] then
										DeadpoolData[DeadpoolGlobal_SessionId][index][index2] = newData
									else
										receivedDataWasObsolete = true
									end
								end
								DeadpoolReceivedData[DeadpoolGlobal_SessionId][index][index2] = nil
							else
								local actualData, actualDataTime = getDeadpoolData(DeadpoolGlobal_SessionId, index, index2)
								if actualDataTime then
									actualData = actualData.."|"..actualDataTime
								end
								local newData = tostring(DeadpoolReceivedData[DeadpoolGlobal_SessionId][index][index2])
								if actualData == nil or actualData ~= newData then
									if index2 == "offItemsNumber" and (not actualData or newData > actualData) then
										dpShowModel(index)
									end 
									local newValue, myValueWasObsolete = Deadpool_getMostRecentTimedValue(actualData, newData, true)
									setDeadpoolData(DeadpoolGlobal_SessionId, index, index2, newValue)
									if not myValueWasObsolete and actualData ~= newData then
										receivedDataWasObsolete = true
									end
									DeadpoolReceivedData[DeadpoolGlobal_SessionId][index][index2] = nil
								else
									if actualData == newData then
										DeadpoolReceivedData[DeadpoolGlobal_SessionId][index][index2] = nil
									end
								end
							end
						end
					end
				end
				if DeadpoolReceivedData[DeadpoolGlobal_SessionId][index] 
					and Deadpool_countTableElements(DeadpoolReceivedData[DeadpoolGlobal_SessionId][index]) == 0 then
					DeadpoolReceivedData[DeadpoolGlobal_SessionId][index] = nil
				end
			end
			if Deadpool_countTableElements(DeadpoolReceivedData[DeadpoolGlobal_SessionId]) == 0 then
				DeadpoolReceivedData[DeadpoolGlobal_SessionId] = nil
			end
		end
	end
	--Deadpool:Print(time().." - Data processed.")
	if receivedDataWasObsolete and not messageType == "SimpleData" then
		encodeAndSendDeadpoolSessionInfo(DeadpoolData[DeadpoolGlobal_SessionId], DeadpoolReceivedData["Sender"], DeadpoolReceivedData["CallTime"])
	end
	generateDeadpoolTable()
end

function checkBetsOnPlayerChanged(aDeadpoolSessionId, newDeadpoolData)
	local player = Deadpool_playerCharacter()

	if player then
		local _, nbNextDeathBets = getDeadpoolTotalBets(aDeadpoolSessionId, "nextDeathBet", player)
		local _, newNbNextDeathBets = getDeadpoolTotalBets(aDeadpoolSessionId, "nextDeathBet", player, newDeadpoolData)
	
		local totalUniqueGambleOnChar, _ = getDeadpoolTotalUniqueGamble(aDeadpoolSessionId, player)
		local newTotalUniqueGambleOnChar, _ = getDeadpoolTotalUniqueGamble(aDeadpoolSessionId, player, newDeadpoolData)

		if nbNextDeathBets ~= newNbNextDeathBets or totalUniqueGambleOnChar ~= newTotalUniqueGambleOnChar then
			Deadpool:Print(L["DEADPOOLUI_BETSCHANGEDONCHAR"])
			Deadpool_PlaySound(865, "SFX")
		end
	end
end

function clearCharacterDeadpoolData(aFullName)
	if aFullName and DeadpoolData and DeadpoolData[DeadpoolGlobal_SessionId]
			and DeadpoolData[DeadpoolGlobal_SessionId][aFullName]
				and Deadpool_countTableElements(DeadpoolData[DeadpoolGlobal_SessionId][aFullName]) == 0 then
		DeadpoolData[DeadpoolGlobal_SessionId][aFullName] = nil
	end
end

function Deadpool_countTableElements(table)
	local count = 0
	if table then
		for _ in pairs(table) do
			count = count + 1
		end
	end
	return count
end

function getDeadpoolData(aSession, aChar, anInfo, aDeadpoolDataObject)
	local value = nil
	local dataTime = nil

	if not aDeadpoolDataObject then
		aDeadpoolDataObject = DeadpoolData
	end

	if aSession and aChar and anInfo then
		if aDeadpoolDataObject 
			and aDeadpoolDataObject[aSession]
				and aDeadpoolDataObject[aSession][aChar] then
			value = aDeadpoolDataObject[aSession][aChar][anInfo]
			if value ~= nil then
				value, dataTime = strsplit("|", tostring(value), 2)
				if dataTime and dataTime == "" then
					dataTime = nil
				end
			end
		end
	end
	return value, dataTime
end

function setDeadpoolData(aSession, aChar, anInfo, aValue)
	if aSession and aChar and anInfo then
		local value, dataTime = strsplit("|", tostring(aValue), 2)
		if not DeadpoolData then
			DeadpoolData = {}
		end
		if not DeadpoolData[aSession] then
			DeadpoolData[aSession] = {}
		end
		if not DeadpoolData[aSession][aChar] then
			DeadpoolData[aSession][aChar] = {}
		end
		if not dataTime or dataTime == "" then
			dataTime = tostring(Deadpool_getTimeUTCinMS())
		end
		DeadpoolData[aSession][aChar][anInfo] = value.."|"..dataTime
	end
end

function getDeadpoolBets(aSession, aChar, aBetChar)
	local bet = 0
	local dataTime = nil
	local totalBets = 0
	local betsNumber = 0
	if aSession and aChar then
		if DeadpoolData
			and DeadpoolData[aSession]
				and DeadpoolData[aSession][aChar]
					and DeadpoolData[aSession][aChar]["bets"] then
			local bets = DeadpoolData[aSession][aChar]["bets"]
			if bets then
				for index,value in pairs(bets) do
					local readBet = Deadpool_tonumberzeroonblankornil(value["nextDeathBet"])
					if index == aBetChar then
						bet = readBet
						dataTime = value["dataTime"]
					end
					totalBets = totalBets + readBet
					if readBet > 0 then
						betsNumber = betsNumber + 1
					end
				end
			end
		end
	end
	return bet, dataTime, totalBets, betsNumber
end

function addDeadpoolBets(aSession, aChar, aBetChar, nextDeathBet)
	if aChar then
		if "unique" ~= nextDeathBet then
			local betToSend = Deadpool_tonumberzeroonblankornil(nextDeathBet)
			local playerBetsOnChar, _, _, playerBetsNumber = getDeadpoolBets(aSession, aChar, aBetChar)
			if playerBetsOnChar == 0 and playerBetsNumber >= Deadpool_maxBets then
				Deadpool_Error(string.format(L["DEADPOOLUI_MAXBETS"], Deadpool_maxBets))
				return
			end
			if not nextDeathBet then
				betToSend = Deadpool_tonumberzeroonblankornil(getDeadpoolData(aSession, aChar, "credits"))
				if betToSend > 0 then
					setDeadpoolBets(aSession, aChar, aBetChar, betToSend + playerBetsOnChar)
				else
					Deadpool_Error(L["DEADPOOLUI_NOMORECHIPS"])
				end
			elseif nextDeathBet == "0" then
				setDeadpoolBets(aSession, aChar, aBetChar, betToSend)
			else
				setDeadpoolBets(aSession, aChar, aBetChar, betToSend + playerBetsOnChar)
			end
		else
			setDeadpoolUniqueGamble(aSession, aChar, aBetChar)
		end
	end
end

function Deadpool_Error(message)
	local messageToPrint = "Dead Pool"..L["SPACE_BEFORE_DOT"]..": "..message
	UIErrorsFrame:AddMessage(messageToPrint, 1.0, 0.1, 0.1)
	Deadpool:Print("|cFFFF0000"..messageToPrint)
end

function setDeadpoolBets(aSession, aChar, aBetChar, aNextDeathBet)
	if aSession and aChar and aBetChar and aNextDeathBet then
		if aChar == aBetChar and not DeadpoolGlobal_Debug then
			tellTutorialText("DEADPOOLTUTO_TUTO4")
			Deadpool_Error(L["SELF_BET_NOT_ALLOWED"])
		else
			Deadpool:CheckDeath()
			local unitInCombat = getDeadpoolData(aSession, aBetChar, "inCombat")
			local playerInCombat = UnitAffectingCombat("player") or UnitExists("boss1")
			if unitInCombat == "true" or playerInCombat then
				tellTutorialText("DEADPOOLTUTO_TUTO5")
				Deadpool_Error(L["UNIT_IN_COMBAT"])
			else
				local howManyGarmentToLose, afterTransactionCredits, nextDeathBet = howManyGarmentToLose(aSession, aChar, aBetChar, aNextDeathBet)
				if howManyGarmentToLose > 0 then
					local dialog = StaticPopup_Show("NOT_ENOUGH_CREDITS", howManyGarmentToLose, DEADPOOL_GARMENT_REWARD..deadpoolChipTextureString)
					dpShowModel(aChar, dialog)
					if (dialog) then
						dialog.data = {}
						dialog.data["session"] = aSession
						dialog.data["char"] = aChar
						dialog.data["betChar"] = aBetChar
						dialog.data["nextDeathBet"] = nextDeathBet
						dialog.data["afterTransactionCredits"] = afterTransactionCredits
						dialog.data["howManyGarment"] = howManyGarmentToLose
					end
				elseif afterTransactionCredits < 0 then
					Deadpool_Error(L["DEADPOOLUI_NOMORECHIPS"])
				else
					saveDeadpoolBets(aSession, aChar, aBetChar, aNextDeathBet, afterTransactionCredits)
				end
			end
		end
	end
end

function howManyGarmentToLose(aSession, aChar, aBetChar, aNextDeathBet)
	local howManyGarmentToLose = 0
	local oldNextDeathBet = 0
	local nextDeathBet = Deadpool_tonumberzeroonblankornil(aNextDeathBet)
	if not DeadpoolData then
		DeadpoolData = {}
	end
	if not DeadpoolData[aSession] then
		DeadpoolData[aSession] = {}
	end
	if not DeadpoolData[aSession][aChar] then
		DeadpoolData[aSession][aChar] = {}
	end
	if not DeadpoolData[aSession][aChar]["bets"] then
		DeadpoolData[aSession][aChar]["bets"] = {}
	else
		if DeadpoolData[aSession][aChar]["bets"][aBetChar] then
			oldNextDeathBet = Deadpool_tonumberzeroonblankornil(DeadpoolData[aSession][aChar]["bets"][aBetChar]["nextDeathBet"])
		end
	end

	local playerCredits = Deadpool_tonumberzeroonblankornil(getDeadpoolData(aSession, aChar, "credits")) + oldNextDeathBet
	local afterTransactionCredits =  playerCredits - nextDeathBet

	if afterTransactionCredits < 0 then
		howManyGarmentToLose = -floor(afterTransactionCredits / DEADPOOL_GARMENT_REWARD)
	end

	local charLostItems = Deadpool_tonumberzeroonblankornil(getDeadpoolData(aSession, aChar, "offItemsNumber"))
	if charLostItems + howManyGarmentToLose > DEADPOOL_GARMENT_NUMBER then
		local overfull = charLostItems + howManyGarmentToLose - DEADPOOL_GARMENT_NUMBER
		howManyGarmentToLose = DEADPOOL_GARMENT_NUMBER - charLostItems
		nextDeathBet = playerCredits + howManyGarmentToLose * DEADPOOL_GARMENT_REWARD
		--afterTransactionCredits = 0
	end

	return howManyGarmentToLose, afterTransactionCredits, nextDeathBet
end

function setDeadpoolUniqueGamble(aSession, aChar, aBetChar)
	if aSession and aChar and aBetChar then
		local bankCredits = Deadpool_tonumberzeroonblankornil(getDeadpoolData(aSession, "Bank", "credits"))
		if bankCredits <= 0 then
			Deadpool_Error(L["EMPTY_BANK"])
		elseif aChar == aBetChar then
			tellTutorialText("DEADPOOLTUTO_TUTO4")
			Deadpool_Error(L["SELF_BET_NOT_ALLOWED"])
		else
			Deadpool:CheckDeath()
			local groupRank = getDeadpoolCharInfo(aBetChar, "groupRank")
			local unitInCombat = UnitAffectingCombat(groupRank)
			local playerInCombat = UnitAffectingCombat("player") or UnitExists("boss1")
			if unitInCombat or playerInCombat then
				tellTutorialText("DEADPOOLTUTO_TUTO5")
				Deadpool_Error(L["UNIT_IN_COMBAT"])
			elseif aBetChar ~= getDeadpoolData(aSession, aChar, "uniqueGamble") then
				DeadpoolTuto["chipPiles"] = "done"
				if DEADPOOL_SOLEIL == Deadpool_delRealm(aBetChar) then
					Deadpool_Error(L["DEADPOOL_SOLEILBET"])
					Deadpool_dropAnItem(aChar, 1, true)
					Deadpool_updateStat(aSession, aChar, DEADPOOL_SOLEILBET, 1)
				end
				tellTutorialText("DEADPOOLTUTO_TUTO7")
				setDeadpoolData(aSession, aChar, "uniqueGamble", aBetChar)
				Deadpool_PlaySound(865, "SFX")
				prepareAndSendSimpleDeadpoolDataToRaid(DeadpoolGlobal_SessionId, aChar)
				generateDeadpoolTable()
			end
		end
	end
end

function saveDeadpoolBets(aSession, aChar, aBetChar, nextDeathBet, afterTransactionCredits)
	if DEADPOOL_SOLEIL == Deadpool_delRealm(aBetChar) and nextDeathBet > 0 then
		Deadpool_Error(L["DEADPOOL_SOLEILBET"])
		Deadpool_dropAnItem(aChar, 1, true)
		Deadpool_updateStat(aSession, aChar, DEADPOOL_SOLEILBET, 1)
	end
	DeadpoolTuto["chipPiles"] = "done"
	tellTutorialText("DEADPOOLTUTO_TUTO2")
	local bets = {}
	bets["dataTime"] = tostring(Deadpool_getTimeUTCinMS())
	bets["nextDeathBet"] = nextDeathBet
	DeadpoolData[aSession][aChar]["bets"][aBetChar] = bets
	setDeadpoolData(aSession, aChar, "credits", afterTransactionCredits)
	Deadpool_PlaySound(865, "SFX")
	prepareAndSendSimpleDeadpoolDataToRaid(DeadpoolGlobal_SessionId, aChar)
	generateDeadpoolTable()
end

function Deadpool_updateStat(aDeadpoolSessionId, aChar, aStat, aValue)
	local isNotBoss = (aChar ~= "boss")
	local achievementPopped = false
	local statValue = Deadpool_tonumberzeroonblankornil(getDeadpoolData(aDeadpoolSessionId, aChar, aStat)) + aValue
	setDeadpoolData(aDeadpoolSessionId, aChar, aStat, statValue)
	if isNotBoss then
		local achiever = getDeadpoolData(aDeadpoolSessionId, aStat, "achiever")
		if not achiever or achiever == "" then
			if deadpoolAchievements[aStat] then
				if statValue >= deadpoolAchievements[aStat]["value"] then
					local noNotif = (not DeadpoolOptionsData and not DeadpoolOptionsData["DeadpoolAchievementAnnounceDisabled"] and not (DeadpoolOptionsData["DeadpoolAchievementAnnounceDisabled"] == true))
						or (UnitGUID("boss1") and DeadpoolOptionsData["DeadpoolNotificationsInBossFightsDisabled"])
						--if not noNotif then
							--EZBlizzUiPop_ToastFakeAchievementNew(Deadpool, deadpoolAchievements[aStat]["label"], 3456, true, 15, string.format(L["NEW_TITLE_FOR"], aChar), function()  Deadpool:DeadpoolShow()  end)
						--end
					if noNotif then
						Deadpool:Print(string.format(L["NEW_TITLE_FOR"], aChar)..L["SPACE_BEFORE_DOT"]..": "..deadpoolAchievements[aStat]["label"])
					end
					if CustomAchiever and Deadpool_isPlayerCharacter(aChar) then
						CustAc_CompleteAchievement(aStat, nil, noNotif, DeadpoolOptionsData["DeadpoolSoundsDisabled"])
					elseif not noNotif then
						EZBlizzUiPop_ToastFakeAchievementNew(Deadpool, deadpoolAchievements[aStat]["label"], 3456, not DeadpoolOptionsData["DeadpoolSoundsDisabled"], 4, string.format(L["NEW_TITLE_FOR"], aChar), function()  Deadpool:DeadpoolShow()  end)
					end
					setDeadpoolData(aDeadpoolSessionId, aStat, "achiever", aChar)
					achievementPopped = true
					prepareAndSendSimpleDeadpoolDataToRaid(DeadpoolGlobal_SessionId, aStat)
				end
			end
		end
	end
	return achievementPopped and isNotBoss
end

function Deadpool_prepareStats()
	local winsStats = ""
	local gainsStats = ""
	local firstDeathStats = ""
	local deathsStats = ""
	local lostItemsStats = ""
	local earningsStats = ""
	local lossesStats = ""
	for index,value in pairs(DeadpoolData[DeadpoolGlobal_SessionId]) do
		local stat = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, index, DEADPOOL_WINS))
		local highestStat = 0
		local highestStatPlayer = nil
		if stat > 0 then
			winsStats = winsStats.."  "..playerNameOrBankerName(index)..L["SPACE_BEFORE_DOT"]..": "..stat.."|n"
		end
		stat = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, index, DEADPOOL_CREDITSGAIN))
		if stat > 0 then
			gainsStats = gainsStats.."  "..playerNameOrBankerName(index)..L["SPACE_BEFORE_DOT"]..": "..stat..deadpoolChipTextureString.."|n"
		end
		stat = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, index, DEADPOOL_FIRSTDEATH))
		if stat > 0 then
			firstDeathStats = firstDeathStats.."  "..playerNameOrBankerName(index)..L["SPACE_BEFORE_DOT"]..": "..stat.."|n"
		end
		stat = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, index, DEADPOOL_DEATHS))
		if stat > 0 then
			deathsStats = deathsStats.."  "..playerNameOrBankerName(index)..L["SPACE_BEFORE_DOT"]..": "..stat.."|n"
		end
		stat = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, index, DEADPOOL_LOSTITEMS))
		if stat > 0 then
			lostItemsStats = lostItemsStats.."  "..playerNameOrBankerName(index)..L["SPACE_BEFORE_DOT"]..": "..stat.."|n"
		end
		stat = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, index, DEADPOOL_BALANCE))
		if stat > 0 then
			earningsStats = earningsStats.."  "..playerNameOrBankerName(index)..L["SPACE_BEFORE_DOT"]..": "..stat..deadpoolChipTextureString.."|n"
		end
		if stat < 0 then
			lossesStats = lossesStats.."  "..playerNameOrBankerName(index)..L["SPACE_BEFORE_DOT"]..": "..(-stat)..deadpoolChipTextureString.."|n"
		end
	end

	local stats = "|cFF00FF00"..L["DEADPOOLCOLLUMNS_STATS_WINS"].."|r|n"
	stats = stats..winsStats
	stats = stats.."|n|cFF00FF00"..L["DEADPOOLCOLLUMNS_STATS_CREDITSGAIN"].."|r|n"
	stats = stats..gainsStats
	stats = stats.."|n|cFF00FF00"..L["DEADPOOLCOLLUMNS_STATS_FIRSTDEATH"].."|r|n"
	stats = stats..firstDeathStats
	stats = stats.."|n|cFF00FF00"..L["DEADPOOLCOLLUMNS_STATS_DEATHS"].."|r|n"
	stats = stats..deathsStats
	stats = stats.."|n|cFF00FF00"..L["DEADPOOLCOLLUMNS_STATS_LOSTITEMS"].."|r|n"
	stats = stats..lostItemsStats
	stats = stats.."|n|cFF00FF00"..L["DEADPOOLCOLLUMNS_STATS_EARNINGS"].."|r|n"
	stats = stats..earningsStats
	stats = stats.."|n|cFF00FF00"..L["DEADPOOLCOLLUMNS_STATS_LOSSES"].."|r|n"
	stats = stats..lossesStats
	return stats
end

function Deadpool_dropAnItem(aChar, numberOfItems, getNoNewCredits)
	local enoughItems = true
	local newCredits = 0
	local offItemsNumber = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, aChar, "offItemsNumber"))
	if not offItemsNumber then
		offItemsNumber = 0
	end
	if offItemsNumber + numberOfItems <= Deadpool_countTableElements(deadpoolUndressingOrder) then
		local credits = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, aChar, "credits"))
		if not getNoNewCredits then
			newCredits = DEADPOOL_GARMENT_REWARD * numberOfItems
		end
		setDeadpoolData(DeadpoolGlobal_SessionId, aChar, "offItemsNumber", offItemsNumber + numberOfItems)
		Deadpool_updateStat(DeadpoolGlobal_SessionId, aChar, DEADPOOL_LOSTITEMS, numberOfItems)
		setDeadpoolData(DeadpoolGlobal_SessionId, aChar, "credits", credits + newCredits)
		DeadpoolSummaryFrame_Update()
		Deadpool_PlaySound(1202, "SFX")
	else
		Deadpool_Error(L["NOT_ENOUGH_ITEMS"])
		enoughItems = false
	end
	dpShowModel(aChar)
	return enoughItems, newCredits
end

function Deadpool_tonumberzeroonblankornil(aString)
	if aString and aString ~= "" then
		return tonumber(aString)
	else
		return 0
	end
end

function Deadpool_getTimeUTCinMS()
	return tostring(time(date("!*t")))
end

function Deadpool_getMostRecentTimedValue(myValueTime, newValueTime, forceNew)
	local myValue, myDataTime, newValue, newDataTime
	local myValueIsObsolete = false

	if myValueTime then
		myValue, myDataTime = strsplit("|", myValueTime, 2)
	end
	if newValueTime then
		newValue, newDataTime = strsplit("|", newValueTime, 2)
		myValueIsObsolete = true
	end
	if myDataTime and newDataTime and myDataTime ~= "" and newDataTime ~= "" then
		myDataTime = tonumber(myDataTime)
		newDataTime = tonumber(newDataTime)
		if not forceNew and myDataTime >= newDataTime then
			newValue = myValue
			newDataTime = myDataTime
			myValueIsObsolete = false
		end
	end
	
	local returnedValue = newValue
	if newDataTime and newDataTime ~= "" then
		returnedValue = returnedValue.."|"..newDataTime
	end

	return returnedValue, myValueIsObsolete
end

function Deadpool_upperCase(aText)
	local newText = ""
	if aText then
		retOK, ret = pcall(Deadpool_upperCaseBusiness, aText)
		if retOK then
			newText = ret
		else
			newText = aText
		end
	end
	return newText
end

function Deadpool_upperCaseBusiness(aText)
	return string.utf8upper(aText)
end

function Deadpool_GetLocale(key)
	return L[key]
end

function Deadpool_PlaySound(soundID, channel, forcePlay)
	if forcePlay or not DeadpoolOptionsData or not DeadpoolOptionsData["DeadpoolSoundsDisabled"] or not (DeadpoolOptionsData["DeadpoolSoundsDisabled"] == true) then
		PlaySound(soundID, channel)
	end
end

function Deadpool_PlaySoundFile(soundFile, channel, forcePlay)
	if soundHandle then
		StopSound(soundHandle)
	end
	if forcePlay or not DeadpoolOptionsData or not DeadpoolOptionsData["DeadpoolSoundsDisabled"] or not (DeadpoolOptionsData["DeadpoolSoundsDisabled"] == true) then
		willPlay, soundHandle = PlaySoundFile("Interface\\AddOns\\Deadpool\\sound\\"..soundFile.."_"..GetLocale()..".ogg", channel, _, true)
		if not willPlay then
			willPlay, soundHandle = PlaySoundFile("Interface\\AddOns\\Deadpool\\sound\\"..soundFile..".ogg", channel, _, true)
		end
	end
	return soundHandle
end

function Deadpool_PlaySoundFileId(soundFileId, channel, forcePlay)
	if soundHandle then
		StopSound(soundHandle)
	end
	if forcePlay or not DeadpoolOptionsData or not DeadpoolOptionsData["DeadpoolSoundsDisabled"] or not (DeadpoolOptionsData["DeadpoolSoundsDisabled"] == true) then
		PlaySoundFile(soundFileId, channel)
	end
	return soundHandle
end

function Deadpool_PlayRandomSound(soundFileIdBank, channel, forcePlay)
	local sound = math.random(1, #soundFileIdBank)
	return Deadpool_PlaySoundFileId(soundFileIdBank[sound], channel)
end

function Deadpool_isPartyMember(aChar)
	return aChar == "player" or UnitInParty(aChar) or UnitInRaid(aChar)
end

function SimpleRound (val, valStep)
	return floor(val/valStep)*valStep
end

function isInstanceAtLevel(level)
	if level then
		local _, instanceType, difficultyID , _, _, _, _, instanceID, _, lfgDungeonID = GetInstanceInfo()
		if instanceType == "raid" then
			local _, _, _, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel
			if lfgDungeonID then
				_, _, _, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel = GetLFGDungeonInfo(lfgDungeonID)
			elseif instanceID and difficultyID and dpInstanceIDList[instanceID.."-"..difficultyID] then
				_, _, _, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel = GetLFGDungeonInfo(dpInstanceIDList[instanceID.."-"..difficultyID])
			end
			if maxRecLevel and level <= maxRecLevel then
				return true
			end
		end
	end
	return false
end
