local PlotClass = {}

local CS = game:GetService("CollectionService")


PlotClass.__index = PlotClass



local function GetPlots(self)
	for _, Plot in next, CS:GetTagged("Plots") do
		self.Plots[Plot] = {
			["Plot"] = Plot;
			["Owner"] = nil;
		}
		print("Setting up")
		Plot.Plot.PlotClaim.Manager.MouseClick:Connect(function(Player)
			print("Attemptint to claim")
			if not Player then return end
			print(Player)
			if self:ClaimPlot(Plot, Player) then
				Plot.Plot.PlotClaim.Transparency = 1
			end
		end)
	end
end



function PlotClass.New()
	local self = setmetatable({ }, PlotClass)
	self.Plots = {}
	GetPlots(self)
	return self
end


function PlotClass:PlayerLeave(Player)
	for Index, Plot in next, self.Plots do
		if Plot.Owner == Player then
			Plot.Owner = nil
			Plot.Plot.Plot.PlotClaim.Transparency = 0
		end
	end
end


local function CheckPlayers(self, Player)
	for Index, Plot in next, self.Plots do
		if Plot.Owner ~= Player then
		else
			return true
		end
	end
end

function PlotClass:ClaimPlot(Plot, Player)
	if self.Plots[Plot].Owner == nil and not CheckPlayers(self, Player) then
		self.Plots[Plot].Owner = Player
		shared.PlayerList[Player].Plot = Plot
		shared.PlayerList[Player]:Load()
		return true
	else
		print("Owned")
		return false
	end
end

return PlotClass
