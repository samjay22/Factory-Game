local DataClass = {}

DataClass.__index = DataClass

local DS = game:GetService("DataStoreService")
local Store = DS:GetDataStore("TestStore20")
local HTTP = game:GetService("HttpService")



--Plot.CFrame.X - v.PrimaryPart.CFrame.X
--Plot.CFrame.X + -v.ObjectCFrame.X

local function LoadPlot(self)
	if self.Data and self.Player then
		for _, Value in next, self.Data.PlotData do
			local Clone = game.ReplicatedStorage.Objects[Value.Type][Value.Name]:Clone()
			Clone.Parent = self.PlotData
			local SetCFrame = self.Plot.PrimaryPart.CFrame * CFrame.new(unpack(Value.CFrame)) 
			Clone:SetPrimaryPartCFrame(SetCFrame)
			local Class = require(game.ServerStorage.Objects[Value.Name])
			local Object = Class.New(Clone, self.Plot, self.Player)
			if game:GetService("CollectionService"):HasTag(Clone,"Conveyor") then
				Object:MoveConveyor()
			elseif Value.Type == "Builders" then
				print("Setting up")
				Object:CheckForSupplies()
			end
		end
	end
end


local function GetData(Player)
	local Data = {}
	local Info = Store:GetAsync(Player.UserId, Data)
	
	if not Info then 
		Data = {
			["Wood"] = 200;
			["Metal"] = 200;
			["PlotData"] = {};
		}
		return Data
	else
		local Data = HTTP:JSONDecode(Info)
		return Data
	end
end

function DataClass.New(Player)
	local self = setmetatable({ }, DataClass)
	self.Player = Player
	self.Data = GetData(Player) 
	self.Saved = false
	self.Plot = nil
	self.Status = "None"
	self.CarryingItem = nil
	self.PlotData = Instance.new("Folder", game.Workspace)
	self.PlotData.Name = Player.UserId
	return self
end

--print(game.Workspace.Baseplate.CFrame:ToWorldSpace(game.Workspace["1"].CFrame):GetComponents())

function DataClass:AddItem(Name, Amount)
	if not Name or not Amount then return end
	if self.Data[Name] then
		self.Data[Name] += Amount
	else
		self.Data[Name] = Amount
	end
end

function DataClass:ClearPlot()
	self.PlotData:ClearAllChildren()
	self.PlotData:Destroy()
end



function DataClass:SaveData()
	if not self.Data or not self.Player then return end
	--self.Data.LastPlotCFrame = {CFrame:ToObjectSpace(self.Plot.CFrame):components()}
	local SaveData = HTTP:JSONEncode(self.Data)
	if self.Saved then return end
	Store:SetAsync(self.Player.UserId, SaveData)
	print("Saved")
	self.Saved = true
end	

function DataClass:PlaceItem(Class, Object)
	if not Class or not Object then return end
	table.insert(self.Data.PlotData, Class.SaveData)
	Object.Parent = self.PlotData
end

function DataClass:Load()
	if not self.Plot then return end
	LoadPlot(self)
end

function DataClass:UpdateItem(Class, Object)
	if not Class then return end
	if table.find(self.Data.PlotData, Class) then
		local Object = table.find(self.Data.PlotData, Class) 
		local Removed = table.remove(self.Data.PlotData, Object)
		table.insert(self.Data.PlotData,Object, Class)
		Object.Parent = self.PlotData
	end
end

function DataClass:RemoveItem(Name, Amount)
	if not Name or not Amount then return end
	if self.Data[Name] then
		if self.Data[Name] - Amount > 0 then self.Data[Name] -= Amount return true else print("Not Enough") return false end
	else
		warn("Dude it not in table")
		return false
	end
end


function DataClass:GetData()
	if not self.Player or not self.Data then return end
	return self.Data
end

return DataClass