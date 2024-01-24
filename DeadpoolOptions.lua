local ACR = LibStub("AceConfigRegistry-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Deadpool", true)

local sidesValues = {
	[0] = RESET_POSITION,
	["LEFT"] = L["MODEL_POPUP_SIDE_LEFT"],
	["RIGHT"] = L["MODEL_POPUP_SIDE_RIGHT"],
}
local sidesSorting = {
	[1] = 0,
	[2] = "LEFT",
	[3] = "RIGHT",
}

function loadDeadpoolOptions()
	local DeadpoolOptions = {
		type = "group",
		name = format("%s |cffADFF2Fv%s|r", "Dead Pool", GetAddOnMetadata("Deadpool", "Version")),
		args = {
			general = {
				type = "group", order = 1,
				name = L["GENERAL_SECTION"],
				inline = true,
				args = {
					enableMiniMapButton = {
						type = "toggle", order = 1,
						name = L["ENABLE_MINIMAPBUTTON"],
						desc = L["ENABLE_MINIMAPBUTTON_DESC"],
						set = function(info, val)
							DeadpoolMIcon.minimapIcon.hide = not val
							local libDBIcon = LibStub("LibDBIcon-1.0")
							if DeadpoolMIcon.minimapIcon.hide then
								libDBIcon:Hide("Deadpool")
							else
								libDBIcon:Show("Deadpool")
							end
						end,
						get = function(info)
							return not DeadpoolMIcon.minimapIcon.hide
						end
					},
					enableBetButton = {
						type = "toggle", order = 2,
						width = "double",
						name = L["ENABLE_BETBUTTON"],
						desc = L["ENABLE_BETBUTTON_DESC"],
						set = function(info, val)
							if not val then
								DeadpoolBetButton:Hide()
							end
							DeadpoolOptionsData["BetButtonDisabled"] = not val
						end,
						get = function(info)
							return not DeadpoolOptionsData["BetButtonDisabled"]
						end
					},
					enableTuto = {
						type = "toggle", order = 3,
						name = L["ENABLE_TUTO"],
						desc = L["ENABLE_TUTO_DESC"],
						set = function(info, val) 
							deadpoolSetTuto(val, true)
						end,
						get = function(info)
							return deadpoolGetTuto()
						end
					}
				},
			},
			rules = {
				type = "group", order = 2,
				name = L["RULES_SECTION"],
				inline = true,
				args = {
					unequipItems = {
						type = "toggle", order = 1,
						width = "double",
						name = L["ENABLE_TRULY_UNEQUIP_ITEMS"],
						desc = L["ENABLE_TRULY_UNEQUIP_ITEMS_DESC"],
						disabled = function()
							return DeadpoolTrulyUnequipSwitch.Cooldown:GetCooldownDuration() ~= 0
						end,
						set = function(info, val)
							setUnequipItemsValue(val)
						end,
						get = function(info)
							local val = getDeadpoolData(DeadpoolGlobal_SessionId, Deadpool_playerCharacter(), "trulyUnequipItems")
							return val and val == "true"
						end
					},
					savingDataAfterLeavingGroup = {
						type = "toggle", order = 2,
						width = "double",
						name = L["ENABLE_SAVING_DATA_AFTER_LEAVING_GROUP"],
						desc = L["ENABLE_SAVING_DATA_AFTER_LEAVING_GROUP_DESC"],
						set = function(info, val)
							DeadpoolOptionsData["DataSavingDisabled"] = not val
						end,
						get = function(info)
							return not DeadpoolOptionsData["DataSavingDisabled"]
						end
					}
				}
			},
			notifications = {
				type = "group", order = 3,
				name = L["NOTIFICATIONS_SECTION"],
				inline = true,
				args = {
					enableInBossFights = {
						type = "toggle", order = 1,
						width = "full",
						name = L["ENABLE_NOTIFICATIONS_IN_BOSS_FIGHTS"],
						desc = L["ENABLE_NOTIFICATIONS_IN_BOSS_FIGHTS_DESC"],
						set = function(info, val) 
							DeadpoolOptionsData["DeadpoolNotificationsInBossFightsDisabled"] = not val
						end,
						get = function(info)
							local enabled = true
							if DeadpoolOptionsData["DeadpoolNotificationsInBossFightsDisabled"] ~= nil then
								enabled = not DeadpoolOptionsData["DeadpoolNotificationsInBossFightsDisabled"]
							end
							return enabled
						end
					},
					enableSound = {
						type = "toggle", order = 2,
						name = L["ENABLE_SOUND"],
						desc = L["ENABLE_SOUND_DESC"],
						set = function(info, val) 
							DeadpoolOptionsData["DeadpoolSoundsDisabled"] = not val
						end,
						get = function(info)
							local enabled = true
							if DeadpoolOptionsData["DeadpoolSoundsDisabled"] ~= nil then
								enabled = not DeadpoolOptionsData["DeadpoolSoundsDisabled"]
							end
							return enabled
						end
					},
					enableReminder = {
						type = "toggle", order = 3,
						width = "double",
						name = L["ENABLE_REMINDER"],
						desc = L["ENABLE_REMINDER_DESC"],
						set = function(info, val) 
							DeadpoolOptionsData["DeadpoolBetReminder"] = val
						end,
						get = function(info)
							return DeadpoolOptionsData["DeadpoolBetReminder"]
						end
					},enableDeathAnnounce = {
						type = "toggle", order = 4,
						name = L["ENABLE_DEATH_ANNOUNCE"],
						desc = L["ENABLE_DEATH_ANNOUNCE_DESC"],
						set = function(info, val) 
							DeadpoolOptionsData["DeadpoolDeathAnnounceDisabled"] = not val
						end,
						get = function(info)
							local enabled = true
							if DeadpoolOptionsData["DeadpoolDeathAnnounceDisabled"] ~= nil then
								enabled = not DeadpoolOptionsData["DeadpoolDeathAnnounceDisabled"]
							end
							return enabled
						end
					},
					enableDeathQuotes = {
						type = "toggle", order = 5,
						name = L["ENABLE_DEATH_QUOTES"],
						desc = L["ENABLE_DEATH_QUOTES_DESC"],
						set = function(info, val) 
							DeadpoolOptionsData["DeadpoolDeathQuotesDisabled"] = not val
							if val then
								if val then
									Deadpool_PlayRandomSound(deathQuotes, "Dialog")
								end
							end
						end,
						get = function(info)
							local enabled = true
							if DeadpoolOptionsData["DeadpoolDeathQuotesDisabled"] ~= nil then
								enabled = not DeadpoolOptionsData["DeadpoolDeathQuotesDisabled"]
							end
							return enabled
						end
					},
					enableAchievementAnnounce = {
						type = "toggle", order = 6,
						name = L["ENABLE_ACHIEVEMENT_ANNOUNCE"],
						desc = L["ENABLE_ACHIEVEMENT_ANNOUNCE_DESC"],
						set = function(info, val) 
							DeadpoolOptionsData["DeadpoolAchievementAnnounceDisabled"] = not val
						end,
						get = function(info)
							local enabled = true
							if DeadpoolOptionsData["DeadpoolAchievementAnnounceDisabled"] ~= nil then
								enabled = not DeadpoolOptionsData["DeadpoolAchievementAnnounceDisabled"]
							end
							return enabled
						end
					},
					enableModelPopup = {
						type = "toggle", order = 7,
						name = L["ENABLE_MODEL_POPUP"],
						desc = L["ENABLE_MODEL_POPUP_DESC"],
						set = function(info, val) 
							DeadpoolOptionsData["DeadpoolModelPopupDisabled"] = not val
						end,
						get = function(info)
							local enabled = true
							if DeadpoolOptionsData["DeadpoolModelPopupDisabled"] ~= nil then
								enabled = not DeadpoolOptionsData["DeadpoolModelPopupDisabled"]
							end
							return enabled
						end
					},
					modelPopupSide = {
						type = "select", order = 8,
						name = L["MODEL_POPUP_SIDE"],
						desc = L["MODEL_POPUP_SIDE_DESC"],
						disabled = function()
							return DeadpoolOptionsData["DeadpoolModelPopupDisabled"]
						end,
						values = sidesValues,
						sorting = sidesSorting,
						set = function(info, val)
							if val == 0 then
								DeadpoolOptionsData["DeadpoolModelPopupSide"] = nil
							else
								DeadpoolOptionsData["DeadpoolModelPopupSide"] = val
							end
						end,
						get = function(info)
							return DeadpoolOptionsData["DeadpoolModelPopupSide"] or 0
						end
					},
				},
			},
			window = {
				type = "group", order = 4,
				name = L["WINDOW_SECTION"],
				inline = true,
				args = {
					localWindowOptions = {
						type = "toggle", order = 1,
						width = "full",
						name = L["LOCAL_WINDOW_OPTIONS"],
						desc = L["LOCAL_WINDOW_OPTIONS_DESC"],
						set = function(info, val)
							local pc = Deadpool_playerCharacter() or UNKNOWNOBJECT
							if val then
								Deadpool_WindowsOptions = pc
								DeadpoolWindow[pc] = {}
								for index,value in pairs(DeadpoolWindow["All"]) do
									DeadpoolWindow[pc][index] = value
								end
							else
								
								DeadpoolWindow[pc] = nil
								Deadpool_WindowsOptions = "All"
								applyDeadpoolWindowOptions(true)
							end
						end,
						get = function(info)
							local pc = Deadpool_playerCharacter() or UNKNOWNOBJECT
							return DeadpoolWindow[pc] ~= nil
						end
					},
					hideInCombat = {
						type = "toggle", order = 2,
						name = L["HIDE_IN_COMBAT"],
						desc = L["HIDE_IN_COMBAT_DESC"],
						set = function(info, val) 
							DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolHideInCombatDisabled"] = not val
							if val and UnitAffectingCombat("player") then
								Deadpool:DeadpoolPlayerEntersCombat()
							end
						end,
						get = function(info)
							local enabled = true
							if DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolHideInCombatDisabled"] ~= nil then
								enabled = not DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolHideInCombatDisabled"]
							end
							return enabled
						end
					},
					playerFirst = {
						type = "toggle", order = 3,
						name = L["PLAYER_FIRST"],
						desc = L["PLAYER_FIRST_DESC"],
						set = function(info, val) 
							DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolPlayerFirstDisabled"] = not val
							generateDeadpoolTable()
						end,
						get = function(info)
							local enabled = true
							if DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolPlayerFirstDisabled"] ~= nil then
								enabled = not DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolPlayerFirstDisabled"]
							end
							return enabled
						end
					},
					alpha = {
						type = "range", order = 4,
						width = "full", descStyle = "",
						name = L["DEADPOOLFRAME_ALPHA"],
						get = function(i)
							return DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"]
						end,
						set = function(i, v)
							DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolFrameAlpha"] = v
							DeadpoolFrame:SetAlpha(v)
							MiniDeadpoolFrameInset.Bg:SetAlpha(v)
							MiniDeadpoolFrameMaximize:SetAlpha(v)
							MiniDeadpoolFrameLock:SetAlpha(v)
							DeadpoolResultsTooltip:SetAlpha(v)
							DeadpoolWinnerTooltip:SetAlpha(v)
						end,
						min = 0.2,
						max = 1.0,
						step = 0.05,
					},
					lineHeight = {
						type = "range", order = 5,
						width = "full", descStyle = "",
						name = L["DEADPOOLFRAME_LINEHEIGHT"],
						get = function(i)
							return DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"]
						end,
						set = function(i, v)
							local newMinHeight = 151 + v
							DeadpoolFrame:SetResizeBounds(0, newMinHeight)
							DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolLigneHeight"] = v
							if DeadpoolFrame:GetHeight() < newMinHeight then
								DeadpoolFrame:SetHeight(newMinHeight)
								DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolHeight"] = newMinHeight
							end
							generateDeadpoolTable()
						end,
						min = 20,
						max = 30,
						step = 2,
					},
					deadpoolScale = {
						type = "range", order = 6,
						width = "full", descStyle = "",
						name = UI_SCALE,
						get = function(i)
							return DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolScale"] or 1.0
						end,
						set = function(i, v)
							DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolScale"] = v
							DeadpoolFrame:SetScale(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolScale"])
							MiniDeadpoolFrame:SetScale(DeadpoolWindow[Deadpool_WindowsOptions]["DeadpoolScale"])
						end,
						min = 0.7,
						max = 1.0,
						step = .01,
					}
				}
			}
		},
	}

	ACR:RegisterOptionsTable("Dead Pool", DeadpoolOptions)
	ACD:AddToBlizOptions("Dead Pool", "Dead Pool")
	ACD:SetDefaultSize("Dead Pool", 600, 675)
end

function deadpoolSetTuto(on, resetTuto, menuType)
	local tuto = "TutoDisabled"
	if menuType then
		tuto = menuType..tuto
	end
	DeadpoolOptionsData[tuto] = not on
	if resetTuto then
		DeadpoolTuto = {}
	end
end

function deadpoolGetTuto(menuType)
	local tuto = "TutoDisabled"
	if menuType then
		tuto = menuType..tuto
	end
	return not DeadpoolOptionsData or not DeadpoolOptionsData[tuto]
end

function setUnequipItemsValue(value)
	local playerCharacter = Deadpool_playerCharacter()
	setDeadpoolData(DeadpoolGlobal_SessionId, playerCharacter, "trulyUnequipItems", value)
	if value then
		prepareAndSendSimpleDeadpoolDataToRaid(DeadpoolGlobal_SessionId, playerCharacter)
		Deadpool:UnequipLostItems()
	else
		Deadpool:ReequipLostItems()
	end
	DeadpoolTrulyUnequip_UpdtateStatus(DeadpoolTrulyUnequipSwitch)
	DeadpoolTrulyUnequip_UpdateCooldown(DeadpoolTrulyUnequipSwitch)
	deadpoolNotifyChangeToOptions()
end

function deadpoolNotifyChangeToOptions()
	ACR:NotifyChange("Dead Pool")
end
