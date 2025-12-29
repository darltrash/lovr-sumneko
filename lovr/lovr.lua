---@meta lovr

--- `lovr` is the single global table that is exposed to every LÖVR app. It contains a set of **modules** and a set of **callbacks**.
---@class lovr
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

---@diagnostic disable: inject-field
---@diagnostic disable: duplicate-set-field

--- The `lovr.conf` callback lets you configure default settings for LÖVR.  It is called once right before the game starts.
--- :::note
--- Make sure you put `lovr.conf` in a file called `conf.lua`, a special file that's loaded before the rest of the framework initializes.
--- :::
---@see lovr.load
---@param t table # The table to edit the configuration settings on.
function lovr.conf(t) end

--- This callback is called every frame, and receives a `Pass` object as an argument which can be used to render graphics to the display.  If a VR headset is connected, this function renders to the headset display, otherwise it will render to the desktop window.
---@see lovr.mirror
---@see lovr.headset.getPass
---@see lovr.graphics.getWindowPass
---@see lovr.graphics.setBackgroundColor
---@param pass Pass # A render pass targeting the main display (headset or window).
---@return boolean | nil # If truthy, the input Pass will not be submitted to the GPU.
function lovr.draw(pass) end

--- The `lovr.errhand` callback is run whenever an error occurs.  It receives a parameter containing the error message.  It should return a handler function that will run in a loop to render the error screen.
--- This handler function is of the same type as the one returned by `lovr.run` and has the same requirements (such as pumping events).  If an error occurs while this handler is running, the program will terminate immediately -- `lovr.errhand` will not be given a second chance.  Errors which occur in the error handler or in the handler it returns may not be cleanly reported, so be careful.
--- A default error handler is supplied that renders the error message as text to the headset and to the window.
---@see lovr.quit
---@param message string # The error message.
---@return function # The error handler function.  It should return nil to continue running, "restart" to restart the app, or a number representing an exit status.
function lovr.errhand(message) end

--- The `lovr.filechanged` callback is called when a file is changed.  File watching must be enabled, either by passing `--watch` when starting LÖVR or by calling `lovr.filesystem.watch`.
--- Currently, only files in the source directory are watched.  On Android, files in the sdcard directory are watched.
---@see lovr.filesystem.watch
---@see lovr.filesystem.unwatch
---@param path string # The path to the file that changed.
---@param action FileAction # What happened to the file.
---@param oldpath string # The old path, for `rename` actions.
function lovr.filechanged(path, action, oldpath) end

--- The `lovr.focus` callback is called whenever the application acquires or loses focus (for example, when opening or closing the system VR menu).  The callback receives a `focused` argument, indicating whether or not the application is now focused.  Additionally, both the headset and desktop window have separate focus states, so a `display` argument indicates which display gained or lost input focus.  It may make sense to pause the game, reduce visual fidelity, or mute audio when the application loses focus.
---@see lovr.headset.isFocused
---@see lovr.visible
---@param focused boolean # Whether the program is now focused.
---@param display DisplayType # Whether the headset or desktop window changed input focus.
function lovr.focus(focused, display) end

--- This callback is called when a key is pressed.
---@see lovr.system.wasKeyPressed
---@see lovr.keyreleased
---@see lovr.textinput
---@see lovr.system.isKeyDown
---@param key KeyCode # The key that was pressed.
---@param scancode number # The id of the key (ignores keyboard layout, may vary between keyboards).
---@param isrepeat boolean # Whether the event is the result of a key repeat instead of an actual press.
function lovr.keypressed(key, scancode, isrepeat) end

--- This callback is called when a key is released.
---@see lovr.system.wasKeyReleased
---@see lovr.keypressed
---@see lovr.textinput
---@see lovr.system.isKeyDown
---@param key KeyCode # The key that was released.
---@param scancode number # The id of the key (ignores keyboard layout, may vary between keyboards).
function lovr.keyreleased(key, scancode) end

--- This callback is called once when the app starts.  It should be used to perform initial setup work, like loading resources and initializing classes and variables.
---@see lovr.quit
---@param arg table # The command line arguments provided to the program.
function lovr.load(arg) end

--- This callback is called when a message is logged.  The default implementation of this callback prints the message to the console using `print`, but it's possible to override this callback to render messages in VR, write them to a file, filter messages, and more.
--- The message can have a "tag" that is a short string representing the sender, and a "level" indicating how severe the message is.
--- The `t.graphics.debug` flag in `lovr.conf` can be used to get log messages from the GPU driver, tagged as `GPU`.  The `t.headset.debug` will enable OpenXR messages from the VR runtime, tagged as `XR`.
--- It is also possible to emit custom log messages using `lovr.event.push`, or by calling the callback.
---@see Pass.text
---@param message string # The log message.  It may end in a newline.
---@param level string # The log level (`debug`, `info`, `warn`, or `error`).
---@param tag string # The log tag.
function lovr.log(message, level, tag) end

--- This callback is called every frame after rendering to the headset and is usually used to render a mirror of the headset display onto the desktop window.  It can be overridden for custom mirroring behavior.  For example, a stereo view could be drawn instead of a single eye or a 2D HUD could be rendered.
---@see lovr.system.openWindow
---@see lovr.draw
---@param pass Pass # A render pass targeting the window.
---@return boolean # If truthy, the input Pass will not be submitted to the GPU.
function lovr.mirror(pass) end

--- The `lovr.mount` callback is called when the headset is put on or taken off.
---@see lovr.headset.isMounted
---@param mounted boolean # Whether the headset is mounted.
function lovr.mount(mounted) end

--- This callback is called when the mouse is moved.
---@see lovr.mousepressed
---@see lovr.mousereleased
---@see lovr.wheelmoved
---@see lovr.system.getMouseX
---@see lovr.system.getMouseY
---@see lovr.system.getMousePosition
---@param x number # The new x position of the mouse.
---@param y number # The new y position of the mouse.
---@param dx number # The movement on the x axis since the last mousemove event.
---@param dy number # The movement on the y axis since the last mousemove event.
function lovr.mousemoved(x, y, dx, dy) end

--- This callback is called when a mouse button is pressed.
---@see lovr.mousereleased
---@see lovr.mousemoved
---@see lovr.wheelmoved
---@see lovr.system.isMouseDown
---@param x number # The x position of the mouse when the button was pressed.
---@param y number # The y position of the mouse when the button was pressed.
---@param button number # The button that was pressed.  Will be 1 for the primary button, 2 for the secondary button, or 3 for the middle mouse button.
function lovr.mousepressed(x, y, button) end

--- This callback is called when a mouse button is released.
---@see lovr.mousepressed
---@see lovr.mousemoved
---@see lovr.wheelmoved
---@see lovr.system.isMouseDown
---@param x number # The x position of the mouse when the button was released.
---@param y number # The y position of the mouse when the button was released.
---@param button number # The button that was released.  Will be 1 for the primary button, 2 for the secondary button, or 3 for the middle mouse button.
function lovr.mousereleased(x, y, button) end

--- This callback contains a permission response previously requested with `lovr.system.requestPermission`.  The callback contains information on whether permission was granted or denied.
---@see lovr.system.requestPermission
---@param permission Permission # The type of permission.
---@param granted boolean # Whether permission was granted or denied.
function lovr.permission(permission, granted) end

--- This callback is called right before the application is about to quit.  Use it to perform any necessary cleanup work.  A truthy value can be returned from this callback to abort quitting.
---@see lovr.event.quit
---@see lovr.load
---@return boolean # Whether quitting should be aborted.
function lovr.quit() end

--- The `lovr.recenter` callback is called whenever the user performs a "recenter" gesture to realign the virtual coordinate space.  On most VR systems this will move the origin to the user's current position and rotate its yaw to match the view direction.  The y=0 position will always be on the floor or at eye level, depending on whether `t.headset.seated` was set in `lovr.conf`.
---@see lovr.headset.getBoundsWidth
---@see lovr.headset.getBoundsDepth
---@see lovr.headset.getBoundsDimensions
---@see lovr.headset.getBoundsGeometry
---@see lovr.headset.isSeated
function lovr.recenter() end

--- This callback is called when the desktop window is resized.
---@see Pass.getDimensions
---@see Pass.getWidth
---@see Pass.getHeight
---@see lovr.headset.getDisplayDimensions
---@see lovr.conf
---@param width number # The new width of the window.
---@param height number # The new height of the window.
function lovr.resize(width, height) end

--- This callback is called when a restart from `lovr.event.restart` is happening.  A value can be returned to send it to the next LÖVR instance, available as the `restart` key in the argument table passed to `lovr.load`.  Object instances can not be used as the restart value, since they are destroyed as part of the cleanup process.
---@see lovr.event.restart
---@see lovr.load
---@see lovr.quit
---@return any # The value to send to the next `lovr.load`.
function lovr.restart() end

--- This callback is the main entry point for a LÖVR program.  It calls `lovr.load` and returns a function that will be called every frame.
---@see lovr.load
---@see lovr.quit
---@return function # The main loop function.
function lovr.run() end

--- This callback is called when text has been entered.
--- For example, when `shift + 1` is pressed on an American keyboard, `lovr.textinput` will be called with `!`.
---@see lovr.keypressed
---@see lovr.keyreleased
---@param text string # The UTF-8 encoded character.
---@param code number # The integer codepoint of the character.
function lovr.textinput(text, code) end

--- The `lovr.threaderror` callback is called whenever an error occurs in a Thread.  It receives the Thread object where the error occurred and an error message.
--- The default implementation of this callback will call `lovr.errhand` with the error.
---@see Thread
---@see Thread.getError
---@see lovr.errhand
---@param thread Thread # The Thread that errored.
---@param message string # The error message.
function lovr.threaderror(thread, message) end

--- The `lovr.update` callback should be used to update your game's logic.  It receives a single parameter, `dt`, which represents the amount of elapsed time between frames.  You can use this value to scale timers, physics, and animations in your game so they play at a smooth, consistent speed.
---@see lovr.timer.getDelta
---@param dt number # The number of seconds elapsed since the last update.
function lovr.update(dt) end

--- The `lovr.visible` callback is called whenever the application becomes visible or invisible. `lovr.draw` may still be called even while invisible to give the VR runtime timing info.  If the VR runtime decides the application doesn't need to render anymore, LÖVR will detect this and stop calling `lovr.draw`.
--- This event is also fired when the desktop window is minimized or restored.  It's possible to distinguish between the headset and window using the `display` parameter.
---@see lovr.headset.isVisible
---@see lovr.focus
---@param visible boolean # Whether the application is visible.
---@param display DisplayType # Whether the headset or desktop window changed visibility.
function lovr.visible(visible, display) end

--- This callback is called on scroll action, from a mouse wheel or a touchpad
---@see lovr.mousepressed
---@see lovr.mousereleased
---@see lovr.mousemoved
---@see lovr.system.isMouseDown
---@param dx number # The relative horizontal motion; rightward movement resuts in positive values.
---@param dy number # The relative vertical motion; upward movement results in positive values.
function lovr.wheelmoved(dx, dy) end


_G.vec2 = _G.lovr.math.vec2
_G.vec3 = _G.lovr.math.vec3
_G.vec4 = _G.lovr.math.vec4
_G.mat4 = _G.lovr.math.mat4
_G.quat = _G.lovr.math.quat
