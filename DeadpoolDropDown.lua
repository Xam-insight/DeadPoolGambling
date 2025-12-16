local L = LibStub("AceLocale-3.0"):GetLocale("Deadpool", true)
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
local XITK = LibStub("XamInsightToolKit")

local betSliderInitialValue = 5

function DeadpoolDropDown_Update(self)
	local betChar = self:GetAttribute("Character")
	if not betChar then
		return
	end
	local betTuto = L["DEADPOOLTUTO_BET"]
	if betChar == "boss" then
		betTuto = L["DEADPOOLTUTO_BOSS"]
	end
	local isPlayer = XITK.isPlayerCharacter(betChar)

	local playerOffItemsNumber = XITK.tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, XITK.playerCharacter(), "offItemsNumber"))
	local playerCredits = XITK.tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, XITK.playerCharacter(), "credits"))

	if not L_DropDownList1.customFrames then
		L_DropDownList1.customFrames = {}
	end

	local buttonId = 1

	local info = LibDD:UIDropDownMenu_CreateInfo()
	info.minWidth = 230
	info.text = "|cFF00FF00"..L["DEADPOOLMENU_BET"]
	info.isTitle = 1
	info.notCheckable = 1
	info.func = nil
	info.arg1 = nil
	info.customFrame = nil
	DeadpoolDownMenu_AddButton(info, buttonId)
	
	if betChar then
		if isPlayer then
			buttonId = buttonId + 1
			
			info.text = L["SELF_BET_NOT_ALLOWED"]
			info.isTitle = nil
			info.leftPadding = 10
			info.disabled = true
			info.customFrame = DeadpoolDropDownButtonSelfBet
			DeadpoolDownMenu_AddButton(info, buttonId, nil, L["DEADPOOLTUTO_SELFBET"])
		else
			local charItemsToLost = DEADPOOL_GARMENT_NUMBER - playerOffItemsNumber
			local maxBetToAdd = playerCredits + charItemsToLost * DEADPOOL_GARMENT_REWARD
			local playerBetOnChar, _, playerTotalBets, _ = getDeadpoolBets(DeadpoolGlobal_SessionId, XITK.playerCharacter(), betChar)
			local totalPlayerCredit = maxBetToAdd + playerTotalBets

			buttonId = buttonId + 1
			
			info.text = L["DEADPOOLMENU_ADD"]
			info.isTitle = nil
			info.leftPadding = 10
			info.func = DeadpoolDropDown_Bet
			info.arg1 = betChar
			info.arg2 = "1"
			info.disabled = maxBetToAdd < 1
			info.customFrame = DeadpoolDropDownButtonBet1
			DeadpoolDownMenu_AddButton(info, buttonId, "1"..deadpoolChipTextureString, betTuto.."|n|n"..L["DEADPOOLTUTO_BET1"].."|n|n"..L["DEADPOOLTUTO_BETTOMUCH"])

			buttonId = buttonId + 1

			info.text = L["DEADPOOLMENU_ADD"]
			info.isTitle = nil
			info.leftPadding = 10
			info.func = DeadpoolDropDown_SliderBet
			info.arg1 = betChar
			info.arg2 = nil
			info.customFrame = DeadpoolDropDownButtonBet5
			info.disabled = maxBetToAdd < 5

			DeadpoolDownMenu_AddButton(info, buttonId, "5"..deadpoolChipTextureString, betTuto.."|n|n"..L["DEADPOOLTUTO_BET5"].."|n|n"..L["DEADPOOLTUTO_BETTOMUCH"])

			if maxBetToAdd > 4 then
				if maxBetToAdd > 5 then
					local sliderStep = DeadpoolDropDownButtonBet5.BetSlider:GetValueStep()
					DeadpoolDropDownButtonBet5.BetSlider:SetMinMaxValues(5, min(XITK.SimpleRound(playerCredits + 20, sliderStep), maxBetToAdd))
					DeadpoolDropDownButtonBet5.BetSlider:Show()
				else
					DeadpoolDropDownButtonBet5.BetSlider:Hide()
				end
				DeadpoolDropDownButtonBet5.BetSlider:SetValue(betSliderInitialValue)
			else
				betSliderInitialValue = 5
				DeadpoolDropDownButtonBet5.BetSlider:Hide()
			end
			DeadpoolDropDownButtonBet5.ShortcutText:SetText(DeadpoolDropDownButtonBet5.BetSlider:GetValue()..deadpoolChipTextureString)

			buttonId = buttonId + 1

			info.text = L["DEADPOOLMENU_ALL"]
			info.isTitle = nil
			info.leftPadding = 10
			info.func = DeadpoolDropDown_Bet
			info.arg1 = betChar
			info.arg2 = nil
			info.customFrame = DeadpoolDropDownButtonBetAll
			info.disabled = playerCredits < 1
			DeadpoolDownMenu_AddButton(info, buttonId, playerCredits..deadpoolChipTextureString, betTuto.."|n|n"..L["DEADPOOLTUTO_BETALL"])

			buttonId = buttonId + 1

			local noPlayerBetOnChar = playerBetOnChar < 1
			info.text = L["DEADPOOLMENU_REMOVE"]
			info.isTitle = nil
			info.leftPadding = 10
			info.func = DeadpoolDropDown_Bet
			info.arg1 = betChar
			info.arg2 = "0"
			info.customFrame = DeadpoolDropDownButtonBetRemove
			info.disabled = noPlayerBetOnChar
			local removeValue = nil
			if not noPlayerBetOnChar then
				removeValue = "-"..playerBetOnChar..deadpoolChipTextureString
			end
			DeadpoolDownMenu_AddButton(info, buttonId, removeValue, L["DEADPOOLTUTO_BETREMOVE"])

			local bankCredits = XITK.tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, "Bank", "credits"))
			if totalPlayerCredit < 1 then
				buttonId = buttonId + 1
				
				DeadpoolDownMenu_AddSeparator(buttonId)
			
				buttonId = buttonId + 1

				info.text = "|cFFFF0000"..L["DEADPOOLMENU_BANKBET"]
				info.isTitle = 1
				info.leftPadding = 0
				info.func = nil
				info.arg1 = nil
				info.arg2 = nil
				info.customFrame = nil
				DeadpoolDownMenu_AddButton(info, buttonId)

				BankIconFrame:SetParent(_G["L_DropDownList1"])
				BankIconFrame:ClearAllPoints()
				BankIconFrame:SetPoint("TOPRIGHT", _G["L_DropDownList1Button"..buttonId], "TOPRIGHT", 3, -3)
				BankIconFrameCount:SetText(bankCredits)
				if bankCredits == 0 then
					BankIconFrameIcon:SetTexCoord(0,.25,0,1)
				elseif bankCredits >= 100 then
					BankIconFrameIcon:SetTexCoord(.75,1,0,1)
				elseif bankCredits >= 50 then
					BankIconFrameIcon:SetTexCoord(.5,.75,0,1)
				elseif bankCredits > 0 then
					BankIconFrameIcon:SetTexCoord(.25,.5,0,1)
				end
				BankIconFrame:SetFrameLevel(4)
				BankIconFrame:Show()
				LibDD:UIDropDownMenu_RegisterCustomFrame(L_DropDownList1, BankIconFrame)

				buttonId = buttonId + 1

				info.text = L["DEADPOOLMENU_UNIQUE"]
				info.isTitle = nil
				info.leftPadding = 10
				info.func = DeadpoolDropDown_Bet
				info.arg1 = betChar
				info.arg2 = "unique"
				info.customFrame = DeadpoolDropDownButtonUniqueBet
				info.disabled = bankCredits < 1
				DeadpoolDownMenu_AddButton(info, buttonId, nil, L["DEADPOOLTUTO_UNIQUEBET"])
			end
		end

		if DeadpoolBankerButton then
			buttonId = buttonId + 1
			
			DeadpoolDownMenu_AddSeparator(buttonId)

			buttonId = buttonId + 1

			info.text = DEADPOOL_BANKER_NAME
			info.isTitle = 1
			info.leftPadding = 0
			info.func = nil
			info.arg1 = nil
			info.arg2 = nil
			info.customFrame = nil
			DeadpoolDownMenu_AddButton(info, buttonId)

			buttonId = buttonId + 1
			
			local buttonText = (DeadpoolBankerButton and DeadpoolBankerButton:GetText() and string.gsub(DeadpoolBankerButton:GetText(), "\n", " ")) or ""
			info.isTitle = nil
			info.leftPadding = 10
			if DeadpoolBankerButton:IsEnabled() then
				info.text = buttonText
				info.isTitle = nil
				info.leftPadding = 10
				info.func = DeadpoolDropDown_BankerBet
				info.arg1 = DeadpoolGlobal_SessionId
				info.arg2 = deadpoolList
				info.customFrame = DeadpoolDropDownButtonBankerBet
				info.disabled = false
				DeadpoolDownMenu_AddButton(info, buttonId, nil, L["DEADPOOLTUTO_BANKER"].."|n|n"..L["DEADPOOLTUTO_BANKERBET"])
			else
				info.text = string.gsub(buttonText, DEADPOOL_BANKER_NAME, "...")
				info.func = askBankerHisBet
				info.arg1 = DeadpoolGlobal_SessionId
				info.arg2 = deadpoolList
				info.customFrame = DeadpoolDropDownButtonBankerBet
				info.disabled = true
				DeadpoolDownMenu_AddButton(info, buttonId, nil, L["DEADPOOLTUTO_BANKER"].."|n|n"..L["DEADPOOLTUTO_BANKERHASBET"])
			end
		end

		buttonId = buttonId + 1
				
		DeadpoolDownMenu_AddSeparator(buttonId)

		if HelpTip then
			buttonId = buttonId + 1

			info.text = L["ENABLE_MENUTUTO"]
			info.isTitle = nil
			info.leftPadding = 0
			info.checked = deadpoolGetTuto("Menu")
			info.isNotRadio = true
			info.func = nil
			info.arg1 = nil
			info.arg2 = nil
			info.customFrame = DeadpoolDropDownButtonTuto
			info.disabled = false
			info.notCheckable = nil
			DeadpoolDownMenu_AddButton(info, buttonId, nil, L["ENABLE_TUTO_DESC"])
		end

		buttonId = buttonId + 1

		info.text = L["DEADPOOLMENU_OPTIONS"]
		info.isTitle = nil
		info.leftPadding = 0
		info.func = DeadpoolOptionsButtonClick
		info.arg1 = nil
		info.arg2 = nil
		info.customFrame = nil
		info.disabled = false
		info.notCheckable = nil
		info.checked = false
		info.isNotRadio = nil
		DeadpoolDownMenu_AddButton(info, buttonId)
		_G["L_DropDownList1Button"..buttonId.."UnCheck"]:Hide()

		buttonId = buttonId + 1

		local chips = nil
		if not ((DeadpoolFrame and DeadpoolFrame:IsShown()) or (MiniDeadpoolFrame and MiniDeadpoolFrame:IsShown())) then
			chips = L["DEADPOOLUI_CHIPS"]..XITK.GetPunctuationSpace()..": "..playerCredits..deadpoolChipTextureString.."      "
		end

		info.text = CANCEL
		info.isTitle = nil
		info.leftPadding = 0
		info.notCheckable = nil
		info.checked = false
		info.isNotRadio = nil
		info.func = DeadpoolDropDown_Hide
		info.arg1 = nil
		info.arg2 = nil
		info.customFrame = nil
		info.disabled = false
		DeadpoolDownMenu_AddButton(info, buttonId)
		_G["L_DropDownList1Button"..buttonId.."UnCheck"]:Hide()

		if chips then
			buttonId = buttonId + 1

			local spaceInfo = {
				hasArrow = false,
				dist = 0,
				isTitle = true,
				isUninteractable = true,
				notCheckable = true,
				customFrame = DeadpoolDropDownButtonPlayerChips
			}
			DeadpoolDownMenu_AddButton(spaceInfo, buttonId, chips)
		end

		DPMenuDurabilityFrame:SetParent(_G["L_DropDownList1"])
		DPMenuDurabilityFrame.owningButton = _G["L_DropDownList1Button"..buttonId]
		DPMenuDurabilityFrame:ClearAllPoints()
		DPMenuDurabilityFrame:SetPoint("BOTTOMRIGHT", _G["L_DropDownList1Button"..buttonId], "BOTTOMRIGHT", -5, -10)
		DPMenuDurabilityFrame:SetFrameLevel(4)
		DPMenuDurabilityFrame:Show()

		LibDD:UIDropDownMenu_RegisterCustomFrame(L_DropDownList1, DPMenuDurabilityFrame)
		DeadpoolDurability("DPMenuDurabilityArmor", playerOffItemsNumber)
	end
end

function DeadpoolDropDown_Show(self, relativeTo)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
	LibDD:ToggleDropDownMenu(1, nil, self, relativeTo)
end

function DeadpoolDropDown_Hide()
	LibDD:HideDropDownMenu(1)
end

function DeadpoolDropDown_Bet(self, char, bet)
	addDeadpoolBets(DeadpoolGlobal_SessionId, XITK.playerCharacter(), char, bet)
end

function DeadpoolDropDown_SliderBet(self, char)
	addDeadpoolBets(DeadpoolGlobal_SessionId, XITK.playerCharacter(), char, DeadpoolDropDownButtonBet5.BetSlider:GetAttribute("betToAdd"))
end

function DeadpoolDropDown_BankerBet(self, aDeadpoolSessionId, deadpoolList)
	askBankerHisBet(aDeadpoolSessionId, deadpoolList)
end

function DeadpoolDownMenu_AddButton(info, buttonId, fontString, helpTip)
	LibDD:UIDropDownMenu_AddButton(info)
	
	if buttonId then
		_G["L_DropDownList1Button"..buttonId]:SetShown(true)
		if info then
			DeadpoolAddFontString(info, fontString, helpTip, _G["L_DropDownList1Button"..buttonId])
			_G["L_DropDownList1Button"..buttonId]:SetAttribute("checked", info.checked)
		end
	end
end

function DeadpoolDownMenu_AddSeparator(fontString)
	LibDD:UIDropDownMenu_AddSeparator(info)
end

function DeadpoolAddFontString(info, text, helpTip, belowFrame)
	if info.customFrame then
		info.customFrame.ShortcutText:SetText(text)
		info.customFrame:SetAttribute("helpTip", helpTip)
		if not info.notCheckable then
			info.customFrame:SetAttribute("helpTipOffsetX", 14)
		end
		info.customFrame:SetAttribute("buttonDisabled", info.disabled)
		info.customFrame:SetAttribute("belowFrame", belowFrame:GetName())
		info.customFrame:SetPoint("BOTTOMRIGHT", belowFrame, "BOTTOMRIGHT", 0, 0)
		belowFrame:SetFrameLevel(1)
		info.customFrame:SetFrameLevel(3)
	end
end

function DeadpoolDropDownButton_OnEnter(self)
	local helpTip = self:GetAttribute("helpTip")
	if helpTip then
		dpShowMenuHelpTip(helpTip, true, self, self:GetAttribute("helpTipOffsetX"))
	end
	local belowFrame = self:GetAttribute("belowFrame")
	local buttonDisabled = self:GetAttribute("buttonDisabled")
	if belowFrame and not buttonDisabled then
		UIDropDownMenuButton_OnEnter(_G[belowFrame])
	end
end

function DeadpoolDropDownButton_OnLeave(self)
	local helpTip = self:GetAttribute("helpTip")
	if helpTip then
		dpCloseMenuHelpTip(helpTip)
	end
	local belowFrame = self:GetAttribute("belowFrame")
	local buttonDisabled = self:GetAttribute("buttonDisabled")
	if belowFrame and not buttonDisabled then
		UIDropDownMenuButton_OnLeave(_G[belowFrame])
	end
end

function DeadpoolDropDownButton_OnClick(self)
	local belowFrame = self:GetAttribute("belowFrame")
	local buttonDisabled = self:GetAttribute("buttonDisabled")
	if belowFrame and not buttonDisabled then
		UIDropDownMenuButton_OnClick(_G[belowFrame])
	end
end

function DeadpoolDropDownButtonTuto_OnClick(self)
	local helpTip = self:GetAttribute("helpTip")
	local belowFrameName = self:GetAttribute("belowFrame")
	local belowFrame = _G[belowFrameName]
	local buttonDisabled = self:GetAttribute("buttonDisabled")
	if belowFrame and not buttonDisabled then
		local check = _G[belowFrameName.."Check"]
		local uncheck = _G[belowFrameName.."UnCheck"]
		local checked = belowFrame:GetAttribute("checked")
		belowFrame:SetAttribute("checked", not checked)
		deadpoolSetTuto(not checked, nil, "Menu")
		if (checked) then
			belowFrame:UnlockHighlight()
			check:Hide()
			uncheck:Show()
			dpCloseMenuHelpTip(helpTip)
		else
			belowFrame:LockHighlight()
			check:Show()
			uncheck:Hide()
			dpShowMenuHelpTip(helpTip, true, self, 16)
		end

	end
end

function DeadpoolDropDownButtonBet5BetSlider_OnValueChanged(self, value)
	local newValue = XITK.SimpleRound(value, self:GetValueStep())
	self:SetValue(newValue)
	self:GetParent().ShortcutText:SetText(newValue..deadpoolChipTextureString)
	self:SetAttribute("betToAdd", tostring(newValue))
	betSliderInitialValue = newValue
end
