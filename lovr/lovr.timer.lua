---@meta lovr.timer

--- The `lovr.timer` module provides a few functions that deal with time.  All times are measured in seconds.
---
--- [Open in browser](https://lovr.org/docs/lovr.timer)
---@class lovr.timer
local timer = {}

--- Returns the average delta over the last second.
---
--- [Open in browser](https://lovr.org/docs/lovr.timer.getAverageDelta)
---@see lovr.timer.getDelta
---@see lovr.update
---@return number # The average delta, in seconds.
function timer.getAverageDelta() end

--- Returns the time between the last two frames.  This is the same value as the `dt` argument provided to `lovr.update` when VR is disabled.  When VR is enabled, the `dt` will instead be `lovr.headset.getDeltaTime`.
---
--- [Open in browser](https://lovr.org/docs/lovr.timer.getDelta)
---@see lovr.headset.getDeltaTime
---@see lovr.timer.getTime
---@see lovr.update
---@return number # The delta time, in seconds.
function timer.getDelta() end

--- Returns the current frames per second, averaged over the last 90 frames.
---
--- [Open in browser](https://lovr.org/docs/lovr.timer.getFPS)
---@return number # The current FPS.
function timer.getFPS() end

--- Returns the time since some time in the past.  This can be used to measure the difference between two points in time.
---
--- [Open in browser](https://lovr.org/docs/lovr.timer.getTime)
---@see lovr.headset.getTime
---@return number # The current time, in seconds.
function timer.getTime() end

--- Sleeps the application for a specified number of seconds.  While the game is asleep, no code will be run, no graphics will be drawn, and the window will be unresponsive.
---
--- [Open in browser](https://lovr.org/docs/lovr.timer.sleep)
---@param duration number # The number of seconds to sleep for.
function timer.sleep(duration) end

--- Steps the timer, returning the new delta time.  This is called automatically in `lovr.run` and it's used to calculate the new `dt` to pass to `lovr.update`.
---
--- [Open in browser](https://lovr.org/docs/lovr.timer.step)
---@return number # The amount of time since the last call to this function, in seconds.
function timer.step() end

_G.lovr.timer = timer
