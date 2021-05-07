function askBankerHisBet(aDeadpoolSessionId, deadpoolList)
	local bankerChips = Deadpool_tonumberzeroonblankornil(getDeadpoolData(aDeadpoolSessionId, DEADPOOL_BANKER, "credits"))
	if bankerChips > 0 then
		local betChar = Deadpool_playerCharacter()
		local betPercentage = 30
		local bet = 1
		local firstDeathNumber = 0
		local firstDeathNumberCharacter = nil
		local sameFirstDeathNumber = 0
		local deathNumber = 0
		local deathNumberCharacter = nil
		local sameDeathNumber = 0
		for _, value in pairs(deadpoolList) do
			local newFirstDeathNumber = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, value, DEADPOOL_FIRSTDEATH))
			if newFirstDeathNumber > firstDeathNumber then
				firstDeathNumber = newFirstDeathNumber
				firstDeathNumberCharacter = value
			elseif newFirstDeathNumber == firstDeathNumber then
				sameFirstDeathNumber = newFirstDeathNumber
			end

			local newDeathNumber = Deadpool_tonumberzeroonblankornil(getDeadpoolData(DeadpoolGlobal_SessionId, value, DEADPOOL_DEATHS))
			if newDeathNumber > deathNumber and value ~= "boss" then
				deathNumber = newDeathNumber
				deathNumberCharacter = value
			elseif newDeathNumber == deathNumber then
				sameDeathNumber = newDeathNumber
			end
		end
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
		bet = floor(bankerChips * betPercentage / 100)
		if bet == 0 then
			bet = 1
		end
		if betChar then
			setDeadpoolBets(DeadpoolGlobal_SessionId, DEADPOOL_BANKER, betChar, bet)
		end
	end
end
