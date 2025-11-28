local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rbus = require(ReplicatedStorage.Shared.rbus)

rbus.new("org.astealthgame")
    :method("version", function()
        return "v0.0.1"
    end)
    :method("wow", function()
        return "wow!"
    end)
    :build()

return {}
