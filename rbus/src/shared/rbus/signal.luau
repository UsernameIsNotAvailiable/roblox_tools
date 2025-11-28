local types = require(script.Parent.types)

type rbus_signal_connection = types.rbus_signal_connection
type rbus_signal = types.rbus_signal

local function new_signal(): rbus_signal
    local listeners = {}

    local signal = {} :: rbus_signal

    function signal:connect(fn: (...any) -> ())
        table.insert(listeners, fn)

        local disconnected = false

        return {
            disconnect = function()
                if disconnected then return end
                disconnected = true

                for i,f in ipairs(listeners) do
                    if f == fn then
                        table.remove(listeners,i)
                        break
                    end
                end
            end
        }
    end
 
    function signal:fire(...)
        for _, fn in ipairs(listeners) do
            fn(...)
        end
    end

    return signal
end

return new_signal
