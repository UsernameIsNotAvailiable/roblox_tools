local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rbus = require(ReplicatedStorage.Shared.rbus)
local astealthgame = require(ReplicatedStorage.Shared.testing.org.astealthgame)
local debug = require(ReplicatedStorage.Shared.testing.org.astealthgame.debug)

task.wait(3)
print("hi")
local version = rbus.get_wrapper("org.astealthgame"):call("version")
print("current version: "..version)

rbus.get_wrapper("org.astealthgame.debug")
    :call("start_debugging")

print(rbus.registry.get_all())
