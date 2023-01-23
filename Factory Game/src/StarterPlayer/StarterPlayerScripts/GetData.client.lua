game:GetService("RunService").RenderStepped:Connect(function()
	local Data, Status = game.ReplicatedStorage.Remotes.SendDataRequest:InvokeServer("Data")
	shared.PlayerData = Data
	shared.Status = Status
end)