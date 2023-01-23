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
	
--	print(Object:GetPrimaryPartCFrame())
	local SaveCFrame = ConvertToSaveCFrame(Object:GetPrimaryPartCFrame(), Plot)
	
	self.SaveData = {
		["Type"] = "Conveyors";
		["Name"] = "Straight";
		["CFrame"] = SaveCFrame;
	}
	
	self.Data = {
		["Speed"] = 10;
		["OtherShit"] = 1;
	}
	
	return self
end

function Conveyor:DropItem(Player)
	if 	shared.PlayerList[Player].Status == "Carrying" then
		shared.PlayerList[Player].CarryingItem:FindFirstChildWhichIsA("Weld"):Destroy()
		shared.PlayerList[Player].CarryingItem.CFrame = self.Conveyor.DropPos.CFrame
		shared.Trees[	shared.PlayerList[Player].CarryingItem].Status = "Moving"
		shared.PlayerList[Player].Status = "None" 
		shared.PlayerList[Player].CarryingItem = nil
	end
end


local function SetupButtons(self)
	self.Conveyor.Event.MouseClick:Connect(function(Player)
		self:DropItem(Player)
	end)	
end



function Conveyor:MoveConveyor()
	if not self.Conveyor then return end
	if not self.Data then return end
	SetupButtons(self)
	pcall(function()
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
	end)
end

function Conveyor:ChangeSpeed(Amount)
	if not self.Conveyor then return end
	if not self.Data then return end
	if not Amount then return end
	self.Data.Speed = Amount
end



return Conveyor
