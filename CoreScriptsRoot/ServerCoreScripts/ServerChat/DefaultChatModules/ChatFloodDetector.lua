local source = [[
--	// FileName: ChatFloodDetector.lua
--	// Written by: Xsitsu
--	// Description: Module that limits the number of messages a speaker can send in a given period of time.

local doFloodCheckByChannel = true
local informSpeakesOfWaitTimes = true
local chatBotsBypassFloodCheck = true
local numberMessagesAllowed = 7
local decayTimePeriod = 15

local floodCheckTable = {}
local whitelistedSpeakers = {}

local function EnterTimeIntoLog(tbl)
	table.insert(tbl, tick() + decayTimePeriod)
end

local function Run(ChatService)
	local function FloodDetectionProcessCommandsFunction(speakerName, message, channel)
		if (whitelistedSpeakers[speakerName]) then return false end

		local speakerObj = ChatService:GetSpeaker(speakerName)
		if (not speakerObj) then return false end
		if (chatBotsBypassFloodCheck and not speakerObj:GetPlayer()) then return false end
		
		if (not floodCheckTable[speakerName]) then
			floodCheckTable[speakerName] = {}
		end
		
		local t = nil
		
		if (doFloodCheckByChannel) then
			if (not floodCheckTable[speakerName][channel]) then
				floodCheckTable[speakerName][channel] = {}
			end
			
			t = floodCheckTable[speakerName][channel]
		else
			t = floodCheckTable[speakerName]
		end

		local now = tick()
		while (#t > 0 and t[1] < now) do
			table.remove(t, 1)
		end
		
		if (#t < numberMessagesAllowed) then
			EnterTimeIntoLog(t)
			return false
		else
			
			local timeDiff = math.ceil(t[1] - now)
			local msg = ""
			if (informSpeakesOfWaitTimes) then
				msg = string.format("You must wait %d second%s before sending another message!", timeDiff, (timeDiff > 1) and "s" or "")
			else
				msg = "You must wait before sending another message!"
			end				
			speakerObj:SendSystemMessage(msg, channel)
			
			return true	
		end
	end
	
	ChatService:RegisterProcessCommandsFunction("flood_detection", FloodDetectionProcessCommandsFunction)
	
	ChatService.SpeakerRemoved:connect(function(speakerName)
		floodCheckTable[speakerName] = nil
	end)
end

return Run
]]


local generated = Instance.new("ModuleScript")
generated.Name = "Generated"
generated.Source = source
generated.Parent = script