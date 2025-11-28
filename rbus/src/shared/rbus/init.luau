local interface = require(script.interface)
local property = require(script.property)
local registry = require(script.registry)
local signal = require(script.signal)
local types = require(script.types)
local wrapper = require(script.wrapper)

local rbus = {
    interface = interface,
    property = property,
    registry = registry,
    signal = signal,
    types = types,
    wrapper = wrapper
}

function rbus.call(name: string, method: string, ...): any
    local srv = registry.get(name)
    if srv == nil then
        return nil
    end

    return srv.methods[method](srv,...)
end

function rbus.get_wrapper(name: string): types.rbus_wrapper
    local srv = registry.get(name)
    if srv == nil then
        error(`rbus: attempt to create wrapper from nil interface: '{name}'`,2)
    end
    return wrapper.from(srv)
end

function rbus.new(name: string): types.rbus_interface_builder
    return interface.new(name)
end

return rbus
