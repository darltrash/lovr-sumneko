---@meta lovr.thread

--- The `lovr.thread` module provides functions for creating threads and communicating between them.
--- These are operating system level threads, which are different from Lua coroutines.
--- Threads are useful for performing expensive background computation without affecting the framerate or performance of the main thread.  Some examples of this include asset loading, networking and network requests, and physics simulation.
--- Threads come with some caveats:
--- - Threads run in a bare Lua environment.  The `lovr` module (and any of lovr's modules) need to
---   be required before they can be used.
---   - To get `require` to work properly, add `require 'lovr.filesystem'` to the thread code.
--- - Threads are completely isolated from other threads.  They do not have access to the variables
---   or functions of other threads, and communication between threads must be coordinated through
---   `Channel` objects.
--- - The graphics module (or any functions that perform rendering) cannot be used in a thread.
---   Note that this includes creating graphics objects like Models and Textures.  There are "data"
---   equivalent `ModelData` and `Image` objects that can be used in threads though.
--- - `lovr.system.pollEvents` cannot be called from a thread.
--- - Crashes or problems can happen if two threads access the same object at the same time, so
---   special care must be taken to coordinate access to objects from multiple threads.
---
--- [Open in browser](https://lovr.org/docs/lovr.thread)
---@class lovr.thread
local thread = {}

--- A Channel is an object used to communicate between `Thread` objects.  Different threads can send messages on the same Channel to communicate with each other.  Messages can be sent and received on a Channel using `Channel:push` and `Channel:pop`, and are received in a first-in-first-out fashion. The following types of data can be passed through Channels: nil, boolean, number, string, lightuserdata, table, vector, and any LÖVR object.
---
--- [Open in browser](https://lovr.org/docs/Channel)
---@class Channel
local Channel = {}

--- Removes all pending messages from the Channel.
---
--- [Open in browser](https://lovr.org/docs/Channel:clear)
function Channel:clear() end

--- Returns the number of messages in the Channel.
---
--- [Open in browser](https://lovr.org/docs/Channel:getCount)
---@return number # The number of messages in the Channel.
function Channel:getCount() end

--- Returns whether or not the message with the given ID has been read.  Every call to `Channel:push` returns a message ID.
---
--- [Open in browser](https://lovr.org/docs/Channel:hasRead)
---@see Channel.push
---@param id number # The ID of the message to check.
---@return boolean # Whether the message has been read.
function Channel:hasRead(id) end

--- Returns a message from the Channel without popping it from the queue.  If the Channel is empty, `nil` is returned.  This can be useful to determine if the Channel is empty.
---
--- [Open in browser](https://lovr.org/docs/Channel:peek)
---@see Channel.pop
---@return any # The message, or `nil` if there is no message.
---@return boolean # Whether a message was returned (use to detect nil).
function Channel:peek() end

--- Pops a message from the Channel.  If the Channel is empty, an optional timeout argument can be used to wait for a message, otherwise `nil` is returned.
---
--- [Open in browser](https://lovr.org/docs/Channel:pop)
---@see Channel.peek
---@see Channel.push
---@param wait number | boolean? # How long to wait for a message to be popped, in seconds.  `true` can be used to wait forever and `false` can be used to avoid waiting. (default: false)
---@return any # The received message, or `nil` if nothing was received.
function Channel:pop(wait) end

--- Pushes a message onto the Channel.  The following types of data can be pushed: nil, boolean, number, string, table, lightuserdata, vectors, and userdata (LÖVR objects).
---
--- [Open in browser](https://lovr.org/docs/Channel:push)
---@see Channel.pop
---@see Channel.hasRead
---@param message any # The message to push.
---@param wait number | boolean? # How long to wait for the message to be popped, in seconds.  `true` can be used to wait forever and `false` can be used to avoid waiting. (default: false)
---@return number # The ID of the pushed message.
---@return boolean # Whether the message was read by another thread before the wait timeout.
function Channel:push(message, wait) end

--- A Thread is an object that runs a chunk of Lua code in the background.  Threads are completely isolated from other threads, meaning they have their own Lua context and can't access the variables and functions of other threads.  Communication between threads is limited and is accomplished by using `Channel` objects.
--- To get `require` to work properly, add `require 'lovr.filesystem'` to the thread code.
---
--- [Open in browser](https://lovr.org/docs/Thread)
---@class Thread
local Thread = {}

--- Returns the message for the error that occurred on the Thread, or nil if no error has occurred.
---
--- [Open in browser](https://lovr.org/docs/Thread:getError)
---@see lovr.threaderror
---@return string | nil # The error message, or `nil` if no error has occurred on the Thread.
function Thread:getError() end

--- Returns whether or not the Thread is currently running.
---
--- [Open in browser](https://lovr.org/docs/Thread:isRunning)
---@see Thread.start
---@return boolean # Whether or not the Thread is running.
function Thread:isRunning() end

--- Starts the Thread.
---
--- [Open in browser](https://lovr.org/docs/Thread:start)
---@param ... any # Up to 4 arguments to pass to the Thread's function.
function Thread:start(...) end

--- Waits for the Thread to complete, then returns.
---
--- [Open in browser](https://lovr.org/docs/Thread:wait)
---@see Thread.isRunning
function Thread:wait() end

--- Returns a named Channel for communicating between threads.
---
--- [Open in browser](https://lovr.org/docs/lovr.thread.getChannel)
---@see Channel
---@see lovr.thread.newChannel
---@param name string # The name of the Channel to get.
---@return Channel # The Channel with the specified name.
function thread.getChannel(name) end

--- Creates a new unnamed `Channel` object.  Usually it's more convenient to use `lovr.thread.getChannel`, since other threads can use that function to query the channel by name.  Unnamed channels don't require a unique name, but they need to be sent to other threads somehow (e.g. on a different Channel or as an argument to `Thread:start`).
---
--- [Open in browser](https://lovr.org/docs/lovr.thread.newChannel)
---@see lovr.thread.getChannel
---@return Channel # The new Channel.
function thread.newChannel() end

--- Creates a new Thread from Lua code.
---
--- [Open in browser](https://lovr.org/docs/lovr.thread.newThread)
---@see Thread.start
---@see lovr.threaderror
---@param code string # The code to run in the Thread.
---@return Thread # The new Thread.
---@overload fun(file: string | Blob): Thread
function thread.newThread(code) end

_G.lovr.thread = thread
