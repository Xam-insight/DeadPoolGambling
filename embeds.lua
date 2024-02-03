local L = LibStub("AceLocale-3.0"):GetLocale("Deadpool", true)

function DeadpoolWindow_OnShow(self)
	DeadpoolTrulyUnequipSwitch:Hide()
	DeadpoolTrulyUnequipSwitch:SetParent(self)
	DeadpoolTrulyUnequipSwitch:ClearAllPoints()
	if self == MiniDeadpoolFrame then
		DeadpoolTrulyUnequipSwitch:SetScale(0.8)
		DeadpoolTrulyUnequipSwitch:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 35, -30)
		DeadpoolTrulyUnequipSwitch:SetAlpha(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"])
	else
		DeadpoolTrulyUnequipSwitch:SetScale(1.0)
		DeadpoolTrulyUnequipSwitch:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 55, 2)
		DeadpoolTrulyUnequipSwitch:SetAlpha(1.0)
	end
	DeadpoolTrulyUnequipSwitch:Show()
	if DeadpoolGlobal_shownModel then
		dpShowModel(DeadpoolGlobal_shownModel.char)
	end
	generateDeadpoolTable()
end

function DeadpoolWindow_OnHide()
	if DeadpoolGlobal_shownModel then
		hideDressUpModel(DeadpoolGlobal_shownModel)
		dpShowModel(DeadpoolGlobal_shownModel.char)
	end
end

function DeadpoolCredits_OnLoad(self, locale, mini)
	local frame = _G[self:GetName()]
	local frameLabel = _G[self:GetName().."Name"]
	frameLabel:SetText(L[locale])
	if mini then
		local frameCountLabel = _G[self:GetName().."Count"]
		local fontName, fontHeight, fontFlags = frameLabel:GetFont()
		local icon = _G[self:GetName().."Icon"]
		frameLabel:SetFont(fontName, fontHeight-3, fontFlags)
		frameCountLabel:SetFont(fontName, fontHeight-3, fontFlags)
		icon:SetSize(13, 13)
	else
		frame:SetAttribute("tooltip", L[locale.."_TOOLTIP"])
		frame:SetAttribute("tooltipDetail", { L[locale.."_TOOLTIPDETAIL"] })
		frame:SetAttribute("tooltipDetailGreen", { L[locale.."_TOOLTIPDETAILGREEN"] })
	end
end

function DPTutorialButton_OnClick()
	if dpIsShowingHelpTips() then
		dpHideAllHelpTips()
	else
		dpShowAllHelpTips()
	end
end

function DeadpoolResultsTooltip_OnMouseDown(self)
	DeadpoolWinnerTooltip:Hide()
	DeadpoolWinnerTooltip:SetAttribute("shown", nil)
	DeadpoolResultsTooltip:Hide()
	DeadpoolResultsTooltip:SetAttribute("shown", nil)
end

function DeadpoolResultsTooltip_OnShow(self)
	self:SetAlpha(1.0)
	C_Timer.After(8, function()
		if not self:GetAttribute("stopFadeOutTimer") then
			local endAlpha = 0
			if DeadpoolFrame and DeadpoolFrame:IsShown() then
				endAlpha = DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"]
			end
			DPTooltips_FadeOut(self, endAlpha)
		end
	end)
end

function DeadpoolResultsTooltip_OnEnter(self)
	DeadpoolWinnerTooltip:SetAttribute("stopFadeOutTimer", true)
	DeadpoolResultsTooltip:SetAttribute("stopFadeOutTimer", true)
	UIFrameFadeRemoveFrame(DeadpoolWinnerTooltip)
	UIFrameFadeRemoveFrame(DeadpoolResultsTooltip)
	DeadpoolWinnerTooltip:SetAlpha(1.0)
	DeadpoolResultsTooltip:SetAlpha(1.0)
end

function DeadpoolResultsTooltip_OnLeave(self)
	local endAlpha = 0
	if DeadpoolFrame and DeadpoolFrame:IsShown() then
		endAlpha = DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"]
	end
	DeadpoolWinnerTooltip:SetAttribute("stopFadeOutTimer", nil)
	DeadpoolResultsTooltip:SetAttribute("stopFadeOutTimer", nil)
	DPTooltips_FadeOut(DeadpoolWinnerTooltip, endAlpha)
	DPTooltips_FadeOut(DeadpoolResultsTooltip, endAlpha)
end

function DPDressUpModel_OnEnter(self)
	if self and self:GetParent() == UIParent then
		self.CloseButton:Show()
	end
end

function DPDressUpModel_OnLeave(self)
	if self and self.CloseButton:IsShown() and not MouseIsOver(self.CloseButton) then
		self.CloseButton:Hide()
	end
end

function DPDressUpModelCloseButton_OnClick(self)
	local parent = self:GetParent()
	hideDressUpModel(parent)
end

function DPDressUpModelCloseButton_OnLeave(self)
	if self and not MouseIsOver(self:GetParent()) then
		self:Hide()
	end
end

function DPEnableMouse(frame, enableMouse)
	if frame then
		frame:EnableMouse(enableMouse)
		if frame.PlayerCredits then
			frame.PlayerCredits:EnableMouse(enableMouse)
			if frame.BankCredits then
				frame.BankCredits:EnableMouse(enableMouse)
				if frame.BetsCredits then
					frame.BetsCredits:EnableMouse(enableMouse)
				end
			end
		end
	end
end

function DeadpoolFrameMaximizeMinimizeButton_OnLoad(self)
	local function OnMinimize(frame)
		dpAcknowledgeHelpTip("DEADPOOLTUTO_MINIMIZE")
		hideDeadpoolWindow()
		Deadpool:DeadpoolShow(true, true)
	end

	self:SetOnMinimizedCallback(OnMinimize);
end

function CreateDeadpoolChip()--/run CreateDeadpoolChip()
	local deadpoolChipFrame = CreateFrame("Frame", "DeadpoolChip", UIParent, "DeadpoolChipTemplate")
	deadpoolChipFrame:Show()
	deadpoolChipFrame:SetAttribute("Type", "DeadpoolChip")
	
	return deadpoolChipFrame
end

function FlipDeadpoolChip(chipFrame)--/run FlipDeadpoolChip(DeadpoolChip)
	if chipFrame and chipFrame:GetAttribute("Type") == "DeadpoolChip" then
		chipFrame.ChipTexture:Hide()
		chipFrame.ChipValue:Hide()
		chipFrame.FlippingChipTexture:Show()
		chipFrame.FlippingChipLoopAnim:Play()
	end
end

function DeadpoolTrulyUnequip_OnLoad(self)
	self:SetAttribute("tooltip", L["ENABLE_TRULY_UNEQUIP_ITEMS"])
	self:SetAttribute("tooltipDetail", { L["ENABLE_TRULY_UNEQUIP_ITEMS_TOOLTIP"] })
	
	DeadpoolTrulyUnequip_UpdateStatus(self)
end

function DeadpoolTrulyUnequip_UpdateStatus(self)
	local player = Deadpool_playerCharacter()
	local trulyUnequipItems = getDeadpoolData(DeadpoolGlobal_SessionId, player, DEADPOOL_TRULYUNEQUIP)
	trulyUnequipItems = trulyUnequipItems and trulyUnequipItems == "true"
	
	self:SetAttribute("value", trulyUnequipItems)
	if trulyUnequipItems then
		self:ApplyVisualState(TalentButtonUtil.BaseVisualState.Normal)
	else
		self:ApplyVisualState(TalentButtonUtil.BaseVisualState.Disabled)
	end
end

function DeadpoolTrulyUnequip_UpdateCooldown(self)
	local cooldown = self.Cooldown;
	CooldownFrame_Set(cooldown, GetTime(), 4, true, true);
	if ( duration and duration > 0 and enable == 0 ) then
		SetItemButtonTextureVertexColor(button, 0.4, 0.4, 0.4);
	end
end

function DeadpoolTrulyUnequip_Glow(self)
	self.shouldGlow = true;
	self:UpdateNonStateVisuals()
	C_Timer.After(1.44, function()
		self.shouldGlow = false
		self:UpdateNonStateVisuals()
	end)
end
