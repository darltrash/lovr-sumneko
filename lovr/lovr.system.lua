---@meta lovr.system

--- The `lovr.system` provides information about the current platform and hardware.
--- It also interfaces with the desktop window and window input.
---@class lovr.system: { [any]: any }
local system = {}

--- These are the different permissions that need to be requested using `lovr.system.requestPermission` on some platforms.
---@alias Permission
---| '"audiocapture"' # Requests microphone access.

--- Returns the clipboard text.
---@see lovr.system.setClipboardText
---@see lovr.system
---@return string # The clipboard text (may be nil).
function system.getClipboardText() end

--- Returns the number of logical cores on the system.
---@see lovr.thread
---@see lovr.system
---@return number # The number of logical cores on the system.
function system.getCoreCount() end

--- Returns the position of the mouse.
---@see lovr.system.getMouseX
---@see lovr.system.getMouseY
---@see lovr.mousemoved
---@see lovr.system
---@return number # The x position of the mouse, relative to the top-left of the window.
---@return number # The y position of the mouse, relative to the top-left of the window.
function system.getMousePosition() end

--- Returns the x position of the mouse.
---@see lovr.system.getMouseY
---@see lovr.system.getMousePosition
---@see lovr.mousemoved
---@see lovr.system
---@return number # The x position of the mouse, relative to the top-left of the window.
function system.getMouseX() end

--- Returns the y position of the mouse.
---@see lovr.system.getMouseX
---@see lovr.system.getMousePosition
---@see lovr.mousemoved
---@see lovr.system
---@return number # The y position of the mouse, relative to the top-left of the window.
function system.getMouseY() end

--- Returns the current operating system.
---@see lovr.system
---@return string # Either "Windows", "macOS", "Linux", "Android" or "Web".
function system.getOS() end

--- Returns the window pixel density.  High DPI windows will usually return 2.0 to indicate that there are 2 pixels for every window coordinate in each axis.  On a normal display, 1.0 is returned, indicating that window coordinates match up with pixels 1:1.
---@see lovr.system
---@return number # The pixel density of the window.
function system.getWindowDensity() end

--- Returns the dimensions of the desktop window.
---@see lovr.system.getWindowWidth
---@see lovr.system.getWindowHeight
---@see lovr.system.isWindowOpen
---@see lovr.system
---@return number # The width of the desktop window.
---@return number # The height of the desktop window.
function system.getWindowDimensions() end

--- Returns the height of the desktop window.
---@see lovr.system.getWindowWidth
---@see lovr.system.getWindowDimensions
---@see lovr.system.isWindowOpen
---@see lovr.system
---@return number # The height of the desktop window.
function system.getWindowHeight() end

--- Returns the width of the desktop window.
---@see lovr.system.getWindowHeight
---@see lovr.system.getWindowDimensions
---@see lovr.system.isWindowOpen
---@see lovr.system
---@return number # The width of the desktop window.
function system.getWindowWidth() end

--- Returns whether key repeat is enabled.
---@see lovr.keypressed
---@see lovr.system
---@return boolean # Whether key repeat is enabled.
function system.hasKeyRepeat() end

--- Returns whether a key on the keyboard is pressed.
---@see lovr.system.wasKeyPressed
---@see lovr.system.wasKeyReleased
---@see lovr.keypressed
---@see lovr.keyreleased
---@see lovr.system
---@param ... KeyCode # The set of keys to check.
---@return boolean # Whether any of the keys are currently pressed.
function system.isKeyDown(...) end

--- Returns whether a mouse button is currently pressed.
---@see lovr.mousepressed
---@see lovr.mousereleased
---@see lovr.system.getMouseX
---@see lovr.system.getMouseY
---@see lovr.system.getMousePosition
---@see lovr.system
---@param button number # The index of a button to check.  Use 1 for the primary mouse button, 2 for the secondary button, and 3 for the middle button.  Other indices can be used, but are hardware-specific.
---@return boolean # Whether the mouse button is currently down.
function system.isMouseDown(button) end

--- Returns whether the desktop window is focused.
---@see lovr.focus
---@see lovr.headset.isFocused
---@see lovr.system.openWindow
---@see lovr.system.isWindowOpen
---@see lovr.system.isWindowVisible
---@see lovr.system
---@return boolean # Whether the desktop window is focused.
function system.isWindowFocused() end

--- Returns whether the desktop window is open.  `t.window` can be set to `nil` in `lovr.conf` to disable automatic opening of the window.  In this case, the window can be opened manually using `lovr.system.openWindow`.
---@see lovr.system.openWindow
---@see lovr.system.isWindowVisible
---@see lovr.system.isWindowFocused
---@see lovr.system
---@return boolean # Whether the desktop window is open.
function system.isWindowOpen() end

--- Returns whether the desktop window is visible (open and not minimized).
---@see lovr.visible
---@see lovr.headset.isVisible
---@see lovr.system.openWindow
---@see lovr.system.isWindowOpen
---@see lovr.system.isWindowFocused
---@see lovr.system
---@return boolean # Whether the desktop window is visible.
function system.isWindowVisible() end

--- Opens the desktop window.  If the window is already open, this function does nothing.
---@see lovr.system.isWindowOpen
---@see lovr.conf
---@see lovr.system
---@param options table # Window options.
function system.openWindow(options) end

--- Fills the event queue with unprocessed events from the operating system.  This function should be called often, otherwise the operating system will consider the application unresponsive. This function is called in the default implementation of `lovr.run`.
---@see lovr.event.poll
---@see lovr.system
function system.pollEvents() end

--- Requests permission to use a feature.  Usually this will pop up a dialog box that the user needs to confirm.  Once the permission request has been acknowledged, the `lovr.permission` callback will be called with the result.  Currently, this is only used for requesting microphone access on Android devices.
---@see lovr.permission
---@see lovr.system
---@param permission Permission # The permission to request.
function system.requestPermission(permission) end

--- Sets the clipboard text.
---@see lovr.system.getClipboardText
---@see lovr.system
---@param text string # The string to set as the clipboard text.
function system.setClipboardText(text) end

--- Enables or disables key repeat.  Key repeat affects whether `lovr.keypressed` will be fired multiple times while a key is held down.  The `repeat` parameter of the callback can be used to detect whether a key press comes from a "repeat" or not.
---@see lovr.keypressed
---@see lovr.system
---@param enable boolean # Whether key repeat should be enabled.
function system.setKeyRepeat(enable) end

--- Returns whether a key on the keyboard was pressed this frame.
---@see lovr.system.isKeyDown
---@see lovr.system.wasKeyReleased
---@see lovr.keypressed
---@see lovr.keyreleased
---@see lovr.system
---@param ... KeyCode # The set of keys to check.
---@return boolean # Whether any of the specified keys were pressed this frame.
function system.wasKeyPressed(...) end

--- Returns whether a key on the keyboard was released this frame.
---@see lovr.system.isKeyDown
---@see lovr.system.wasKeyPressed
---@see lovr.keypressed
---@see lovr.keyreleased
---@see lovr.system
---@param ... KeyCode # The set of keys to check.
---@return boolean # Whether any of the specified keys were released this frame.
function system.wasKeyReleased(...) end

--- Returns whether a button on the mouse was pressed this frame.
---@see lovr.system.isMouseDown
---@see lovr.system.wasMouseReleased
---@see lovr.mousepressed
---@see lovr.mousereleased
---@see lovr.system
---@param button number # The index of a button to check.  Use 1 for the primary mouse button, 2 for the secondary button, and 3 for the middle button.  Other indices can be used, but are hardware-specific.
---@return boolean # Whether the mouse button was pressed this frame.
function system.wasMousePressed(button) end

--- Returns whether a button on the mouse was released this frame.
---@see lovr.system.isMouseDown
---@see lovr.system.wasMousePressed
---@see lovr.mousepressed
---@see lovr.mousereleased
---@see lovr.system
---@param button number # The index of a button to check.  Use 1 for the primary mouse button, 2 for the secondary button, and 3 for the middle button.  Other indices can be used, but are hardware-specific.
---@return boolean # Whether the mouse button was released this frame.
function system.wasMouseReleased(button) end

_G.lovr.system = system
