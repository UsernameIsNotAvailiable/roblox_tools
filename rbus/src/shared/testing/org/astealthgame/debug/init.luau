local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rbus = require(ReplicatedStorage.Shared.rbus)

rbus.new("org.astealthgame.debug")
    :method("start_debugging", function()
        print("starting debug...")
    end)
    :build()


return {}
