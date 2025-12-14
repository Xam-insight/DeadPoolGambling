local L = LibStub("AceLocale-3.0"):GetLocale("Deadpool", true)
local XITK = LibStub("XamInsightToolKit")

local miniDeadpoolLines = {}

miniDeadpoolLineHeight = 15
DeadpoolGlobal_MiniBetweenObjectsGap = 5

function deadpoolMiniFrame()
	--NewMiniDeadpoolFrame
	MiniDeadpoolFrame = CreateFrame("Frame", "MiniDeadpoolFrame", UIParent, "MiniDeadpoolFrameTemplate")
	MiniDeadpoolFrame:SetScale(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolScale"] or 1.0)
	MiniDeadpoolFrame.alphaFunc = setMiniDeadpoolFrameAlpha
	
	local fontstring = MiniDeadpoolFrame:CreateFontString("MiniDeadpoolLabel", "ARTWORK", "DeadpoolWindowTitleTemplate")
    fontstring:SetText("Dead Pool")
    fontstring:SetPoint("TOP", 0, -7)

	MiniDeadpoolFrame.Lock:SetAttribute("tooltip", L["LOCKBUTTON_TOOLTIP"])
	MiniDeadpoolFrame.Lock:SetAttribute("tooltipDetail", { L["LOCKBUTTON_TOOLTIPDETAIL"] })
	
	local deadpoolOptionsButton = createDeadpoolOptionsButton(MiniDeadpoolFrame)
	deadpoolOptionsButton:SetScale(0.7)

	for i = 1, DEADPOOL_NUM_LINES do
		local line = CreateFrame("Button", "MiniDeadpoolLine"..i, MiniDeadpoolFrame.Inset, "DeadpoolLineTemplate")
		--line:SetHighlightTexture("Interface/FriendsFrame/UI-FriendsFrame-HighlightBar-Blue", 0.4)
		if i == 1 then
			line:SetPoint("TOPLEFT", MiniDeadpoolFrame.Inset, 0, -3)
		else
			line:SetPoint("TOPLEFT", miniDeadpoolLines[i - 1], "BOTTOMLEFT")
		end
		line:SetSize(MiniDeadpoolFrame.Inset:GetWidth(), miniDeadpoolLineHeight)
		line:Hide()
		line:EnableMouse(false)
		miniDeadpoolLines[i] = line
	end
end

function updateMiniDeadpoolFrame()
	if MiniDeadpoolFrame and MiniDeadpoolFrame:IsShown() then
		local numItems = XITK.countTableElements(deadpoolList)
		if numItems > 10 then
			miniDeadpoolLineHeight = 10
			MiniDeadpoolFrame.Inset:SetPoint("TOPLEFT", 20, -26)
			MiniDeadpoolFrame.Inset:SetPoint("BOTTOMRIGHT", -22, 26)
		else
			miniDeadpoolLineHeight = 15
			MiniDeadpoolFrame.Inset:SetPoint("TOPLEFT", 10, -26)
			MiniDeadpoolFrame.Inset:SetPoint("BOTTOMRIGHT", -12, 26)
		end
	
		updateDeadpoolList(deadpoolCharInfo)
		local nbLignes = 0
		for index,miniDeadpoolLine in pairs(miniDeadpoolLines) do
			if miniDeadpoolLine and deadpoolList[index] then
				miniDeadpoolLine:SetHeight(miniDeadpoolLineHeight)
				createDeadpoolLine(DeadpoolGlobal_SessionId, index, deadpoolList[index], miniDeadpoolLine, false, true)
				miniDeadpoolLine:Show()
				nbLignes = nbLignes + 1
			else
				miniDeadpoolLine:Hide()
			end
		end
		MiniDeadpoolFrame:SetHeight(58 + nbLignes * miniDeadpoolLineHeight)
	end
end

function applyMiniDeadpoolWindowOptions()
	setMiniDeadpoolFrameAlpha()

	retOK, ret = pcall(callbackDeadpoolWindow, MiniDeadpoolFrame)

	local windowLocked = DeadpoolWindow[Deadpool_WindowsOptions]["MiniDeadpoolWindowLocked"]
	MiniDeadpoolFrameLock:SetChecked(windowLocked)
	MiniDeadpoolFrame.canMove = not windowLocked
	DPEnableMouse(MiniDeadpoolFrame, not windowLocked)
end

function setMiniDeadpoolFrameAlpha()
	if MiniDeadpoolFrame and DeadpoolOptionsData and DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"] then
		MiniDeadpoolFrameInset.Bg:SetAlpha(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"])
		MiniDeadpoolFrameMaximize:SetAlpha(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"])
		MiniDeadpoolFrameLock:SetAlpha(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"])
	end
end
