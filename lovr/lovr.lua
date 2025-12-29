---@meta lovr

--- `lovr` is the single global table that is exposed to every LÖVR app. It contains a set of **modules** and a set of **callbacks**.
---@class lovr: table
---@field conf fun(t: table)
---@field draw fun(pass: Pass): boolean | nil
---@field errhand fun(message: string): function
---@field filechanged fun(path: string, action: FileAction, oldpath: string)
---@field focus fun(focused: boolean, display: DisplayType)
---@field keypressed fun(key: KeyCode, scancode: number, isrepeat: boolean)
---@field keyreleased fun(key: KeyCode, scancode: number)
---@field load fun(arg: table)
---@field log fun(message: string, level: string, tag: string)
---@field mirror fun(pass: Pass): boolean
---@field mount fun(mounted: boolean)
---@field mousemoved fun(x: number, y: number, dx: number, dy: number)
---@field mousepressed fun(x: number, y: number, button: number)
---@field mousereleased fun(x: number, y: number, button: number)
---@field permission fun(permission: Permission, granted: boolean)
---@field quit fun(): boolean
---@field recenter fun()
---@field resize fun(width: number, height: number)
---@field restart fun(): any
---@field run fun(): function
---@field textinput fun(text: string, code: number)
---@field threaderror fun(thread: Thread, message: string)
---@field update fun(dt: number)
---@field visible fun(visible: boolean, display: DisplayType)
---@field wheelmoved fun(dx: number, dy: number)
local lovr = {}

---@class Object
local Object = {}

--- Immediately destroys Lua's reference to the object it's called on.  After calling this function on an object, it is an error to do anything with the object from Lua (call methods on it, pass it to other functions, etc.).  If nothing else is using the object, it will be destroyed immediately, which can be used to destroy something earlier than it would normally be garbage collected in order to reduce memory.
function Object:release() end

--- Returns the name of the object's type as a string.
---@return string # The type of the object.
function Object:type() end

--- Get the current major, minor, and patch version of LÖVR.
---@return number # The major version.
---@return number # The minor version.
---@return number # The patch number.
---@return string # The version codename.
---@return string # The commit hash (not available in all builds).
function lovr.getVersion() end

_G.lovr = lovr
---@module 'lovr'
lovr.lovr = lovr

---@module 'lovr.audio'
lovr.audio = lovr.audio

---@module 'lovr.data'
lovr.data = lovr.data

---@module 'lovr.event'
lovr.event = lovr.event

---@module 'lovr.filesystem'
lovr.filesystem = lovr.filesystem

---@module 'lovr.graphics'
lovr.graphics = lovr.graphics

---@module 'lovr.headset'
lovr.headset = lovr.headset

---@module 'lovr.math'
lovr.math = lovr.math

---@module 'lovr.physics'
lovr.physics = lovr.physics

---@module 'lovr.system'
lovr.system = lovr.system

---@module 'lovr.thread'
lovr.thread = lovr.thread

---@module 'lovr.timer'
lovr.timer = lovr.timer

vec2 = lovr.math.vec2
Vec2 = lovr.math.newVec2
vec3 = lovr.math.vec3
Vec3 = lovr.math.newVec3
vec4 = lovr.math.vec4
Vec4 = lovr.math.newVec4
mat4 = lovr.math.mat4
Mat4 = lovr.math.newMat4
quat = lovr.math.quat
Quat = lovr.math.newQuat
