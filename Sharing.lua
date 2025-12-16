local L = LibStub("AceLocale-3.0"):GetLocale("Deadpool", true)
local XITK = LibStub("XamInsightToolKit")

function encodeAndSendDeadpoolSessionInfo(aData, aSender, aMessageTime)
	if aData then
		aData["DeadpoolSessionId"] = DeadpoolGlobal_SessionId
		--Deadpool:Print(time().." - Preparing message.", DeadpoolGlobal_SessionId)
		local s = Deadpool:Serialize(aData)
		--Deadpool:Print(time().." - Message OK.")
		if aSender and aMessageTime then
			Deadpool:SendCommMessage(DeadpoolGlobal_CommPrefix, "Data#"..aMessageTime.."#"..s, "WHISPER", aSender)
			--Deadpool:Print(time().." - Message envoye.")
			--Deadpool:Print("Sent data to "..aSender..".")
		else
			local messageTime = tostring(XITK.getTimeUTCinMS())
			local chat = "RAID"
			if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
				chat = "INSTANCE_CHAT"
			end
			Deadpool:SendCommMessage(DeadpoolGlobal_CommPrefix, "Data#"..messageTime.."#"..s, chat)
			--Deadpool:Print("Sent data to raid.")
		end
	end
end

function encodeAndSendSimpleDeadpoolData(aData)
	local t = aData
	local s = Deadpool:Serialize(t)
	local messageTime = tostring(XITK.getTimeUTCinMS())
	local chat = "RAID"
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		chat = "INSTANCE_CHAT"
	end
	Deadpool:SendCommMessage(DeadpoolGlobal_CommPrefix, "SimpleData#"..messageTime.."#"..s, chat)
end

function Deadpool:ReceiveDataFrame_OnEvent(prefix, message, distribution, sender)
	if prefix == DeadpoolGlobal_CommPrefix then
		--Deadpool:Print(time().." - Received message from "..sender..".", DeadpoolGlobal_SessionId)
		local messageType, messageTime, messageMessage, messageParam = strsplit("#", message, 4)
		if not XITK.isPlayerCharacter(sender) then
			if messageType == "Data" or messageType == "SimpleData" then
				local success, o = self:Deserialize(messageMessage)
				if success == false then
					--Deadpool:Print(time().." - Received corrupted data from "..sender..".")
				else
					if DeadpoolReceivedData
						and DeadpoolReceivedData["CallTime"]
							and DeadpoolReceivedData["CallTime"] == messageTime
								and not messageType == "SimpleData" then
						-- do nothing
						--Deadpool:Print(time().." - Received already processed "..messageType.." from "..sender..".")
					else
						--Deadpool:Print(time().." - Received "..messageType.." from "..sender..".", DeadpoolGlobal_SessionId)
						if not DeadpoolReceivedData then
							DeadpoolReceivedData = {}
						end
						DeadpoolReceivedData["CallTime"] = messageTime
						DeadpoolReceivedData["Sender"] = sender
						if o and o["DeadpoolSessionId"] then
							DeadpoolReceivedData["DeadpoolSessionId"] = o["DeadpoolSessionId"]
							DeadpoolReceivedData[o["DeadpoolSessionId"]] = o
						else
							DeadpoolReceivedData["DeadpoolSessionId"] = DeadpoolGlobal_SessionId
							DeadpoolReceivedData[DeadpoolGlobal_SessionId] = o
						end
						loadReceivedDeadpoolData(messageType)
					end
				end
			elseif messageType == "Call" then
				--Deadpool:Print(time().." - Received "..messageType.." from "..sender..".", DeadpoolGlobal_SessionId)
				loadBets(DeadpoolGlobal_SessionId, sender)
				encodeAndSendDeadpoolSessionInfo(DeadpoolData[DeadpoolGlobal_SessionId], sender, messageTime)
			--elseif messageType == "Death" then
			--	Deadpool:CheckDeath()
			end
		end
		if messageType == "VersionCall" then
			sendDeadpoolVersion(sender)
		elseif messageType == "Version" then
			Deadpool:Print(sender..XITK.GetPunctuationSpace()..": "..messageMessage)
		end
	end
end

function Deadpool:CallForDeadpoolData(event, isInitialLogin, partyGUID)
	if event then
		if event == "PLAYER_ENTERING_WORLD" then
			C_Timer.After(0, function()
				self:OnPlayerAlive(event)
			end)
		end
		if event ~= "PLAYER_ENTERING_WORLD" or not isInitialLogin then
			if event and event == "GROUP_JOINED" then
				tellTutorialText("DEADPOOLTUTO_TUTO6")
				if not UnitIsGroupLeader("player") or DeadpoolOptionsData["DataSavingDisabled"] then
					DeadpoolSavedBets = {}
					local guid = ""
					if partyGUID then
						guid = "-"..partyGUID
					end
					local pc = XITK.playerCharacter() or UNKNOWN
					playerJoinsDeadpoolSession("DeadpoolSession_"..pc..guid, true)
				end
				DEADPOOL_GROUPJOINED = true
			end
			--Deadpool:Print(time().." - Calling data!", DeadpoolGlobal_SessionId, event)
			local chat = "RAID"
			if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
				chat = "INSTANCE_CHAT"
			end
			C_ChatInfo.SendAddonMessage(DeadpoolGlobal_CommPrefix, "Call#"..tostring(XITK.getTimeUTCinMS()), chat)
		end
	end
end

function AnnounceDeath()
	local chat = "RAID"
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		chat = "INSTANCE_CHAT"
	end
	Deadpool:SendCommMessage(DeadpoolGlobal_CommPrefix, "Death#"..tostring(XITK.getTimeUTCinMS()), chat)
end

function checkDeadpoolVersion()
	local chat = "RAID"
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		chat = "INSTANCE_CHAT"
	end
	Deadpool:SendCommMessage(DeadpoolGlobal_CommPrefix, "VersionCall#"..tostring(XITK.getTimeUTCinMS()), chat)
end

function sendDeadpoolVersion(aSender)
	Deadpool:SendCommMessage(DeadpoolGlobal_CommPrefix, "Version#"..tostring(XITK.getTimeUTCinMS()).."#"..C_AddOns.GetAddOnMetadata("Deadpool", "Version"), "WHISPER", aSender)
end
