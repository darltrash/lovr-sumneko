---@meta lovr.headset

--- The `lovr.headset` module is where all the magical VR functionality is.  With it, you can access connected VR hardware and get information about the available space the player has.  Note that all units are reported in meters.  Position `(0, 0, 0)` is on the floor in the center of the play area.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset)
---@class lovr.headset
lovr.headset = {}

--- Different types of input devices supported by the `lovr.headset` module.
---@alias Device
---| '"head"' # The headset.
---| '"floor"' # A device representing the floor, at the center of the play area.  The pose of this device in physical space will remain constant, even after recentering.
---| '"left"' # A shorthand for hand/left.
---| '"right"' # A shorthand for hand/right.
---| '"hand/left"' # The left hand.
---| '"hand/right"' # The right hand.
---| '"hand/left/grip"' # The left hand grip pose, used for held objects.
---| '"hand/right/grip"' # The right hand grip pose, used for held objects.
---| '"hand/left/point"' # The left hand pointer pose, used for pointing or aiming.
---| '"hand/right/point"' # The right hand pointer pose, used for pointing or aiming.
---| '"hand/left/pinch"' # The left hand pinch pose between the thumb and index fingers, used for precise, close-range interactions.
---| '"hand/right/pinch"' # The right hand pinch pose between the thumb and index fingers, used for precise, close-range interactions.
---| '"hand/left/poke"' # The left hand poke pose, on the tip of the index finger or in front of a controller.
---| '"hand/right/poke"' # The right hand poke pose, on the tip of the index finger or in front of a controller.
---| '"elbow/left"' # A device tracking the left elbow.
---| '"elbow/right"' # A device tracking the right elbow.
---| '"shoulder/left"' # A device tracking the left shoulder.
---| '"shoulder/right"' # A device tracking the right shoulder.
---| '"chest"' # A device tracking the chest.
---| '"waist"' # A device tracking the waist.
---| '"knee/left"' # A device tracking the left knee.
---| '"knee/right"' # A device tracking the right knee.
---| '"foot/left"' # A device tracking the left foot or ankle.
---| '"foot/right"' # A device tracking the right foot or ankle.
---| '"camera"' # A camera device, often used for recording "mixed reality" footage.
---| '"keyboard"' # A tracked keyboard.
---| '"stylus"' # A tracked pen or pointer.
---| '"eye/left"' # The left eye.
---| '"eye/right"' # The right eye.
---| '"eye/gaze"' # The combined eye gaze pose.  The position is between the eyes.  The orientation aligns the-Z axis in the direction the user is looking and the +Y axis to the head's "up" vector. This provides more accurate eye tracking information compared to using the individual eye devices.

--- Axes on an input device.
---@alias DeviceAxis
---| '"trigger"' # A trigger (1D).
---| '"thumbstick"' # A thumbstick (2D).
---| '"thumbrest"' # A rest (1D, pressure sensitivity, also available as a `DeviceButton`).
---| '"touchpad"' # A touchpad (2D).
---| '"grip"' # A grip button or grab gesture (1D).
---| '"nib"' # The pressure sensitivity of the nib (tip) of a `stylus` device.  Also available on the `hand/left` and `hand/right` devices for the stylus nibs on touch pro controllers.

--- Buttons on an input device.
---@alias DeviceButton
---| '"trigger"' # The trigger button.
---| '"thumbstick"' # The thumbstick.
---| '"thumbrest"' # The thumbrest.
---| '"touchpad"' # The touchpad.
---| '"grip"' # The grip button.
---| '"menu"' # The menu button.
---| '"a"' # The A button.
---| '"b"' # The B button.
---| '"x"' # The X button.
---| '"y"' # The Y button.
---| '"nib"' # The nib (tip) of the `stylus` device.  Also available on `hand/left` and `hand/right` devices for the stylus tips on touch pro controllers.

--- The different levels of foveation supported by `lovr.headset.setFoveation`.
---@alias FoveationLevel
---| '"low"' # Low foveation.
---| '"medium"' # Medium foveation.
---| '"high"' # High foveation.

--- These are all of the supported VR APIs that LÖVR can use to power the lovr.headset module.  You can change the order of headset drivers using `lovr.conf` to prefer or exclude specific VR APIs.
--- At startup, LÖVR searches through the list of drivers in order.
---@alias HeadsetDriver
---| '"simulator"' # A VR simulator using keyboard/mouse.
---| '"openxr"' # OpenXR.

--- Represents the different types of origins for coordinate spaces.  An origin of "floor" means that the origin is on the floor in the middle of a room-scale play area.  An origin of "head" means that no positional tracking is available, and consequently the origin is always at the position of the headset.
---@alias HeadsetOrigin
---| '"head"' # The origin is at the head.
---| '"floor"' # The origin is on the floor.

--- Different passthrough modes, set using `lovr.headset.setPassthrough`.
--- For best results, the `blend` and `add` modes should use a transparent background color, which can be changed with `lovr.graphics.setBackgroundColor`.
---@alias PassthroughMode
---| '"opaque"' # The headset display will not blend with anything behind it.  Most VR headsets use this mode.
---| '"blend"' # The real world will blend with the headset display using the alpha channel.  This is supported on VR headsets with camera passthrough, as well as some AR displays.
---| '"add"' # Color values from virtual content will be added to the real world.  This is the most common mode used for AR.  Notably, black pixels will not show up at all.

--- A Layer is a textured plane placed in 3D space.  Layers are sent directly to the VR runtime and composited along with the rest of the 3D content.  This has several advantages compared to rendering the texture into the 3D scene with `Pass:draw`:
--- - Better tracking.  The VR runtime composites the texture later in the rendering process, using a more accurate head pose.
--- - Better resolution, less shimmery.  Regular 3D content must have lens distortion correction
---   applied to it, whereas layers are composited after distortion correction, meaning they have a
---   higher pixel density.  The layer can also use a higher resolution than the main headset
---   texture, allowing for extra resolution on the 2D content without having to supersample all of
---   the 3D rendering.
--- - Supersampling and sharpening effects.  Some headset runtimes (currently just Quest) can also
---   supersample and sharpen layers.
--- Combined, all of this makes a massive difference in quality when rendering 2D content on a Layer, especially improving text readability.
--- Note that currently the VR simulator does not support layers.
---
--- [Open in browser](https://lovr.org/docs/Layer)
---@class Layer
local Layer = {}

--- Returns the color of the layer.  This will tint the contents of its texture.  It can be used to fade the layer without re-rendering its texture, which is especially useful for layers created with the `static` option.
---
--- [Open in browser](https://lovr.org/docs/Layer:getColor)
---@return number # The red component of the color.
---@return number # The green component of the color.
---@return number # The blue component of the color.
---@return number # The alpha component of the color.
function Layer:getColor() end

--- Returns the curve of the layer.  Curving a layer renders it on a piece of a cylinder instead of a plane. The radius of the cylinder is `1 / curve` meters, so increasing the curve decreases the radius of the cylinder.
---
--- [Open in browser](https://lovr.org/docs/Layer:getCurve)
---@return number # The curve of the layer.
function Layer:getCurve() end

--- Returns the width and height of the layer.  This is the size of the Layer's plane in meters, not the resolution of the layer's texture in pixels.
---
--- [Open in browser](https://lovr.org/docs/Layer:getDimensions)
---@return number # The width of the layer, in meters.
---@return number # The height of the layer, in meters.
function Layer:getDimensions() end

--- Returns the orientation of the layer.
---
--- [Open in browser](https://lovr.org/docs/Layer:getOrientation)
---@see Layer.getPosition
---@see Layer.setPosition
---@see Layer.getPose
---@see Layer.setPose
---@return number # The amount of rotation around the axis of rotation, in radians.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Layer:getOrientation() end

--- Returns the render pass for the layer.  This can be used to render to the layer.
---
--- [Open in browser](https://lovr.org/docs/Layer:getPass)
---@see Layer.getTexture
---@return Pass # The layer's render pass.
function Layer:getPass() end

--- Returns the position and orientation of the layer.
---
--- [Open in browser](https://lovr.org/docs/Layer:getPose)
---@see Layer.getPosition
---@see Layer.setPosition
---@see Layer.getOrientation
---@see Layer.setOrientation
---@return number # The x position.
---@return number # The y position.
---@return number # The z position.
---@return number # The amount of rotation around the axis of rotation, in radians.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Layer:getPose() end

--- Returns the position of the layer, in meters.
---
--- [Open in browser](https://lovr.org/docs/Layer:getPosition)
---@see Layer.getOrientation
---@see Layer.setOrientation
---@see Layer.getPose
---@see Layer.setPose
---@return number # The x position of the layer.
---@return number # The y position of the layer.
---@return number # The z position of the layer.
function Layer:getPosition() end

--- Returns the texture for the layer.  This is the texture that will be pasted onto the layer.
---
--- [Open in browser](https://lovr.org/docs/Layer:getTexture)
---@see Layer.getPass
---@return Texture # The layer's texture.
function Layer:getTexture() end

--- Returns the viewport of the layer.  The viewport is a 2D region of pixels that the layer will display within its plane.
---
--- [Open in browser](https://lovr.org/docs/Layer:getViewport)
---@return number # The x coordinate of the upper-left corner of the viewport.
---@return number # The y coordinate of the upper-left corner of the viewport.
---@return number # The width of the viewport, in pixels.
---@return number # The height of the viewport, in pixels.
function Layer:getViewport() end

--- Sets the color of the layer.  This will tint the contents of its texture.  It can be used to fade the layer without re-rendering its texture, which is especially useful for layers created with the `static` option.
---
--- [Open in browser](https://lovr.org/docs/Layer:setColor)
---@param r number # The red component of the color.
---@param g number # The green component of the color.
---@param b number # The blue component of the color.
---@param a number? # The alpha component of the color. (default: 1.0)
---@overload fun(self: Layer, t: number[])
---@overload fun(self: Layer, hex: number, a?: number)
function Layer:setColor(r, g, b, a) end

--- Sets the curve of the layer.  Curving a layer renders it on a piece of a cylinder instead of a plane. The radius of the cylinder is `1 / curve` meters, so increasing the curve decreases the radius of the cylinder.
---
--- [Open in browser](https://lovr.org/docs/Layer:setCurve)
---@param curve number? # The curve of the layer.  Negative values or zero means no curve. (default: 0)
function Layer:setCurve(curve) end

--- Sets the width and height of the layer.  This is the size of the Layer's plane in meters, not not the resolution of the layer's texture in pixels.
---
--- [Open in browser](https://lovr.org/docs/Layer:setDimensions)
---@param width number # The width of the layer, in meters.
---@param height number # The height of the layer, in meters.
function Layer:setDimensions(width, height) end

--- Sets the orientation of the layer.
---
--- [Open in browser](https://lovr.org/docs/Layer:setOrientation)
---@see Layer.getPosition
---@see Layer.setPosition
---@see Layer.getPose
---@see Layer.setPose
---@param angle number # The amount of rotation around the axis of rotation, in radians.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@overload fun(self: Layer, orientation: Quat)
function Layer:setOrientation(angle, ax, ay, az) end

--- Sets the position and orientation of the layer.
---
--- [Open in browser](https://lovr.org/docs/Layer:setPose)
---@see Layer.getPosition
---@see Layer.setPosition
---@see Layer.getOrientation
---@see Layer.setOrientation
---@param x number # The x position.
---@param y number # The y position.
---@param z number # The z position.
---@param angle number # The amount of rotation around the axis of rotation, in radians.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@overload fun(self: Layer, position: Vec3, orientation: Quat)
function Layer:setPose(x, y, z, angle, ax, ay, az) end

--- Sets the position of the layer, in meters.
---
--- [Open in browser](https://lovr.org/docs/Layer:setPosition)
---@see Layer.getOrientation
---@see Layer.setOrientation
---@see Layer.getPose
---@see Layer.setPose
---@param x number # The x position of the layer.
---@param y number # The y position of the layer.
---@param z number # The z position of the layer.
function Layer:setPosition(x, y, z) end

--- Sets the viewport of the layer.  The viewport is a 2D region of pixels that the layer will display within its plane.
---
--- [Open in browser](https://lovr.org/docs/Layer:setViewport)
---@param x number # The x coordinate of the upper-left corner of the viewport.
---@param y number # The y coordinate of the upper-left corner of the viewport.
---@param w number # The width of the viewport, in pixels.
---@param h number # The height of the viewport, in pixels.
function Layer:setViewport(x, y, w, h) end

--- Animates a model to match its input state.  The buttons and joysticks on a controller will move as they're pressed/moved and hand models will move to match hand tracking joints.
--- The model must have been created using `lovr.headset.newModel` with the `animated` flag set to `true`.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.animate)
---@see lovr.headset.newModel
---@see Model.animate
---@param model Model # The model to animate.
---@return boolean # Whether the animation was applied successfully to the Model.  If the Model was not compatible or animation data for the device was not available, this will be `false`.
---@overload fun(device?: Device, model: Model): boolean
function lovr.headset.animate(model) end

--- Returns the current angular velocity of a device.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getAngularVelocity)
---@see lovr.headset.getVelocity
---@see lovr.headset.getPosition
---@see lovr.headset.getOrientation
---@param device Device? # The device to get the velocity of. (default: 'head')
---@return number # The x component of the angular velocity.
---@return number # The y component of the angular velocity.
---@return number # The z component of the angular velocity.
function lovr.headset.getAngularVelocity(device) end

--- Get the current state of an analog axis on a device.  Some axes are multidimensional, for example a 2D touchpad or thumbstick with x/y axes.  For multidimensional axes, this function will return multiple values, one number for each axis.  In these cases, it can be useful to use the `select` function built in to Lua to select a particular axis component.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getAxis)
---@see DeviceAxis
---@see lovr.headset.isDown
---@param device Device # The device.
---@param axis DeviceAxis # The axis.
---@return number | nil # The current state of the components of the axis, or `nil` if the device does not have any information about the axis.
function lovr.headset.getAxis(device, axis) end

--- Returns the depth of the play area, in meters.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getBoundsDepth)
---@see lovr.headset.getBoundsWidth
---@see lovr.headset.getBoundsDimensions
---@return number # The depth of the play area, in meters.
function lovr.headset.getBoundsDepth() end

--- Returns the size of the play area, in meters.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getBoundsDimensions)
---@see lovr.headset.getBoundsWidth
---@see lovr.headset.getBoundsDepth
---@see lovr.headset.getBoundsGeometry
---@return number # The width of the play area, in meters.
---@return number # The depth of the play area, in meters.
function lovr.headset.getBoundsDimensions() end

--- Returns a list of points representing the boundaries of the play area, or `nil` if the current headset driver does not expose this information.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getBoundsGeometry)
---@see lovr.headset.getBoundsDimensions
---@param t table? # A table to fill with the points.  If `nil`, a new table will be created. (default: nil)
---@return table # A flat table of 3D points representing the play area boundaries.
function lovr.headset.getBoundsGeometry(t) end

--- Returns the width of the play area, in meters.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getBoundsWidth)
---@see lovr.headset.getBoundsDepth
---@see lovr.headset.getBoundsDimensions
---@return number # The width of the play area, in meters.
function lovr.headset.getBoundsWidth() end

--- Returns the near and far clipping planes used to render to the headset.  Objects closer than the near clipping plane or further than the far clipping plane will be clipped out of view.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getClipDistance)
---@return number # The distance to the near clipping plane, in meters.
---@return number # The distance to the far clipping plane, in meters, or 0 for an infinite far clipping plane with a reversed Z range.
function lovr.headset.getClipDistance() end

--- Returns the headset delta time, which is the difference between the current and previous predicted display times.  When the headset is active, this will be the `dt` value passed in to `lovr.update`.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getDeltaTime)
---@see lovr.headset.getTime
---@see lovr.timer.getTime
---@see lovr.timer.getDelta
---@return number # The delta time.
function lovr.headset.getDeltaTime() end

--- Returns the direction a device is pointing.  It will always be normalized.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getDirection)
---@see lovr.headset.getPose
---@see lovr.headset.getOrientation
---@see lovr.headset.getVelocity
---@see lovr.headset.getAngularVelocity
---@see lovr.headset.isTracked
---@see lovr.headset.getDriver
---@param device Device? # The device to get the direction of. (default: 'head')
---@return number # The x component of the direction.
---@return number # The y component of the direction.
---@return number # The z component of the direction.
function lovr.headset.getDirection(device) end

--- Returns the texture dimensions of the headset display (for one eye), in pixels.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getDisplayDimensions)
---@see lovr.headset.getDisplayWidth
---@see lovr.headset.getDisplayHeight
---@return number # The width of the display.
---@return number # The height of the display.
function lovr.headset.getDisplayDimensions() end

--- Returns the height of the headset display (for one eye), in pixels.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getDisplayHeight)
---@see lovr.headset.getDisplayWidth
---@see lovr.headset.getDisplayDimensions
---@return number # The height of the display.
function lovr.headset.getDisplayHeight() end

--- Returns the width of the headset display (for one eye), in pixels.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getDisplayWidth)
---@see lovr.headset.getDisplayHeight
---@see lovr.headset.getDisplayDimensions
---@return number # The width of the display.
function lovr.headset.getDisplayWidth() end

--- Returns the `HeadsetDriver` that is currently in use, plus the name of the VR runtime.  The order of headset drivers can be changed using `lovr.conf`.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getDriver)
---@see lovr.headset.getName
---@return HeadsetDriver # The current headset backend, e.g. `openxr` or `simulator`.
---@return string # The name of the VR runtime, e.g. `SteamVR/OpenXR`.
function lovr.headset.getDriver() end

--- Returns a table of features that are supported by the current headset runtime.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getFeatures)
---@see lovr.headset.getName
---@return table # 
function lovr.headset.getFeatures() end

--- Returns the current foveation settings, previously set by `lovr.headset.setFoveation`.'
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getFoveation)
---@return FoveationLevel # The foveation level (or the maximum level when dynamic foveation is active).
---@return boolean # Whether dynamic foveation is active, allowing the system to reduce foveation based on GPU load.
function lovr.headset.getFoveation() end

--- Returns pointers to the OpenXR instance and session objects.
--- This can be used with FFI or other native plugins to integrate with other OpenXR code.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getHandles)
---@return lightuserdata # The OpenXR instance handle (`XrInstance`).
---@return lightuserdata # The OpenXR session handle (`XrSession`).
function lovr.headset.getHandles() end

--- Returns a table with all of the currently tracked hand devices.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getHands)
---@return Device[] # The currently tracked hand devices.
function lovr.headset.getHands() end

--- Returns the list of active `Layer` objects.  These are the layers that will be rendered in the headset's display.  They are rendered in order.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getLayers)
---@see lovr.headset.newLayer
---@see Layer
---@return Layer[] # The list of layers.
function lovr.headset.getLayers() end

--- Returns the name of the headset as a string.  The exact string that is returned depends on the hardware and VR SDK that is currently in use.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getName)
---@return string # The name of the headset as a string.
function lovr.headset.getName() end

--- Returns the current orientation of a device, in angle/axis form.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getOrientation)
---@see lovr.headset.getPose
---@see lovr.headset.getPosition
---@see lovr.headset.getDirection
---@see lovr.headset.getVelocity
---@see lovr.headset.getAngularVelocity
---@see lovr.headset.isTracked
---@see lovr.headset.getDriver
---@param device Device? # The device to get the orientation of. (default: 'head')
---@return number # The amount of rotation around the axis of rotation, in radians.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function lovr.headset.getOrientation(device) end

--- Returns a `Pass` that renders to the headset display.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getPass)
---@see lovr.graphics.newPass
---@see lovr.graphics.getWindowPass
---@see lovr.conf
---@return Pass | nil # The pass.
function lovr.headset.getPass() end

--- Returns the current passthrough mode.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getPassthrough)
---@see lovr.headset.getPassthroughModes
---@return PassthroughMode # The current passthrough mode.
function lovr.headset.getPassthrough() end

--- Returns the set of supported passthrough modes.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getPassthroughModes)
---@see lovr.headset.getPassthrough
---@see lovr.headset.setPassthrough
---@return table # The set of supported passthrough modes.  Keys will be `PassthroughMode` strings, and values will be booleans indicating whether the mode is supported.
function lovr.headset.getPassthroughModes() end

--- Returns the current position and orientation of a device.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getPose)
---@see lovr.headset.getPosition
---@see lovr.headset.getOrientation
---@see lovr.headset.getVelocity
---@see lovr.headset.getAngularVelocity
---@see lovr.headset.getSkeleton
---@see lovr.headset.isTracked
---@see lovr.headset.getDriver
---@param device Device? # The device to get the pose of. (default: 'head')
---@return number # The x position.
---@return number # The y position.
---@return number # The z position.
---@return number # The amount of rotation around the axis of rotation, in radians.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function lovr.headset.getPose(device) end

--- Returns the current position of a device, in meters, relative to the play area.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getPosition)
---@see lovr.headset.getPose
---@see lovr.headset.getOrientation
---@see lovr.headset.getVelocity
---@see lovr.headset.getAngularVelocity
---@see lovr.headset.isTracked
---@see lovr.headset.getDriver
---@param device Device? # The device to get the position of. (default: 'head')
---@return number # The x position of the device.
---@return number # The y position of the device.
---@return number # The z position of the device.
function lovr.headset.getPosition(device) end

--- Returns the refresh rate of the headset display, in Hz.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getRefreshRate)
---@see lovr.headset.getRefreshRates
---@return number | nil # The refresh rate of the display, or `nil` if I have no idea what it is.
function lovr.headset.getRefreshRate() end

--- Returns a table with all the refresh rates supported by the headset display, in Hz.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getRefreshRates)
---@see lovr.headset.getRefreshRate
---@see lovr.headset.setRefreshRate
---@return table | nil # A flat table of the refresh rates supported by the headset display, or nil if not supported.
function lovr.headset.getRefreshRates() end

--- Returns a list of joint transforms tracked by a device.  Currently, only hand devices are able to track joints.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getSkeleton)
---@see lovr.headset.getPose
---@see lovr.headset.animate
---@param device Device # The hand device to query (`left` or `right`).
---@return number[][] # A list of joint transforms for the device.  Each transform is a table with 3 numbers for the position of the joint, 1 number for the joint radius (in meters), and 4 numbers for the angle/axis orientation of the joint.  There is also a `radius` key with the radius of the joint as well.
---@overload fun(device: Device, t: table): number[][]
function lovr.headset.getSkeleton(device) end

--- Returns a Texture that will be submitted to the headset display.  This will be the render target used in the headset's render pass.  The texture is not guaranteed to be the same every frame, and must be called every frame to get the current texture.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getTexture)
---@see lovr.headset.getPass
---@see lovr.mirror
---@return Texture | nil # The headset texture.
function lovr.headset.getTexture() end

--- Returns the estimated time in the future at which the light from the pixels of the current frame will hit the eyes of the user.
--- This can be used as a replacement for `lovr.timer.getTime` for timestamps that are used for rendering to get a smoother result that is synchronized with the display of the headset.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getTime)
---@see lovr.headset.getDeltaTime
---@see lovr.timer.getTime
---@return number # The predicted display time, in seconds.
function lovr.headset.getTime() end

--- Returns the current linear velocity of a device, in meters per second.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getVelocity)
---@see lovr.headset.getAngularVelocity
---@see lovr.headset.getPose
---@see lovr.headset.getPosition
---@see lovr.headset.getOrientation
---@param device Device? # The device to get the velocity of. (default: 'head')
---@return number # The x component of the linear velocity.
---@return number # The y component of the linear velocity.
---@return number # The z component of the linear velocity.
function lovr.headset.getVelocity(device) end

--- Returns the view angles of one of the headset views.
--- These can be used with `Mat4:fov` to create a projection matrix.
--- If tracking data is unavailable for the view or the index is invalid, `nil` is returned.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getViewAngles)
---@see lovr.headset.getViewCount
---@see lovr.headset.getViewPose
---@param view number # The view index.
---@return number | nil # The left view angle, in radians.
---@return number | nil # The right view angle, in radians.
---@return number | nil # The top view angle, in radians.
---@return number | nil # The bottom view angle, in radians.
function lovr.headset.getViewAngles(view) end

--- Returns the number of views used for rendering.  Each view consists of a pose in space and a set of angle values that determine the field of view.
--- This is usually 2 for stereo rendering configurations, but it can also be different.  For example, one way of doing foveated rendering uses 2 views for each eye -- one low quality view with a wider field of view, and a high quality view with a narrower field of view.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getViewCount)
---@see lovr.headset.getViewPose
---@see lovr.headset.getViewAngles
---@return number # The number of views.
function lovr.headset.getViewCount() end

--- Returns the pose of one of the headset views.  This info can be used to create view matrices or do other eye-dependent calculations.
--- If tracking data is unavailable for the view or the index is invalid, `nil` is returned.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.getViewPose)
---@see lovr.headset.getViewCount
---@see lovr.headset.getViewAngles
---@param view number # The view index.
---@return number | nil # The x coordinate of the view position, in meters.
---@return number | nil # The y coordinate of the view position, in meters.
---@return number | nil # The z coordinate of the view position, in meters.
---@return number | nil # The amount of rotation around the rotation axis, in radians.
---@return number | nil # The x component of the axis of rotation.
---@return number | nil # The y component of the axis of rotation.
---@return number | nil # The z component of the axis of rotation.
function lovr.headset.getViewPose(view) end

--- Returns whether a headset session is active.  When true, there is an active connection to the VR hardware.  When false, most headset methods will not work properly until `lovr.headset.start` is used to start a session.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.isActive)
---@see lovr.headset.start
---@see lovr.headset.stop
---@return boolean # Whether the headset session is active.
function lovr.headset.isActive() end

--- Returns whether a button on a device is pressed.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.isDown)
---@see DeviceButton
---@see lovr.headset.wasPressed
---@see lovr.headset.wasReleased
---@see lovr.headset.isTouched
---@see lovr.headset.getAxis
---@param device Device # The device.
---@param button DeviceButton # The button.
---@return boolean | nil # Whether the button on the device is currently pressed, or `nil` if the device does not have the specified button.
function lovr.headset.isDown(device, button) end

--- Returns whether LÖVR has VR input focus.  Focus is lost when the VR system menu is shown.  The `lovr.focus` callback can be used to detect when this changes.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.isFocused)
---@see lovr.focus
---@return boolean # Whether the application is focused.
function lovr.headset.isFocused() end

--- Returns whether the headset is mounted.  Usually this uses a proximity sensor on the headset to detect whether someone is wearing the headset.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.isMounted)
---@see lovr.mount
---@see lovr.headset.isFocused
---@see lovr.headset.isVisible
---@return boolean # Whether the headset is mounted.
function lovr.headset.isMounted() end

--- Returns whether the headset coordinate space is in seated mode.
--- Seated mode is enabled by setting `t.headset.seated` to true in `lovr.conf`.  In seated mode, `y=0` will be at eye level, instead of on the floor like in standing-scale experiences.
--- The seated coordinate space can be more convenient for applications that are rendering a simple interface in front of the user (like a video player) instead of a roomscale 3D scene.  y=0 will also be at the correct height at startup, whether the user is sitting or standing.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.isSeated)
---@see lovr.conf
---@see lovr.recenter
---@return boolean # Whether the experience is seated.
function lovr.headset.isSeated() end

--- Returns whether a button on a device is currently touched.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.isTouched)
---@see DeviceButton
---@see lovr.headset.isDown
---@see lovr.headset.getAxis
---@param device Device # The device.
---@param button DeviceButton # The button.
---@return boolean | nil # Whether the button on the device is currently touched, or `nil` if the device does not have the button or it isn't touch-sensitive.
function lovr.headset.isTouched(device, button) end

--- Returns whether any active headset driver is currently returning pose information for a device.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.isTracked)
---@param device Device? # The device to get the pose of. (default: 'head')
---@return boolean # Whether the device is currently tracked.
function lovr.headset.isTracked(device) end

--- Returns whether LÖVR's content is being presented to the headset display.  Normally this will be true, but some VR runtimes allow applications to be hidden or "minimized", similar to desktop windows.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.isVisible)
---@see lovr.visible
---@see lovr.headset.isFocused
---@see lovr.focus
---@return boolean # Whether the application is visible.
function lovr.headset.isVisible() end

--- Creates a new `Layer`.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.newLayer)
---@see lovr.headset.getLayers
---@see lovr.headset.setLayers
---@param width number # The width of the Layer texture, in pixels.
---@param height number # The height of the Layer texture, in pixels.
---@return Layer # The new Layer.
function lovr.headset.newLayer(width, height) end

--- Loads a new Model object for the specified model key.
--- Model keys are lightuserdata values that act as an ID for a specific model.  Use `lovr.headset.getModelKeys` to retrieve a list of model keys for the currently connected hardware.
--- It is recommended to refresh the list of model keys in the `lovr.modelschanged` event, which gets fired whenever the list of keys changes.  `lovr.modelschanged` is also fired once at startup when the models are ready to load.  In the callback, you can get the new list of model keys and load models for any keys that haven't been loaded yet.
--- There isn't any correspondence between a model key and a `Device`, because there could be multiple models for a device, or some models that do not correspond to a device at all.  For example, the hand device could have a model for a controller, a wrist tracker, or a hand mesh.
--- Once a model is loaded, call `lovr.headset.isTracked` with the model to check if it should be visible, and `lovr.headset.getPose` to get the position and orientation to draw the model at.
--- To reposition the nodes in the model to match the current state of the buttons, joysticks, etc., call `lovr.headset.animate` with the model.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.newModel)
---@see lovr.headset.animate
---@see lovr.headset.isTracked
---@see lovr.modelschanged
---@see lovr.graphics.newModel
---@param key lightuserdata # A model key to load, previously obtained with `lovr.headset.getModelKeys`.
---@return Model # The new Model, or `nil` if a model could not be loaded.
---@overload fun(device?: Device): Model
function lovr.headset.newModel(key) end

--- Sets a background layer.  This will render behind any transparent pixels in the main 3D content. It works similarly to other `Layer` objects, but using a cubemap or equirectangular texture.
--- The background texture is sent to the VR runtime once, and the runtime is responsible for compositing it behind the rest of the scene.  This can improve performance greatly, since the background doesn't need to be re-rendered every frame.  It also ensures the background remains tracked smoothly even if LÖVR is struggling to render at a high frame rate.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.setBackground)
---@see Layer
---@see Pass.skybox
---@param background Image[] # The image(s) or texture to use for the background.  Backgrounds can either be cubemaps (6 images) or equirectangular (a single panoramic 2D image).Textures can have any color format, but it will be converted to `rgba8` before getting copied to the VR runtime.  Images currently have to be `rgba8`.
---@overload fun()
function lovr.headset.setBackground(background) end

--- Sets the near and far clipping planes used to render to the headset.  Objects closer than the near clipping plane or further than the far clipping plane will be clipped out of view.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.setClipDistance)
---@param near number # The distance to the near clipping plane, in meters.
---@param far number # The distance to the far clipping plane, in meters, or 0 for an infinite far clipping plane with a reversed Z range.
function lovr.headset.setClipDistance(near, far) end

--- Sets foveated rendering settings.  Currently only fixed foveated rendering is supported.  This renders the edges of the screen at a lower resolution to improve GPU performance.  Higher foveation levels will save more GPU time, but make the edges of the screen more blocky.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.setFoveation)
---@param level FoveationLevel # The foveation level (or the maximum level when dynamic foveation is active).
---@param dynamic boolean? # Whether the system is allowed to dynamically adjust the foveation level based on GPU load. (default: true)
---@return boolean # Whether foveation was enabled successfully.
---@overload fun(): boolean
function lovr.headset.setFoveation(level, dynamic) end

--- Sets the list of active `Layer` objects.  These are the layers that will be rendered in the headset's display.  They are rendered in order.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.setLayers)
---@see lovr.headset.newLayer
---@see Layer
---@param ... Layer # Zero or more layers to render in the headset.
---@overload fun(t: table)
function lovr.headset.setLayers(...) end

--- Sets a new passthrough mode.  Not all headsets support all passthrough modes.  Use `lovr.headset.getPassthroughModes` to see which modes are supported.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.setPassthrough)
---@see lovr.headset.getPassthroughModes
---@param mode PassthroughMode # The passthrough mode to request.
---@return boolean # Whether the passthrough mode was supported and successfully enabled.
---@overload fun(transparent: boolean): boolean
---@overload fun(): boolean
function lovr.headset.setPassthrough(mode) end

--- Sets the display refresh rate, in Hz.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.setRefreshRate)
---@see lovr.headset.getRefreshRates
---@param rate number # The new refresh rate, in Hz.
---@return boolean # Whether the display refresh rate was successfully set.
function lovr.headset.setRefreshRate(rate) end

--- Starts the headset session.  This must be called after the graphics module is initialized. Normally it is called automatically by `boot.lua`, but this can be disabled by setting `t.headset.start` to false in `lovr.conf`.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.start)
---@see lovr.headset.stop
---@see lovr.headset.isActive
function lovr.headset.start() end

--- Stops the headset session.  This tears down the connection to the VR runtime and hardware. `lovr.draw` will instead start rendering to the desktop window, as though the headset module was disabled.  However, certain information about the headset can still be queried, such as its name, supported passthrough modes, display size, etc.  A headset session can be started later using `lovr.headset.start`.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.stop)
---@see lovr.headset.start
---@see lovr.headset.isActive
function lovr.headset.stop() end

--- Causes the device to stop any active haptics vibration.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.stopVibration)
---@see lovr.headset.vibrate
---@param device Device? # The device to stop the vibration on. (default: 'head')
function lovr.headset.stopVibration(device) end

--- Submits the current headset texture to the VR display.  This should be called after calling `lovr.graphics.submit` with the headset render pass.  Normally this is taken care of by `lovr.run`.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.submit)
---@see lovr.headset.getPass
---@see lovr.headset.getTexture
function lovr.headset.submit() end

--- Updates the headset module, blocking until it is time to start a new frame and polling new input states.  This should only be called once at the beginning of a frame, and is normally taken care of by the default `lovr.run` implementation.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.update)
---@see lovr.headset.submit
---@see lovr.run
---@return number # The delta time since the last frame.  This is the same value returned by `lovr.headset.getDeltaTime`, and is used by boot.lua.
function lovr.headset.update() end

--- Causes the device to vibrate with a custom strength, duration, and frequency, if possible.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.vibrate)
---@see lovr.headset.stopVibration
---@param device Device? # The device to vibrate. (default: 'head')
---@param strength number? # The strength of the vibration (amplitude), between 0 and 1. (default: 1)
---@param duration number? # The duration of the vibration, in seconds. (default: .5)
---@param frequency number? # The frequency of the vibration, in hertz.  0 will use a default frequency. (default: 0)
---@return boolean # Whether the vibration was successfully triggered by an active headset driver.
function lovr.headset.vibrate(device, strength, duration, frequency) end

--- Returns whether a button on a device was pressed this frame.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.wasPressed)
---@see DeviceButton
---@see lovr.headset.isDown
---@see lovr.headset.wasReleased
---@see lovr.headset.isTouched
---@see lovr.headset.getAxis
---@param device Device # The device.
---@param button DeviceButton # The button to check.
---@return boolean # Whether the button on the device was pressed this frame.
function lovr.headset.wasPressed(device, button) end

--- Returns whether a button on a device was released this frame.
---
--- [Open in browser](https://lovr.org/docs/lovr.headset.wasReleased)
---@see DeviceButton
---@see lovr.headset.isDown
---@see lovr.headset.wasPressed
---@see lovr.headset.isTouched
---@see lovr.headset.getAxis
---@param device Device # The device.
---@param button DeviceButton # The button to check.
---@return boolean # Whether the button on the device was released this frame.
function lovr.headset.wasReleased(device, button) end

return lovr.headset