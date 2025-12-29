---@meta lovr.event

--- The `lovr.event` module handles events from the operating system.
--- Due to its low-level nature, it's rare to use `lovr.event` in simple projects.
---
--- [Open in browser](https://lovr.org/docs/lovr.event)
---@class lovr.event
lovr.event = {}

--- This enum is used to distinguish whether a display is the headset display or the desktop window.
---@alias DisplayType
---| '"headset"' # The headset.
---| '"window"' # The desktop window.

--- Keys that can be pressed on a keyboard.  Notably, numpad keys are missing right now.
---@alias KeyCode
---| '"a"' # The A key.
---| '"b"' # The B key.
---| '"c"' # The C key.
---| '"d"' # The D key.
---| '"e"' # The E key.
---| '"f"' # The F key.
---| '"g"' # The G key.
---| '"h"' # The H key.
---| '"i"' # The I key.
---| '"j"' # The J key.
---| '"k"' # The K key.
---| '"l"' # The L key.
---| '"m"' # The M key.
---| '"n"' # The N key.
---| '"o"' # The O key.
---| '"p"' # The P key.
---| '"q"' # The Q key.
---| '"r"' # The R key.
---| '"s"' # The S key.
---| '"t"' # The T key.
---| '"u"' # The U key.
---| '"v"' # The V key.
---| '"w"' # The W key.
---| '"x"' # The X key.
---| '"y"' # The Y key.
---| '"z"' # The Z key.
---| '"0"' # The 0 key.
---| '"1"' # The 1 key.
---| '"2"' # The 2 key.
---| '"3"' # The 3 key.
---| '"4"' # The 4 key.
---| '"5"' # The 5 key.
---| '"6"' # The 6 key.
---| '"7"' # The 7 key.
---| '"8"' # The 8 key.
---| '"9"' # The 9 key.
---| '"space"' # The space bar.
---| '"return"' # The enter key.
---| '"tab"' # The tab key.
---| '"escape"' # The escape key.
---| '"backspace"' # The backspace key.
---| '"up"' # The up arrow key.
---| '"down"' # The down arrow key.
---| '"left"' # The left arrow key.
---| '"right"' # The right arrow key.
---| '"home"' # The home key.
---| '"end"' # The end key.
---| '"pageup"' # The page up key.
---| '"pagedown"' # The page down key.
---| '"insert"' # The insert key.
---| '"delete"' # The delete key.
---| '"f1"' # The F1 key.
---| '"f2"' # The F2 key.
---| '"f3"' # The F3 key.
---| '"f4"' # The F4 key.
---| '"f5"' # The F5 key.
---| '"f6"' # The F6 key.
---| '"f7"' # The F7 key.
---| '"f8"' # The F8 key.
---| '"f9"' # The F9 key.
---| '"f10"' # The F10 key.
---| '"f11"' # The F11 key.
---| '"f12"' # The F12 key.
---| '"`"' # The backtick/backquote/grave accent key.
---| '"-"' # The dash/hyphen/minus key.
---| '"="' # The equal sign key.
---| '"["' # The left bracket key.
---| '"]"' # The right bracket key.
---| '"\"' # The backslash key.
---| '";"' # The semicolon key.
---| '"'"' # The single quote key.
---| '","' # The comma key.
---| '"."' # The period key.
---| '"/"' # The slash key.
---| '"kp0"' # The 0 numpad key.
---| '"kp1"' # The 1 numpad key.
---| '"kp2"' # The 2 numpad key.
---| '"kp3"' # The 3 numpad key.
---| '"kp4"' # The 4 numpad key.
---| '"kp5"' # The 5 numpad key.
---| '"kp6"' # The 6 numpad key.
---| '"kp7"' # The 7 numpad key.
---| '"kp8"' # The 8 numpad key.
---| '"kp9"' # The 9 numpad key.
---| '"kp."' # The . numpad key.
---| '"kp/"' # The / numpad key.
---| '"kp*"' # The * numpad key.
---| '"kp-"' # The - numpad key.
---| '"kp+"' # The + numpad key.
---| '"kpenter"' # The enter numpad key.
---| '"kp="' # The equals numpad key.
---| '"lctrl"' # The left control key.
---| '"lshift"' # The left shift key.
---| '"lalt"' # The left alt key.
---| '"lgui"' # The left OS key (windows, command, super).
---| '"rctrl"' # The right control key.
---| '"rshift"' # The right shift key.
---| '"ralt"' # The right alt key.
---| '"rgui"' # The right OS key (windows, command, super).
---| '"capslock"' # The caps lock key.
---| '"scrolllock"' # The scroll lock key.
---| '"numlock"' # The numlock key.

--- Clears the event queue, removing any unprocessed events.
---
--- [Open in browser](https://lovr.org/docs/lovr.event.clear)
function lovr.event.clear() end

--- This function returns a Lua iterator for all of the unprocessed items in the event queue.  Each event consists of a name as a string, followed by event-specific arguments.  This function is called in the default implementation of `lovr.run`, so it is normally not necessary to poll for events yourself.
---
--- [Open in browser](https://lovr.org/docs/lovr.event.poll)
---@return function # The iterator function, usable in a for loop.
function lovr.event.poll() end

--- Pushes an event onto the event queue.  It will be processed the next time `lovr.event.poll` is called.  For an event to be processed properly, there needs to be a function in the `lovr.handlers` table with a key that's the same as the event name.
---
--- [Open in browser](https://lovr.org/docs/lovr.event.push)
---@see lovr.event.poll
---@see lovr.event.quit
---@param name string # The name of the event.
---@param ... any # The arguments for the event.  Currently, up to 4 are supported.
function lovr.event.push(name, ...) end

--- Pushes an event to quit.  An optional number can be passed to set the exit code for the application.  An exit code of zero indicates normal termination, whereas a nonzero exit code indicates that an error occurred.
---
--- [Open in browser](https://lovr.org/docs/lovr.event.quit)
---@see lovr.quit
---@see lovr.event.poll
---@see lovr.event.restart
---@param code number? # The exit code of the program. (default: 0)
function lovr.event.quit(code) end

--- Pushes an event to restart the framework.
---
--- [Open in browser](https://lovr.org/docs/lovr.event.restart)
---@see lovr.restart
---@see lovr.event.poll
---@see lovr.event.quit
function lovr.event.restart() end

return lovr.event