local L = LibStub("AceLocale-3.0"):GetLocale("Deadpool", true)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addon)
	if addon ~= "Deadpool" then
		return
	else
		-- Clean up after ourselves
		self:UnregisterEvent("ADDON_LOADED")
		self:SetScript("OnEvent", nil)
	end
	-- Initialize the saved variables
	local defaults = {
		minimapIcon = {
			hide = false,
			minimapPos = 220,
		}
	}
	if not DeadpoolMIcon then
		DeadpoolMIcon = defaults
	else
		for k, v in pairs(defaults) do
			if DeadpoolMIcon[k] == nil or type(DeadpoolMIcon[k]) ~= type(v) then
				DeadpoolMIcon[k] = v
			end
		end
	end
 
	-- Create the data object
	local obj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Deadpool", {
		type = "launcher",
		icon = "Interface\\AddOns\\Deadpool\\art\\chip",
		tocname = "Deadpool",
		OnClick = function(self, button)
			if button == "LeftButton" then
				if DeadpoolFrame:IsShown() or MiniDeadpoolFrame:IsShown() then
					hideDeadpoolWindow()
					MiniDeadpoolFrame:Hide()
				else
					Deadpool:DeadpoolShow(DeadpoolWindow[Deadpool_WindowsOptions]["MiniDeadpoolShown"], DeadpoolWindow[Deadpool_WindowsOptions]["MiniDeadpoolShown"])
				end
			else
				DeadpoolOptionsButtonClick(self)
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(GetAddOnMetadata("Deadpool", "Title"), 1.0, 1.0, 1.0)
			tooltip:AddLine(L["MINIMAP_TOOLTIP1"])
			tooltip:AddLine(L["MINIMAP_TOOLTIP2"])
		end,
	})
 
	-- Register the data object for a minimap button
	LibStub("LibDBIcon-1.0"):Register("Deadpool", obj, DeadpoolMIcon.minimapIcon)
end)
