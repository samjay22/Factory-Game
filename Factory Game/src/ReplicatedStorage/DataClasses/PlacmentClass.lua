local Placment = {}

Placment.__index = Placment

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local GridSize = 2

local DataModules = game.ReplicatedStorage.DataModules
local ItemCosts = require(DataModules.ItemCosts)
local ItemImages = require(DataModules.ItemImages)

local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CS =game:GetService("CollectionService")


local function Finish(self, Done)
	print("Ran")
	if self.UI then
		self.UI:Destroy()
		self.UI = nil
	end
	if Done then
		local Clone = game.ReplicatedStorage.UI.Success:Clone()
		Clone.Parent = Player.PlayerGui.Main
		game.Debris:AddItem(Clone, 5)
	else
		local Clone = game.ReplicatedStorage.UI.Fail:Clone()
		Clone.Parent = Player.PlayerGui.Main
		game.Debris:AddItem(Clone, 5)
	end
end





local function MakeUI(self)
	if not shared.PlayerData then return end
	if not self.UI then
		self.UI = game.ReplicatedStorage.UI.PlacingTemplate:Clone()
		for Name, Amount in next, ItemCosts[self.Object.Name].Resources do
			local Clone = game.ReplicatedStorage.UI.ItemTemplate:Clone()
			Clone.ItemImage.Image = ItemImages[Name]
			if shared.PlayerData[Name] then
				Clone.Amount.Text = shared.PlayerData[Name] .. "/" ..  Amount
			else
				Clone.Amount.Text = 0 .. "/" ..  Amount
			end
			Clone.Parent = self.UI.Reqs
		end
		self.UI.Parent = Player.PlayerGui.Main
	end
end





function Placment.New(Plot)
	if not Plot then return  end
	local self = setmetatable({ }, Placment)
	self.Moving = false
	self.Placing = false
	self.Connections = {}
	self.Canvas = Plot.PrimaryPart
	self.UI = nil
	self.Rotation = 0
	self.Position = CFrame.new()
	return self
end

local function GetGrid(CF)
	local X = math.floor(CF.X / GridSize + .5) * GridSize
	local Y = CF.Y
	local Z = math.floor(CF.Z / GridSize + .5) * GridSize
	return CFrame.new(X,Y,Z)
end


--local function SnapPart(self, Node)
--	if not self.Object then return end
--	self.Object:SetPrimaryPartCFrame(Node.CFrame)
--	self.Position = Node.CFrame
--end


--local function CheckNode(self, Pos)
--	local CMag = math.huge
--	local ClosestNode
	
	
--	for _, Ob in next, self.Object.Nodes:GetChildren() do
--		for _, Node in next, CS:GetTagged("Node") do
--			if Ob ~= Node then
--				local Mag = (Pos - Node.Position).Magnitude
--				if Mag <= CMag then
--					CMag = Mag
--					ClosestNode = Node
--				end
--			end
--		end
--	end
--	return CMag, ClosestNode
--end


--local function DetectClosestPart(self, Pos)
--	local Mag, Node = CheckNode(self, Pos)
--	if not Node or not Mag then return end
--	if Mag <= 5 then
--		return true, Node
--	else
--		return false
--	end
--end

function Placment:CalcSize()
	local Size = self.Canvas.Size
	
	local back = Vector3.new(0, -1, 0)
	local top = Vector3.new(0, 0, -1)
	local right = Vector3.new(-1, 0, 0)

	local CF = self.Canvas.CFrame * CFrame.fromMatrix(-back*Size/2, right, top, back)
	Size = Vector2.new((Size * right).magnitude, (Size * top).magnitude)
	return CF, Size
end

function Placment:GetPlacment(Position, Rotation)
	Rotation = self.Rotation or 0
	local CF, Size = self:CalcSize()
	
	local MSize = CFrame.fromEulerAnglesYXZ(0, Rotation, 0) * self.Object.PrimaryPart.Size
	MSize = Vector3.new(math.abs(MSize.x), math.abs(MSize.y), math.abs(MSize.z))
	
	local Pos = CF:PointToObjectSpace(Position)
	local Size2 = (Size - Vector2.new(MSize.X, MSize.Z))/2
	
	local X = math.clamp(Pos.x, -Size2.x, Size2.x)
	local Y = math.clamp(Pos.y, -Size2.y, Size2.y)
	
	return GetGrid(CF * CFrame.new(X, Y, -MSize.y/2) * CFrame.Angles(-math.pi/2, Rotation, 0))
end




local function SetupPlace(self, Type, Name, Move)
	self.Connections["UIS"] = UIS.InputBegan:Connect(function(Input, Pro)
		local Key = Input.KeyCode
		print(Key)
		if Key == Enum.KeyCode.R then
			print("Rotated")
				self.Rotation += 90
		end
	end)
	self.Connections["Mouse"] = Mouse.Button1Down:Connect(function()
		local Done = game.ReplicatedStorage.Remotes.Place:InvokeServer({self.Position, Type, Name, Move})
		self.Placing = false
		self.Moving = false
		self.Object:Destroy()
		self.Object = nil
		Finish(self, Done)
		for _, V in next, self.Connections do
			V:Disconnect()
			V = nil
		end
	end)
end


function Placment:StartPlacment(Type, Name, Mover)
	if self.Object or self.Moving or self.Placing or 	shared.Status ~= "None" then return end
	game.ReplicatedStorage.Remotes.UpdateStatus:FireServer("Placing")
	self.Object = Mover or game.ReplicatedStorage.Objects[Type][Name]:Clone()
	self.Object.Parent = game.Workspace
	SetupPlace(self, Type, Name, Mover)
	MakeUI(self)
	
	if Mover then self.Moving = true else self.Placing = true end
	self.Connections["RS"] = RS.RenderStepped:Connect(function()
		local UnitRay = game.Workspace.Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
		local RayCast = Ray.new(UnitRay.Origin, UnitRay.Direction * 100)
		local Hit, Pos = game.Workspace:FindPartOnRayWithIgnoreList(RayCast, {Player.Character, self.Object})
		if not self.Moving and not self.Placing then return end
		self.Position  = self:GetPlacment(Pos, self.Rotation)
		self.Position = self.Position * CFrame.Angles(0,math.rad(self.Rotation), 0)
		--local Snap, Node = DetectClosestPart(self, Pos) 
		--if Snap  then
		--	SnapPart(self, Node)
		--else
			self.Object:SetPrimaryPartCFrame(	self.Position)	
		--end
	end)
end

return Placment
