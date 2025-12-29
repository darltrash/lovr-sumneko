local data = require "api.api.init"

local reserved = {
    ["and"] = true,
    ["break"] = true,
    ["do"] = true,
    ["else"] = true,
    ["elseif"] = true,
    ["end"] = true,
    ["false"] = true,
    ["for"] = true,
    ["function"] = true,
    ["if"] = true,
    ["in"] = true,
    ["local"] = true,
    ["nil"] = true,
    ["not"] = true,
    ["or"] = true,
    ["repeat"] = true,
    ["return"] = true,
    ["then"] = true,
    ["true"] = true,
    ["until"] = true,
    ["while"] = true,
}

local operators = {
    ["add"] = "add",
    ["sub"] = "sub",
    ["div"] = "div",
    ["mul"] = "mul",
    --["equals"] = "eq",
    --["length"] = "len",
}

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

local function handleType(t)
    if t == "*" then
        return "any"
    end

    local a = t:match("{(.*)}")
    if a then
        local things = {}
        for item in a:gmatch("[^|]+") do
            -- trim whitespace around each item
            item = item:match("^%s*(.-)%s*$")
            table.insert(things, handleType(item))
        end

        if #things == 1 then
            return things[1] .. "[]"
        end

        return "(" .. table.concat(things, "|") .. ")[]"
    end

    return t
end

local function handleParam(name)
    if name:sub(1, 3) == "..." then
        return "..."
    elseif reserved[name] then
        return name .. "_"
    end
    return name
end

local function writeOperator(func, f)
    local name = operators[func.name]
    if not name then
        return
    end

    for i = 1, #func.variants do
        local var = func.variants[i]

        if (#var.arguments > 1) then
            goto continue
        end

        local params = {}
        for _, arg in ipairs(var.arguments) do
            table.insert(params, handleType(arg.type))
        end

        if (#var.returns > 1) then
            goto continue
        end

        local returns = {}
        for _, ret in ipairs(var.returns) do
            table.insert(returns, handleType(ret.type))
        end

        f:write("---@operator ")
        f:write(name)
        f:write("(")
        f:write(table.concat(params, ", "))
        f:write(")")
        if #returns > 0 then
            f:write(": ")
            f:write(table.concat(returns, ", "))
        end
        f:write("\n")

        ::continue::
    end
end

local function writeFunction(func, namespace, is_method, f)
    local key = func.key
    local name = func.name

    writeComment(func.description, f)

    if func.related then
        for _, rel in ipairs(func.related) do
            f:write("---@see ")
            f:write((rel:gsub(":", ".")))
            f:write("\n")
        end
    end

    local params = {}
    local first = func.variants[1]
    do
        for _, arg in ipairs(first.arguments) do
            local param = handleParam(arg.name)
            local type = handleType(arg.type) .. (arg.default and "?" or "")

            f:write("---@param ")
            f:write(param)
            f:write(" ")
            f:write(type)
            f:write(" # ")
            writeSingleLine(arg.description, f)
            if arg.default then
                f:write(" (default: ")
                f:write(arg.default)
                f:write(")")
            end
            f:write("\n")
            table.insert(params, param)
        end

        for _, ret in ipairs(first.returns) do
            f:write("---@return ")
            f:write(handleType(ret.type))
            if ret.description then
                f:write(" # ")
                writeSingleLine(ret.description, f)
            end
            f:write("\n")
        end
    end

    for i = 2, #func.variants do
        local var = func.variants[i]

        local p = {}
        for _, arg in ipairs(var.arguments) do
            local param = handleParam(arg.name)
            if arg.default then
                param = param .. "?"
            end
            table.insert(p, param .. ": " .. handleType(arg.type))
        end

        local returns = {}
        for _, ret in ipairs(var.returns) do
            table.insert(returns, handleType(ret.type))
        end

        f:write("---@overload fun(")
        f:write(table.concat(p, ", "))
        f:write(")")
        if #returns > 0 then
            f:write(": ")
            f:write(table.concat(returns, ", "))
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

    f:write("\n\n")
end

local function writeObject(object, namespace, f)
    local key = object.key
    local name = object.name

    --# ---@class Blob
    f:write("---@class ")
    f:write(name)
    if name == "Mat4" then
        f:write(": number[]")
    end
    f:write("\n")

    local vec_n = tonumber(name:sub(4))
    if vec_n and name:sub(1, 3) == "Vec" then
        local c = "xyzw"
        for i = 1, vec_n do
            f:write("---@field ")
            f:write(c:sub(i, i))
            f:write(" number\n")
        end
    end

    --if object.constructors then
    --    for _, const in ipairs(object.constructors) do
    --        f:write("---@see ")
    --        f:write(const)
    --        f:write(" # (Constructor)\n")
    --    end
    --end

    for _, func in ipairs(object.methods) do
        writeOperator(func, f)
    end

    --# local Blob = {}
    f:write("local ")
    f:write(name)
    f:write(" = {}\n\n")

    for _, func in ipairs(object.methods) do
        writeFunction(func, name, true, f)
    end

    return name
end

local function processModule(module)
    local key = module.key
    local name = key:match("([^.]+)$")

    io.write(("- %-20s"):format(key .. "..."))
    if module.external then
        print("SKIP")
        return
    end

    local f = io.open("lovr/" .. key .. ".lua", "w+")
    assert(f, "Could not open file, make sure you got permissions!")

    --# ---@meta lovr.audio
    f:write("---@meta ")
    f:write(key)
    f:write("\n\n")

    writeComment(module.description, f)

    --# ---@class lovr.audio
    f:write("---@class ")
    f:write(key)
    f:write("\n")

    --# local audio = {}
    f:write("local ")
    f:write(name)
    f:write(" = {}\n\n")

    for _, enum in ipairs(module.enums) do
        writeEnum(enum, f)
    end

    for _, objt in ipairs(module.objects) do
        writeObject(objt, name, f)
    end

    for _, func in ipairs(module.functions) do
        writeFunction(func, name, false, f)
    end

    --# _G.lovr.audio = audio
    f:write("_G.")
    f:write(key)
    f:write(" = ")
    f:write(name)
    f:write("\n")

    f:close()

    print("OK")
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
local f = assert(io.open("lovr/lovr.lua", "a+"))
f:write("\n")
for _, key in ipairs(modules) do
    local name = key:match("([^.]+)$")

    f:write("---@module '")
    f:write(key)
    f:write("'\n")
    f:write("lovr.")
    f:write(name)
    f:write(" = ")
    f:write(key)
    f:write("\n\n")
end

f:write("---@diagnostic disable: inject-field\n")
f:write("---@diagnostic disable: duplicate-set-field\n")
f:write("\n")

for _, call in ipairs(data.callbacks) do
    local key = call.key
    local name = key:match("([^.]+)$")

    writeFunction(call, "lovr", false, f)
end

f:write("\n")
local shortcuts = {
    "vec2", "vec3", "vec4",
    "mat4", "quat"
}
for _, short in ipairs(shortcuts) do
    f:write("_G.")
    f:write(short)
    f:write(" = _G.lovr.math.")
    f:write(short)
    f:write("\n")
end

f:close()
