local Req = require(game.ReplicatedStorage.DataClasses.PlacmentClass)
local Player = game.Players.LocalPlayer
local Char = Player.Character
local UIS = game:GetService("UserInputService")
local CS = game:GetService("CollectionService")

local Placment = require(game.ReplicatedStorage.DataClasses.PlacmentClass)
local Mouse = Player:GetMouse()

local Placing = false

repeat
	local Suc, Fail = pcall(function()
		wait()
		Plot = game.ReplicatedStorage.Remotes.SendDataRequest:InvokeServer("Plot")
	end)
until Suc

repeat wait() until Plot
repeat wait() until shared.PlayerData
print(shared.PlayerData["Wood"])

local Object = Placment.New(Plot)

--Mouse.Button1Down:Connect(function()
--	print(Mouse.Target.Parent)
--	print( CS:HasTag(Mouse.Target.Parent, "Conveyor") )
--	local Conveyor, ConveyorObject = CS:HasTag(Mouse.Target.Parent, "Conveyor") , Mouse.Target.Parent or CS:HasTag(Mouse.Target.Parent.Parent, "Conveyor") , Mouse.Target.Parent.Parent
--	if Conveyor then
--		print("Moving")
--		Object:StartPlacment(nil,nil, ConveyorObject)
--	end
--end)

UIS.InputBegan:Connect(function(Input)
	local Key = Input.KeyCode
	if Key == Enum.KeyCode.E and not Placing then
		Placing = true
		Object:StartPlacment("Conveyors","Straight")
		wait(1)
		Placing = false
	elseif Key == Enum.KeyCode.Q and not Placing then
		Placing = true
		Object:StartPlacment("Builders","Constructor")
		wait(1)
		Placing = false
	end
end)

