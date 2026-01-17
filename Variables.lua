local L = LibStub("AceLocale-3.0"):GetLocale("Deadpool", true)
local XITK = LibStub("XamInsightToolKit")

Deadpool_name = "Dead Pool"
Deadpool_logo = Deadpool_name.." |T137008:16|t |cffffffffG|r|cff666666a|r|cffffffffm|r|cff666666b|r|cffffffffl|r|cff666666i|r|cffffffffn|r|cff666666g|r"

StaticPopupDialogs["NOT_ENOUGH_CREDITS"] = {
	text = Deadpool_logo.."|n|n"..L["NOT_ENOUGH_CREDITS"],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function (self, data)
		local enoughItems, newCredits = Deadpool_dropAnItem(data["char"], data["howManyGarment"])
		if enoughItems then
			saveDeadpoolBets(data["session"], data["char"], data["betChar"], data["nextDeathBet"], data["afterTransactionCredits"] + newCredits)
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

-- StaticPopupDialogs["TRULY_UNEQUIP_ITEMS"] = {
	-- text = Deadpool_logo.."|n|n"..L["TRULY_UNEQUIP_ITEMS"],
	-- button1 = YES,
	-- button2 = NO,
	-- OnAccept = function (self)
		-- setUnequipItemsValue(true)
		-- DeadpoolTrulyUnequip_UpdateCooldown(DeadpoolTrulyUnequipSwitch)
		-- Deadpool:UnequipLostItems()
	-- end,
	-- OnCancel = function (self)
		-- setUnequipItemsValue(false)
	-- end,
	-- timeout = 0,
	-- whileDead = true,
	-- hideOnEscape = true,
	-- preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
-- }

StaticPopupDialogs["DEADPOOL_SELL_ITEM_WARNING"] = {
    text = Deadpool_logo.."|n|n"..L["DEADPOOL_SELL_ITEM_WARNING"],
    button1 = YES,
    button2 = NO,
    OnAccept = function(self, data)
        -- Quit DEADPOOL_TRULYUNEQUIP mode
		setDeadpoolData(DeadpoolGlobal_SessionId, XITK.playerCharacter(), DEADPOOL_TRULYUNEQUIP, nil)
		Deadpool:UnequipLostItems(event)
    end,
    OnCancel = function()
        -- Do nothing
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	hasItemFrame = 1,
	compactItemFrame = true,
}

deadpoolUndressingOrder = {
	[1] = { ["slot"] = INVSLOT_HEAD,      ["slotLabel"] = "Head"      },
	[2] = { ["slot"] = INVSLOT_WAIST,     ["slotLabel"] = "Waist"     },
	[3] = { ["slot"] = INVSLOT_SHOULDER,  ["slotLabel"] = "Shoulders" },
	[4] = { ["slot"] = INVSLOT_FEET,      ["slotLabel"] = "Feet"      },
	[5] = { ["slot"] = INVSLOT_HAND,      ["slotLabel"] = "Hands"     },
	[6] = { ["slot"] = INVSLOT_WRIST,     ["slotLabel"] = "Wrists"    },
	[7] = { ["slot"] = INVSLOT_CHEST,     ["slotLabel"] = "Chest"     },
	[8] = { ["slot"] = INVSLOT_LEGS,      ["slotLabel"] = "Legs"      },
}

DEADPOOLDATA_VERSION = "deadpoolVersion"

DEADPOOL_GARMENT_NUMBER = 8
DEADPOOL_GARMENT_REWARD = 20
DEADPOOL_BANK_PERCENT = 0--15/100
DEADPOOL_INITIAL_MONEY = 20

DEADPOOL_SOLEIL = "Soleîl"

DEADPOOL_BANKER = "GALLYWIX"
DEADPOOL_BANKER_ID = 136683
DEADPOOL_BANKER_NAME = XITK.GetNameFromNpcID(DEADPOOL_BANKER_ID) -- GALLYWIX
if not DEADPOOL_BANKER_NAME or DEADPOOL_BANKER_NAME == "" or DEADPOOL_BANKER_NAME:match("^%s+$") then
	DEADPOOL_BANKER_NAME = "Galliwix"
end

DEADPOOL_WINS         = "Wins"
DEADPOOL_FIRSTDEATH   = "FirstDeath"
DEADPOOL_CREDITSGAIN  = "CreditsGain"
DEADPOOL_LOSTITEMS    = "LostItems"
DEADPOOL_TRULYUNEQUIP = "trulyUnequipItems"
DEADPOOL_SOLEILBET    = "SoleilBet"
DEADPOOL_DEATHS       = "Deaths"
DEADPOOL_DEATHSONBOSS = "DeathsOnBoss"
DEADPOOL_BALANCE      = "Balance"
DEADPOOL_WINNER       = "Winner"

DEADPOOL_ISBESTACHIVERACHIEVEMENT = "IsBestAchieverAchievement"

deadpoolAchievements = {
	[DEADPOOL_WINS]        = { ["value"] = 20,                      ["label"] = L["DEADPOOL_ACHIEVEMENT_WINS"]         , ["desc"] = string.format(L["DEADPOOL_ACHIEVEMENT_WINS_DESC"], 20)                          , ["icon"] = 134211, ["points"] = 10 },
	[DEADPOOL_FIRSTDEATH]  = { ["value"] = 10,                      ["label"] = L["DEADPOOL_ACHIEVEMENT_FIRSTDEATH"]   , ["desc"] = string.format(L["DEADPOOL_ACHIEVEMENT_FIRSTDEATH_DESC"], 10)                    , ["icon"] = 237272, ["points"] = 10 },
	[DEADPOOL_BALANCE]     = { ["value"] = 100,                     ["label"] = L["DEADPOOL_ACHIEVEMENT_CREDITSBALACE"], ["desc"] = string.format(L["DEADPOOL_ACHIEVEMENT_CREDITSBALACE_DESC"], 100)                , ["icon"] = 133785, ["points"] = 10 },
	[DEADPOOL_LOSTITEMS]   = { ["value"] = DEADPOOL_GARMENT_NUMBER, ["label"] = L["DEADPOOL_ACHIEVEMENT_LOSTITEMS"]    , ["desc"] = string.format(L["DEADPOOL_ACHIEVEMENT_LOSTITEMS_DESC"], DEADPOOL_GARMENT_NUMBER), ["icon"] = 136047, ["points"] = 10 },
	[DEADPOOL_SOLEILBET]   = { ["value"] = 5,                       ["label"] = L["DEADPOOL_ACHIEVEMENT_SOLEILBET"]    , ["desc"] = string.format(L["DEADPOOL_ACHIEVEMENT_SOLEILBET_DESC"], 5, DEADPOOL_SOLEIL, 5)  , ["icon"] = 134909, ["points"] = 0  },

	[DEADPOOL_WINNER]      = { [DEADPOOL_ISBESTACHIVERACHIEVEMENT] = true },
}

deadpoolChipTextureString = " |TInterface\\AddOns\\Deadpool\\art\\chip:16:16:0:0|t"

deathQuotes = {
	1799662, -- Bwonsamdi
	1875111,
	1875116,
	1875119,
	1875120,
	2016732,
	2016735,
	2016740,
	2016742,
	2016743,
	2016744,
	2016745,
	2016746,
	2016747,
	552503,  -- Illidan
	1124453, -- Archimonde
	543348,  -- Abedneum
	543373,	 -- aeonis
	543567,	 -- algalontheobserver
	543652,	 -- ambassadorhellmaw
	543824,	 -- anetheron
	543913,  -- anraphe
	543936,  -- anubarak
	544509,  -- attumenthehuntsman
	544523,  -- auriaya
	544829,  -- baltharus
	544932,  -- baronrivendare
	545031,  -- blackhearttheinciter
	545885,  -- captainscarloc
	546220,  -- chronolordepoch
	547361,  -- doomwalker
	547362,
	547934,  -- eadricthepure
	547943,  -- edwinvancleef
	547958,  -- elderbrightleaf
	547991,  -- eldernadox
	548108,  -- epochhunter
	548399,  -- executus
	548565,  -- faerlina
	551339,  -- gruulthedragonkiller
	551509,  -- halion
	551853,  -- highlordmograine
	553083,  -- keleseth
	553090,
	553615,  -- ladyvashj
	554068,  -- lichking
	554260,  -- loken/
	554362,  -- lorthemar
	554396,
	554608,  -- maidenofgrief
	554770,  -- malganis
	554797,
	554883,  -- malygos
	555173,  -- mekgineerthermaplug
	555829,  -- morogrimtidewalker
	555843,  -- mothershahraz
	556495,  -- nethermancersepethrea
	556505,  -- nexusprinceshafar
	556795,  -- noththefrozen
	557688,  -- omortheunscarred
	558034,  -- paletress
	558107,  -- patchwerk
	558111,  -- pathaleonthecalculator
	558270,  -- princekaelthas
	558332,  -- princemalchezzar
	558339,
	558404,  -- professorputricide
	558427,
	558519,  -- ptah
	558795,  -- ragnaros
	558767,
	558994,  -- razuvious
	559479,  -- runemastermolgeim
	559480,
	559695,  -- scourgelordtyrannus
	560326,  -- sindragosa
	560909,  -- steelbreaker
	562132,  -- thorngrinthetender
	563331,  -- valithriadreamwalker
	563635,  -- vazrudentheherald
	563769,  -- vesperon
	563783,  -- voidreaver
	563784,
	563940,  -- warbringeromrogg
	563988,  -- warpsplinter
	564057,  -- watchkeepergargolmar
	572400,  -- azshara
	572734,  -- murozond
	617589,  -- mastersnowdrift
	621118,  -- instructorchillheart
	622565,  -- subetaitheswift
	624685,  -- shaofviolence
	631110,  -- garajal
	631112,
	633245,  -- armsmasterharlan
	633787,  -- brotherkorloff
	641712,  -- jandicebarov
	773375,  -- lorthemar
	798515,  -- malakk
	1041362, -- zaela
	1045675, -- gorashan
	1058360, -- volrath
	1123842, -- jubeithos
	1123970, -- kilrog
	1124067, -- iskar
	1124380, -- velhar
	1124453, -- archimonde
	558409,  -- hputricide
	3749977, -- Vesiphone KO
	3749978, -- KO
	3749981, -- KO
	5778825, -- queen_ansurek KO
	6183810, -- vexie_fullthrottle
	6213556, -- mugzee
	6213585,
	6213587,
	6183842, -- chrome_king_gallywix
	6183847,
	6727548, -- plexus_sentinel
	6727550,
	6727765, -- nexus-king salhadaar
	6727766,
	6728215, -- dimensius
	6729191,
	--/run XITK.PlaySoundFileID(6213556) /run PlaySoundFile("sound\\creature\\dimensius\\vo_1120_dimensius_6729194.ogg")
}

--[[
function testSoundFile(setID) -- /run testSoundFile(3749977)
	willPlay, soundHandle = PlaySoundFile(setID, "MASTER")
	if willPlay then
		print(willPlay, soundHandle, setID)
	end
end

function testSoundFileDeathId(setID, timer)
	if deathQuotes[setID] then
		testSoundFile(deathQuotes[setID])
		C_Timer.After(timer, function()
			testSoundFileDeathId(setID + 1, timer)
		end)
	end
end

function testSoundFiles(timer) -- /run testSoundFiles(5)
	testSoundFileDeathId(1, timer)
end
--]]
