local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rbus = require(ReplicatedStorage.Shared.rbus)
local registry = require(ReplicatedStorage.Shared.rbus.registry)

task.wait(1)
rbus.get_wrapper("com.roblox.player")
    :get_signal("added")
        :connect(function(plr: Player)
            print("player joined: "..plr.Name)
        end)

rbus.get_wrapper("com.roblox.player")
    :get_signal("removing")
        :connect(function(plr: Player)
            print("player removing: "..plr.Name)
        end)

print(registry.get_all())
