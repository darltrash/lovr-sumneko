---@meta lovr

--- `lovr` is the single global table that is exposed to every LÖVR app. It contains a set of **modules** and a set of **callbacks**.
---
--- [Open in browser](https://lovr.org/docs/lovr)
---@class lovr: table
--- The `lovr.conf` callback lets you configure default settings for LÖVR.  It is called once right before the game starts.
--- :::note
--- Make sure you put `lovr.conf` in a file called `conf.lua`, a special file that's loaded before the rest of the framework initializes.
--- :::
---
--- [Open in browser](https://lovr.org/docs/lovr.conf)
---@field conf fun(t: table)
--- This callback is called every frame, and receives a `Pass` object as an argument which can be used to render graphics to the display.  If a VR headset is connected, this function renders to the headset display, otherwise it will render to the desktop window.
---
--- [Open in browser](https://lovr.org/docs/lovr.draw)
---@field draw fun(pass: Pass): boolean | nil
--- The `lovr.errhand` callback is run whenever an error occurs.  It receives a parameter containing the error message.  It should return a handler function that will run in a loop to render the error screen.
--- This handler function is of the same type as the one returned by `lovr.run` and has the same requirements (such as pumping events).  If an error occurs while this handler is running, the program will terminate immediately -- `lovr.errhand` will not be given a second chance.  Errors which occur in the error handler or in the handler it returns may not be cleanly reported, so be careful.
--- A default error handler is supplied that renders the error message as text to the headset and to the window.
---
--- [Open in browser](https://lovr.org/docs/lovr.errhand)
---@field errhand fun(message: string): function
--- The `lovr.filechanged` callback is called when a file is changed.  File watching must be enabled, either by passing `--watch` when starting LÖVR or by calling `lovr.filesystem.watch`.
--- Currently, only files in the source directory are watched.  On Android, files in the sdcard directory are watched.
---
--- [Open in browser](https://lovr.org/docs/lovr.filechanged)
---@field filechanged fun(path: string, action: FileAction, oldpath: string)
--- The `lovr.focus` callback is called whenever the application acquires or loses focus (for example, when opening or closing the system VR menu).  The callback receives a `focused` argument, indicating whether or not the application is now focused.  Additionally, both the headset and desktop window have separate focus states, so a `display` argument indicates which display gained or lost input focus.  It may make sense to pause the game, reduce visual fidelity, or mute audio when the application loses focus.
---
--- [Open in browser](https://lovr.org/docs/lovr.focus)
---@field focus fun(focused: boolean, display: DisplayType)
--- This callback is called when a key is pressed.
---
--- [Open in browser](https://lovr.org/docs/lovr.keypressed)
---@field keypressed fun(key: KeyCode, scancode: number, isrepeat: boolean)
--- This callback is called when a key is released.
---
--- [Open in browser](https://lovr.org/docs/lovr.keyreleased)
---@field keyreleased fun(key: KeyCode, scancode: number)
--- This callback is called once when the app starts.  It should be used to perform initial setup work, like loading resources and initializing classes and variables.
---
--- [Open in browser](https://lovr.org/docs/lovr.load)
---@field load fun(arg: table)
--- This callback is called when a message is logged.  The default implementation of this callback prints the message to the console using `print`, but it's possible to override this callback to render messages in VR, write them to a file, filter messages, and more.
--- The message can have a "tag" that is a short string representing the sender, and a "level" indicating how severe the message is.
--- The `t.graphics.debug` flag in `lovr.conf` can be used to get log messages from the GPU driver, tagged as `GPU`.  The `t.headset.debug` will enable OpenXR messages from the VR runtime, tagged as `XR`.
--- It is also possible to emit custom log messages using `lovr.event.push`, or by calling the callback.
---
--- [Open in browser](https://lovr.org/docs/lovr.log)
---@field log fun(message: string, level: string, tag: string)
--- This callback is called every frame after rendering to the headset and is usually used to render a mirror of the headset display onto the desktop window.  It can be overridden for custom mirroring behavior.  For example, a stereo view could be drawn instead of a single eye or a 2D HUD could be rendered.
---
--- [Open in browser](https://lovr.org/docs/lovr.mirror)
---@field mirror fun(pass: Pass): boolean
--- The `lovr.mount` callback is called when the headset is put on or taken off.
---
--- [Open in browser](https://lovr.org/docs/lovr.mount)
---@field mount fun(mounted: boolean)
--- This callback is called when the mouse is moved.
---
--- [Open in browser](https://lovr.org/docs/lovr.mousemoved)
---@field mousemoved fun(x: number, y: number, dx: number, dy: number)
--- This callback is called when a mouse button is pressed.
---
--- [Open in browser](https://lovr.org/docs/lovr.mousepressed)
---@field mousepressed fun(x: number, y: number, button: number)
--- This callback is called when a mouse button is released.
---
--- [Open in browser](https://lovr.org/docs/lovr.mousereleased)
---@field mousereleased fun(x: number, y: number, button: number)
--- This callback contains a permission response previously requested with `lovr.system.requestPermission`.  The callback contains information on whether permission was granted or denied.
---
--- [Open in browser](https://lovr.org/docs/lovr.permission)
---@field permission fun(permission: Permission, granted: boolean)
--- This callback is called right before the application is about to quit.  Use it to perform any necessary cleanup work.  A truthy value can be returned from this callback to abort quitting.
---
--- [Open in browser](https://lovr.org/docs/lovr.quit)
---@field quit fun(): boolean
--- The `lovr.recenter` callback is called whenever the user performs a "recenter" gesture to realign the virtual coordinate space.  On most VR systems this will move the origin to the user's current position and rotate its yaw to match the view direction.  The y=0 position will always be on the floor or at eye level, depending on whether `t.headset.seated` was set in `lovr.conf`.
---
--- [Open in browser](https://lovr.org/docs/lovr.recenter)
---@field recenter fun()
--- This callback is called when the desktop window is resized.
---
--- [Open in browser](https://lovr.org/docs/lovr.resize)
---@field resize fun(width: number, height: number)
--- This callback is called when a restart from `lovr.event.restart` is happening.  A value can be returned to send it to the next LÖVR instance, available as the `restart` key in the argument table passed to `lovr.load`.  Object instances can not be used as the restart value, since they are destroyed as part of the cleanup process.
---
--- [Open in browser](https://lovr.org/docs/lovr.restart)
---@field restart fun(): any
--- This callback is the main entry point for a LÖVR program.  It calls `lovr.load` and returns a function that will be called every frame.
---
--- [Open in browser](https://lovr.org/docs/lovr.run)
---@field run fun(): function
--- This callback is called when text has been entered.
--- For example, when `shift + 1` is pressed on an American keyboard, `lovr.textinput` will be called with `!`.
---
--- [Open in browser](https://lovr.org/docs/lovr.textinput)
---@field textinput fun(text: string, code: number)
--- The `lovr.threaderror` callback is called whenever an error occurs in a Thread.  It receives the Thread object where the error occurred and an error message.
--- The default implementation of this callback will call `lovr.errhand` with the error.
---
--- [Open in browser](https://lovr.org/docs/lovr.threaderror)
---@field threaderror fun(thread: Thread, message: string)
--- The `lovr.update` callback should be used to update your game's logic.  It receives a single parameter, `dt`, which represents the amount of elapsed time between frames.  You can use this value to scale timers, physics, and animations in your game so they play at a smooth, consistent speed.
---
--- [Open in browser](https://lovr.org/docs/lovr.update)
---@field update fun(dt: number)
--- The `lovr.visible` callback is called whenever the application becomes visible or invisible. `lovr.draw` may still be called even while invisible to give the VR runtime timing info.  If the VR runtime decides the application doesn't need to render anymore, LÖVR will detect this and stop calling `lovr.draw`.
--- This event is also fired when the desktop window is minimized or restored.  It's possible to distinguish between the headset and window using the `display` parameter.
---
--- [Open in browser](https://lovr.org/docs/lovr.visible)
---@field visible fun(visible: boolean, display: DisplayType)
--- This callback is called on scroll action, from a mouse wheel or a touchpad
---
--- [Open in browser](https://lovr.org/docs/lovr.wheelmoved)
---@field wheelmoved fun(dx: number, dy: number)
lovr = {}

--- The superclass of all LÖVR objects.  All objects have these methods.
---
--- [Open in browser](https://lovr.org/docs/Object)
---@class Object
local Object = {}

--- Immediately destroys Lua's reference to the object it's called on.  After calling this function on an object, it is an error to do anything with the object from Lua (call methods on it, pass it to other functions, etc.).  If nothing else is using the object, it will be destroyed immediately, which can be used to destroy something earlier than it would normally be garbage collected in order to reduce memory.
---
--- [Open in browser](https://lovr.org/docs/Object:release)
function Object:release() end

--- Returns the name of the object's type as a string.
---
--- [Open in browser](https://lovr.org/docs/Object:type)
---@return string # The type of the object.
function Object:type() end

--- Get the current major, minor, and patch version of LÖVR.
---
--- [Open in browser](https://lovr.org/docs/lovr.getVersion)
---@return number # The major version.
---@return number # The minor version.
---@return number # The patch number.
---@return string # The version codename.
---@return string # The commit hash (not available in all builds).
function lovr.getVersion() end

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
