local XITK = LibStub("XamInsightToolKit-2.0")

function askBankerHisBet(aDeadpoolSessionId, deadpoolList)
	local betChar = XITK:playerCharacter()
	local betPercentage = 30
	local bet = 1
	local firstDeathNumber = 0
	local firstDeathNumberCharacter = nil
	local sameFirstDeathNumber = 0
	local deathNumber = 0
	local deathNumberCharacter = nil
	local sameDeathNumber = 0
	
	local playersIds = {}
	
	for _, value in pairs(deadpoolList) do
		tinsert(playersIds, value)
		local newFirstDeathNumber = XITK:tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, value, DEADPOOL_FIRSTDEATH))
		if newFirstDeathNumber > firstDeathNumber then
			firstDeathNumber = newFirstDeathNumber
			firstDeathNumberCharacter = value
		elseif newFirstDeathNumber == firstDeathNumber then
			sameFirstDeathNumber = newFirstDeathNumber
		end

		local newDeathNumber = XITK:tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, value, DEADPOOL_DEATHS))
		if newDeathNumber > deathNumber and value ~= "boss" then
			deathNumber = newDeathNumber
			deathNumberCharacter = value
		elseif newDeathNumber == deathNumber then
			sameDeathNumber = newDeathNumber
		end
	end
	
	-- BANKER
	local nbChips = XITK:tonumberzeroonblankornil(getDeadpoolData(aDeadpoolSessionId, DEADPOOL_BANKER, "credits"))
	if nbChips > 0 then
		local totalNextDeathBetsOnChar, nbNextDeathBetsOnChar = getDeadpoolTotalBets(aDeadpoolSessionId, "nextDeathBet", DEADPOOL_BANKER)
		if nbNextDeathBetsOnChar <=0 then
			betChar = playersIds[math.random(1, #playersIds)]
			if firstDeathNumber > sameFirstDeathNumber then
				betChar = firstDeathNumberCharacter
				if firstDeathNumber > 10 then
					betPercentage = 60
				end
			elseif deathNumber > sameDeathNumber then
				betChar = deathNumberCharacter
				if deathNumber > 15 then
					betPercentage = 60
				end
			end
			bet = floor(nbChips * betPercentage / 100)
			if bet == 0 then
				bet = 1
			end
			if betChar then
				setDeadpoolBets(DeadpoolGlobal_SessionId, DEADPOOL_BANKER, betChar, bet)
			end
		end
	end
	
	-- FOLLOWERS
	for key, value in pairs(DeadpoolFollowersId) do
		nbChips = XITK:tonumberzeroonblankornil(getDeadpoolData(aDeadpoolSessionId, value, "credits"))
		if nbChips > 0 then
			totalNextDeathBetsOnChar, nbNextDeathBetsOnChar = getDeadpoolTotalBets(aDeadpoolSessionId, "nextDeathBet", value)
			if nbNextDeathBetsOnChar <=0 then
				betChar = playersIds[math.random(1, #playersIds)]
				bet = 1

				if firstDeathNumber > sameFirstDeathNumber then
					betChar = firstDeathNumberCharacter
					if firstDeathNumber > 10 then
						betPercentage = 60
					end
				elseif deathNumber > sameDeathNumber then
					betChar = deathNumberCharacter
					if deathNumber > 15 then
						betPercentage = 60
					end
				end
				bet = floor(nbChips * betPercentage / 100)
				if bet == 0 then
					bet = 1
				end

				if betChar and betChar ~= value then
					setDeadpoolBets(DeadpoolGlobal_SessionId, value, betChar, bet)
				end
			end
		end
	end
end
