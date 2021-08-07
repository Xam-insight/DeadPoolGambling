if (not EZBlizzardUiPopupsTooltip) then
	CreateFrame("GameTooltip", "EZBlizzardUiPopupsTooltip", UIParent, "GameTooltipTemplate")
	EZBlizzardUiPopupsTooltip:SetFrameStrata("TOOLTIP")
	EZBlizzardUiPopupsTooltip:Hide()
end

function EZBlizzardUiPopups_PlaySound(soundID)
	if soundID then
		PlaySound(soundID, "master")
	end
end

-- Tip by Gello - Hyjal
-- takes an npcID and returns the name of the npc
function EZBlizzardUiPopups_GetNameFromNpcID(npcID)
	local name = ""
	
	EZBlizzardUiPopupsTooltip:SetOwner(UIParent, "ANCHOR_NONE");
	EZBlizzardUiPopupsTooltip:SetHyperlink(format("unit:Creature-0-0-0-0-%d-0000000000", npcID))
	
	local line = _G[("EZBlizzardUiPopupsTooltipTextLeft%d"):format(1)]
	if line and line:GetText() then
		name = line:GetText()
	end
	
	return name
end

-- TOASTS - Thanks to Tuhljin from Overachiever !
-----------

--local function alertOnClick(self, ...)
function EZBlizzardUiPopups_AlertFrame_OnClick(self, ...)
	if (self.delay == -1) then
		self:SetScript("OnLeave", AlertFrame_ResumeOutAnimation)
		self.delay = 0
	end
	if (self.onClick) then
		if (AlertFrame_OnClick(self, ...)) then  return;  end -- Handle right-clicking to hide the frame.
		self.onClick(self, ...)
	elseif (self.onClick == false) then
		AlertFrame_OnClick(self, ...)
	else
		AchievementAlertFrame_OnClick(self, ...)
	end
end

local function EZBlizzardUiPopups_AlertFrame_SetUp(frame, achievementID, alreadyEarned, name, delay, toptext, onClick, icon)
	-- An alert flagged as alreadyEarned has more space for the text to display since there's no shield+points icon.
	local ret = AchievementAlertFrame_SetUp(frame, achievementID, alreadyEarned)
	frame.Name:SetText(name)
	frame.Unlocked:SetText(toptext or (toptext == false and THIS_TITLE) or ACHIEVEMENT_UNLOCKED)
	frame.onClick = onClick
	frame.delay = delay
	frame:SetScript("OnClick", EZBlizzardUiPopups_AlertFrame_OnClick)
	if (delay) then
		if (delay <= 0) then
			C_Timer.After(0, function()  AlertFrame_StopOutAnimation(frame);  end)
		else
			C_Timer.After(0, function()
				frame.waitAndAnimOut.animOut:SetStartDelay(delay)
			end)
		end
	end
	if (delay == -1) then
		frame:SetScript("OnLeave", nil)
	else
		frame:SetScript("OnLeave", AlertFrame_ResumeOutAnimation)
	end
	if (icon) then
		--HEY = HEY or { frame.Icon.Texture:GetTexCoord() }
		frame.Icon.Texture:SetTexture(icon)
		frame.Icon.Texture:SetTexCoord(0.0, 1.0, 0.0, 1.0)
		--frame.Background:SetTexture(TexAlert)
		--frame.OldAchievement:SetTexture(TexAlertBorders)
	else
		frame.Icon.Texture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		--frame.Background:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Background")
		--frame.OldAchievement:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Borders")
	end
end

function EZBlizzardUiPopups_ToastFakeAchievement(addon, name, baseID, playSound, delay, toptext, onClick, icon, newEarn)
  if AchievementFrame_LoadUI then
	  if (IsKioskModeEnabled and IsKioskModeEnabled()) then
		return;
	  end
	  if ( not AchievementFrame ) then
		AchievementFrame_LoadUI();
	  end

	  if (not addon.AlertSystem) then
		addon.AlertSystem = AlertFrame:AddQueuedAlertFrameSubSystem("AchievementAlertFrameTemplate", EZBlizzardUiPopups_AlertFrame_SetUp, 4, math.huge)
	  end

	  if (not baseID) then  baseID = 5208;  end -- 5208 is "Twin Peaking", chosen because of its thumbs-up texture.
	  addon.AlertSystem:AddAlert(baseID, not newEarn, name, delay, toptext, onClick, icon)

	  if (playSound) then EZBlizzardUiPopups_PlaySound(12891);  end -- UI_Alert_AchievementGained
  end
end

-- NPC dialog pop-up
-----------

local modelAnimationLoop = 2

local npcModels = {
	["BAINE"]                 = { ["CreatureId"] = 36648,  ["CameraId"] = 141, ["animation"] = 60 }, -- or animation 65 ?
	["SYLVANAS"]              = { ["CreatureId"] = 10181,  ["CameraId"] = 84,  ["animation"] = 60 },
	["ANDUIN"]                = { ["CreatureId"] = 107574, ["CameraId"] = 82,  ["animation"] = 60 },
	["ALLIANCE_GUILD_HERALD"] = { ["CreatureId"] = 49587,  ["CameraId"] = 82,  ["animation"] = 60 },
	["VARIAN"]                = { ["CreatureId"] = 29611,  ["CameraId"] = 82,  ["animation"] = 60 },
	["HEMET"]                 = { ["CreatureId"] = 94409,  ["CameraId"] = 90,  ["animation"] = 60 },
	["RAVERHOLDT"]            = { ["CreatureId"] = 101513, ["CameraId"] = 82,  ["animation"] = 60 },
	["UTHER"]                 = { ["CreatureId"] = 17233,  ["CameraId"] = 82,  ["animation"] = 60 },
	["VELEN"]                 = { ["CreatureId"] = 17468,  ["CameraId"] = 106, ["animation"] = 60 },
	["NOBUNDO"]               = { ["CreatureId"] = 110695, ["CameraId"] = 268, ["animation"] = 60 },
	["KHADGAR"]               = { ["CreatureId"] = 90417,  ["CameraId"] = 82,  ["animation"] = 60 },
	["CHOGALL"]               = { ["CreatureId"] = 81822,  ["CameraId"] = 815, ["animation"] = 60 },
	["CHEN"]                  = { ["CreatureId"] = 56133,  ["CameraId"] = 144, ["animation"] = 60 },
	["MALFURION"]             = { ["CreatureId"] = 102432, ["CameraId"] = 575, ["animation"] = 60 },
	["ILLIDAN"]               = { ["CreatureId"] = 22917,  ["CameraId"] = 296, ["animation"] = 60 },
	["LICH_KING"]             = { ["CreatureId"] = 36597,  ["CameraId"] = 88,  ["animation"] = 60 },
	["HORDE_GUILD_HERALD"]    = { ["CreatureId"] = 49590,  ["CameraId"] = 141, ["animation"] = 60 },
	["THRALL"]                = { ["CreatureId"] = 91731,  ["CameraId"] = 815, ["animation"] = 60 },
	["GALLYWIX"]              = { ["CreatureId"] = 101605, ["CameraId"] = 114, ["animation"] = 51 }
}
EZBlizzardUiPopups_npcModels = npcModels

function EZBlizzardUiPopups_npcDialog(npc, text)
	local frame = nil
	if TalkingHead_LoadUI then
		frame = EZBlizzardUiPopups_npcDialogShow(npc, text)
	end
	return frame
end

function EZBlizzardUiPopups_npcDialogShow(npc, text)
	local frame = nil
	if text then
		if ( not TalkingHeadFrame ) then
			TalkingHead_LoadUI()
		end

		frame = TalkingHeadFrame
		
		local model = frame.MainFrame.Model
		model:ClearModel()
		model:SetCreature(npcModels[npc]["CreatureId"])
		--model:SetDisplayInfo(npcModels[npc]["CreatureId"])
		EZBlizzardUiPopups_TalkingHeadFrame_Play(npcModels[npc]["CameraId"], EZBlizzardUiPopups_GetNameFromNpcID(npcModels[npc]["CreatureId"]), text, npcModels[npc]["animation"])

	end
	return frame
end

local modelAnimationLoopIterration = 0
function EZBlizzardUiPopups_TalkingHeadFrame_Play(cameraId, name, text, animation)
	local frame = TalkingHeadFrame
	local model = frame.MainFrame.Model
	
	local textFormatted = string.format(text)
	frame:Show()
	model.uiCameraID = cameraId
	Model_ApplyUICamera(model, model.uiCameraID)

	TalkingHeadFrame_Reset(frame, textFormatted, name)
	TalkingHeadFrame_FadeinFrames()
	C_Timer.After(0.1, function()
		model:SetAnimation(animation)
		model:SetScript("OnAnimFinished", function()
			modelAnimationLoopIterration = modelAnimationLoopIterration + 1
			if modelAnimationLoopIterration < modelAnimationLoop then
				model:SetAnimation(animation)
			else
				model:SetAnimation(0)
				model:SetScript("OnAnimFinished", nil)
				modelAnimationLoopIterration = 0
			end
		end)
	end)
	C_Timer.After(10, function() TalkingHeadFrame_Close() end)
end

--[[
local camId = 114
local creatureId = 101605
local imageSize = 80
local animation = 144

for i = 0, 15 do
	for j = 0, 8 do
		local totopModel = CreateFrame("PlayerModel", "", UIParent)
		totopModel:SetPoint("TOPLEFT", i*imageSize, -j*imageSize - 30)
		totopModel:SetWidth(imageSize)
		totopModel:SetHeight(imageSize)
		totopModel:SetCreature(creatureId)
		--totopModel:SetDisplayInfo(creatureId)
		Model_ApplyUICamera(totopModel, camId)
		local fontstring = totopModel:CreateFontString("", "ARTWORK", "GameTooltipText")
		fontstring:SetTextColor(1, 1, 1, 1.0)
		fontstring:SetText(animation)
		fontstring:SetPoint("BOTTOM", 0, 0)
		totopModel:SetAnimation(animation)
		totopModel:SetAttribute("animation", animation)
		totopModel:SetScript("OnAnimFinished", function()
			totopModel:SetAnimation(totopModel:GetAttribute("animation"))
		end)
		--camId = camId + 1
		animation = animation + 1
	end
end
--]]

--[[

	local totopModel = CreateFrame("PlayerModel", "", UIParent)
	totopModel:SetPoint("CENTER", 0, 0)
	totopModel:SetWidth(200)
	totopModel:SetHeight(200)
	totopModel:SetCreature(107574)
	totopModel:SetCamDistanceScale(1.5)
	totopModel:SetPortraitZoom(1)
	totopModel:SetRotation(-0.3)

--]]

-- Loading models
local model = CreateFrame('PlayerModel', nil, UIParent)
for index,value in pairs(npcModels) do
	model:SetCreature(npcModels[index]["CreatureId"])
	--model:SetDisplayInfo(npcModels[index]["CreatureId"])
	model:ClearModel()
end
model:Hide()
--]]
