
local ItemPrices = require(game.ReplicatedStorage.DataModules.ItemCosts)


local function RemoveItems(Player, List)
	local PlrData = shared.PlayerList [Player]
	for Name, Value in next, List do
		PlrData:RemoveItem(Name, Value)
	end
end

local function CheckValidity(Object, Player)
	local Data = {}
	local PlrData = shared.PlayerList [Player]
	for Name, Value in next, ItemPrices[Object.Name].Resources do
		if PlrData.Data[Name] then
			if PlrData.Data[Name] - Value >= 0 then
				RemoveItems(Player, ItemPrices[Object.Name].Resources )
			else
				return false
			end
		else
			return false
		end
	end
	return  true
end


local function SetupPlace(Type, Object)
	if Type == "Conveyors" then
		print("Setup")
		Object:MoveConveyor()
	end
end

local function PlaceItem(Data, Player)
	if shared.PlayerList[Player].Status == "Placing" then
		if Data[4] then
			Data[4]:SetPrimaryPartCFrame(Data[1])
			local Class = require(game.ServerStorage.Objects[Data[4].Name])
			local Object = Class.New(Data[4], 	shared.PlayerList [Player].Plot, Player)
			Object:MoveConveyor()
			SetupPlace(Data[2], Object)
			shared.PlayerList [Player]:UpdateItem(Class, Data[4])
		elseif not Data[4] then
			local A = game.ReplicatedStorage.Objects[Data[2]][Data[3]]:Clone()
			A:SetPrimaryPartCFrame(Data[1])
			local Class = require(game.ServerStorage.Objects[A.Name])
			local Object = Class.New(A, 	shared.PlayerList [Player].Plot, Player)
			SetupPlace(Data[2], Object)
			shared.PlayerList [Player]:PlaceItem(Object, A)
		end
	end
	shared.PlayerList[Player].Status = "None"
end

game.ReplicatedStorage.Remotes.Place.OnServerInvoke = (function(Player, Data)
	if shared.PlayerList[Player].Status ~= "Placing" then return false end
	print(Data[7], Data[2], Data[3])
	local A = Data[7] or game.ReplicatedStorage.Objects[Data[2]][Data[3]]:Clone()
	if CheckValidity(A, Player) then
		if A:FindFirstChild("Direction") then
			A:FindFirstChild("Direction").Transparency = 1
			--		print("Changed")
		end
		PlaceItem(Data, Player)
		return true
	else
		return false
	end
end)