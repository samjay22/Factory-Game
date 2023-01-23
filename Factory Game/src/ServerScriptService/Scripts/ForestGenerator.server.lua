local Tree = game.ServerStorage.Templates.Wood
local TreeClass = require(game.ServerStorage.Classes.TreeClass)


shared.Trees = {}

local Trees = {
	["Wood"] = 100;
}

for Num = 0,Trees.Wood do
	local TreeGen = TreeClass.GenTree(Tree)
end