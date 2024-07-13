local L = LibStub("AceLocale-3.0"):GetLocale("Deadpool", true)

L["DEADPOOLTUTO_CHIPS"] = L["DEADPOOLUI_CHIPS"].." ("..L["DEADPOOLUI_CHIPS_TOOLTIP"]..")|n"..L["DEADPOOLUI_CHIPS_TOOLTIPDETAIL"].."|n|n"..L["DEADPOOLUI_BANK"].." ("..L["DEADPOOLUI_BANK_TOOLTIP"]..")|n"..L["DEADPOOLUI_BANK_TOOLTIPDETAIL"].."|n|n"..L["DEADPOOLUI_BETS"].." ("..L["DEADPOOLUI_BETS_TOOLTIP"]..")|n"..L["DEADPOOLUI_BETS_TOOLTIPDETAIL"]

DeadpoolHelpTip = {}

do
	local function DeadpoolHelpTipReset(framePool, frame)
		frame:ClearAllPoints()
		frame:Hide()
		frame:Reset()
	end

	DeadpoolHelpTip.framePool = CreateFramePool("FRAME", nil, "DeadpoolHelpTipTemplate", DeadpoolHelpTipReset)
end

function DeadpoolHelpTip:Show(parent, info, relativeRegion, force)
	assert(info and info.text, "Invalid helptip info")
	assert((info.bitfieldFlag ~= nil and info.cvarBitfield ~= nil) or (info.bitfieldFlag == nil and info.cvarBitfield == nil))

	if not self:CanShow(info, force) then
		return false
	end

	if self:IsShowing(parent, info.text) then
		return true
	end

	local frame = self.framePool:Acquire()
	frame.width = HelpTip.width + (info.extraRightMarginPadding or 0)
	frame:SetWidth(frame.width)
	frame:Init(parent, info, relativeRegion or parent)

	local offLeft = frame:GetLeft()
	local offRight = GetScreenWidth() - frame:GetRight()
	local offTop = GetScreenHeight() - frame:GetTop()
	local offBottom = frame:GetBottom()

	local oldTargetPoint = info.targetPoint
	local oldOffsetX = info.offsetX
	local oldOffsetY = info.offsetY
	local newTargetPoint = info.targetPoint
	local newOffsetX = info.offsetX
	local newOffsetY = info.offsetY
	if ( offLeft < 0 ) then
		newTargetPoint = HelpTip.Point.RightEdgeCenter
		--newOffsetX = -newOffsetX
	elseif ( offRight < 0 ) then
		newTargetPoint = HelpTip.Point.LeftEdgeCenter
		--newOffsetX = -newOffsetX
	elseif ( offTop < 0 ) then
		newTargetPoint = HelpTip.Point.BottomEdgeCenter
		newOffsetY = -newOffsetY
	elseif ( offBottom < 0 ) then
		newTargetPoint = HelpTip.Point.TopEdgeCenter
		newOffsetY = -newOffsetY
	end

	if oldTargetPoint ~= newTargetPoint then
		info.targetPoint = newTargetPoint
		info.offsetX = newOffsetX
		info.offsetY = newOffsetY
		frame:Init(parent, info, relativeRegion or parent)
		info.targetPoint = oldTargetPoint
		info.offsetX = oldOffsetX
		info.offsetY = oldOffsetY
	end

	frame:Show()

	return true
end

function DeadpoolHelpTip:CanShow(info, force)
	if Kiosk.IsEnabled() then
		return false
	end

	if not force and DeadpoolOptionsData["MenuTutoDisabled"] then
		return false
	end

	if info.checkCVars then
		if info.cvar then
			if GetCVar(info.cvar) ~= info.cvarValue then
				return false
			end
		end
		if info.cvarBitfield then
			if GetCVarBitfield(info.cvarBitfield, info.bitfieldFlag) then
				return false
			end
		end
	end

	-- priority
	if info.system and info.systemPriority then
		for frame in self.framePool:EnumerateActive() do
			if frame.info.system == info.system and frame.info.systemPriority then
				if info.systemPriority > frame.info.systemPriority then
					frame:Close()
					-- by design there can only be one such frame, no need to keep going
					break
				else
					-- higher or equal priority is already shown
					return false
				end
			end
		end
	end

	return true
end

function DeadpoolHelpTip:IsShowing(parent, text)
	for frame in self.framePool:EnumerateActive() do
		if frame:Matches(parent, text) then
			return true
		end
	end
	return false
end

function DeadpoolHelpTip:IsShowingAny(parent)
	for frame in self.framePool:EnumerateActive() do
		if frame:Matches(parent) then
			return true
		end
	end
	return false
end

function DeadpoolHelpTip:HideAll(parent)
	local framesToClose = { }

	for frame in self.framePool:EnumerateActive() do
		if frame:Matches(parent) then
			tinsert(framesToClose, frame)
		end
	end

	for i, frame in ipairs(framesToClose) do
		frame:Close()
	end
end

function DeadpoolHelpTip:Hide(parent, text)
	for frame in self.framePool:EnumerateActive() do
		if frame:Matches(parent, text) then
			frame:Close()
			break
		end
	end
end

local dpHelpTipsInfo = {}
local defaultMenuHelpTipOffsetX = -10

if HelpTip then
	dpHelpTipsInfo = {
		["DEADPOOLTUTO_MINIMIZE"] = {
			["info"] = {
				text = L["DEADPOOLTUTO_MINIMIZE"], -- |TInterface\\Buttons\\UI-Panel-SmallerButton-Up:15:15:0:0:32:32:7:25:8:26|t 
				buttonStyle = HelpTip.ButtonStyle.GotIt,
				targetPoint = HelpTip.Point.TopEdgeCenter,
				useParentStrata = true,
				onAcknowledgeCallback = function() dpAcknowledgeHelpTip("DEADPOOLTUTO_MINIMIZE") end,
				offsetX = 0,
				offsetY = -5,
			},
			["relativeRegion"] = "DeadpoolFrameMinimize",
			["group"] = "DeadpoolFrame",
			["parent"] = "dpHelpToolTipFrame"
		},
		["DEADPOOLTUTO_BOSS"] = {
			["info"] = {
				text = L["DEADPOOLTUTO_BOSS"],
				buttonStyle = HelpTip.ButtonStyle.GotIt,
				targetPoint = HelpTip.Point.LeftEdgeCenter,
				useParentStrata = true,
				onAcknowledgeCallback = function() dpAcknowledgeHelpTip("DEADPOOLTUTO_BOSS") end,
				offsetX = 0,
				offsetY = 0,
			},
			["relativeRegion"] = "DeadpoolFrame",
			["group"] = "DeadpoolFrame",
			["parent"] = "dpHelpToolTipFrameMouseOver"
		},
		["MENU_HELPTIP"] = {
			["info"] = {
				text = L["DEADPOOLTUTO_BET"],
				buttonStyle = HelpTip.ButtonStyle.None,
				targetPoint = HelpTip.Point.LeftEdgeCenter,
				useParentStrata = true,
				offsetX = defaultMenuHelpTipOffsetX,
				offsetY = 0,
			},
			["relativeRegion"] = "DeadpoolDropDown",
			["group"] = "L_DropDownList1",
			["parent"] = "L_DropDownList1"
		},
	}
end

local dpPlayerSpecFrame_HelpPlate = {
	FramePos = { x = 0,	y = -22 },
	FrameSize = { width = 645, height = 446	},
	[1] = { ButtonPos = { x = 88,	y = -22 }, HighLightBox = { x = 8, y = -30, width = 204, height = 382 },	ToolTipDir = "UP",		ToolTipText = SPEC_FRAME_HELP_1 },
	[2] = { ButtonPos = { x = 570,	y = -22 }, HighLightBox = { x = 224, y = -6, width = 414, height = 408 },	ToolTipDir = "RIGHT",	ToolTipText = SPEC_FRAME_HELP_2 },
	[3] = { ButtonPos = { x = 355,	y = -409}, HighLightBox = { x = 268, y = -418, width = 109, height = 26 },	ToolTipDir = "RIGHT",	ToolTipText = SPEC_FRAME_HELP_3 },
}

dpHelpToolTipFrame = CreateFrame("Frame", "DeadpoolHelpToolTipFrame", UIParent)
dpHelpToolTipFrame:SetFrameStrata("LOW")

dpHelpToolTipFrameMouseOver = CreateFrame("Frame", "DeadpoolHelpToolTipFrame", UIParent)
dpHelpToolTipFrameMouseOver:SetFrameStrata("LOW")

function dpSetHelpTipFramesStrata(strata)
	dpHelpToolTipFrame:SetFrameStrata(strata)
	dpHelpToolTipFrameMouseOver:SetFrameStrata(strata)
end

function dpInitializeHelp()
	dpShowHelpTip("DEADPOOLTUTO_MINIMIZE")
end

function dpIsShowingHelpTips()
	if HelpTip then
		return DeadpoolHelpTip:IsShowingAny(dpHelpToolTipFrame)
	end
end

function dpShowAllHelpTips()
	dpShowHelpTip("DEADPOOLTUTO_MINIMIZE", true)
	--dpShowHelpTip("DEADPOOLTUTO_BOSS", true)
end

function dpHideAllHelpTips()
	if HelpTip then
		DeadpoolHelpTip:HideAll(dpHelpToolTipFrame)
	end
end

function dpShowHelpTip(helpTip, force, relativeRegion, hideOther)
	if HelpTip then
		if dpHelpTipsInfo[helpTip] then
			if (not DeadpoolTuto[helpTip] or force) and _G[dpHelpTipsInfo[helpTip]["group"]]:IsShown() then
				if hideOther then
					HelpTip:HideAll(_G[dpHelpTipsInfo[helpTip]["parent"]])
				end
				DeadpoolHelpTip:Show(_G[dpHelpTipsInfo[helpTip]["parent"]], dpHelpTipsInfo[helpTip]["info"], relativeRegion or _G[dpHelpTipsInfo[helpTip]["relativeRegion"]], force)
			end
		end
	end
end

function dpShowMenuHelpTip(helpTip, force, relativeRegion, offsetX)
	if HelpTip and not DeadpoolOptionsData["MenuTutoDisabled"] then
		dpHelpTipsInfo["MENU_HELPTIP"]["info"]["offsetX"] = defaultMenuHelpTipOffsetX + (offsetX or 0)
		dpHelpTipsInfo["MENU_HELPTIP"]["info"]["text"] = helpTip
		if (not DeadpoolTuto[helpTip] or force) and _G[dpHelpTipsInfo["MENU_HELPTIP"]["group"]]:IsShown() then
			DeadpoolHelpTip:Show(_G[dpHelpTipsInfo["MENU_HELPTIP"]["parent"]], dpHelpTipsInfo["MENU_HELPTIP"]["info"], relativeRegion or _G[dpHelpTipsInfo["MENU_HELPTIP"]["relativeRegion"]], force)
		end
	end
end

function dpAcknowledgeHelpTip(helpTip)
	if HelpTip then
		DeadpoolTuto[helpTip] = "Done"
	end
end

function dpCloseMenuHelpTip(helpTip)
	DeadpoolHelpTip:Hide(L_DropDownList1, helpTip)
end

function DeadpoolHelpTipTemplate_OnHide(self)
	self:UnregisterEvent("UI_SCALE_CHANGED");
	self:UnregisterEvent("DISPLAY_SIZE_CHANGED");

	local info = self.info;
	local appendFrame = info.appendFrame;
	if appendFrame then
		appendFrame:Hide();
		appendFrame:ClearAllPoints();
		appendFrame:SetParent(UIParent);
	end

	if info.onHideCallback then
		info.onHideCallback(self.acknowledged, info.callbackArg);
	end
	if not self.acknowledged and info.acknowledgeOnHide then
		self:HandleAcknowledge();
	end
	if self.acknowledged and info.onAcknowledgeCallback then
		info.onAcknowledgeCallback(info.callbackArg);
	end
	--HelpTip:Release(self);
end