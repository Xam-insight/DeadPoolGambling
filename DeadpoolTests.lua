if DeadpoolGlobal_Debug then

function Deadpool:Test(nbPlayers)--/run Deadpool:Test(14) /run Deadpool:TestBetPlayers()
	if not dpFakeCharInfo then
		hooksecurefunc("getDeadpoolRosterInfo", function()
			Deadpool:TestAddPlayers(nbPlayers)
		end)
	end
	generateDeadpoolTable()
end

function Deadpool:TestAddPlayers(nbPlayers)
	if not dpFakeCharInfo then
		Deadpool:TestBuildFakePlayers()
		for k, v in pairs(dpFakeCharInfo) do
			DeadpoolData[DeadpoolGlobal_SessionId][k] = nil
		end
	end
	local nb = 0
	for k, v in pairs(dpFakeCharInfo) do
		nb = nb + 1
		if nb > nbPlayers then
			break
		end
		deadpoolCharInfo[k] = v
	end
end

function Deadpool:TestBetPlayers()
	local keys = {}
    for k, v in pairs(deadpoolCharInfo) do
        keys[#keys+1] = k
    end
	for k, v in pairs(deadpoolCharInfo) do
		local randTime = math.random(1, 5)
		C_Timer.After(randTime, function()
			local randBet = math.random(1, #keys)
			if keys[randBet] ~= k then
				setDeadpoolBetLocally(DeadpoolGlobal_SessionId, k, keys[randBet], math.random(1, 20), 0)
				setDeadpoolData(DeadpoolGlobal_SessionId, k, "credits", 0)
				generateDeadpoolTable()
			end
		end)
	end
end

function Deadpool:TestBuildFakePlayers()
	dpFakeCharInfo = {
		["Xamhunter"] = {
			["classFileName"] = "HUNTER",
			["race"] = 1,
			["groupRole"] = "DAMAGER",
			["gender"] = 1,
			["groupRank"] = "raid1",
			["localName"] = "Xamhunter",
		},
		["Xamwarlock"] = {
			["classFileName"] = "WARLOCK",
			["race"] = 2,
			["groupRole"] = "DAMAGER",
			["gender"] = 0,
			["groupRank"] = "raid2",
			["localName"] = "Xamwarlock",
		},
		["Xampriest"] = {
			["classFileName"] = "PRIEST",
			["race"] = 3,
			["groupRole"] = "HEALER",
			["gender"] = 1,
			["groupRank"] = "raid3",
			["localName"] = "Xampriest",
		},
		["Xampaladin"] = {
			["classFileName"] = "PALADIN",
			["race"] = 4,
			["groupRole"] = "TANK",
			["gender"] = 0,
			["groupRank"] = "raid4",
			["localName"] = "Xampaladin",
			},
		["Xammage"] = {
			["classFileName"] = "MAGE",
			["race"] = 5,
			["groupRole"] = "DAMAGER",
			["gender"] = 1,
			["groupRank"] = "raid5",
			["localName"] = "Xammage",
			},
		["Xamrogue"] = {
			["classFileName"] = "ROGUE",
			["race"] = 6,
			["groupRole"] = "DAMAGER",
			["gender"] = 0,
			["groupRank"] = "raid6",
			["localName"] = "Xamrogue",
		},
		["Xamdruid"] = {
			["classFileName"] = "DRUID",
			["race"] = 7,
			["groupRole"] = "HEALER",
			["gender"] = 1,
			["groupRank"] = "raid7",
			["localName"] = "Xamdruid",
		},
		["Xamshaman"] = {
			["classFileName"] = "SHAMAN",
			["race"] = 8,
			["groupRole"] = "DAMAGER",
			["gender"] = 0,
			["groupRank"] = "raid1",
			["localName"] = "Xamshaman",
		},
		["Xamwarriora"] = {
			["classFileName"] = "WARRIOR",
			["race"] = 9,
			["groupRole"] = "TANK",
			["gender"] = 1,
			["groupRank"] = "raid8",
			["localName"] = "Xamwarriora",
		},
		["Xamwarriorb"] = {
			["classFileName"] = "WARRIOR",
			["race"] = 10,
			["groupRole"] = "DAMAGER",
			["gender"] = 0,
			["groupRank"] = "raid9",
			["localName"] = "Xamwarriorb",
		},
		["Xamdeathknight"] = {
			["classFileName"] = "DEATHKNIGHT",
			["race"] = 11,
			["groupRole"] = "DAMAGER",
			["gender"] = 1,
			["groupRank"] = "raid10",
			["localName"] = "Xamdeathknight",
		},
		["Xamevokera"] = {
			["classFileName"] = "EVOKER",
			["race"] = 52,
			["groupRole"] = "DAMAGER",
			["gender"] = 0,
			["groupRank"] = "raid11",
			["localName"] = "Xamevokera",
		},
		["Xamevokerh"] = {
			["classFileName"] = "EVOKER",
			["race"] = 70,
			["groupRole"] = "DAMAGER",
			["gender"] = 1,
			["groupRank"] = "raid12",
			["localName"] = "Xamevokerh",
		},
	}
end

end
