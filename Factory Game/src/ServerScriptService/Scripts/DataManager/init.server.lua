local DataClass = require(script.DataClass)

shared.PlayerList = {}


game.Players.PlayerAdded:Connect(function(Player)
	shared.PlayerList[Player] = DataClass.New(Player)
end)

game.ReplicatedStorage.Remotes.UpdateStatus.OnServerEvent:Connect(function(Player, Status)
	shared.PlayerList[Player].Status = Status
end)

game.Players.PlayerRemoving:Connect(function(Player)
	shared.PlayerList[Player] :SaveData()
	shared.PlayerList[Player]:ClearPlot()
	shared.PlayerList[Player] = nil
end)

game:BindToClose(function()
	for _, P in next, game.Players:GetChildren() do
		shared.PlayerList[P] :SaveData()
	end
end)

game.ReplicatedStorage.Remotes.SendDataRequest.OnServerInvoke = function(Player, Type)
	--	print("Fired")
	if Type == "Data" then
		repeat wait() until shared.PlayerList[Player]
		return shared.PlayerList[Player].Data , shared.PlayerList[Player].Status
	elseif Type == "Plot" then
		repeat wait() until shared.PlayerList[Player].Plot
		return  shared.PlayerList[Player].Plot , shared.PlayerList[Player].Status
	end
end
