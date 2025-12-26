---@meta lovr.timer

--- The `lovr.timer` module provides a few functions that deal with time.  All times are measured in seconds.
---@class lovr.timer: { [any]: any }
local timer = {}

--- Returns the average delta over the last second.
---@see lovr.timer.getDelta
---@see lovr.update
---@see lovr.timer
---@return number # The average delta, in seconds.
function timer.getAverageDelta() end

--- Returns the time between the last two frames.  This is the same value as the `dt` argument provided to `lovr.update`.
---@see lovr.timer.getTime
---@see lovr.update
---@see lovr.timer
---@return number # The delta time, in seconds.
function timer.getDelta() end

--- Returns the current frames per second, averaged over the last 90 frames.
---@see lovr.timer
---@return number # The current FPS.
function timer.getFPS() end

--- Returns the time since some time in the past.  This can be used to measure the difference between two points in time.
---@see lovr.headset.getTime
---@see lovr.timer
---@return number # The current time, in seconds.
function timer.getTime() end

--- Sleeps the application for a specified number of seconds.  While the game is asleep, no code will be run, no graphics will be drawn, and the window will be unresponsive.
---@see lovr.timer
---@param duration number # The number of seconds to sleep for.
function timer.sleep(duration) end

--- Steps the timer, returning the new delta time.  This is called automatically in `lovr.run` and it's used to calculate the new `dt` to pass to `lovr.update`.
---@see lovr.timer
---@return number # The amount of time since the last call to this function, in seconds.
function timer.step() end

_G.lovr.timer = timer
