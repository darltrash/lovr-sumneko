local json = require "json"

local data
do
    local f = io.open("api.json", "r")
    assert(f, "Could not open file, are you sure it's there?")
    data = json.decode(f:read("a"))
    f:close()
end

local function writeComment(cmt, f)
    for line in cmt:gmatch('[^\r\n]+') do
        f:write("--- ")
        f:write(line)
        f:write("\n")
    end
end

local function writeSingleLine(cmt, f)
    f:write((cmt:gsub("\n", "")))
end

local function writeEnum(enum, f)
    writeComment(enum.description, f)
    f:write("---@alias ")
    f:write(enum.name)
    f:write("\n")

    for _, value in ipairs(enum.values) do
        f:write("---| '\"")
        f:write(value.name)
        f:write("\"' # ")
        writeSingleLine(value.description, f)
        f:write("\n")
    end

    f:write("\n")
end

local function writeFunction(func, namespace, is_method, f)
    local key = func.key
    local name = func.name

    writeComment(func.description, f)

    for _, rel in ipairs(func.related) do
        f:write("---@see ")
        f:write(rel)
        f:write("\n")
    end

    for i = 2, #func.variants do
        local var = func.variants[i]

        local params = {}
        for _, arg in ipairs(var.arguments) do
            if arg.name:sub(1, 3) == "..." then
                arg.name = "..."
            end
            if arg.type == "*" then
                arg.type = "any"
            end
            table.insert(params, arg.name .. ": " .. arg.type)
        end

        local returns = {}
        for _, ret in ipairs(var.returns) do
            table.insert(returns, ret.type)
        end

        f:write("---@overload fun(")
        f:write(table.concat(params, ", "))
        f:write(")")
        if #returns > 0 then
            f:write(": ")
            f:write(table.concat(returns, ", "))
        end
        f:write("\n")
    end

    local first = func.variants[1]
    do
        local params = {}
        for _, arg in ipairs(first.arguments) do
            if arg.name:sub(1, 3) == "..." then
                arg.name = "..."
            end

            if arg.type == "*" then
                arg.type = "any"
            end

            f:write("---@param ")
            f:write(arg.name)
            f:write(" ")
            f:write(arg.type .. (arg.default and "?" or ""))
            f:write(" # ")
            writeSingleLine(arg.description, f)
            if arg.default then
                f:write(" (default: ")
                f:write(arg.default)
                f:write(")")
            end
            f:write("\n")
            table.insert(params, arg.name)
        end

        for _, ret in ipairs(first.returns) do
            f:write("---@return ")
            f:write(ret.type)
            if ret.description then
                f:write(" # ")
                writeSingleLine(ret.description, f)
            end
            f:write("\n")
        end

        f:write("function ")
        f:write(namespace)
        f:write(is_method and ":" or ".")
        f:write(name)
        f:write("(")
        f:write(table.concat(params, ", "))
        f:write(") end")
    end

    f:write("\n\n")
end

local function writeObject(object, namespace, f)
    local key = object.key
    local name = object.name

    --# ---@class Blob
    f:write("---@class ")
    f:write(name)
    f:write("\n")

    --# local Blob = {}
    f:write("local ")
    f:write(name)
    f:write(" = {}\n\n")

    for _, func in ipairs(object.methods) do
        writeFunction(func, name, true, f)
    end

    --# data.Blob = Blob
    f:write(namespace)
    f:write(" = ")
    f:write(name)
    f:write("\n\n")
end

local function processModule(module)
    local key = module.key
    local name = key:match("([^.]+)$")

    io.write("- '" .. key .. "'... ")
    if module.external then
        print("Skipping (external.)")
        return
    end

    local f = io.open("api/" .. key .. ".lua", "w+")
    assert(f, "Could not open file, make sure you got permissions!")

    --# ---@meta lovr.audio
    f:write("---@meta ")
    f:write(key)
    f:write("\n\n")

    writeComment(module.description, f)

    --# ---@class lovr.audio: { [any]: any }
    f:write("---@class ")
    f:write(key)
    f:write(": { [any]: any }")
    f:write("\n")

    --# local audio = {}
    f:write("local ")
    f:write(name)
    f:write(" = {}\n\n")

    for _, enum in ipairs(module.enums) do
        writeEnum(enum, f)
    end

    for _, func in ipairs(module.functions) do
        writeFunction(func, name, false, f)
    end

    for _, objt in ipairs(module.objects) do
        writeObject(objt, name, f)
    end

    --# _G.lovr.audio = audio
    f:write("_G.")
    f:write(key)
    f:write(" = ")
    f:write(name)
    f:write("\n")

    f:close()

    print("Done.")
end

print("Processing modules")
local modules = {} -- Somewhat of a hack, don't mind me.
for _, v in ipairs(data.modules) do
    processModule(v)
    if not v.external then
        table.insert(modules, v.key)
    end
end

-- Because we register each namespace as it's own class, effectively, we have
-- forced ourselves to write a little index of subclasses :(
local f = assert(io.open("api/lovr.lua", "a+"))
f:write("\n")
for _, key in ipairs(modules) do
    local name = key:match("([^.]+)$")

    f:write("lovr.")
    f:write(name)
    f:write(" = ")
    f:write(key)
    f:write("\n")
end
f:close()
