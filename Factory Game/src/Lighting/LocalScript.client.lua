--local function Finish(self, Done)
--	if self.UI then
--		self.UI:Destroy()
--		self.UI = nil
--	end
--	if Done then
--		local Clone = game.ReplicatedStorage.UI.Success:Clone()
--		Clone.Parent = Player.PlayerGui.Main
--		game.Debris:AddItem(Clone, 5)
--	else
--		local Clone = game.ReplicatedStorage.UI.Fail:Clone()
--		Clone.Parent = Player.PlayerGui.Main
--		game.Debris:AddItem(Clone, 5)
--	end
--end





--local function MakeUI(self)
--	if not shared.PlayerData then return end
--	if not self.UI then
--		self.UI = game.ReplicatedStorage.UI.PlacingTemplate:Clone()
--		for Name, Amount in next, ItemCosts[self.Object.Name].Resources do
--			local Clone = game.ReplicatedStorage.UI.ItemTemplate:Clone()
--			Clone.ItemImage.Image = ItemImages[Name]
--			if shared.PlayerData[Name] then
--				Clone.Amount.Text = shared.PlayerData[Name] .. "/" ..  Amount
--			else
--				Clone.Amount.Text = 0 .. "/" ..  Amount
--			end
--			Clone.Parent = self.UI.Reqs
--		end
--		self.UI.Parent = Player.PlayerGui.Main
--	end
--end

