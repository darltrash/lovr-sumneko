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
            f:write(rel)
            f:write("\n")
        end
    end

    for i = 2, #func.variants do
        local var = func.variants[i]

        local params = {}
        for _, arg in ipairs(var.arguments) do
            table.insert(params, handleParam(arg.name) .. ": " .. handleType(arg.type))
        end

        local returns = {}
        for _, ret in ipairs(var.returns) do
            table.insert(returns, handleType(ret.type))
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
            f:write("---@param ")
            f:write(handleParam(arg.name))
            f:write(" ")
            f:write(handleType(arg.type) .. (arg.default and "?" or ""))
            f:write(" # ")
            writeSingleLine(arg.description, f)
            if arg.default then
                f:write(" (default: ")
                f:write(arg.default)
                f:write(")")
            end
            f:write("\n")
            table.insert(params, handleParam(arg.name))
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

local function generateSwizzles(name, f)
    local components = {}
    local vecSize = 0

    if name == "Vec2" then
        components = { "x", "y" }
        vecSize = 2
    elseif name == "Vec3" then
        components = { "x", "y", "z" }
        vecSize = 3
    elseif name == "Vec4" or name == "Quat" then
        components = { "x", "y", "z", "w" }
        vecSize = 4
    end

    for _, comp in ipairs(components) do
        f:write("---@field ")
        f:write(comp)
        f:write(" number\n")
    end

    if vecSize >= 2 then
        local common2 = { "xy", "yx", "xx", "yy" }
        if vecSize >= 3 then
            table.insert(common2, "xz")
            table.insert(common2, "yz")
            table.insert(common2, "zx")
            table.insert(common2, "zy")
        end
        if vecSize >= 4 then
            table.insert(common2, "xw")
            table.insert(common2, "yw")
            table.insert(common2, "zw")
            table.insert(common2, "wx")
            table.insert(common2, "wy")
            table.insert(common2, "wz")
        end

        for _, swizzle in ipairs(common2) do
            f:write("---@field ")
            f:write(swizzle)
            f:write(" Vec2\n")
        end
    end

    if vecSize >= 3 then
        local common3 = {
            "xyz", "xzy", "yxz", "yzx", "zxy", "zyx", "xxx", "yyy", "zzz"
        }
        if vecSize >= 4 then
            table.insert(common3, "xyw")
            table.insert(common3, "xzw")
            table.insert(common3, "yzw")
            table.insert(common3, "wxy")
            table.insert(common3, "wxz")
            table.insert(common3, "wyz")
        end

        for _, swizzle in ipairs(common3) do
            f:write("---@field ")
            f:write(swizzle)
            f:write(" Vec3\n")
        end
    end

    if vecSize == 4 then
        local common4 = {
            "xyzw", "xywz", "xzyw", "xzwy", "xwyz", "xwzy",
            "yxzw", "yxwz", "yzxw", "yzwx", "ywxz", "ywzx",
            "zxyw", "zxwy", "zyxw", "zywx", "zwxy", "zwyx",
            "wxyz", "wxzy", "wyxz", "wyzx", "wzxy", "wzyx",
            "xxxx", "yyyy", "zzzz", "wwww"
        }

        for _, swizzle in ipairs(common4) do
            f:write("---@field ")
            f:write(swizzle)
            f:write(" Vec4\n")
        end
    end
end

local function writeObject(object, namespace, f)
    local key = object.key
    local name = object.name

    local swizzable = name:sub(1, 3) == "Vec" or name == "Quat"

    --# ---@class Blob
    f:write("---@class ")
    f:write(name)
    if name == "Mat4" then
        f:write(": number[]")
    elseif swizzable then
        f:write(": { [string]: number|Vec2|Vec3|Vec4 }")
    end
    f:write("\n")

    if swizzable then
        generateSwizzles(name, f)
    end

    for _, func in ipairs(object.methods) do
        writeOperator(func, f)
    end

    if object.constructors then
        for _, const in ipairs(object.constructors) do
            f:write("---@see ")
            f:write(const)
            f:write(" # (Constructor)\n")
        end
    end

    --# local Blob = {}
    f:write("local ")
    f:write(name)
    f:write(" = {}\n\n")

    for _, func in ipairs(object.methods) do
        writeFunction(func, name, true, f)
    end
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

    f:write("lovr.")
    f:write(name)
    f:write(" = ")
    f:write(key)
    f:write("\n")
end
f:write("\n")
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
