local TreeClass = {}


TreeClass.__index = TreeClass

local StatusTypes = {"Alive", "Respawning", "Carrying", "Idle", "Moving"}

local TS = game:GetService("TweenService")

local function UpdateUI(self)
	print("Updated")
	self. Tree.Mine.AmountLeft.Wood.Amount.AmountText.Text = self.Wood .. " / " .."25"
	self. Tree.Mine.AmountLeft.Wood.Amount.Size = UDim2.fromScale(self.Wood/25,1)
end


local function CarryLog(self)
	local Info = TweenInfo.new(1)
	local Tween = TS:Create(self.Tree, Info, {CFrame = self.Tree.CFrame * CFrame.Angles(math.rad(90),0,0)})
	Tween:Play()
	self. Tree.Mine.AmountLeft.Enabled = false
	self. Tree.Anchored = false
	self.Status = StatusTypes[4]
end

local function SetupMiner(self, Backup)
	local Tree = Backup
	self.Tree = Tree
	Tree.Mine.MouseClick:Connect(function(Player)
		print(self.Status)
		if not Player then return end
		if  self.Status == StatusTypes[1] and self.Wood > 0 then
			self.Wood -= 1
			print("Ran")
			UpdateUI(self)
			self:UpdateTreeStatus()
		elseif self.Status == StatusTypes[4] or self.Status == StatusTypes[5] then
			local Char = Player.Character
			local Weld = Instance.new("Weld", Tree)
			Weld.Part0 = Tree
			Weld.Part1 = Player.Character.LeftHand
			shared.PlayerList[Player].Status = StatusTypes[3]
			self.Status = StatusTypes[3]
			shared.PlayerList[Player].CarryingItem = Tree
			--shared.PlayerList[Player]:AddItem("Wood", 1)
		end
	
	end)
end

local function MakeTree(self)
	local Tree =  self.TreeTemplate:Clone()
	--local Forest = game.Workspace.Forest.Position
	local Min = game.Workspace.Forest.Min.Position
	local Max = game.Workspace.Forest.Max.Position
	local X = math.random(Min.X, Max.X)
	local Z = math.random(Min.Z, Max.Z)
	Tree.Position = Vector3.new(X,2,Z)
	Tree.Parent = game.Workspace.Forest
	SetupMiner(self, Tree)
	Tree.Anchored = true
	shared.Trees[Tree] = self
	return Tree
end

function TreeClass.GenTree(Tree, Position)
	local self = setmetatable({ }, TreeClass)
	self.TreeTemplate = Tree
	self.Tree = MakeTree(self)
	self.Wood = 25
	self.Status = StatusTypes[1]
	self.Position = Position
	return self	
end


local function Regen(self)
	wait(30)
	self.Status = StatusTypes[1]
	self.Wood = 25
	self.Tree = MakeTree(self)
end


local function RemoveStatus(self)
	coroutine.wrap(function()
		wait(30)
		if self.Status == StatusTypes[4] then
			self.Tree:Destroy()
			self.Tree = nil
		end
	end)()
end

function TreeClass:UpdateTreeStatus()
	if self.Wood <= 0 then
		CarryLog(self)
		RemoveStatus(self)
		Regen(self)
	end
end



return TreeClass
