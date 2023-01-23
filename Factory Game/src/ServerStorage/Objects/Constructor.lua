local Constructor = {}


Constructor.__index = Constructor

local CS = game:GetService("CollectionService")
local RS = game:GetService("RunService")

local function ConvertToSaveCFrame(CF, Plot)
	if not CF then return end
	return {(Plot.PrimaryPart.CFrame:Inverse() * CF):components()}
end


local Recipes = require(game.ServerStorage.Recipies.Recipies)


function Constructor.New(Object, Plot, Owner)
	local self = setmetatable({ }, Constructor)
	self.Owner = Owner
	self.Object = Object
	local SaveCFrame = ConvertToSaveCFrame(Object:GetPrimaryPartCFrame(), Plot)
	
	self.SaveData = {
		["Type"] = "Builders";
		["Name"] = "Constructor";
		["CFrame"] = SaveCFrame;
		["Storage"] = {};
	}
	return self
end


local function AddItem(self, Name, Amount)
	if not Name or not Amount then return end
	if self.SaveData.Storage[Name] then
		self.SaveData.Storage[Name]  += Amount
	else
		self.SaveData.Storage[Name]  = Amount
	end
end

local function FindSupplies(self)
	if not self.Object or not self.Object:FindFirstChild("Detector") then return end
	local Min = self.Object.Detector.Position - (self.Object.Detector.Size / 2)
	local Max = self.Object.Detector.Position + (self.Object.Detector.Size / 2)
	local RG3 = Region3.new(Min, Max)
	local Reg = game.Workspace:FindPartsInRegion3(RG3)
	
	for _,V in next, Reg do
		if CS:HasTag(V, "Wood") then
			print("Ran")
			print("Collecting")
			AddItem(self, "Wood", 1)
			V:Destroy()
		end
	end
end

local function Craft(self)
	print("Crafting")
	local Part = Instance.new("Part", game.Workspace)
	Part.Position = self.Object.Detector.Position
	print("MadeMetal")
end

local function CraftItem(self, Name)
	local CanCraft = false
	for Name, Amount in next, Recipes.Metal.Resources do
		if self.SaveData.Storage[Name] then
			print(self.SaveData.Storage[Name]  - Amount > 0)
			if self.SaveData.Storage[Name]  - Amount >= 0 then
				pcall(function()
					shared.PlayerList[self.Owner]:AddItem("Wood", 5)
				end)
				--Craft(self)
				self.SaveData.Storage[Name]  -= Amount
			else
				return 
			end
		end
	end
end

function Constructor:CheckForSupplies()
	if not self.Object then return end
	RS.Heartbeat:Connect(function()
		FindSupplies(self)
		CraftItem(self)
	end)
end






return Constructor