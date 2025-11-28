local types = require(script.Parent.types)

local wrapper = {}
wrapper.__index = wrapper

type rbus_wrapper = types.rbus_wrapper
type rbus_interface = types.rbus_interface
type rbus_property<T> = types.rbus_property<T>
type rbus_signal = types.rbus_signal

function wrapper.from(iface: rbus_interface): rbus_wrapper
    local self = setmetatable({
        interface = iface
    }, wrapper)

    return (self :: any) :: rbus_wrapper
end

function wrapper.call(self: rbus_wrapper,name: string,...): any
    local method = self.interface.methods[name]
    if method == nil then
        error(`rbus: wrapper: attempt to invoke missing method '{self.interface.name}::{name}()'`,2)
    end

    return method(self.interface,...)
end

function wrapper.get_property(self: rbus_wrapper,name: string): rbus_property<any>
    local property = self.interface.properties[name]
    return property
end

function wrapper.get_signal(self: rbus_wrapper,name: string): rbus_signal
    local sig = self.interface.signals[name]
    if sig == nil then
        error(`rbus: wrapper: attempt to get missing signal '{self.interface.name}.{name}'`,2)
    end

    return sig
end

return wrapper
