Deadpool = LibStub("AceAddon-3.0"):NewAddon("Dead Pool", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Deadpool", true)
local AceGUI = LibStub("AceGUI-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")

DeadpoolGlobal_CommPrefix = "Deadpool"

--DeadpoolGlobal_Debug = true

deadpoolFramePool = {}
local deadpoolDressUpModelPool = {}

DeadpoolGlobal_BetweenObjectsGap = 11

DEADPOOL_NUM_LINES = 40
local DEADPOOL_LINE_WIDTH = 96

local DEADPOOL_COL1_WIDTH = 110 -- + Portrait !
local DEADPOOL_COL2_WIDTH = 4*32 + 5
local DEADPOOL_COL4_WIDTH = 40
local DEADPOOL_ALLCOLS_WIDTH = DEADPOOL_COL1_WIDTH -- + Portrait !
	+ DEADPOOL_COL2_WIDTH
	+ DEADPOOL_COL4_WIDTH

deadpoolList = {}
local deadpoolLines = {}

function Deadpool:OnInitialize()
	-- Called when the addon is loaded
	self:RegisterChatCommand("deadpool", "DeadpoolChatCommand")
    self:RegisterComm(DeadpoolGlobal_CommPrefix, "ReceiveDataFrame_OnEvent")
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "ReloadData")
    self:RegisterEvent("RAID_TARGET_UPDATE", "ReloadData")
	self:RegisterEvent("UNIT_HEALTH", "CheckDeath")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CallForDeadpoolData")
	--self:RegisterEvent("ADDON_LOADED", "CallForDeadpoolData")
	self:RegisterEvent("GROUP_JOINED", "CallForDeadpoolData")
	--self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "DeadpoolMouseOverUnit")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "DeadpoolPlayerEntersCombat")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "DeadpoolPlayerLeavesCombat")
	--self:RegisterEvent("PARTY_MEMBER_ENABLE", "generateDressUpModel")
	self:RegisterEvent("UNIT_PORTRAIT_UPDATE", "generateDressUpModel") -- reloadDeadpoolPortraits
	--self:RegisterEvent("PLAYER_ALIVE", "OnPlayerAlive")
	--self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("BOSS_KILL", "BossKill")
	
	self:RegisterEvent("READY_CHECK", "BetReminder");
	self:RegisterEvent("READY_CHECK_FINISHED", "BetReminderClose")

	self:RegisterEvent("PLAYER_ALIVE", "UnequipLostItems")
	self:RegisterEvent("PLAYER_UNGHOST", "UnequipLostItems")
	
	self:RegisterEvent("GROUP_LEFT", "LeaveGroup")
	
	hooksecurefunc("UnitFrame_UpdateTooltip", function()
		Deadpool:DeadpoolMouseOverUnit()
	end)

	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
		Deadpool:MerchantFrameUpdate()
	end)
end

function Deadpool:OnEnable()
	-- Called when the addon is enabled
	--Deadpool:Print("Activated")
    if not DeadpoolFrame then
        --Deadpool:Print("Frame loading")
        loadDeadpoolOptions()
        initDeadpoolBusinessObjects()
        
		--NewDeadpoolMiniFrame
		deadpoolMiniFrame()

		--NewDeadpoolFrame
		DeadpoolFrame = CreateFrame("Frame", "DeadpoolFrame", UIParent, "DeadpoolFrameTemplate")
		DeadpoolFrame:SetScale(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolScale"] or 1.0)
		DeadpoolFrame.alphaFunc = setDeadpoolFrameAlpha
		
		DeadpoolFrame.ClosePanelButton:SetScript("OnClick", function(self)
			hideDeadpoolWindow()
		end)
		DeadpoolFrame:SetHitRectInsets(-10, -10, -10, -10)

		applyDeadpoolWindowOptions()
		applyMiniDeadpoolWindowOptions()
		
		DeadpoolFrame.NineSlice.Text:SetText("Dead Pool");
		
		DeadpoolFrame.Lock:SetAttribute("tooltip", L["LOCKBUTTON_TOOLTIP"])
		DeadpoolFrame.Lock:SetAttribute("tooltipDetail", { L["LOCKBUTTON_TOOLTIPDETAIL"] })
		
		local deadpoolOptionsButton = createDeadpoolOptionsButton(DeadpoolFrame)
        local announceDeadpoolSessionButton = createAnnounceDeadpoolSessionButton(DeadpoolFrame, deadpoolOptionsButton)
        local deadpoolSearchBox = createDeadpoolSearchBox(DeadpoolFrame)

		local columnsTitle1 = CreateFrame("Button", "DeadpoolColumnsTitle1Frame", DeadpoolFrame, "DeadpoolColumnHeaderTemplate")
		columnsTitle1:SetPoint("TOPLEFT", 10, -23)
        columnsTitle1:SetText(L["DEADPOOLCOLLUMNS_CHARACTER"])
		WhoFrameColumn_SetWidth(columnsTitle1, DEADPOOL_COL1_WIDTH + 25)
		columnsTitle1.sortType = "character"

		local columnsTitle2 = CreateFrame("Button", "DeadpoolColumnsTitle2Frame", DeadpoolFrame, "DeadpoolColumnHeaderTemplate")
		columnsTitle2:SetPoint("LEFT", columnsTitle1, "RIGHT", -2, 0)
        columnsTitle2:SetText(L["DEADPOOLCOLLUMNS_NEXTDEATHBETS"])
		WhoFrameColumn_SetWidth(columnsTitle2, DEADPOOL_COL2_WIDTH)
		columnsTitle2.sortType = "nbDeathBets"

		local columnsTitle3 = CreateFrame("Button", "DeadpoolColumnsTitle4Frame", DeadpoolFrame, "DeadpoolColumnHeaderTemplate")
		columnsTitle3:SetPoint("LEFT", columnsTitle2, "RIGHT", -2, 0)
        columnsTitle3:SetText(L["DEADPOOLCOLLUMNS_ODDS"])
		WhoFrameColumn_SetWidth(columnsTitle3, DEADPOOL_COL4_WIDTH)
		columnsTitle3.sortType = "odds"

		DeadpoolFrameSummaryButton:SetPoint("LEFT", columnsTitle3, "RIGHT", 0, 0)

		DeadpoolFrameInsideFrame:SetWidth(DEADPOOL_ALLCOLS_WIDTH + 13 + 30)
		local scrollFrame = CreateFrame("ScrollFrame", "DeadpoolScrollFrame",
			DeadpoolFrameInsideFrame, "FauxScrollFrameTemplate")
		scrollFrame:SetPoint("TOPLEFT", DeadpoolFrameInsideFrame ,"TOPLEFT", 0, -5)
		scrollFrame:SetPoint("BOTTOMRIGHT", DeadpoolFrameInsideFrame ,"BOTTOMRIGHT", -27, 3)
		scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
			FauxScrollFrame_OnVerticalScroll(self, offset, DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"], Deadpool_UpdateScrollFrame)
		end)
 
		for i = 1, DEADPOOL_NUM_LINES do
			local line = CreateFrame("Button", "DeadpoolLine"..i, scrollFrame:GetParent(), "DeadpoolLineTemplate")
			if i == 1 then
				line:SetPoint("TOPLEFT", scrollFrame, 3, 0)
			else
				line:SetPoint("TOPLEFT", deadpoolLines[i - 1], "BOTTOMLEFT")
			end
			line:SetSize(scrollFrame:GetParent():GetWidth() - 29, DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"])
			line:Hide()
			deadpoolLines[i] = line
		end
		
		if not DeadpoolBankerButton then
			local template = "LFGListCategoryTemplate"
			if not LFGListCategoryTemplate then
				template = "LFGListCategoryTemplateClassic"
			end
			DeadpoolBankerButton = CreateFrame("BUTTON", nil, DeadpoolFrame, template)
			DeadpoolBankerButton:SetPoint("TOP", DeadpoolFrameInsideFrame, "BOTTOM", 0, 0)
			DeadpoolBankerButton.Icon:SetAtlas("groupfinder-button-dungeons")
			DeadpoolBankerButton:SetScript("OnClick", function(self)
				Deadpool_PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "SFX", true)
				askBankerHisBet(DeadpoolGlobal_SessionId, deadpoolList)
			end)
			DeadpoolBankerButton.Label:SetAllPoints(DeadpoolBankerButton)
			DeadpoolBankerButton.Label:SetJustifyH("CENTER")
		end

		local dropDownframe = LibDD:Create_UIDropDownMenu("DeadpoolDropDown", parent_frame)
		dropDownframe.xOffset = 0
		dropDownframe.yOffset = -1
		DeadpoolDropDown.point = "TOPLEFT"
		DeadpoolDropDown.relativePoint = "RIGHT"
		LibDD:UIDropDownMenu_Initialize(dropDownframe, DeadpoolDropDown_Update, "MENU")
		--LibDD:UIDropDownMenu_OnHide(_G["L_DropDownList1"])
										
		Deadpool:Print(L["DEADPOOL_WELCOME"])
    end

	--Deadpool_CustomAchiever is deprecated
	--if not CustomAchieverData then
	--	CustAcAddon = "Deadpool_CustomAchiever"
	--	C_AddOns.LoadAddOn(CustAcAddon)
	--end
	if CustomAchieverData then
		CustAc_CreateOrUpdateCategory("Deadpool", nil, "Dead Pool Gambling")
		for k,v in pairs(deadpoolAchievements) do
			if k ~= DEADPOOL_WINNER then
				CustAc_CreateOrUpdateAchievement(k, "Deadpool", v["icon"], v["points"], v["label"], v["desc"], v["label"], true)
			end
		end
	end
end

function Deadpool:BetReminder()
	local trulyUnequipItems = getDeadpoolData(DeadpoolGlobal_SessionId, Deadpool_playerCharacter(), DEADPOOL_TRULYUNEQUIP)
	if trulyUnequipItems and trulyUnequipItems == "true" then
		DeadpoolTrulyUnequip_Glow(DeadpoolTrulyUnequipSwitch)
	end
	if DeadpoolOptionsData["DeadpoolBetReminder"] and not Deadpool_hasPlayed(DeadpoolGlobal_SessionId, Deadpool_playerCharacter()) then
		if DeadpoolFrame:IsShown() then 
			ScriptAnimationUtil.ShakeFrameRandom(DeadpoolFrame, 5, .7, .05)
		else
			if not MiniDeadpoolFrame:IsShown() then 
				MiniDeadpoolFrame:Show()
			end
			ScriptAnimationUtil.ShakeFrameRandom(MiniDeadpoolFrame, 5, .7, .05)
		end
	end
end

function Deadpool:BetReminderClose()
	local trulyUnequipItems = getDeadpoolData(DeadpoolGlobal_SessionId, Deadpool_playerCharacter(), DEADPOOL_TRULYUNEQUIP)
	if trulyUnequipItems and trulyUnequipItems == "true" then
		DeadpoolTrulyUnequip_Glow(DeadpoolTrulyUnequipSwitch)
	end
	if not DeadpoolWindow[Deadpool_WindowsOptions]["MiniDeadpoolShown"] then
		MiniDeadpoolFrame:Hide()
	end
end

function Deadpool:OnPlayerAlive(event)
	--self:UnregisterEvent("PLAYER_ALIVE")
	self:UnequipLostItems(event)
	self:DeadpoolShow(not DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolShown"], DeadpoolWindow[Deadpool_WindowsOptions]["MiniDeadpoolShown"])
end

function applyDeadpoolWindowOptions(withSummaryFrame)
	setDeadpoolFrameAlpha()
    DeadpoolFrame:SetWidth(DEADPOOL_ALLCOLS_WIDTH + 24 + 30)
	DeadpoolFrame:SetResizeBounds(0, 151 + DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"], nil, GetScreenHeight() - 32)
	
	retOK, ret = pcall(callbackDeadpoolWindow, DeadpoolFrame)
    
	DeadpoolFrame:SetHeight(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolHeight"])
	local windowLocked = DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolWindowLocked"]
	DeadpoolFrameLock:SetChecked(windowLocked)
	DeadpoolFrame.canMove = not windowLocked
	DPEnableMouse(DeadpoolFrame, not windowLocked)
	if windowLocked then
		DeadpoolFrame.SizeDown:Hide()
	else
		DeadpoolFrame.SizeDown:Show()
	end
	
	if withSummaryFrame then
		DeadpoolFrameSummaryButton_Onclick(not DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolSummaryFrameShown"])
	end
end

function hideDeadpoolWindow()
	hideAllDressUpModels()
	PanelTemplates_SetTab(DeadpoolSummaryFrame, 1)
	DeadpoolFrame:Hide()
	DeadpoolResultsTooltip:Hide()
	DeadpoolWinnerTooltip:Hide()
	DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolShown"] = nil
end

--[[ Tip from Moop (Fatality)
function Deadpool:COMBAT_LOG_EVENT_UNFILTERED()
	--timestamp, event, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
	_, event, _, _, _, _, _, _, destName, _, _ = CombatLogGetCurrentEventInfo()

	if event == "UNIT_DIED" then
		if not (UnitInRaid(destName) or UnitInParty(destName)) then return end
		Deadpool:CheckDeath()
		AnnounceDeath()
	end
end
--]]
function callbackDeadpoolWindow(aFrame)
	local mini = ""
	if aFrame == MiniDeadpoolFrame and DeadpoolWindow[Deadpool_WindowsOptions]["mini-point"] then
		mini = "mini-"
	end
	if DeadpoolWindow[Deadpool_WindowsOptions][mini.."point"] then
		aFrame:ClearAllPoints()
		aFrame:SetPoint(DeadpoolWindow[Deadpool_WindowsOptions][mini.."point"], UIParent,
			DeadpoolWindow[Deadpool_WindowsOptions][mini.."relativePoint"], DeadpoolWindow[Deadpool_WindowsOptions][mini.."xOffset"], DeadpoolWindow[Deadpool_WindowsOptions][mini.."yOffset"])
	end
end

function deadpoolSaveWindowPosition()
	local point, _, relativePoint, xOffset, yOffset = DeadpoolFrame:GetPoint()
	DeadpoolWindow[Deadpool_WindowsOptions]["point"] = point
	DeadpoolWindow[Deadpool_WindowsOptions]["relativePoint"] = relativePoint
	DeadpoolWindow[Deadpool_WindowsOptions]["xOffset"] = xOffset
	DeadpoolWindow[Deadpool_WindowsOptions]["yOffset"] = yOffset
	
	point, _, relativePoint, xOffset, yOffset = MiniDeadpoolFrame:GetPoint()
	DeadpoolWindow[Deadpool_WindowsOptions]["mini-point"] = point
	DeadpoolWindow[Deadpool_WindowsOptions]["mini-relativePoint"] = relativePoint
	DeadpoolWindow[Deadpool_WindowsOptions]["mini-xOffset"] = xOffset
	DeadpoolWindow[Deadpool_WindowsOptions]["mini-yOffset"] = yOffset
end

function Deadpool:ReloadData()
	DeadpoolBetButton:Hide()
	generateDeadpoolTable()
end

function Deadpool:DeadpoolChatCommand(input)
	Deadpool:DeadpoolShow(DeadpoolWindow[Deadpool_WindowsOptions]["MiniDeadpoolShown"], DeadpoolWindow[Deadpool_WindowsOptions]["MiniDeadpoolShown"])
end

function Deadpool_CompartmentFunc(addon, clickButton)
	if clickButton == "RightButton" then
		Deadpool_OpenOptions()
	else
		Deadpool_ToggleFrame()
	end
end

function Deadpool_CompartmentFuncOnEnter(addon, button)
	local tooltip = C_AddOns.GetAddOnMetadata("Deadpool", "Title")
	local tooltipDetail = L["MINIMAP_TOOLTIP1"]
	local tooltipDetail2 = L["MINIMAP_TOOLTIP2"]
	
	button:SetAttribute("tooltip", tooltip)
	button:SetAttribute("tooltipDetail", { tooltipDetail, tooltipDetail2 })
	DeadpoolIconButtonEnter(button, "LEFT")
end

function Deadpool_CompartmentFuncOnLeave()
	DeadpoolTooltip:Hide()
end

function Deadpool_ToggleFrame()
	if DeadpoolFrame:IsShown() then
		hideDeadpoolWindow()
	elseif MiniDeadpoolFrame:IsShown() then
		MiniDeadpoolFrame:Hide()
	else
		Deadpool:DeadpoolShow(DeadpoolWindow[Deadpool_WindowsOptions]["MiniDeadpoolShown"], DeadpoolWindow[Deadpool_WindowsOptions]["MiniDeadpoolShown"])
	end
end
				
function Deadpool_OpenOptions()
	ACD:Open("Dead Pool")
end

function Deadpool:DeadpoolShow(noMain, mini)
	if not noMain and DeadpoolFrame and not DeadpoolFrame:IsShown() then
		setDeadpoolFrameAlpha()
		DeadpoolFrame:Show()
		DeadpoolShowResults()
		DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolShown"] = true
		DeadpoolFrameSummaryButton_Onclick(not DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolSummaryFrameShown"])
		tellTutorialText("DEADPOOLTUTO_TUTO1")
		dpShowHelpTip("DEADPOOLTUTO_MINIMIZE")
	end
	if mini then
		setMiniDeadpoolFrameAlpha()
		MiniDeadpoolFrame:Show()
		DeadpoolShowResults()
		DeadpoolWindow[Deadpool_WindowsOptions]["MiniDeadpoolShown"] = true
		DeadpoolTuto["DEADPOOLTUTO_MINIMIZE"] = "Done"
	end
	generateDeadpoolTable()
	--dpInitializeHelp()
end

function Deadpool:CheckDeath(event, unitId)
	if unitId then
		if Deadpool_isPartyMember(unitId) then
			local playerId = UnitIsPlayer(unitId) and Deadpool_fullName(unitId)
			if not playerId then
				_, _, _, _, _, playerId = strsplit("-", UnitGUID(unitId))
			end
			local online = UnitIsConnected(unitId)
			local isDead = UnitIsDeadOrGhost(unitId)
			if playerId then
				local isAlreadyDead = getDeadpoolData(DeadpoolGlobal_SessionId, playerId, "isAlreadyDead")
				deadpoolUpdateStatus(playerId, unitId, online, isDead, isAlreadyDead)
			end
		end
	else
		local numGroupMembers = GetNumGroupMembers()
		if numGroupMembers > 0 then
			for i = 1, numGroupMembers do
				local name, _, _, _, _, _, _, online, isDead, _, _ = GetRaidRosterInfo(i)
				local playerId = DeadpoolFollowersId[name] or Deadpool_addRealm(name)
				isDead = isDead or (getDeadpoolCharInfo(playerId, "groupRank") and UnitIsGhost(getDeadpoolCharInfo(playerId, "groupRank")))
				local isAlreadyDead = getDeadpoolData(DeadpoolGlobal_SessionId, playerId, "isAlreadyDead")
				local groupRank = getDeadpoolCharInfo(playerId, "groupRank")
				deadpoolUpdateStatus(playerId, groupRank, online, isDead, isAlreadyDead)
			end
		else
			local playerId = Deadpool_playerCharacter()
			if playerId then
				local isDead = UnitIsDeadOrGhost("player")
				local isAlreadyDead = getDeadpoolData(DeadpoolGlobal_SessionId, playerId, "isAlreadyDead")
				deadpoolUpdateStatus(playerId, "player", true, isDead, isAlreadyDead)
			end
		end
	end
end

function deadpoolUpdateStatus(playerId, groupRank, online, isDead, isAlreadyDead)
	if playerId then
		if isDead then
			setDeadpoolData(DeadpoolGlobal_SessionId, playerId, "isDead", "true")
			if not isAlreadyDead or isAlreadyDead == "false" then
				setDeadpoolData(DeadpoolGlobal_SessionId, playerId, "isAlreadyDead", "true")
				deadpoolCharacterIsDead(DeadpoolGlobal_SessionId, playerId)
			end
		else
			setDeadpoolData(DeadpoolGlobal_SessionId, playerId, "isDead", "false")
			if online then
				setDeadpoolData(DeadpoolGlobal_SessionId, playerId, "isAlreadyDead", "false")
			end
		end
		if groupRank then
			if UnitAffectingCombat(groupRank) then
				setDeadpoolData(DeadpoolGlobal_SessionId, playerId, "inCombat", "true")
			else
				setDeadpoolData(DeadpoolGlobal_SessionId, playerId, "inCombat", "false")
			end
		end
	end
end

local dpCharacterDied
function deadpoolCharacterIsDead(aDeadpoolSessionId, aChar, alternativeName)
	DeadpoolSavedBets = {}
	Deadpool_updateStat(aDeadpoolSessionId, aChar, DEADPOOL_DEATHS, 1)
	if UnitGUID("boss1") then
		Deadpool_updateStat(aDeadpoolSessionId, aChar, DEADPOOL_DEATHSONBOSS, 1)
	end
	local totalNextDeathBets, nbNextDeathBets = getDeadpoolTotalBets(aDeadpoolSessionId, "nextDeathBet")
	local totalUniqueGambleOnChar, totalUniqueGamble = getDeadpoolTotalUniqueGamble(aDeadpoolSessionId, aChar)
	if totalNextDeathBets > 0 or totalUniqueGamble > 0 then
		dpCharacterDied = true
		local tooltip = L["DEADPOOLUI_RESULTS"]
		local tooltipDetail = {}
		local tooltipDetailGreen = {}
		local tooltipDetailRed = {}
		local deadpoolLog = nil
		local totalNextDeathBetsOnChar, nbNextDeathBetsOnChar = getDeadpoolTotalBets(aDeadpoolSessionId, "nextDeathBet", aChar)
		local bankCredits = getDeadpoolData(aDeadpoolSessionId, "Bank", "credits")
		bankCredits = Deadpool_tonumberzeroonblankornil(bankCredits)

		local _, _, totalBets = getDeadpoolBets(aDeadpoolSessionId, Deadpool_playerCharacter())
		local uniqueGamble = getDeadpoolData(aDeadpoolSessionId, Deadpool_playerCharacter(), "uniqueGamble")
		if (uniqueGamble and uniqueGamble ~= "")
			or totalBets > 0 then
			local quotePlayed = tellTutorialText("DEADPOOLTUTO_TUTO3", true)
			if not quotePlayed and Deadpool_isPlayerCharacter(aChar) and not DeadpoolOptionsData["DeadpoolDeathQuotesDisabled"] then
				local isInBossCombat = UnitGUID("boss1")
				if not isInBossCombat then
					Deadpool_PlayRandomSound(deathQuotes, "Dialog")
				end
			else
				Deadpool_PlaySound(41361, "SFX") -- For after TWW: PlaySound(283499)
			end
		end
		local bankWins = true
		local bankLoses = false
		local playersGain = 0
		local dataTime = tostring(Deadpool_getTimeUTCinMS())
		if aDeadpoolSessionId and aChar and DeadpoolData
			and DeadpoolData[aDeadpoolSessionId] then
			local shortName = alternativeName or getDeadpoolCharInfo(aChar, "localName")
			local gender = Deadpool_tonumberzeroonblankornil(getDeadpoolCharInfo(aChar, "gender"))
			deadpoolLog = shortName..L["DEADPOOLLOGS_DIED"..gender]
			if alternativeName then
				deadpoolLog = alternativeName.." "..BOSS_DEAD:lower().."."
			end
			Deadpool:Print(deadpoolLog)
			local deathAchievementPopped = Deadpool_updateStat(aDeadpoolSessionId, aChar, DEADPOOL_FIRSTDEATH, 1)
			if not deathAchievementPopped then
				if not DeadpoolOptionsData or not DeadpoolOptionsData["DeadpoolDeathAnnounceDisabled"] or not (DeadpoolOptionsData["DeadpoolDeathAnnounceDisabled"] == true) then
					local noNotif = (UnitGUID("boss1") and DeadpoolOptionsData["DeadpoolNotificationsInBossFightsDisabled"])
						or (C_ChallengeMode.IsChallengeModeActive() and not DeadpoolOptionsData["DeadpoolNotificationsInMythicPlus"])
					if not noNotif then
						EZBlizzUiPop_ToastFakeAchievementNew(Deadpool, deadpoolLog, 3456, false, 4, "Dead Pool", function()  Deadpool:DeadpoolShow()  end)
					end
				end
			end
			table.insert(tooltipDetail, deadpoolLog)
			-- Winner popup
			local winner = nil
			local winnerValue = nil
			for k1 in pairs(DeadpoolData[aDeadpoolSessionId]) do
				if "Bank" ~= k1 and "DeadpoolSessionId" ~= k1 and not deadpoolAchievements[k1] then
					shortName = getDeadpoolCharInfo(k1, "localName")
					local bets = DeadpoolData[aDeadpoolSessionId][k1]["bets"]
					uniqueGamble = getDeadpoolData(aDeadpoolSessionId, k1, "uniqueGamble")
					local playerBets = 0
					local playerActualCredits = Deadpool_tonumberzeroonblankornil(getDeadpoolData(aDeadpoolSessionId, k1, "credits"))
					local deadpoolGain_ = 0
					if bets then
						for k2 in pairs(bets) do
							local playerNextDeathBetsOnChar = getDeadpoolPlayerBetsOnChar(aDeadpoolSessionId, k1, k2)
							playerBets = playerBets + playerNextDeathBetsOnChar
							if k2 == aChar and playerNextDeathBetsOnChar > 0 then
								deadpoolGain_ = deadpoolGain(totalNextDeathBets, playerNextDeathBetsOnChar, totalNextDeathBetsOnChar)
								playersGain = playersGain + deadpoolGain_
								deadpoolLog = shortName..L["DEADPOOLLOGS_WINS"]..deadpoolGain_..string.format(L["DEADPOOLLOGS_CHIPS"], deadpoolChipTextureString)
								Deadpool:Print(deadpoolLog)
								table.insert(tooltipDetailGreen, deadpoolLog)
								bankWins = false
								Deadpool_updateStat(aDeadpoolSessionId, k1, DEADPOOL_WINS, 1)
							end
							bets[k2]["nextDeathBet"] = nil
							bets[k2]["dataTime"] = dataTime
						end
					end
					if uniqueGamble and uniqueGamble ~= "" then
						if bankCredits > 0 and uniqueGamble == aChar then
							local deadpoolBankGain = deadpoolGain(bankCredits, 1, totalUniqueGambleOnChar)
							local possibleGarmentsBack = 0
							if deadpoolBankGain > 2*DEADPOOL_INITIAL_MONEY-1 then
								local offItemsNumber = Deadpool_tonumberzeroonblankornil(getDeadpoolData(aDeadpoolSessionId, k1, "offItemsNumber"))
								possibleGarmentsBack = min(floor((deadpoolBankGain - DEADPOOL_INITIAL_MONEY) / DEADPOOL_GARMENT_REWARD), offItemsNumber)
								possibleGarmentsBack = max(0,possibleGarmentsBack) -- to prevent les than 0 value
								if possibleGarmentsBack > 0 then
									setDeadpoolData(aDeadpoolSessionId, k1, "offItemsNumber", offItemsNumber - possibleGarmentsBack)
									--setDeadpoolData(aDeadpoolSessionId, k1, DEADPOOL_LOSTITEMS, offItemsNumber - garmentsBack)
								end
								deadpoolBankGain = deadpoolBankGain - possibleGarmentsBack * DEADPOOL_GARMENT_REWARD
							end

							deadpoolLog = shortName..L["DEADPOOLLOGS_WINS"]..deadpoolBankGain..string.format(L["DEADPOOLLOGS_BANKCHIPS"], deadpoolChipTextureString)
							deadpoolGain_ = deadpoolGain_ + deadpoolBankGain
							Deadpool:Print(deadpoolLog)
							table.insert(tooltipDetailRed, deadpoolLog)
							bankLoses = true
							Deadpool_updateStat(aDeadpoolSessionId, k1, DEADPOOL_WINS, 1)
						end
						setDeadpoolData(aDeadpoolSessionId, k1, "uniqueGamble", "")
					end
					if deadpoolGain_ > 0 then
						setDeadpoolData(aDeadpoolSessionId, k1, "credits", playerActualCredits + deadpoolGain_)
						Deadpool_updateStat(aDeadpoolSessionId, k1, DEADPOOL_CREDITSGAIN, deadpoolGain_)	
					end
					-- Balance
					local balance = deadpoolGain_ - playerBets
					if balance ~= 0 then
						Deadpool_updateStat(aDeadpoolSessionId, k1, DEADPOOL_BALANCE, balance)
					end
					-- Winner popup
					local playerBalance = Deadpool_tonumberzeroonblankornil(getDeadpoolData(aDeadpoolSessionId, k1, DEADPOOL_BALANCE))
					if not winnerValue or playerBalance > winnerValue then
						winner = k1
						winnerValue = playerBalance
					elseif winnerValue and playerBalance == winnerValue then
						winner = L["DEADPOOLUI_WINNER_NONE"]
					end
					-- Loose > Drop item
					if aChar == k1 and playerBets > 0 then
						Deadpool_dropAnItem(aChar, 1, true)
						deadpoolLog = string.format(L["DEADPOOLLOGS_HASBETANDDIED"], getDeadpoolCharInfo(aChar, "localName"))
						Deadpool:Print(deadpoolLog)
						table.insert(tooltipDetailRed, deadpoolLog)
					end
				end
			end
			-- Winner popup
			setDeadpoolData(aDeadpoolSessionId, DEADPOOL_WINNER, "achiever", winner)
			setDeadpoolData(aDeadpoolSessionId, DEADPOOL_WINNER, "value", winnerValue)
		end
		if bankLoses then
			bankCredits = 0
		end
		if bankWins and totalNextDeathBets > 0 then
			bankCredits = bankCredits + totalNextDeathBets
			deadpoolLog = L["DEADPOOLLOGS_NOWINNER"].." "..L["DEADPOOLLOGS_THEBANK"]..L["DEADPOOLLOGS_COLLECTS"]..totalNextDeathBets..string.format(L["DEADPOOLLOGS_CHIPS"], deadpoolChipTextureString)
			Deadpool:Print(deadpoolLog)
			table.insert(tooltipDetailRed, deadpoolLog)
		else
			local bankGain = totalNextDeathBets - playersGain
			if bankGain > 0 then
				bankCredits = bankCredits + bankGain
				deadpoolLog = L["DEADPOOLLOGS_THEBANK"]..L["DEADPOOLLOGS_COLLECTS"]..bankGain..string.format(L["DEADPOOLLOGS_CHIPS"], deadpoolChipTextureString)
				Deadpool:Print(deadpoolLog)
				table.insert(tooltipDetailRed, deadpoolLog)
			end
		end
		setDeadpoolData(aDeadpoolSessionId, "Bank", "credits", bankCredits)
		DeadpoolResultsTooltip:SetAttribute("tooltip", tooltip)
		DeadpoolResultsTooltip:SetAttribute("tooltipDetail", tooltipDetail)
		DeadpoolResultsTooltip:SetAttribute("tooltipDetailGreen", tooltipDetailGreen)
		DeadpoolResultsTooltip:SetAttribute("tooltipDetailRed", tooltipDetailRed)
		DeadpoolShowResults((not UnitGUID("boss1") or not DeadpoolOptionsData["DeadpoolNotificationsInBossFightsDisabled"])
						and (not C_ChallengeMode.IsChallengeModeActive() or DeadpoolOptionsData["DeadpoolNotificationsInMythicPlus"]))
	end
	generateDeadpoolTable()
end

function showDeadpoolPlayerDetails(line)
	if line then
		selectedDeadpoolCharacter = line:GetAttribute("fullName")
	end
	DeadpoolSummaryFrame_Update()
end

function deadpoolUndressModel(modelFrame, offItemsNumber)
	if modelFrame and modelFrame:GetObjectType() == "DressUpModel" then
		modelFrame:UndressSlot(INVSLOT_TABARD)
		modelFrame:UndressSlot(INVSLOT_BACK)
		--modelFrame:UndressSlot(INVSLOT_MAINHAND) -- causes crashes when player is disconnected or phased
		--modelFrame:UndressSlot(INVSLOT_OFFHAND)
		--modelFrame:UndressSlot(INVSLOT_RANGED)

		local durabilityFrame = "DeadpoolSummaryFramePlayerDurabilityFrame"
		if modelFrame:GetParent() ~= DeadpoolSummaryFramePlayer then
			durabilityFrame = "DPDurabilityFrame"
			DPDurabilityFrame:SetParent(modelFrame)
			DPDurabilityFrame:ClearAllPoints()
			DPDurabilityFrame:SetPoint("RIGHT", modelFrame, "RIGHT", 0, 0)
			DPDurabilityFrame:Show()
		else
			DPDurabilityFrame:Hide()
			DeadpoolSummaryFramePlayerDurabilityFrame:Show()
		end
		DeadpoolDurability(durabilityFrame, offItemsNumber)

		if offItemsNumber then
			local numberOfSlots = Deadpool_countTableElements(deadpoolUndressingOrder)
			if offItemsNumber > numberOfSlots then
				offItemsNumber = numberOfSlots
			end

			if offItemsNumber > 6 then
				modelFrame:UndressSlot(INVSLOT_BODY)
			end

			for i = 1, offItemsNumber do
				modelFrame:UndressSlot(deadpoolUndressingOrder[i]["slot"])
			end
		end
	end
end

function DeadpoolDurability(frame, offItemsNumber)
	if frame then
		_G[frame.."Head"]:SetVertexColor(DeadpoolDurabilityColor(1.0))
		_G[frame.."Shoulders"]:SetVertexColor(DeadpoolDurabilityColor(1.0))
		_G[frame.."Chest"]:SetVertexColor(DeadpoolDurabilityColor(1.0))
		_G[frame.."Wrists"]:SetVertexColor(DeadpoolDurabilityColor(1.0))
		_G[frame.."Hands"]:SetVertexColor(DeadpoolDurabilityColor(1.0))
		_G[frame.."Waist"]:SetVertexColor(DeadpoolDurabilityColor(1.0))
		_G[frame.."Legs"]:SetVertexColor(DeadpoolDurabilityColor(1.0))
		_G[frame.."Feet"]:SetVertexColor(DeadpoolDurabilityColor(1.0))

		if offItemsNumber then
			for i = 1, offItemsNumber do
				local texture = _G[frame..deadpoolUndressingOrder[i]["slotLabel"]]
				if texture then
					texture:SetVertexColor(DeadpoolDurabilityColor(0.3))
				end
			end
		end
	end
end

function DeadpoolDurabilityColor(alpha)
	return 0.75, 0.5, 1.0, alpha
end

function DeadpoolOptionsButtonClick(self)
	Deadpool_OpenOptions()
end

function AnnounceDeadpoolSessionButton_OnClick()
	if DeadpoolResultsTooltip:IsShown() or DeadpoolWinnerTooltip:IsShown() then
		DeadpoolResultsTooltip:SetAttribute("shown", nil)
		DeadpoolResultsTooltip:Hide()
		DeadpoolWinnerTooltip:SetAttribute("shown", nil)
		DeadpoolWinnerTooltip:Hide()
	else
		DeadpoolShowResults(true)
	end
end

function DeadpoolBetsOddsInfoEnter(self)
	local character = self:GetAttribute("Character")
	local trulyUnequipItems = getDeadpoolData(DeadpoolGlobal_SessionId, character, DEADPOOL_TRULYUNEQUIP)
	local tooltipDetailPurple = trulyUnequipItems and trulyUnequipItems == "true" and L["ENABLE_TRULY_UNEQUIP_ITEMS_ENABLED"].."#"..(getDeadpoolData(DeadpoolGlobal_SessionId, character, "offItemsNumber") or "0")
	if tooltipDetailPurple then
		self:SetAttribute("tooltipDetailPurple",
			{
				tooltipDetailPurple
			}
		)
	else
		self:SetAttribute("tooltipDetailPurple", nil)
	end
end

function DeadpoolIconButtonEnter(self)
	local tooltip = self:GetAttribute("tooltip")
	local tooltipDetail = self:GetAttribute("tooltipDetail")
	local tooltipDetailGreen = self:GetAttribute("tooltipDetailGreen")
	local tooltipDetailRed = self:GetAttribute("tooltipDetailRed")
	local tooltipDetailBlue = self:GetAttribute("tooltipDetailBlue")
	local tooltipDetailPurple = self:GetAttribute("tooltipDetailPurple")
	DeadpoolTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
	if tooltip then
		DeadpoolTooltip:SetText(tooltip)
		if tooltipDetail then
			for index,value in pairs(tooltipDetail) do
				DeadpoolTooltip:AddLine(value, 1.0, 1.0, 1.0)
			end
		end
		if tooltipDetailGreen then
			for index,value in pairs(tooltipDetailGreen) do
				DeadpoolTooltip:AddLine(value, 0.0, 1.0, 0.0)
			end
		end
		if tooltipDetailRed then
			for index,value in pairs(tooltipDetailRed) do
				DeadpoolTooltip:AddLine(value, 1.0, 0.0, 0.0)
			end
		end
		if tooltipDetailBlue then
			for index,value in pairs(tooltipDetailBlue) do
				local leftText, rightText = strsplit("#", value, 2)
				DeadpoolTooltip:AddDoubleLine(leftText, rightText, 0.25, 0.78, 0.92, 0.25, 0.78, 0.92)
			end
		end
		if tooltipDetailPurple then
			for index,value in pairs(tooltipDetailPurple) do
				local leftText, rightText = strsplit("#", value, 2)
				DeadpoolTooltip:AddDoubleLine(leftText, rightText, 0.74, 0.50, 0.99, 0.74, 0.50, 0.99)
			end
		end
		DeadpoolTooltip:Show()
	end
end

local function DeadpoolGetLastPopup()
	local lastPopup
	for i = STATICPOPUP_NUMDIALOGS, 1, -1 do
		local frame = _G["StaticPopup"..i]
		if frame and frame:IsShown() then
			lastPopup = frame
			break
		end
	end
	return lastPopup
end

function DeadpoolShowResults(force)
	local parentFrame = DeadpoolFrame
	local yStep = 0
	if MiniDeadpoolFrame:IsShown() then
		parentFrame = MiniDeadpoolFrame
		DeadpoolResultsTooltip:SetScale(0.6)
		DeadpoolWinnerTooltip:SetScale(0.6)
		yStep = 20
	else
		DeadpoolResultsTooltip:SetScale(0.8)
		DeadpoolWinnerTooltip:SetScale(0.8)
	end
	DeadpoolResultsTooltip:ClearLines()
	local tooltip = DeadpoolResultsTooltip:GetAttribute("tooltip")
	local tooltipDetail = DeadpoolResultsTooltip:GetAttribute("tooltipDetail")
	local tooltipDetailGreen = DeadpoolResultsTooltip:GetAttribute("tooltipDetailGreen")
	local tooltipDetailRed = DeadpoolResultsTooltip:GetAttribute("tooltipDetailRed")
	if tooltip and (Deadpool_countTableElements(tooltipDetail) > 0 or Deadpool_countTableElements(tooltipDetailGreen) > 0) then
		if parentFrame:IsShown() then
			DeadpoolResultsTooltip:SetOwner(parentFrame, "ANCHOR_BOTTOM", 0, -12 + yStep)
		else
			local lastFrame = DeadpoolGetLastPopup()
			if ( lastFrame ) then
				DeadpoolResultsTooltip:SetOwner(lastFrame, "ANCHOR_BOTTOM", 0, -35)
			else
				DeadpoolResultsTooltip:SetOwner(UIParent, "ANCHOR_TOP", 0, -201)
			end
		end
		DeadpoolResultsTooltip:AddLine(tooltip, 1.0, 0.82, 0.0)
		if tooltipDetail then
			for index,value in pairs(tooltipDetail) do
				DeadpoolResultsTooltip:AddLine(value, 1.0, 1.0, 1.0)
			end
		end
		if tooltipDetailGreen then
			for index,value in pairs(tooltipDetailGreen) do
				DeadpoolResultsTooltip:AddLine(value, 0.0, 1.0, 0.0)
			end
		end
		if tooltipDetailRed then
			for index,value in pairs(tooltipDetailRed) do
				DeadpoolResultsTooltip:AddLine(value, 1.0, 0.0, 0.0)
			end
		end
		if force or DeadpoolResultsTooltip:GetAttribute("shown") then
			UIFrameFadeRemoveFrame(DeadpoolResultsTooltip)
			DeadpoolResultsTooltip:Show()
			DeadpoolResultsTooltip:SetAttribute("shown", true)
		end
	end
	
	DeadpoolWinnerTooltip:ClearLines()
	tooltip = getDeadpoolData(DeadpoolGlobal_SessionId, DEADPOOL_WINNER, "achiever")
	if tooltip then
		if parentFrame:IsShown() then
			DeadpoolWinnerTooltip:SetOwner(parentFrame, "ANCHOR_TOP", 0, 0 - yStep)
		else
			local lastFrame = DeadpoolGetLastPopup()
			if ( lastFrame ) then
				DeadpoolWinnerTooltip:SetOwner(lastFrame, "ANCHOR_BOTTOM", 0, 0)
			else
				DeadpoolWinnerTooltip:SetOwner(UIParent, "ANCHOR_TOP", 0, -135)
			end
		end
		DeadpoolWinnerTooltip:AddDoubleLine(L["DEADPOOLUI_WINNER"], playerNameOrBankerName(tooltip), 1.0, 0.82, 0.0, 1.0, 1.0, 1.0)
		if force or DeadpoolWinnerTooltip:GetAttribute("shown") then
			UIFrameFadeRemoveFrame(DeadpoolWinnerTooltip)
			DeadpoolWinnerTooltip:Show()
			DeadpoolWinnerTooltip:SetAttribute("shown", true)
		end
	else
		DeadpoolWinnerTooltip:SetAttribute("shown", nil)
		DeadpoolWinnerTooltip:Hide()
	end
end

function DeadpoolIconButtonLeave(self)
	DeadpoolTooltip:Hide()
end

function getFontStringFromDeadpoolFramePool(id, name, template, deadpoolLine)
	if not deadpoolFramePool[id] then
		deadpoolFramePool[id] = {}
	end
	if not deadpoolFramePool[id][name] then
		deadpoolFramePool[id][name] = _G[deadpoolLine:GetName()]:CreateFontString(name, "ARTWORK", template)
	end
	return deadpoolFramePool[id][name]
end

function getElementFromDeadpoolFramePool(type, id, name, template, parent, columnNumber)
	local elementName = name
	if columnNumber then
		elementName = columnNumber
	end
	if not deadpoolFramePool[id] then
		deadpoolFramePool[id] = {}
	end
	if not deadpoolFramePool[id][elementName] then
		deadpoolFramePool[id][elementName] = CreateFrame(type, name, _G[parent], template)
	end
	return deadpoolFramePool[id][elementName]
end

function createDeadpoolLine(aDeadpoolSessionId, indexCharac, fullName, deadpoolLine, resizing, isMiniLine)
	
	local miniLabel = ""
	local ligneHeight = DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"]
	local ligneWidth = DEADPOOL_ALLCOLS_WIDTH - 8 + 30
	local betweenObjectsGap = DeadpoolGlobal_BetweenObjectsGap
	if isMiniLine then
		miniLabel = "Mini"
		ligneHeight = miniDeadpoolLineHeight
		ligneWidth = MiniDeadpoolFrame.Inset:GetWidth()
		betweenObjectsGap = DeadpoolGlobal_MiniBetweenObjectsGap
	end

	deadpoolLine:SetAttribute("fullName", fullName)

	if selectedDeadpoolLine and fullName == selectedDeadpoolCharacter then
		selectedDeadpoolLine = deadpoolLine
		deadpoolLine.Selected:Show()
	else
		deadpoolLine.Selected:Hide()
	end

	local oddsInfoFrame = getElementFromDeadpoolFramePool("Button", indexCharac,
			miniLabel.."DeadpoolOddsInfoFrame"..indexCharac, "DeadpoolBetsOddsInfoTemplate", deadpoolLine:GetName())
	oddsInfoFrame:SetSize(deadpoolLine:GetHeight() - 2, deadpoolLine:GetHeight() - 2)
	if not resizing then
		_G[miniLabel.."DeadpoolOddsInfoFrame"..indexCharac.."_ChipPile"]:SetVertexColor(1, 1, 1)
	end
	
	local xValue = betweenObjectsGap

	if not isMiniLine then
		local roleButton, role = createDeadpoolRoleButton(aDeadpoolSessionId, fullName, indexCharac, xValue, deadpoolLine)
		xValue = roleButton:GetWidth() + 2*betweenObjectsGap
	end

	local fontstringLabel = miniLabel.."DPPlayerLabel"
	local fontstring = getFontStringFromDeadpoolFramePool(indexCharac, fontstringLabel, "DeadpoolPlayerLabelTemplate", deadpoolLine)
	local color = RAID_CLASS_COLORS[(getDeadpoolCharInfo(fullName, "classFileName") or "ROGUE")]
	fontstring:SetTextColor(color.r, color.g, color.b, 1.0)
	local charName = getDeadpoolCharInfo(fullName, "localName")
	local isDead = getDeadpoolData(aDeadpoolSessionId, fullName, "isDead")
	if isDead == "true" then
		local height = 14
		if not isMiniLine then
			height = Deadpool_tonumberzeroonblankornil(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"]) - 8
		end
		charName = charName.." |T137008:"..tostring(height).."|t"
	end
	if charName ~= "boss" then
		fontstring:SetText(charName)
	elseif isMiniLine then
		fontstring:SetText("|T521748:16:16:0:0|t "..L["NEXT_BOSS"])
	else
		fontstring:SetText(L["NEXT_BOSS"])
	end
	fontstring:SetPoint("LEFT", xValue, 0)
	fontstring:SetWidth(85 + 30 - ligneHeight)
	
	if not resizing then
		xValue = xValue + _G[fontstringLabel]:GetWidth()
		local playerCharacter = Deadpool_playerCharacter()
		local totalNextDeathBets, nbNextDeathBets = getDeadpoolTotalBets(aDeadpoolSessionId, "nextDeathBet")
		local totalNextDeathBetsOnChar, nbNextDeathBetsOnChar = getDeadpoolTotalBets(aDeadpoolSessionId, "nextDeathBet", fullName)
		local playerNextDeathBetsOnChar = getDeadpoolPlayerBetsOnChar(aDeadpoolSessionId, playerCharacter, fullName)
		local nbOf5 = floor(nbNextDeathBetsOnChar/5)
		local rest = nbNextDeathBetsOnChar - (5*nbOf5)
		for i = 1, 4 do
			local deadpoolBetCount = getElementFromDeadpoolFramePool("Frame", indexCharac,
				miniLabel.."DeadpoolBetCount"..indexCharac.."_"..i, "DeadpoolBetCountTemplate", deadpoolLine:GetName())
			deadpoolBetCount:SetPoint("LEFT", xValue, 0)
			deadpoolBetCount:SetHeight(ligneHeight)
			if isMiniLine then
				deadpoolBetCount:SetWidth(ligneHeight)
			end
			deadpoolBetCount:Show()
			_G[miniLabel.."DeadpoolBetCount"..indexCharac.."_"..i..miniLabel.."Texture"]:Hide()
			_G[miniLabel.."DeadpoolBetCount"..indexCharac.."_"..i.."Texture"]:Hide()
			local deadpoolBetCountTexture = _G[miniLabel.."DeadpoolBetCount"..indexCharac.."_"..i..miniLabel.."Texture"]
			if i <= nbOf5 then
				deadpoolBetCountTexture:SetTexCoord(0.625, 0.750, 0, 1)
			else
				if i == nbOf5 + 1 and rest > 0 then
					deadpoolBetCountTexture:SetTexCoord(0 + rest * .125, .125 + rest * .125, 0, 1)
				else
					deadpoolBetCountTexture:SetTexCoord(0, .125, 0, 1)
				end
			end
			deadpoolBetCountTexture:Show()
			xValue = xValue + deadpoolBetCount:GetWidth()
		end
		xValue = xValue + 10
	
		local odds = deadpoolOdds(totalNextDeathBets, totalNextDeathBetsOnChar)
		local betsOnCharVstotalBets = odds / Deadpool_nozero(totalNextDeathBets)
		local chipPileToShow = _G[miniLabel.."DeadpoolOddsInfoFrame"..indexCharac.."_ChipPile"]
		if isMiniLine then
			chipPileToShow:SetTexCoord(.875, 1, 0, 1)--Chip
		elseif betsOnCharVstotalBets < 0.05 then
			chipPileToShow:SetTexCoord(.125, .25, 0, 1)--1
		elseif betsOnCharVstotalBets < 0.1 then
			chipPileToShow:SetTexCoord(.25, .375, 0, 1)--2
		elseif betsOnCharVstotalBets < 0.32 then
			chipPileToShow:SetTexCoord(.375, .5, 0, 1)--3
		elseif betsOnCharVstotalBets < 0.49 then
			chipPileToShow:SetTexCoord(.5, .625, 0, 1)--4
		else
			chipPileToShow:SetTexCoord(.625, .75, 0, 1)--5
		end

		if playerNextDeathBetsOnChar > 0 then
			chipPileToShow:SetVertexColor(0.44, 0.86, 0.44)
		end
		chipPileToShow:Show()

		if isMiniLine then
			oddsInfoFrame:SetPoint("LEFT", -oddsInfoFrame:GetWidth(), 0)
		else
			oddsInfoFrame:SetPoint("LEFT", xValue, 0)
			xValue = xValue + oddsInfoFrame:GetWidth()
		end
		oddsInfoFrame:SetAttribute("tooltip", string.format(L["DEADPOOLCOLLUMNS_WHOM_ODDS"], getDeadpoolCharInfo(playerCharacter, "localName")))
		local oddsLib = string.format("%.1f", odds)
		oddsInfoFrame:SetAttribute("tooltipDetail", { L["DEADPOOLUI_BET"], L["DEADPOOLUI_BET2"]..oddsLib..L["DEADPOOLUI_BET3"] })
		if playerNextDeathBetsOnChar > 0 then
			oddsInfoFrame:SetAttribute("tooltipDetailGreen", { string.format(L["DEADPOOLUI_BET7"], playerNextDeathBetsOnChar, deadpoolChipTextureString), 
				L["DEADPOOLUI_BET4"]..playerNextDeathBetsOnChar.." x "..oddsLib })
		else
			oddsInfoFrame:SetAttribute("tooltipDetailGreen", { L["DEADPOOLUI_BET5"] })
		end
		oddsInfoFrame:SetAttribute("Character", fullName)

		local uniqueGamble = getDeadpoolData(aDeadpoolSessionId, playerCharacter, "uniqueGamble")
		if uniqueGamble and uniqueGamble == fullName then
			chipPileToShow:SetVertexColor(0.86, 0.44, 0.44)
			oddsInfoFrame:SetAttribute("tooltipDetailRed", { L["DEADPOOLUI_BET6"] })
		else
			oddsInfoFrame:SetAttribute("tooltipDetailRed", nil)
		end
		oddsInfoFrame:SetAttribute("tooltipDetailBlue",
			{
				L["DEADPOOLCOLLUMNS_STATS_FIRSTDEATH"].."#"..Deadpool_tonumberzeroonblankornil(getDeadpoolData(aDeadpoolSessionId, fullName, DEADPOOL_FIRSTDEATH)),
				L["DEADPOOLCOLLUMNS_STATS_DEATHS"].."#"..Deadpool_tonumberzeroonblankornil(getDeadpoolData(aDeadpoolSessionId, fullName, DEADPOOL_DEATHS)),
				L["DEADPOOLCOLLUMNS_STATS_DEATHSONBOSS"].."#"..Deadpool_tonumberzeroonblankornil(getDeadpoolData(aDeadpoolSessionId, fullName, DEADPOOL_DEATHSONBOSS))
			}
		)

		if not DeadpoolOptionsData["TutoDisabled"]
			and (not DeadpoolTuto
				or not DeadpoolTuto["chipPiles"]) then
			oddsInfoFrame.Flash:Show()
			oddsInfoFrame.FlashAnim:Play()
		else
			oddsInfoFrame.Flash:Hide()
			oddsInfoFrame.FlashAnim:Stop()
		end
	
		deadpoolLine:SetWidth(ligneWidth)
	end

	return xValue + betweenObjectsGap
end

function deadpoolOdds(totalNextDeathBets, totalNextDeathBetsOnChar)
	local odds = Deadpool_nozero(totalNextDeathBets * (1-DEADPOOL_BANK_PERCENT) / Deadpool_nozero(totalNextDeathBetsOnChar))
	if odds < 1 then
		odds = 1
	end
	return odds
end

function deadpoolGain(totalNextDeathBets, playerNextDeathBetsOnChar, totalNextDeathBetsOnChar)
	return floor(deadpoolOdds(totalNextDeathBets, totalNextDeathBetsOnChar) * playerNextDeathBetsOnChar)
end

function Deadpool_nozero(aNumber)
	if aNumber == 0 then
		return 1
	end
	return aNumber
end

function getDeadpoolPlayerBetsOnChar(aDeadpoolSessionId, aPlayer, aChar)
	local playerBetsOnChar = 0
	if aDeadpoolSessionId and aPlayer and DeadpoolData
		and DeadpoolData[aDeadpoolSessionId] and DeadpoolData[aDeadpoolSessionId][aPlayer]
		and DeadpoolData[aDeadpoolSessionId][aPlayer]["bets"] then

		for key,value in pairs(DeadpoolData[aDeadpoolSessionId][aPlayer]["bets"]) do
			if key == aChar then
				playerBetsOnChar = Deadpool_tonumberzeroonblankornil(value["nextDeathBet"])
			end
		end
	end
	return playerBetsOnChar
end

function Deadpool_hasPlayed(aDeadpoolSessionId, aPlayer)
	if aDeadpoolSessionId and aPlayer and DeadpoolData
			and DeadpoolData[aDeadpoolSessionId] and DeadpoolData[aDeadpoolSessionId][aPlayer] then
		if DeadpoolData[aDeadpoolSessionId][aPlayer]["bets"] then
			for key,value in pairs(DeadpoolData[aDeadpoolSessionId][aPlayer]["bets"]) do
				if Deadpool_tonumberzeroonblankornil(value["nextDeathBet"]) > 0 then
					return key
				end
			end
		end
		if DeadpoolData[aDeadpoolSessionId][aPlayer]["uniqueGamble"] then
			local uniqueGamble = getDeadpoolData(aDeadpoolSessionId, aPlayer, "uniqueGamble")
			if uniqueGamble and uniqueGamble ~= "" then
				return uniqueGamble
			end
		end
	end
	return nil
end

function getDeadpoolTotalBets(aDeadpoolSessionId, aBetType, aChar, aDeadpoolDataObject)
	local totalBets = 0
	local nbBets = 0
	if aDeadpoolDataObject == nil then
		aDeadpoolDataObject = DeadpoolData
	end
	if aDeadpoolSessionId and aBetType and aDeadpoolDataObject
		and aDeadpoolDataObject[aDeadpoolSessionId] then
		for k1 in pairs(aDeadpoolDataObject[aDeadpoolSessionId]) do
			local bets = aDeadpoolDataObject[aDeadpoolSessionId][k1]["bets"]
			if bets then
				for k2 in pairs(bets) do
					local betCredits = bets[k2][aBetType]
					if betCredits
						and (not aChar or aChar == k2)then
						local betCreditsValue = Deadpool_tonumberzeroonblankornil(betCredits)
						totalBets = totalBets + betCreditsValue
						if betCreditsValue > 0 then
							nbBets = nbBets + 1
						end
					end
				end
			end
		end
	end
	return totalBets, nbBets
end

function getDeadpoolTotalUniqueGamble(aDeadpoolSessionId, aChar, aDeadpoolDataObject)
	local totalBetsOnChar = 0
	local totalBets = 0
	if aDeadpoolDataObject == nil then
		aDeadpoolDataObject = DeadpoolData
	end
	if aDeadpoolSessionId and aChar and aDeadpoolDataObject
		and aDeadpoolDataObject[aDeadpoolSessionId] then
		for k1 in pairs(aDeadpoolDataObject[aDeadpoolSessionId]) do
			local uniqueGamble = getDeadpoolData(aDeadpoolSessionId, k1, "uniqueGamble", aDeadpoolDataObject)
			if uniqueGamble and uniqueGamble ~= "" then
				totalBets = totalBets + 1
				if uniqueGamble == aChar then
					totalBetsOnChar = totalBetsOnChar + 1
				end
			end
		end
	end
	return totalBetsOnChar, totalBets
end

function Deadpool_isPlayerCharacter(aName)
	return Deadpool_playerCharacter() == Deadpool_addRealm(aName)
end

local Deadpool_pc
function Deadpool_playerCharacter()
	if not Deadpool_pc then
		Deadpool_pc = Deadpool_fullName("player")
	end
	return Deadpool_pc
end

function ValidateDeadpoolBetButton_Onclick(self)
	local aSession = DeadpoolGlobal_SessionId
	local aChar = Deadpool_playerCharacter()
	local aBetChar = self:GetAttribute("characteriD")
	local aBet = DeadpoolSummaryFrameTargetNextDeathBet:GetText()

	if aChar then
		local _, _, bet = howManyGarmentToLose(aSession, aChar, aBetChar, aBet)
		DeadpoolSummaryFrameTargetNextDeathBet:SetText(bet)

		setDeadpoolBets(aSession, aChar, aBetChar, bet)
	end
end

function DeadpoolFrameSummaryButton_Onclick(hide, manualClick)
	local point, _, relativePoint, xOffset, yOffset = DeadpoolFrame:GetPoint()
	local frameOffset = DeadpoolSummaryFrame:GetWidth() + 1
	if hide then
		hideAllDressUpModels()
		DeadpoolFrame:SetWidth(DEADPOOL_ALLCOLS_WIDTH + 24 + 30)
		DeadpoolSummaryFrame:Hide()
		DeadpoolSummaryFrameTarget:Hide()
		DeadpoolSummaryFramePlayer:Hide()
		DeadpoolSummaryFrameStats:Hide()
		_G["DeadpoolFrameSummaryButtonArrow-Right"]:Show()
		_G["DeadpoolFrameSummaryButtonArrow-Left"]:Hide()
		if manualClick and (point == "CENTER" or point == "BOTTOM" or point == "TOP") then
			DeadpoolFrame:SetPoint(point, UIParent, relativePoint, xOffset - frameOffset/2, yOffset)
			deadpoolSaveWindowPosition()
		end
		DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolSummaryFrameShown"] = nil
	else
		DeadpoolFrame:SetWidth(DEADPOOL_ALLCOLS_WIDTH + 24 + 30 + frameOffset)
		DeadpoolSummaryFrame:Show()
		_G["DeadpoolFrameSummaryButtonArrow-Right"]:Hide()
		_G["DeadpoolFrameSummaryButtonArrow-Left"]:Show()
		if manualClick and (point == "CENTER" or point == "BOTTOM" or point == "TOP") then
			DeadpoolFrame:SetPoint(point, UIParent, relativePoint, xOffset + frameOffset/2, yOffset)
			deadpoolSaveWindowPosition()
		end
		DeadpoolSummaryFrame_Update()
	end
end

function createAnnounceDeadpoolSessionButton(parent, relativeTo)
	local name = "SessionTitleButton"
	local tooltip = L["ANNOUNCEDEADPOOLSESSIONBUTTON_TOOLTIP"]
	local tooltipDetail = L["ANNOUNCEDEADPOOLSESSIONBUTTON_TOOLTIPDETAIL"]

	local announceDeadpoolSessionButton = CreateFrame("Button", name, parent, "AnnounceDeadpoolSessionButtonTemplate")
	announceDeadpoolSessionButton:SetPoint("RIGHT", relativeTo, "LEFT", -2, 0)
	announceDeadpoolSessionButton:SetAttribute("tooltip", tooltip)
	announceDeadpoolSessionButton:SetAttribute("tooltipDetail", { tooltipDetail })

	return announceDeadpoolSessionButton
end

function createDeadpoolOptionsButton(parent)
	local name = "DeadpoolOptionsButton"
	local tooltip = L["MENUOPTIONS_TOOLTIP"]
	local tooltipDetail = L["MENUOPTIONS_TOOLTIPDETAIL"]

	local optionsButton = CreateFrame("Button", name, parent, "DeadpoolOptionsButtonTemplate")
	optionsButton:SetPoint("RIGHT", parent.Lock, "LEFT", 0, -1)
	optionsButton:SetAttribute("tooltip", tooltip)
	optionsButton:SetAttribute("tooltipDetail", { tooltipDetail })

	return optionsButton
end

function createDeadpoolSearchBox(parent)
	local name = "DeadpoolSearchBox"
	local searchBox = CreateFrame("EditBox", name, parent, "DeadpoolSearchBoxTemplate")
	if HelpTip then
		searchBox:SetPoint("LEFT", DPTutorialButton, "RIGHT", -13, 1)
	else
		DPTutorialButton:Hide()
		searchBox:SetPoint("TOPLEFT", 10, -1)
	end
	
	return searchBox
end

function createDeadpoolRoleButton(aDeadpoolSessionId, fullName, indexCharac, xValue, deadpoolLine)
	local portraitButton = getElementFromDeadpoolFramePool("Button", indexCharac,
		"DeadpoolPortrait"..indexCharac, "PortraitButtonTemplate", deadpoolLine:GetName())
	if fullName ~= "boss" then
		portraitButton:SetAttribute("tooltip", playerNameOrBankerName(fullName))
	else
		portraitButton:SetAttribute("tooltip", L["NEXT_BOSS"])
	end
	portraitButton:SetPoint("LEFT", xValue, 0)
	portraitButton:SetHeight(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"] - 2)
	portraitButton:SetWidth(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"] - 2)
	portraitButton.CircleGlow:SetHeight(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"] - 2 + 10)
	portraitButton.CircleGlow:SetWidth(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"] - 2 + 10)
	local portraitButtonTexture = _G["DeadpoolPortrait"..indexCharac.."Texture"]
	if not portraitButtonTexture then
		portraitButtonTexture = portraitButton:CreateTexture("DeadpoolPortrait"..indexCharac.."Texture", "BACKGROUND")
	end
	portraitButtonTexture:SetHeight(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"] - 2)
	portraitButtonTexture:SetWidth(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"] - 2)
	portraitButtonTexture:SetPoint("CENTER", 0, 0)
	local groupRank = getDeadpoolCharInfo(fullName, "groupRank")
	if groupRank then
		if groupRank ~= "boss" then
			SetPortraitTexture(portraitButtonTexture, groupRank)
		else
			portraitButtonTexture:SetTexture("Interface\\LFGFrame\\UI-LFG-PORTRAIT")
		end
	end
	if fullName == "boss" or getDeadpoolData(aDeadpoolSessionId, fullName, "credits") then
		portraitButton.CircleGlow:Show()
		local deadpoolVersion = getDeadpoolData(aDeadpoolSessionId, fullName, DEADPOOLDATA_VERSION) or ""
		portraitButton:SetAttribute("tooltipDetailGreen", { string.format(L["DEADPOOLUI_PLAYINGDEADPOOL"], deadpoolVersion) })
	else
		portraitButton.CircleGlow:Hide()
		portraitButton:SetAttribute("tooltipDetailGreen", nil)
	end

	local roleButtonSize = floor((DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"] - 2)/2)
	local roleButton = getElementFromDeadpoolFramePool("Button", indexCharac,
		"DeadpoolRole"..indexCharac, "DeadpoolRoleButtonTemplate", "DeadpoolPortrait"..indexCharac)
	roleButton:SetPoint("BOTTOMRIGHT", 5, -3)
	roleButton:SetHeight(roleButtonSize)
	roleButton:SetWidth(roleButtonSize)
	roleButton:SetNormalTexture(getDeadpoolRoleTexture(getDeadpoolCharInfo(fullName, "groupRole"), roleButton, indexCharac, roleButtonSize))
   	roleButton:SetAttribute("fullName", fullName)
	return portraitButton, role
end

function getDeadpoolRoleTexture(role, roleButton, indexCharac, texSize)
	local texture = _G[(role or "NONE").."RoleTexture"]
	if not texture then
		texture = roleButton:CreateTexture((role or "NONE").."RoleTexture"..indexCharac, "BACKGROUND", (role or "NONE").."DeadpoolRoleTextureTemplate")
	end
	if texSize then
		texture:SetHeight(texSize)
		texture:SetWidth(texSize)
	end
	return texture
end

function DeadpoolSummaryFrame_Update()
	if DeadpoolSummaryFrame and DeadpoolSummaryFrame:IsShown() then
		local selectedTab = PanelTemplates_GetSelectedTab(DeadpoolSummaryFrame)
		local characterName = playerNameOrBankerName(selectedDeadpoolCharacter)
		if ( selectedTab == 1 ) then
			hideAllDressUpModels()
			DeadpoolSummaryFrameTarget:Show()
			DeadpoolSummaryFramePlayer:Hide()
			DeadpoolSummaryFrameStats:Hide()
			if selectedDeadpoolCharacter then
				DeadpoolSummaryFrameTargetTitleText:SetText(characterName)
				ValidateBetButton:SetAttribute("characteriD", selectedDeadpoolCharacter)
				local nextDeathBet = getDeadpoolBets(DeadpoolGlobal_SessionId, Deadpool_playerCharacter(), selectedDeadpoolCharacter)
				if not GetCurrentKeyBoardFocus() or not (DeadpoolSummaryFrameTargetNextDeathBet == GetCurrentKeyBoardFocus()) then
					DeadpoolSummaryFrameTargetNextDeathBet:SetText(nextDeathBet)
				end
				DeadpoolSummaryFrameTargetNextDeathBet:Show()
				DeadpoolSummaryFrameTargetNextDeathBetLabel:Show()
				ValidateBetButton:Show()
			else
				DeadpoolSummaryFrameTargetTitleText:SetText(L["NO_SELECTED_CHARACTER"])
				DeadpoolSummaryFrameTargetNextDeathBet:Hide()
				DeadpoolSummaryFrameTargetNextDeathBetLabel:Hide()
				ValidateBetButton:Hide()
			end
		elseif ( selectedTab == 2 ) then
			DeadpoolSummaryFrameTarget:Hide()
			DeadpoolSummaryFramePlayer:Show()
			DeadpoolSummaryFrameStats:Hide()
			
			hideAllDressUpModels() -- to prevent alpha reset

			local deadpoolSideDressUpModelTarget = Deadpool:generateDressUpModel(nil, selectedDeadpoolCharacter, "SideDressUpModel")
			if deadpoolSideDressUpModelTarget then
				if selectedDeadpoolCharacter and selectedDeadpoolCharacter ~= "boss" then
					UIFrameFadeRemoveFrame(deadpoolSideDressUpModelTarget)
					deadpoolSideDressUpModelTarget:SetAlpha(1.0)
					deadpoolSideDressUpModelTarget:SetParent(DeadpoolSummaryFramePlayer)
					deadpoolSideDressUpModelTarget:ClearAllPoints()
					deadpoolSideDressUpModelTarget:SetPoint("TOPLEFT", DeadpoolSummaryFramePlayer, "TOPLEFT", 3, -3)
					deadpoolSideDressUpModelTarget:SetPoint("BOTTOMRIGHT", DeadpoolSummaryFramePlayer, "BOTTOMRIGHT", -3, 3)
				else
					deadpoolSideDressUpModelTarget:ClearModel()
					DeadpoolSummaryFramePlayerDurabilityFrame:Hide()
				end
			end
		else
			hideAllDressUpModels()
			DeadpoolSummaryFrameTarget:Hide()
			DeadpoolSummaryFramePlayer:Hide()
			DeadpoolSummaryFrameStats:Show()
			local stats = Deadpool_prepareStats()
			DeadpoolSummaryFrameStats.ScrollFrame.Text:SetText(stats)
		end
	end
end

local sideFromParentRelativePoint = {
	["TOPRIGHT"] = "LEFT",
	["TOP"] = "RIGHT",
	["TOPLEFT"] = "RIGHT",
	["RIGHT"] = "LEFT",
	["CENTER"] = "RIGHT",
	["LEFT"] = "RIGHT",
	["BOTTOMRIGHT"] = "LEFT",
	["BOTTOM"] = "RIGHT",
	["BOTTOMLEFT"] = "RIGHT",
}
local oppositeSide = {
	["RIGHT"] = "LEFT",
	["LEFT"] = "RIGHT",
}

--[[ ModelFileID for alternative forms
Male Worgen form 307454
Human form 1011653
Female Worgen form 307453
Female Human form 1000764
Male Dracthyr form 4207724
Male Visage form 4395382
Female Dracthyr form 4207724
Female Visage form 4220448
--]]
local shouldUseNativeFormInModelScene = {
	[307454] = true, -- Male Worgen form
	[307453] = true, -- Female Worgen form
	[4207724] = true, -- Male Dracthyr form
	[4207724] = true  -- Female Dracthyr form
}

function dpSetAnimation(model, animationId)
	if model and animationId and model.currentAnimation ~= animationId then
		model:SetDoBlend(true)
		model:SetAnimation(animationId)
		model.currentAnimation = animationId
		if animationId ~= 0 then
			model:SetScript("OnAnimFinished", function(self)
				self:SetAnimation(0)
				self.currentAnimation = 0
				self:SetScript("OnAnimFinished", nil)
			end)
		else
			model:SetScript("OnAnimFinished", nil)
		end
	end
end

DeadpoolGlobal_shownModel = nil
function dpShowModel(deadpoolCharacter, parentFrame)
	if not DeadpoolOptionsData["DeadpoolModelPopupDisabled"] then
		local point = "LEFT"
		local relativeTo = "RIGHT"
		local xValue = 0
		local yValue = 0
		local lockParentFrame = (parentFrame ~= nil)
		if not parentFrame then
			if DeadpoolFrame:IsShown() then
				parentFrame = DeadpoolFrame
			elseif MiniDeadpoolFrame:IsShown() then
				parentFrame = MiniDeadpoolFrame
			elseif DeadpoolWinnerTooltip:IsShown() then
				parentFrame = DeadpoolWinnerTooltip
			else
				local lastFrame = DeadpoolGetLastPopup()
				if ( lastFrame ) then
					parentFrame = lastFrame
				else
					parentFrame = UIParent
					point = "CENTER"
					relativeTo = "TOP"
					xValue = 0
					yValue = -135
				end
			end
		end
		if parentFrame then
			UIFrameFadeRemoveFrame(deadpoolDressUpModelPool["model"])
			local deadpoolDressUpModel = Deadpool:generateDressUpModel(nil, deadpoolCharacter)
			if deadpoolDressUpModel then
				if not lockParentFrame then
					if DeadpoolGlobal_shownModel then
						hideDressUpModel(DeadpoolGlobal_shownModel)
					end
					DeadpoolGlobal_shownModel = deadpoolDressUpModel
				end
				deadpoolDressUpModel.CloseButton:Hide()
				if (not DeadpoolFrame:IsShown() or not DeadpoolSummaryFramePlayer:IsShown() or selectedDeadpoolCharacter ~= deadpoolCharacter) then
					if parentFrame ~= UIParent then
						local _, _, relativePoint, _, _ = parentFrame:GetPoint()
						relativeTo = DeadpoolOptionsData["DeadpoolModelPopupSide"] or (relativePoint and sideFromParentRelativePoint[relativePoint])
						point = oppositeSide[relativeTo]
						if MiniDeadpoolFrame:IsShown() and point == "RIGHT" then
							xValue = -15
						end
					end
					deadpoolDressUpModel:ClearAllPoints()
					deadpoolDressUpModel:SetPoint(point, parentFrame, relativeTo, xValue, yValue)
					deadpoolDressUpModel:SetSize(100, 200)
					DPModel_FadeIn(deadpoolDressUpModel, parentFrame:GetAlpha())
					modelFadesOutAfter(6, deadpoolCharacter)
				else
					deadpoolDressUpModel:SetParent(UIParent)
					deadpoolDressUpModel:SetParent(DeadpoolSummaryFramePlayer)
					C_Timer.After(0, function()
						dpSetAnimation(deadpoolDressUpModel, 83)
						if deadpoolDressUpModelPool["SideDressUpModel"] and deadpoolDressUpModel.char == deadpoolDressUpModelPool["SideDressUpModel"].char then
							dpSetAnimation(deadpoolDressUpModelPool["SideDressUpModel"], 83)
						end
					end)
				end
			end
		end
	end
end

local fadeOutTime = nil
function modelFadesOutAfter(seconds)
	local deadpoolDressUpModel = deadpoolDressUpModelPool["model"]
	C_Timer.After(seconds, function()
		if deadpoolDressUpModel:GetParent() ~= DeadpoolSummaryFramePlayer then
			local timeAfter = time()
			if not (fadeOutTime and timeAfter < fadeOutTime) then
				DPModel_FadeOut(deadpoolDressUpModel)
				DeadpoolGlobal_shownModel = nil
			end
		end
	end)
	fadeOutTime = time() + seconds
end

function DPModel_FadeIn(frame, alpha)
	local fadeInfo = {}
	fadeInfo.mode = "IN"
	fadeInfo.timeToFade = 1
	fadeInfo.startAlpha = 0
	fadeInfo.endAlpha = alpha
	fadeInfo.finishedFunc = function() dpSetAnimation(frame, 83) end
	UIFrameFade(frame, fadeInfo)
end

function DPModel_FadeOut(frame)
	local fadeInfo = {}
	fadeInfo.mode = "OUT"
	fadeInfo.timeToFade = 1
	fadeInfo.startAlpha = frame:GetAlpha()
	fadeInfo.endAlpha = 0
	fadeInfo.finishedFunc = function() hideDressUpModel(frame) end
	UIFrameFade(frame, fadeInfo)
end

function DPTooltips_FadeOut(frame, endAlpha)
	if frame and frame:IsShown() then
		local fadeInfo = {}
		fadeInfo.mode = "OUT"
		fadeInfo.timeToFade = 1
		fadeInfo.startAlpha = frame:GetAlpha()
		fadeInfo.endAlpha = endAlpha or 0
		fadeInfo.finishedFunc = function(frame) if frame:GetAlpha() == 0 then frame:Hide() end end
		fadeInfo.finishedArg1 = frame
		UIFrameFade(frame, fadeInfo)
	end
end

function Deadpool:generateDressUpModel(event, aChar, frameName)
	local dressUpModel = deadpoolDressUpModelPool[frameName or "model"]
	if aChar and (not event or Deadpool_isPartyMember(aChar)) then
		local char = aChar
		if event then
			char = UnitIsPlayer(aChar) and Deadpool_fullName(aChar)
			if not char then
				_, _, _, _, _, char = strsplit("-", UnitGUID(aChar))
			end
			if dressUpModel and dressUpModel.char ~= char then
				char = nil
			end
		end

		if char then
			local dressUpModelDrawingTrial = createDressUpModel("DrawingTrial")

			if not deadpoolDressUpModelPool[frameName or "model"] then
				dressUpModel = createDressUpModel(frameName or "Final")
				deadpoolDressUpModelPool[frameName or "model"] = dressUpModel
			end
			dressUpModel.char = char

			local groupRank = "player"
			local isPlayer = Deadpool_isPlayerCharacter(char)
			if not isPlayer then
				groupRank = getDeadpoolCharInfo(char, "groupRank")
			end
			-- Allways returns nil -- local modelCanDraw = nil
			local modelCanSet = nil
			if not isPlayer and groupRank then
				-- Allways returns nil -- modelCanDraw = dressUpModel:CanSetUnit(groupRank)
				modelCanSet = dressUpModelDrawingTrial:SetUnit(groupRank)
			end
			if isPlayer then -- Allways returns nil -- or modelCanDraw then
				if groupRank then
					dressUpModel:SetUnit(groupRank, event ~= nil)
				end
			else
				if groupRank then
					NotifyInspect(groupRank)
				end
				if groupRank and UnitIsPlayer(groupRank) and modelCanSet then
					dressUpModel:SetUnit(groupRank, event ~= nil)
					if shouldUseNativeFormInModelScene[dressUpModel:GetModelFileID()] then
						dressUpModel:SetUnit(groupRank, event ~= nil, true)
					end
				elseif not event then
					dressUpModel:SetUnit("player", event ~= nil)
					--dressUpModel:SetBarberShopAlternateForm()
					--dressUpModel:SetCustomRace(
					--	getDeadpoolCharInfo(char, "race"), getDeadpoolCharInfo(char, "gender"))
					deadpool_customDressing(dressUpModel)
				end
			end

			C_Timer.After(0, function()
				deadpoolUndressModel(dressUpModel,
					Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, char, "offItemsNumber")))
			end)
		end
	end
	return dressUpModel
end

function hideAllDressUpModels()
	if deadpoolDressUpModelPool["model"] and deadpoolDressUpModelPool["model"]:GetParent():GetName() == "DeadpoolSummaryFramePlayer" then
		hideDressUpModel(deadpoolDressUpModelPool["model"])
	end
end

function hideDressUpModel(model)
	if model then
		model:SetParent(UIParent)
		model:ClearAllPoints()
		model:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -100, 100)
		model:SetPoint("BOTTOMRIGHT", UIParent, "TOPLEFT", -10, 10)
		model:SetAlpha(1.0)
		dpSetAnimation(model, 0)
	end
end

function createDressUpModel(aName)
	local frameName = "DressUpModel-"..aName
	local frame = _G[frameName]
	if not frame then
		frame = CreateFrame("DressUpModel", frameName, UIParent, "DPDressUpModel")
		frame:SetAttribute("fullName", aName)
	end
	return frame
end

function deadpool_customDressing(aModel)
	if aModel and aModel:GetObjectType() == "DressUpModel" then
		aModel:Undress()
		aModel:TryOn("item:"..54451) -- Head : High Society Top Hat
		aModel:TryOn("item:"..33122) -- Back : Cloak of Darkness
		aModel:TryOn("item:"..51971) -- Waist : Enumerated Belt
		aModel:TryOn("item:"..24755) -- Shoulder : Daggerfen Pauldrons
		aModel:TryOn("item:"..116134) -- Feet : Noble's Fancy Boots
		aModel:TryOn("item:"..24365) -- Hand : Deft Handguards
		aModel:TryOn("item:"..24684) -- Wrist : Archmage Bracelets
		aModel:TryOn("item:"..116052) -- Chest : Nobleman's Coat
		aModel:TryOn("item:"..116133) -- Legs : Nobleman's Pantaloons
	end
end

local dpLastTableGeneration
local dpGenerationPending
function generateDeadpoolTable()
	local callTime = time()
	if not dpLastTableGeneration then
		dpLastTableGeneration = callTime
	else
		if callTime < dpLastTableGeneration + 2 then
			if not dpGenerationPending then
				dpGenerationPending = true
				DeadpoolFrame.SearchingSpinner:Show()
				MiniDeadpoolFrame.SearchingSpinner:Show()
				C_Timer.After(2 - (callTime - dpLastTableGeneration), function()
					dpGenerationPending = nil
					generateDeadpoolTable()
				end)
			end
			return
		else
			
			dpLastTableGeneration = callTime
		end
	end

	deadpoolCharInfo = getDeadpoolRosterInfo()
	updateMiniDeadpoolFrame()

	local aFrameIsShown = (DeadpoolFrame and DeadpoolFrame:IsShown()) or (MiniDeadpoolFrame and MiniDeadpoolFrame:IsShown())

	if aFrameIsShown then
		local credits = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, Deadpool_playerCharacter(), "credits"))
		DeadpoolPlayerCreditsCount:SetText(credits)
		MiniDeadpoolPlayerCreditsCount:SetText(credits)

		credits = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, "Bank", "credits"))
		DeadpoolBankCreditsCount:SetText(credits)
		MiniDeadpoolBankCreditsCount:SetText(credits)

		local totalNextDeathBets, nbNextDeathBets = getDeadpoolTotalBets(DeadpoolGlobal_SessionId, "nextDeathBet")
		DeadpoolBetsCreditsCount:SetText(totalNextDeathBets)
		MiniDeadpoolBetsCreditsCount:SetText(totalNextDeathBets)
	end

	if DeadpoolFrame and DeadpoolFrame:IsShown() then
		local searchBoxText = ""
		if _G["DeadpoolSearchBox"] then
			searchBoxText = Deadpool_upperCase(_G["DeadpoolSearchBox"]:GetText())
		end

		updateDeadpoolList(deadpoolCharInfo, searchBoxText)
		
		Deadpool_UpdateScrollFrame(_G["DeadpoolScrollFrame"])

		DeadpoolSummaryFrame_Update()

		local numGroupMembers = GetNumGroupMembers()
		if numGroupMembers > 0 then
			local stats = Deadpool_prepareStats()
			DeadpoolSummaryFrameStats.ScrollFrame.Text:SetText(stats)
		end
		local stats = Deadpool_prepareStats()
	end

	if DeadpoolBankerButton then
		local bankerBet = Deadpool_hasPlayed(DeadpoolGlobal_SessionId, DEADPOOL_BANKER)
		local bankerChips = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, DEADPOOL_BANKER, "credits"))
		if bankerBet then
			DeadpoolBankerButton.SelectedTexture:SetShown(true)
			local shortBankerBetName = L["NEXT_BOSS"]
			if bankerBet ~= "boss" then
				shortBankerBetName = getDeadpoolCharInfo(bankerBet, "localName")
			end
			DeadpoolBankerButton:SetText(string.format(L["BANKER_BET"], DEADPOOL_BANKER_NAME, shortBankerBetName or UNKNOWN))
			DeadpoolBankerButton:Disable()
		else
			DeadpoolBankerButton.SelectedTexture:SetShown(false)
			if bankerChips > 0 then
				local gamblerName = DEADPOOL_BANKER_NAME
				local _, _, difficultyID = GetInstanceInfo()
				if difficultyID == 205 then -- Followers dungeon
					gamblerName = gamblerName.."|n"..L["MAKE_FOLLOWERS_PLAY"]
				end
				DeadpoolBankerButton:SetText(string.format(L["MAKE_BANKER_PLAY"], gamblerName))
				DeadpoolBankerButton:Enable()
			else
				DeadpoolBankerButton:SetText(string.format(L["BANKER_NO_CHIPS"], DEADPOOL_BANKER_NAME))
				DeadpoolBankerButton:Disable()
			end
		end
	end
	DeadpoolFrame.SearchingSpinner:Hide()
	MiniDeadpoolFrame.SearchingSpinner:Hide()
end

function updateDeadpoolList(charInfo, searchBoxText)
	if charInfo then
		-- Characters sorting
		local playerFirst = not DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolPlayerFirstDisabled"]
		local charNames = {}
		for k in pairs(charInfo) do
			if (not playerFirst or not Deadpool_isPlayerCharacter(k)) and k ~= "boss" then
				charNames[ #charNames + 1 ] = charInfo[k]["localName"].."#"..k
			end
		end
		table.sort(charNames)

		if playerFirst then
			local pc = Deadpool_playerCharacter()
			if pc then
				deadpoolList = { pc }
			end
		else
			deadpoolList = {}
		end

		if charInfo["boss"] then
			table.insert(deadpoolList, "boss")
		end

		for k,v in pairs(charNames) do
			local charName, charId = strsplit("#", v, 2)
			if charId ~= DEADPOOL_BANKER 
				and (not searchBoxText or searchBoxText == ""
					or string.find(Deadpool_upperCase(charName), searchBoxText)) then -- Search box result
				table.insert(deadpoolList, charId)
			end
		end
	end
end

function Deadpool_UpdateScrollFrame(self, resizing)
	if DeadpoolFrame and DeadpoolFrame:IsShown() then
		local numItems = Deadpool_countTableElements(deadpoolList)
		local numLines = getPrintableLinesNumber(DeadpoolFrame:GetHeight() - 60 - 19 - 41)
		FauxScrollFrame_Update(self, numItems, numLines, DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"])
		local offset = FauxScrollFrame_GetOffset(self)

		for index,deadpoolLine in pairs(deadpoolLines) do
			local lineplusoffset = index + offset
			if deadpoolLine then
				deadpoolLine:SetHeight(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"])
				if lineplusoffset > numItems or index > numLines then
					deadpoolLine:Hide()
				else
					createDeadpoolLine(DeadpoolGlobal_SessionId, index, deadpoolList[lineplusoffset], deadpoolLine, resizing)
					deadpoolLine:Show()
				end
			end
		end
	end
end

function getPrintableLinesNumber(windowHeight)
	prntableLinesNumber = 0

	if windowHeight and DeadpoolOptionsData and DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"] then
		prntableLinesNumber = floor(windowHeight/DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"])
	end

	return prntableLinesNumber
end

function DeadpoolFrameTemplate_OnEnter(self)
	if DeadpoolOptionsData
		and DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"]
			and DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"] < 0.7 then
		self:SetAlpha(0.7)
	end
end

function setDeadpoolFrameAlpha()
	if DeadpoolFrame and DeadpoolOptionsData and DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"] then
		DeadpoolFrame:SetAlpha(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"])
	end
end
				
function DeadpoolFrameTemplate_OnLeave(self)
	if not MouseIsOver(self) and not MouseIsOver(DeadpoolFrameLock) and not MouseIsOver(DeadpoolFrame.ClosePanelButton) then
		setDeadpoolFrameAlpha()
	end
end

local mouseOverFrame
local lastMouseOver
function Deadpool:DeadpoolMouseOverUnit()
	if not UnitAffectingCombat("player") and not DeadpoolOptionsData["BetButtonDisabled"] then
		local unitFrame = EZBlizzUiPop_GetMouseFocus()
		if unitFrame then
			local unitFrameName = unitFrame:GetName()
			if not unitFrameName then
				unitFrameName = unitFrame:GetParent():GetName()
			end
			if not unitFrameName then
				unitFrame = unitFrame:GetParent()
				unitFrameName = unitFrame:GetParent():GetName()
			end
	
			local differentUnit = unitFrameName ~= mouseOverFrame
			local dropDownMenuWasShown = _G["L_DropDownList1"]:IsShown()
			if differentUnit then
				DeadpoolBetButton:Hide()
				DeadpoolDropDown_Hide()
				mouseOverFrame = unitFrameName
			end
		
			if unitFrameName then
				local unitid = unitFrame.unit
				if unitid and Deadpool_isPartyMember(unitid) and not UnitAffectingCombat(unitid) then
					local playerId = UnitIsPlayer(unitid) and Deadpool_fullName(unitid)
					if not playerId then
						_, _, _, _, _, playerId = strsplit("-", UnitGUID(unitid))
					end
					if playerId then
						DeadpoolBetButton:SetParent(unitFrame)
						DeadpoolBetButton:SetFrameStrata("MEDIUM")
						DeadpoolBetButton:SetPoint("CENTER", unitFrame, "TOPRIGHT", -1, -1)
						DeadpoolBetButton:SetAttribute("Character", playerId)
						DeadpoolBetButton:SetAttribute("stopFadeOutTimer", true)
						UIFrameFadeRemoveFrame(DeadpoolBetButton)
						DeadpoolBetButton:SetAlpha(1.0)
						DeadpoolBetButton:Show()
						
						C_Timer.After(3, function()
							DeadpoolBetButton:SetAttribute("stopFadeOutTimer", nil)
						end)
						
						C_Timer.After(4, function()
							if not DeadpoolBetButton:GetAttribute("stopFadeOutTimer") then
								DPTooltips_FadeOut(DeadpoolBetButton, 0.0)
							end
						end)
						
						if differentUnit and dropDownMenuWasShown then
							if lastMouseOver and lastMouseOver + 1 >= time() then
								DeadpoolDropDown:SetAttribute("Character", unitName)
								LibDD:ToggleDropDownMenu(1, nil, DeadpoolDropDown, "DeadpoolBetButton")
							end
						end
					end
				end
			end
			lastMouseOver = time()
		end
	else
		DeadpoolBetButton:Hide()
		DeadpoolDropDown_Hide()
	end
end

showDeadpoolFrameAfterCombat = false
showMiniDeadpoolFrameAfterCombat = false

function Deadpool:DeadpoolPlayerEntersCombat(event)
	if not DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolHideInCombatDisabled"] then
		if DeadpoolFrame:IsShown() then
			hideDeadpoolWindow()
			showDeadpoolFrameAfterCombat = true
		end
		if MiniDeadpoolFrame:IsShown() then
			MiniDeadpoolFrame:Hide()
			showMiniDeadpoolFrameAfterCombat = true
		end
	end
	DeadpoolBetButton:Hide()
end

function Deadpool:DeadpoolPlayerLeavesCombat(event)
	self:UnequipLostItems(event)
	if showDeadpoolFrameAfterCombat and not DeadpoolFrame:IsShown() then
		Deadpool:DeadpoolShow()
		showDeadpoolFrameAfterCombat = false
	end
	if showMiniDeadpoolFrameAfterCombat and not MiniDeadpoolFrame:IsShown() then
		MiniDeadpoolFrame:Show()
		showMiniDeadpoolFrameAfterCombat = false
	end
	DeadpoolBetButton:Hide()
	if dpCharacterDied then
		dpCharacterDied = nil
		DeadpoolShowResults((not UnitGUID("boss1") or not DeadpoolOptionsData["DeadpoolNotificationsInBossFightsDisabled"])
			and (not C_ChallengeMode.IsChallengeModeActive() or DeadpoolOptionsData["DeadpoolNotificationsInMythicPlus"]))
	end
end

-- NPC dialog pop-up
-----------

function tellTutorialText(text, force)
	local quotePlayed = nil
	local isInBossCombat = UnitGUID("boss1")
	if not isInBossCombat and text and ((DeadpoolFrame and DeadpoolFrame:IsShown()) or (MiniDeadpoolFrame and MiniDeadpoolFrame:IsShown()) or force)
		and not DeadpoolOptionsData["TutoDisabled"]
			and (not DeadpoolTuto or not DeadpoolTuto[text]) then
		quotePlayed = Deadpool_PlaySoundFile(text, "Dialog")
		EZBlizzUiPop_npcDialog(DEADPOOL_BANKER, L[text])
		DeadpoolTuto[text] = "Done"
	end
	return quotePlayed
end

function Deadpool:BossKill(event, encounterID, encounterName)
	generateDeadpoolTable()
	local totalUniqueGambleOnChar = getDeadpoolTotalUniqueGamble(DeadpoolGlobal_SessionId, "boss")
	local totalNextDeathBetsOnChar = getDeadpoolTotalBets(DeadpoolGlobal_SessionId, "nextDeathBet", "boss")
	if totalUniqueGambleOnChar > 0 or totalNextDeathBetsOnChar > 0 then
		deadpoolCharacterIsDead(DeadpoolGlobal_SessionId, "boss", encounterName)
	end
end

local DeadPoolSaveSetName = "Dead Pool save"
function Deadpool:UnequipLostItems(event)
	local trulyUnequipItems = getDeadpoolData(DeadpoolGlobal_SessionId, Deadpool_playerCharacter(), DEADPOOL_TRULYUNEQUIP)
	if trulyUnequipItems and trulyUnequipItems == "true" then
		DeadpoolTrulyUnequip_Glow(DeadpoolTrulyUnequipSwitch)
		local deadpoolEquipmentSetID = C_EquipmentSet.GetEquipmentSetID(DeadPoolSaveSetName)
		if not deadpoolEquipmentSetID then
			local setIcon = 237272
			C_EquipmentSet.CreateEquipmentSet(DeadPoolSaveSetName, setIcon)
		end		
		self:RegisterEvent("EQUIPMENT_SWAP_FINISHED", "EquipmentSwapped")
		
		Deadpool_UnequipItems()
	else
		Deadpool:ReequipLostItems()
	end
	DeadpoolTrulyUnequip_UpdateStatus(DeadpoolTrulyUnequipSwitch)
end

function Deadpool:LeaveGroup(event)
	setDeadpoolData(DeadpoolGlobal_SessionId, Deadpool_playerCharacter(), DEADPOOL_TRULYUNEQUIP, nil)
	Deadpool:UnequipLostItems(event)
end

function Deadpool:ReequipLostItems()
	Deadpool_deleteDeadpoolEquipmentSet(true)
end

function Deadpool:EquipmentSwapped(event, result, setID)
	local deadpoolEquipmentSetID = C_EquipmentSet.GetEquipmentSetID(DeadPoolSaveSetName)
	if deadpoolEquipmentSetID and setID ~= deadpoolEquipmentSetID then
		Deadpool_deleteDeadpoolEquipmentSet(false)
		self:UnregisterEvent("EQUIPMENT_SWAP_FINISHED")
	end
end

function Deadpool_deleteDeadpoolEquipmentSet(reequipFirst)
	if not UnitAffectingCombat("player") and not UnitIsDeadOrGhost("player") then
		local deadpoolEquipmentSetID = C_EquipmentSet.GetEquipmentSetID(DeadPoolSaveSetName)
		if deadpoolEquipmentSetID then
			local setEquipped = true
			if reequipFirst then
				setEquipped = C_EquipmentSet.UseEquipmentSet(deadpoolEquipmentSetID)
				DeadpoolTrulyUnequip_UpdateCooldown(DeadpoolTrulyUnequipSwitch)
			end
			if not reequipFirst or setEquipped then
				C_EquipmentSet.DeleteEquipmentSet(deadpoolEquipmentSetID)
			end
		end
	end
end

function Deadpool:MerchantFrameUpdate()
	if getDeadpoolData(DeadpoolGlobal_SessionId, Deadpool_playerCharacter(), DEADPOOL_TRULYUNEQUIP) then
		local buybackName = GetBuybackItemInfo(GetNumBuybackItems())
		
		if buybackName then
			local itemID = Deadpool_isItemInSet(buybackName, DeadPoolSaveSetName)
			if itemID then
				BuybackItem(GetNumBuybackItems())
				
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemID)
				local rColor, gColor, bColor = GetItemQualityColor(itemRarity)
				local data = {
					texture = itemTexture,
					name = itemName,
					color = {rColor, gColor, bColor, 1},
					link = itemLink,
					itemFrameOnEnter = StaticPopupItemOnEnter,
					isItemBound = true,
					costString = itemSellPrice,
				};
				
				StaticPopup_Show("DEADPOOL_SELL_ITEM_WARNING", nil, nil, data)
			end
		end
	end
end
