local PlotClass = require(game.ServerStorage.Classes.PlotClass)


local Plots =  PlotClass.New()



game.Players.PlayerRemoving:Connect(function(Player)
	if not Player then return end
	Plots:PlayerLeave(Player)
	print("Removed")
end)