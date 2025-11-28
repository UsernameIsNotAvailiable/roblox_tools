local types = require(script.Parent.types)

type maybe_nil<T> = types.maybe_nil<T>
type map<T, U> = types.map<T, U>
type rbus_interface = types.rbus_interface

local registry = {}

local interfaces = {}

local function split_dot_path(path: string): {string}
    local parts = {}
    for part in string.gmatch(path, "[^%.]+") do
        table.insert(parts,part)
    end
    return parts
end

local function set_interface(path: string,iface: rbus_interface): ()
    local parts = split_dot_path(path)

    local node = interfaces

    for i = 1, #parts - 1 do
        local part = parts[i]
        if node[part] == nil then
            node[part] = {}
        end
        node = node[part]
    end

    node[parts[#parts]] = iface
end

local function get_interface(path: string): maybe_nil<rbus_interface>
    local parts = split_dot_path(path)
    local node = interfaces

    for i = 1, #parts do
        node = node[parts[i]]
        if node == nil then
            return nil
        end
    end

    return node
end

function registry.register(iface: rbus_interface): ()
    set_interface(iface.name, iface)
end

function registry.get(name: string): maybe_nil<rbus_interface>
    return get_interface(name)
end

function registry.get_all(): map<string,rbus_interface>
    return interfaces
end

return registry
