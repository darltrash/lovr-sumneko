---@meta lovr

--- `lovr` is the single global table that is exposed to every LÖVR app. It contains a set of **modules** and a set of **callbacks**.
---@class lovr: { [any]: any }
local lovr = {}

--- Get the current major, minor, and patch version of LÖVR.
---@see lovr
---@return number # The major version.
---@return number # The minor version.
---@return number # The patch number.
---@return string # The version codename.
---@return string # The commit hash (not available in all builds).
function lovr.getVersion() end

---@class Object
local Object = {}

--- Immediately destroys Lua's reference to the object it's called on.  After calling this function on an object, it is an error to do anything with the object from Lua (call methods on it, pass it to other functions, etc.).  If nothing else is using the object, it will be destroyed immediately, which can be used to destroy something earlier than it would normally be garbage collected in order to reduce memory.
---@see Object
function Object:release() end

--- Returns the name of the object's type as a string.
---@see Object
---@return string # The type of the object.
function Object:type() end

lovr = Object

_G.lovr = lovr

lovr.lovr = lovr
lovr.audio = lovr.audio
lovr.data = lovr.data
lovr.event = lovr.event
lovr.filesystem = lovr.filesystem
lovr.graphics = lovr.graphics
lovr.headset = lovr.headset
lovr.math = lovr.math
lovr.physics = lovr.physics
lovr.system = lovr.system
lovr.thread = lovr.thread
lovr.timer = lovr.timer
