---@meta lovr.audio

--- The `lovr.audio` module is responsible for playing sound effects and music.  To play a sound, create a `Source` object and call `Source:play` on it.  Currently ogg, wav, and mp3 audio formats are supported.
---@class lovr.audio
local audio = {}

--- Different types of audio material presets, for use with `lovr.audio.setGeometry`.
---@alias AudioMaterial
---| '"generic"' # Generic default audio material.
---| '"brick"' # Brick.
---| '"carpet"' # Carpet.
---| '"ceramic"' # Ceramic.
---| '"concrete"' # Concrete.
---| '"glass"' # Glass.
---| '"gravel"' # Gravel.
---| '"metal"' # Metal.
---| '"plaster"' # Plaster.
---| '"rock"' # Rock.
---| '"wood"' # Wood.

--- Audio devices can be created in shared mode or exclusive mode.  In exclusive mode, the audio device is the only one active on the system, which gives better performance and lower latency. However, exclusive devices aren't always supported and might not be allowed, so there is a higher chance that creating one will fail.
---@alias AudioShareMode
---| '"shared"' # Shared mode.
---| '"exclusive"' # Exclusive mode.

--- When referencing audio devices, this indicates whether it's the playback or capture device.
---@alias AudioType
---| '"playback"' # The playback device (speakers, headphones).
---| '"capture"' # The capture device (microphone).

--- Different types of effects that can be applied with `Source:setEffectEnabled`.
---@alias Effect
---| '"absorption"' # Models absorption as sound travels through the air, water, etc.
---| '"attenuation"' # Decreases audio volume with distance (1 / max(distance, 1)).
---| '"occlusion"' # Causes audio to drop off when the Source is occluded by geometry.
---| '"reverb"' # Models reverb caused by audio bouncing off of geometry.
---| '"spatialization"' # Spatializes the Source using either simple panning or an HRTF.
---| '"transmission"' # Causes audio to be heard through walls when occluded, based on audio materials.

--- When figuring out how long a Source is or seeking to a specific position in the sound file, units can be expressed in terms of seconds or in terms of frames.  A frame is one set of samples for each channel (one sample for mono, two samples for stereo).
---@alias TimeUnit
---| '"seconds"' # Seconds.
---| '"frames"' # Frames.

--- When accessing the volume of Sources or the audio listener, this can be done in linear units with a 0 to 1 range, or in decibels with a range of -∞ to 0.
---@alias VolumeUnit
---| '"linear"' # Linear volume range.
---| '"db"' # Decibels.

---@class Source
local Source = {}

--- Creates a copy of the Source, referencing the same `Sound` object and inheriting all of the settings of this Source.  However, it will be created in the stopped state and will be rewound to the beginning.
---@see lovr.audio.newSource
---@return Source # A genetically identical copy of the Source.
function Source:clone() end

--- Returns the directivity settings for the Source.
--- The directivity is controlled by two parameters: the weight and the power.
--- The weight is a number between 0 and 1 controlling the general "shape" of the sound emitted. 0.0 results in a completely omnidirectional sound that can be heard from all directions.  1.0 results in a full dipole shape that can be heard only from the front and back.  0.5 results in a cardioid shape that can only be heard from one direction.  Numbers in between will smoothly transition between these.
--- The power is a number that controls how "focused" or sharp the shape is.  Lower power values can be heard from a wider set of angles.  It is an exponent, so it can get arbitrarily large.  Note that a power of zero will still result in an omnidirectional source, regardless of the weight.
---@return number # The dipole weight.  0.0 is omnidirectional, 1.0 is a dipole, 0.5 is cardioid.
---@return number # The dipole power, controlling how focused the directivity shape is.
function Source:getDirectivity() end

--- Returns the duration of the Source.
---@see Sound.getDuration
---@param unit TimeUnit? # The unit to return. (default: 'seconds')
---@return number # The duration of the Source.
function Source:getDuration(unit) end

--- Returns the orientation of the Source, in angle/axis representation.
---@see Source.getPosition
---@see Source.getPose
---@see lovr.audio.getOrientation
---@return number # The number of radians the Source is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Source:getOrientation() end

--- Returns the pitch of the Source.
---@return number # The pitch.
function Source:getPitch() end

--- Returns the position and orientation of the Source.
---@see Source.getPosition
---@see Source.getOrientation
---@see lovr.audio.getPose
---@return number # The x position of the Source, in meters.
---@return number # The y position of the Source, in meters.
---@return number # The z position of the Source, in meters.
---@return number # The number of radians the Source is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Source:getPose() end

--- Returns the position of the Source, in meters.  Setting the position will cause the Source to be distorted and attenuated based on its position relative to the listener.
---@see Source.getOrientation
---@see Source.getPose
---@see lovr.audio.getPosition
---@return number # The x coordinate.
---@return number # The y coordinate.
---@return number # The z coordinate.
function Source:getPosition() end

--- Returns the radius of the Source, in meters.
--- This does not control falloff or attenuation.  It is only used for smoothing out occlusion.  If a Source doesn't have a radius, then when it becomes occluded by a wall its volume will instantly drop.  Giving the Source a radius that approximates its emitter's size will result in a smooth transition between audible and occluded, improving realism.
---@return number # The radius of the Source, in meters.
function Source:getRadius() end

--- Returns the `Sound` object backing the Source.  Multiple Sources can share one Sound, allowing its data to only be loaded once.  An easy way to do this sharing is by using `Source:clone`.
---@see Source.clone
---@see lovr.audio.newSource
---@return Sound # The Sound object.
function Source:getSound() end

--- Returns the current volume factor for the Source.
---@param units VolumeUnit? # The units to return (linear or db). (default: 'linear')
---@return number # The volume of the Source.
function Source:getVolume(units) end

--- Returns whether a given `Effect` is enabled for the Source.
---@see Source.isSpatial
---@param effect Effect # The effect.
---@return boolean # Whether the effect is enabled.
function Source:isEffectEnabled(effect) end

--- Returns whether or not the Source will loop when it finishes.
---@return boolean # Whether or not the Source is looping.
function Source:isLooping() end

--- Returns whether or not the Source is playing.
---@see Source.play
---@see Source.pause
---@see Source.stop
---@return boolean # Whether the Source is playing.
function Source:isPlaying() end

--- Returns whether the Source was created with the `spatial` flag.  Non-spatial sources are routed directly to the speakers and can not use effects.
---@see Source.isEffectEnabled
---@see Source.setEffectEnabled
---@return boolean # Whether the source is spatial.
function Source:isSpatial() end

--- Pauses the source.  It can be resumed with `Source:resume` or `Source:play`. If a paused source is rewound, it will remain paused.
function Source:pause() end

--- Plays the Source.  This doesn't do anything if the Source is already playing.
---@return boolean # Whether the Source successfully started playing.
function Source:play() end

--- Seeks the Source to the specified position.
---@param position number # The position to seek to.
---@param unit TimeUnit? # The units for the seek position. (default: 'seconds')
function Source:seek(position, unit) end

--- Sets the directivity settings for the Source.
--- The directivity is controlled by two parameters: the weight and the power.
--- The weight is a number between 0 and 1 controlling the general "shape" of the sound emitted. 0.0 results in a completely omnidirectional sound that can be heard from all directions.  1.0 results in a full dipole shape that can be heard only from the front and back.  0.5 results in a cardioid shape that can only be heard from one direction.  Numbers in between will smoothly transition between these.
--- The power is a number that controls how "focused" or sharp the shape is.  Lower power values can be heard from a wider set of angles.  It is an exponent, so it can get arbitrarily large.  Note that a power of zero will still result in an omnidirectional source, regardless of the weight.
---@param weight number # The dipole weight.  0.0 is omnidirectional, 1.0 is a dipole, 0.5 is cardioid.
---@param power number # The dipole power, controlling how focused the directivity shape is.
function Source:setDirectivity(weight, power) end

--- Enables or disables an effect on the Source.
---@see Source.isSpatial
---@param effect Effect # The effect.
---@param enable boolean # Whether the effect should be enabled.
function Source:setEffectEnabled(effect, enable) end

--- Sets whether or not the Source loops.
---@param loop boolean # Whether or not the Source will loop.
function Source:setLooping(loop) end

--- Sets the orientation of the Source in angle/axis representation.
---@see Source.setPosition
---@see Source.setPose
---@see lovr.audio.setOrientation
---@param angle number # The number of radians the Source should be rotated around its rotation axis.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@overload fun(self: Source, orientation: Quat)
function Source:setOrientation(angle, ax, ay, az) end

--- Sets the pitch of the Source.
---@param pitch number # The new pitch.
function Source:setPitch(pitch) end

--- Sets the position and orientation of the Source.
---@see Source.setPosition
---@see Source.setOrientation
---@see lovr.audio.setPose
---@param x number # The x position of the Source.
---@param y number # The y position of the Source.
---@param z number # The z position of the Source.
---@param angle number # The number of radians the Source is rotated around its axis of rotation.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@overload fun(self: Source, position: Vec3, orientation: Quat)
function Source:setPose(x, y, z, angle, ax, ay, az) end

--- Sets the position of the Source.  Setting the position will cause the Source to be distorted and attenuated based on its position relative to the listener.
--- Only mono sources can be positioned.  Setting the position of a stereo Source will cause an error.
---@see Source.setOrientation
---@see Source.setPose
---@param x number # The x coordinate of the position.
---@param y number # The y coordinate of the position.
---@param z number # The z coordinate of the position.
---@overload fun(self: Source, position: Vec3)
function Source:setPosition(x, y, z) end

--- Sets the radius of the Source, in meters.
--- This does not control falloff or attenuation.  It is only used for smoothing out occlusion.  If a Source doesn't have a radius, then when it becomes occluded by a wall its volume will instantly drop.  Giving the Source a radius that approximates its emitter's size will result in a smooth transition between audible and occluded, improving realism.
---@param radius number # The new radius of the Source, in meters.
function Source:setRadius(radius) end

--- Sets the current volume factor for the Source.
---@param volume number # The new volume.
---@param units VolumeUnit? # The units of the value. (default: 'linear')
function Source:setVolume(volume, units) end

--- Stops the source, also rewinding it to the beginning.
---@see Source.play
---@see Source.pause
---@see Source.isPlaying
function Source:stop() end

--- Returns the current playback position of the Source.
---@param unit TimeUnit? # The unit to return. (default: 'seconds')
---@return number # The current playback position.
function Source:tell(unit) end

--- Returns the global air absorption coefficients for the medium.  This affects Sources that have the `absorption` effect enabled, causing audio volume to drop off with distance as it is absorbed by the medium it's traveling through (air, water, etc.).  The difference between absorption and the attenuation effect is that absorption is more subtle and is frequency-dependent, so higher-frequency bands can get absorbed more quickly than lower ones. This can be used to apply "underwater" effects and stuff.
---@return number # The absorption coefficient for the low frequency band.
---@return number # The absorption coefficient for the mid frequency band.
---@return number # The absorption coefficient for the high frequency band.
function audio.getAbsorption() end

--- Returns information about the active playback or capture device.
---@see lovr.audio.getDevices
---@see lovr.audio.setDevice
---@param type AudioType? # The type of device to query. (default: 'playback')
---@return string | nil # The name of the device, or `nil` if no device is set.
---@return userdata | nil # The opaque id of the device, or `nil` if no device is set.
function audio.getDevice(type) end

--- Returns a list of playback or capture devices.  Each device has an `id`, `name`, and a `default` flag indicating whether it's the default device.
--- To use a specific device id for playback or capture, pass it to `lovr.audio.setDevice`.
---@see lovr.audio.setDevice
---@see lovr.audio.getDevice
---@see lovr.audio.start
---@see lovr.audio.stop
---@param type AudioType? # The type of devices to query (playback or capture). (default: 'playback')
---@return table # The list of devices.
function audio.getDevices(type) end

--- Returns the orientation of the virtual audio listener in angle/axis representation.
---@see lovr.audio.getPosition
---@see lovr.audio.getPose
---@see Source.getOrientation
---@return number # The number of radians the listener is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function audio.getOrientation() end

--- Returns the position and orientation of the virtual audio listener.
---@see lovr.audio.getPosition
---@see lovr.audio.getOrientation
---@see Source.getPose
---@return number # The x position of the listener, in meters.
---@return number # The y position of the listener, in meters.
---@return number # The z position of the listener, in meters.
---@return number # The number of radians the listener is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function audio.getPose() end

--- Returns the position of the virtual audio listener, in meters.
---@return number # The x position of the listener.
---@return number # The y position of the listener.
---@return number # The z position of the listener.
function audio.getPosition() end

--- Returns the sample rate used by the playback device.  This can be changed using `lovr.conf`.
---@see lovr.conf
---@return number # The sample rate of the playback device, in Hz.
function audio.getSampleRate() end

--- Returns the name of the active spatializer (`simple`, `oculus`, or `phonon`).
--- The `t.audio.spatializer` setting in `lovr.conf` can be used to express a preference for a particular spatializer.  If it's `nil`, all spatializers will be tried in the following order: `phonon`, `oculus`, `simple`.
---@see lovr.conf
---@return string # The name of the active spatializer.
function audio.getSpatializer() end

--- Returns the master volume.  All audio sent to the playback device has its volume multiplied by this factor.
---@param units VolumeUnit? # The units to return (linear or db). (default: 'linear')
---@return number # The master volume.
function audio.getVolume(units) end

--- Returns whether an audio device is started.
---@see lovr.audio.start
---@see lovr.audio.stop
---@param type AudioType? # The type of device to check. (default: 'playback')
---@return boolean # Whether the device is active.
function audio.isStarted(type) end

--- Creates a new Source from an ogg, wav, or mp3 file.
---@see Source.clone
---@param file string | Blob # A filename or Blob containing audio data to load.
---@param options table? # Optional options. (default: nil)
---@return Source # The new Source.
---@overload fun(sound: Sound, options?: table): Source
function audio.newSource(file, options) end

--- Sets the global air absorption coefficients for the medium.  This affects Sources that have the `absorption` effect enabled, causing audio volume to drop off with distance as it is absorbed by the medium it's traveling through (air, water, etc.).  The difference between absorption and the attenuation effect is that absorption is more subtle and is frequency-dependent, so higher-frequency bands can get absorbed more quickly than lower ones.  This can be used to apply "underwater" effects and stuff.
---@param low number # The absorption coefficient for the low frequency band.
---@param mid number # The absorption coefficient for the mid frequency band.
---@param high number # The absorption coefficient for the high frequency band.
function audio.setAbsorption(low, mid, high) end

--- Switches either the playback or capture device to a new one.
--- If a device for the given type is already active, it will be stopped and destroyed.  The new device will not be started automatically, use `lovr.audio.start` to start it.
--- A device id (previously retrieved using `lovr.audio.getDevices`) can be given to use a specific audio device, or `nil` can be used for the id to use the default audio device.
--- A sink can be also be provided when changing the device.  A sink is an audio stream (`Sound` object with a `stream` type) that will receive all audio samples played (for playback) or all audio samples captured (for capture).  When an audio device with a sink is started, be sure to periodically call `Sound:read` on the sink to read audio samples from it, otherwise it will overflow and discard old data.  The sink can have any format, data will be converted as needed. Using a sink for the playback device will reduce performance, but this isn't the case for capture devices.
--- Audio devices can be started in `shared` or `exclusive` mode.  Exclusive devices may have lower latency than shared devices, but there's a higher chance that requesting exclusive access to an audio device will fail (either because it isn't supported or allowed).  One strategy is to first try the device in exclusive mode, switching to shared if it doesn't work.
---@see lovr.audio.getDevice
---@see lovr.audio.getDevices
---@see lovr.audio.start
---@see lovr.audio.stop
---@param type AudioType? # The device to switch. (default: 'playback')
---@param id userdata? # The id of the device to use, or `nil` to use the default device. (default: nil)
---@param sink Sound? # An optional audio stream to use as a sink for the device. (default: nil)
---@param mode AudioShareMode? # The sharing mode for the device. (default: shared)
---@return boolean # Whether creating the audio device succeeded.
function audio.setDevice(type, id, sink, mode) end

--- Sets a mesh of triangles to use for modeling audio effects, using a table of vertices or a Model.  When the appropriate effects are enabled, audio from `Source` objects will correctly be occluded by walls and bounce around to create realistic reverb.
--- An optional `AudioMaterial` may be provided to specify the acoustic properties of the geometry.
---@see lovr.audio.getSpatializer
---@see Source.setEffectEnabled
---@param vertices table # A flat table of vertices.  Each vertex is 3 numbers representing its x, y, and z position. The units used for audio coordinates are up to you, but meters are recommended.
---@param indices table # A list of indices, indicating how the vertices are connected into triangles.  Indices are 1-indexed and are 32 bits (they can be bigger than 65535).
---@param material AudioMaterial? # The acoustic material to use. (default: 'generic')
---@return boolean # Whether audio geometry is supported by the current spatializer and the geometry was loaded successfully.
---@overload fun(model: Model, material?: AudioMaterial): boolean
function audio.setGeometry(vertices, indices, material) end

--- Sets the orientation of the virtual audio listener in angle/axis representation.
---@see lovr.audio.setPosition
---@see lovr.audio.setPose
---@see Source.setOrientation
---@param angle number # The number of radians the listener should be rotated around its rotation axis.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@overload fun(orientation: Quat)
function audio.setOrientation(angle, ax, ay, az) end

--- Sets the position and orientation of the virtual audio listener.
---@see lovr.audio.setPosition
---@see lovr.audio.setOrientation
---@see Source.setPose
---@param x number # The x position of the listener.
---@param y number # The y position of the listener.
---@param z number # The z position of the listener.
---@param angle number # The number of radians the listener is rotated around its axis of rotation.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@overload fun(position: Vec3, orientation: Quat)
function audio.setPose(x, y, z, angle, ax, ay, az) end

--- Sets the position of the virtual audio listener.  The position doesn't have any specific units, but usually they can be thought of as meters, to match the headset module.
---@see lovr.audio.setOrientation
---@see lovr.audio.setPose
---@see Source.setPosition
---@param x number # The x position of the listener.
---@param y number # The y position of the listener.
---@param z number # The z position of the listener.
---@overload fun(position: Vec3)
function audio.setPosition(x, y, z) end

--- Sets the master volume.  All audio sent to the playback device has its volume multiplied by this factor.
---@param volume number # The master volume.
---@param units VolumeUnit? # The units of the value. (default: 'linear')
function audio.setVolume(volume, units) end

--- Starts the active playback or capture device.  By default the playback device is initialized and started, but this can be controlled using the `t.audio.start` flag in `lovr.conf`.
---@see lovr.audio.getDevices
---@see lovr.audio.setDevice
---@see lovr.audio.stop
---@see lovr.audio.isStarted
---@see lovr.system.requestPermission
---@see lovr.permission
---@param type AudioType? # The type of device to start. (default: 'playback')
---@return boolean # Whether the device was successfully started.
function audio.start(type) end

--- Stops the active playback or capture device.  This may fail if:
--- - The device is not started
--- - No device was initialized with `lovr.audio.setDevice`
---@see lovr.audio.getDevices
---@see lovr.audio.setDevice
---@see lovr.audio.start
---@see lovr.audio.isStarted
---@param type AudioType? # The type of device to stop. (default: 'playback')
---@return boolean # Whether the device was successfully stopped.
function audio.stop(type) end

_G.lovr.audio = audio
