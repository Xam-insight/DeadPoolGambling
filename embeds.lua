local L = LibStub("AceLocale-3.0"):GetLocale("Deadpool", true)

function DeadpoolWindow_OnShow()
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
