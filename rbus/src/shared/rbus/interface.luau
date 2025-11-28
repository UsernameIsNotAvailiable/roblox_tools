local registry = require(script.Parent.registry)
local types = require(script.Parent.types)

type rbus_interface = types.rbus_interface
type rbus_interface_builder = types.rbus_interface_builder
type rbus_method<TRet, TArgs...> = types.rbus_method<TRet, TArgs...>
type rbus_property<T> = types.rbus_property<T>
type rbus_signal = types.rbus_signal

local interface = {}
interface.__index = interface

function interface.new(name: string): rbus_interface_builder
    if registry.get(name) ~= nil then
        error(`rbus: interface: attempt to create interface with already existing name {name}`)
    end

    local self = setmetatable({
        name = name,
        methods = {},
        signals = {},
        properties = {}
    }, interface)

    return (self :: any) :: rbus_interface_builder
end

function interface.method<TRet, TArgs...>(self: rbus_interface_builder,name: string, fn: rbus_method<TRet,TArgs...>): rbus_interface_builder
    self.methods[name] = fn
    return self
end

function interface.property<T>(self: rbus_interface_builder, name: string, prop: rbus_property<T>): rbus_interface_builder
    self.properties[name] = prop
    return self
end

function interface.signal<T>(self: rbus_interface_builder, name: string, signal: rbus_signal): rbus_interface_builder
    self.signals[name] = signal
    return self
end

function interface.build(self: rbus_interface_builder): rbus_interface
    local iface = {
        name = self.name,
        methods = self.methods,
        signals = self.signals,
        properties = self.properties,
    }

    registry.register(iface)

    return iface
end

return interface
