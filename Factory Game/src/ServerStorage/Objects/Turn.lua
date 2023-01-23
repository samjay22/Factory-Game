local Conveyor = {}

Conveyor.__index = Conveyor
local RS = game:GetService("RunService")

local function ConvertToSaveCFrame(CF, Plot)
	if not CF then return end
	return {(Plot.PrimaryPart.CFrame:Inverse() * CF):components()}
end

function Conveyor.New(Object, Plot)
	local self = setmetatable({ }, Conveyor)
	self.Conveyor = Object

	--print(Object:GetPrimaryPartCFrame())
	local SaveCFrame = ConvertToSaveCFrame(Object:GetPrimaryPartCFrame(), Plot)

	self.SaveData = {
		["Type"] = "Conveyors";
		["Name"] = "Turn";
		["CFrame"] = SaveCFrame;
	}

	self.Data = {
		["Speed"] = 10;
		["OtherShit"] = 1;
	}

	return self
end


function Conveyor:MoveConveyor()
	if not self.Conveyor then return end
	if not self.Data then return end
	coroutine.wrap(function()
		while true do
			RS.Heartbeat:Wait()
			if not self.Conveyor or not self.Conveyor:FindFirstChild("Belts") then return end
			for _, Belt in next, self.Conveyor.Belts:GetChildren() do
				Belt.Velocity = Belt.CFrame.LookVector * self.Data.Speed
				RS.Heartbeat:Wait()
			end
		end
	end)()
end

function Conveyor:ChangeSpeed(Amount)
	if not self.Conveyor then return end
	if not self.Data then return end
	if not Amount then return end
	self.Data.Speed = Amount
end



return Conveyor
