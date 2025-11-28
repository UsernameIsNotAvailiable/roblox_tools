local types = require(script.Parent.types)
local signal = require(script.Parent.signal)

type rbus_property<T> = types.rbus_property<T>

local function new_propety<T>(initial: T): rbus_property<T>
    local value: T = initial
    local changed = signal()

    local prop = {} :: rbus_property<T>

    function prop:get(): T
        return value
    end

    function prop:set(v: T): ()
        if v ~= value then
            value = v
            changed:fire(value)
        end
    end

    prop.changed = changed

    return prop
end

return new_propety
