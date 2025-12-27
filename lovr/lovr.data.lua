---@meta lovr.data

--- The `lovr.data` module provides functions for accessing underlying data representations for several LÖVR objects.
---@class lovr.data: { [any]: any }
local data = {}

--- This indicates the different node properties that can be animated.
---@alias AnimationProperty
---| '"translation"' # Node translation.
---| '"rotation"' # Node rotation.
---| '"scale"' # Node scale.
---| '"weights"' # Node blend shape weights.

--- These are the data types that can be used by vertex data in meshes.
---@alias AttributeType
---| '"i8"' # Signed 8 bit integers (-128 to 127).
---| '"u8"' # Unsigned 8 bit integers (0 to 255).
---| '"i16"' # Signed 16 bit integers (-32768 to 32767).
---| '"u16"' # Unsigned 16 bit integers (0 to 65535).
---| '"i32"' # Signed 32 bit integers (-2147483648 to 2147483647).
---| '"u32"' # Unsigned 32 bit integers (0 to 429467295).
---| '"f32"' # Floating point numbers.

--- Sounds can have different numbers of channels, and those channels can map to various speaker layouts.
---@alias ChannelLayout
---| '"mono"' # 1 channel.
---| '"stereo"' # 2 channels.  The first channel is for the left speaker and the second is for the right.
---| '"ambisonic"' # 4 channels.  Ambisonic channels don't map directly to speakers but instead represent directions in 3D space, sort of like the images of a skybox.  Currently, ambisonic sounds can only be loaded, not played.

--- These are the different types of attributes that may be present in meshes loaded from models.
---@alias DefaultAttribute
---| '"position"' # Vertex positions.
---| '"normal"' # Vertex normal vectors.
---| '"uv"' # Vertex texture coordinates.
---| '"color"' # Vertex colors.
---| '"tangent"' # Vertex tangent vectors.
---| '"joints"' # Vertex joint indices.
---| '"weights"' # Vertex joint weights.

--- The DrawMode of a mesh determines how its vertices are connected together.
---@alias ModelDrawMode
---| '"points"' # Each vertex is draw as a single point.
---| '"lines"' # Every pair of vertices is drawn as a line.
---| '"linestrip"' # Draws a single line through all of the vertices.
---| '"lineloop"' # Draws a single line through all of the vertices, then connects back to the first vertex.
---| '"strip"' # Vertices are rendered as triangles.  After the first 3 vertices, each subsequent vertex connects to the previous two.
---| '"triangles"' # Every 3 vertices forms a triangle.
---| '"fan"' # Vertices are rendered as triangles.  After the first 3 vertices, each subsequent vertex is connected to the previous vertex and the first vertex.

--- Sounds can store audio samples as 16 bit integers or 32 bit floats.
---@alias SampleFormat
---| '"f32"' # 32 bit floating point samples (between -1.0 and 1.0).
---| '"i16"' # 16 bit integer samples (between -32768 and 32767).

--- Different ways to interpolate between animation keyframes.
---@alias SmoothMode
---| '"step"' # The animated property will snap to the nearest keyframe.
---| '"linear"' # The animated property will linearly interpolate between keyframes.
---| '"cubic"' # The animated property will follow a smooth curve between nearby keyframes.

--- Different data layouts for pixels in `Image` and `Texture` objects.
--- Formats starting with `d` are depth formats, used for depth/stencil render targets.
--- Formats starting with `bc` and `astc` are compressed formats.  Compressed formats have better performance since they stay compressed on the CPU and GPU, reducing the amount of memory bandwidth required to look up all the pixels needed for shading.
--- Formats without the `f` suffix are unsigned normalized formats, which store values in the range `[0,1]`.  The `f` suffix indicates a floating point format which can store values outside this range, and is used for HDR rendering or storing data in a texture.
---@alias TextureFormat
---| '"r8"' # One 8-bit channel.  1 byte per pixel.
---| '"rg8"' # Two 8-bit channels.  2 bytes per pixel.
---| '"rgba8"' # Four 8-bit channels.  4 bytes per pixel.
---| '"bgra8"' # Four 8-bit channels.  4 bytes per pixel.
---| '"r16"' # One 16-bit channel.  2 bytes per pixel.
---| '"rg16"' # Two 16-bit channels.  4 bytes per pixel.
---| '"rgba16"' # Four 16-bit channels.  8 bytes per pixel.
---| '"r16f"' # One 16-bit floating point channel.  2 bytes per pixel.
---| '"rg16f"' # Two 16-bit floating point channels.  4 bytes per pixel.
---| '"rgba16f"' # Four 16-bit floating point channels.  8 bytes per pixel.
---| '"r32f"' # One 32-bit floating point channel.  4 bytes per pixel.
---| '"rg32f"' # Two 32-bit floating point channels.  8 bytes per pixel.
---| '"rgba32f"' # Four 32-bit floating point channels.  16 bytes per pixel.
---| '"rgb565"' # Packs three channels into 16 bits.  2 bytes per pixel.
---| '"rgb5a1"' # Packs four channels into 16 bits, with "cutout" alpha.  2 bytes per pixel.
---| '"rgb10a2"' # Packs four channels into 32 bits.  4 bytes per pixel.
---| '"rg11b10f"' # Packs three unsigned floating point channels into 32 bits.  4 bytes per pixel.
---| '"d16"' # One 16-bit depth channel.  2 bytes per pixel.
---| '"d24"' # One 24-bit depth channel.  4 bytes per pixel.
---| '"d24s8"' # One 24-bit depth channel and one 8-bit stencil channel.  4 bytes per pixel.
---| '"d32f"' # One 32-bit floating point depth channel.  4 bytes per pixel.
---| '"d32fs8"' # One 32-bit floating point depth channel and one 8-bit stencil channel.  5 bytes per pixel.
---| '"bc1"' # 3 channels.  8 bytes per 4x4 block, or 0.5 bytes per pixel.  Good for opaque images.
---| '"bc2"' # Four channels.  16 bytes per 4x4 block or 1 byte per pixel.  Not good for anything, because it only has 16 distinct levels of alpha.
---| '"bc3"' # Four channels.  16 bytes per 4x4 block or 1 byte per pixel.  Good for color images with transparency.
---| '"bc4u"' # One unsigned normalized channel.  8 bytes per 4x4 block or 0.5 bytes per pixel.  Good for grayscale images, like heightmaps.
---| '"bc4s"' # One signed normalized channel.  8 bytes per 4x4 block or 0.5 bytes per pixel.  Similar to bc4u but has a range of -1 to 1.
---| '"bc5u"' # Two unsigned normalized channels.  16 bytes per 4x4 block, or 1 byte per pixel.  Good for normal maps.
---| '"bc5s"' # Two signed normalized channels.  16 bytes per 4x4 block or 1 byte per pixel.  Good for normal maps.
---| '"bc6uf"' # Three unsigned floating point channels.  16 bytes per 4x4 block or 1 byte per pixel.  Good for HDR images.
---| '"bc6sf"' # Three floating point channels.  16 bytes per 4x4 block or 1 byte per pixel.  Good for HDR images.
---| '"bc7"' # Four channels.  16 bytes per 4x4 block or 1 byte per pixel.  High quality.  Good for most color images, including transparency.
---| '"astc4x4"' # Four channels, 16 bytes per 4x4 block or 1 byte per pixel.
---| '"astc5x4"' # Four channels, 16 bytes per 5x4 block or 0.80 bytes per pixel.
---| '"astc5x5"' # Four channels, 16 bytes per 5x5 block or 0.64 bytes per pixel.
---| '"astc6x5"' # Four channels, 16 bytes per 6x5 block or 0.53 bytes per pixel.
---| '"astc6x6"' # Four channels, 16 bytes per 6x6 block or 0.44 bytes per pixel.
---| '"astc8x5"' # Four channels, 16 bytes per 8x5 block or 0.40 bytes per pixel.
---| '"astc8x6"' # Four channels, 16 bytes per 8x6 block or 0.33 bytes per pixel.
---| '"astc8x8"' # Four channels, 16 bytes per 8x8 block or 0.25 bytes per pixel.
---| '"astc10x5"' # Four channels, 16 bytes per 10x5 block or 0.32 bytes per pixel.
---| '"astc10x6"' # Four channels, 16 bytes per 10x6 block or 0.27 bytes per pixel.
---| '"astc10x8"' # Four channels, 16 bytes per 10x8 block or 0.20 bytes per pixel.
---| '"astc10x10"' # Four channels, 16 bytes per 10x10 block or 0.16 bytes per pixel.
---| '"astc12x10"' # Four channels, 16 bytes per 12x10 block or 0.13 bytes per pixel.
---| '"astc12x12"' # Four channels, 16 bytes per 12x12 block or 0.11 bytes per pixel.

--- Creates a new Blob.
---@see lovr.filesystem.newBlob
---@overload fun(contents: string, name: string): Blob
---@overload fun(source: Blob, name: string): Blob
---@param size number # The amount of data to allocate for the Blob, in bytes.  All of the bytes will be filled with zeroes.
---@param name string? # A name for the Blob (used in error messages) (default: '')
---@return Blob # The new Blob.
function data.newBlob(size, name) end

--- Creates a new Image.  Image data can be loaded and decoded from an image file.  Alternatively, a blank image can be created with a given width, height, and format.
---@overload fun(width: number, height: number, format: TextureFormat, data: Blob): Image
---@overload fun(source: Image): Image
---@param file string | Blob # A filename or Blob containing an image file to load.
---@return Image # The new Image.
function data.newImage(file) end

--- Loads a 3D model from a file.  The supported 3D file formats are OBJ and glTF.
---@param file string | Blob # A filename or Blob containing the model data to import.
---@return ModelData # The new ModelData.
function data.newModelData(file) end

--- Creates a new Rasterizer from a TTF or BMFont file.
---@overload fun(size: number): Rasterizer
---@param file string | Blob # A filename or Blob containing the font file to load.
---@param size number? # The resolution to render the font at, in pixels (TTF only).  Higher resolutions use more memory and processing power but may provide better quality results for some fonts/situations. (default: 32)
---@return Rasterizer # The new Rasterizer.
function data.newRasterizer(file, size) end

--- Creates a new Sound.  A sound can be loaded from an audio file, or it can be created empty with capacity for a certain number of audio frames.
--- When loading audio from a file, use the `decode` option to control whether compressed audio should remain compressed or immediately get decoded to raw samples.
--- When creating an empty sound, the `contents` parameter can be set to `'stream'` to create an audio stream.  On streams, `Sound:setFrames` will always write to the end of the stream, and `Sound:getFrames` will always read the oldest samples from the beginning.  The number of frames in the sound is the total capacity of the stream's buffer.
---@overload fun(file: string | Blob, decode: boolean): Sound
---@param frames number # The number of frames the Sound can hold.
---@param format SampleFormat? # The sample data type. (default: 'f32')
---@param channels ChannelLayout? # The channel layout. (default: 'stereo')
---@param sampleRate number? # The sample rate, in Hz. (default: 48000)
---@param contents Blob | string | nil? # A Blob containing raw audio samples to use as the initial contents, 'stream' to create an audio stream, or `nil` to leave the data initialized to zero. (default: nil)
---@return Sound # Sounds good.
function data.newSound(frames, format, channels, sampleRate, contents) end

---@class Blob
---@see lovr.data.newBlob # (Constructor)
---@see lovr.filesystem.newBlob # (Constructor)
local Blob = {}

--- Returns the size of the Blob's contents, in bytes.
---@return number # The size of the Blob, in bytes.
function Blob:getSize() end

--- Returns the filename the Blob was loaded from, or the custom name given to it when it was created.  This label is also used in error messages.
---@return string # The name of the Blob.
function Blob:getName() end

--- Returns a raw pointer to the Blob's data.  This can be used to interface with other C libraries using the LuaJIT FFI.  Use this only if you know what you're doing!
---@return userdata # A pointer to the data.
function Blob:getPointer() end

--- Returns a binary string containing the Blob's data.
---@param offset number? # A byte offset into the Blob where the string will start. (default: 0)
---@param size number? # The number of bytes the string will contain.  If nil, the rest of the data in the Blob will be used, based on the `offset` parameter. (default: nil)
---@return string # The Blob's data.
function Blob:getString(offset, size) end

--- Returns signed 8-bit integers from the data in the Blob.
---@see Blob:setI8
---@see Blob:getU8
---@see Blob:getI16
---@see Blob:getU16
---@see Blob:getI32
---@see Blob:getU32
---@see Blob:getF32
---@see Blob:getF64
---@param offset number? # A non-negative byte offset to read from. (default: 0)
---@param count number? # The number of integers to read. (default: 1)
---@return number # `count` signed 8-bit integers, from -128 to 127.
function Blob:getI8(offset, count) end

--- Returns unsigned 8-bit integers from the data in the Blob.
---@see Blob:setU8
---@see Blob:getI8
---@see Blob:getI16
---@see Blob:getU16
---@see Blob:getI32
---@see Blob:getU32
---@see Blob:getF32
---@see Blob:getF64
---@param offset number? # A non-negative byte offset to read from. (default: 0)
---@param count number? # The number of integers to read. (default: 1)
---@return number # `count` unsigned 8-bit integers, from 0 to 255.
function Blob:getU8(offset, count) end

--- Returns signed 16-bit integers from the data in the Blob.
---@see Blob:setI16
---@see Blob:getI8
---@see Blob:getU8
---@see Blob:getU16
---@see Blob:getI32
---@see Blob:getU32
---@see Blob:getF32
---@see Blob:getF64
---@param offset number? # A non-negative byte offset to read from. (default: 0)
---@param count number? # The number of integers to read. (default: 1)
---@return number # `count` signed 16-bit integers, from -32768 to 32767.
function Blob:getI16(offset, count) end

--- Returns unsigned 16-bit integers from the data in the Blob.
---@see Blob:setU16
---@see Blob:getI8
---@see Blob:getU8
---@see Blob:getI16
---@see Blob:getI32
---@see Blob:getU32
---@see Blob:getF32
---@see Blob:getF64
---@param offset number? # A non-negative byte offset to read from. (default: 0)
---@param count number? # The number of integers to read. (default: 1)
---@return number # `count` unsigned 16-bit integers, from 0 to 65535.
function Blob:getU16(offset, count) end

--- Returns signed 32-bit integers from the data in the Blob.
---@see Blob:setI32
---@see Blob:getI8
---@see Blob:getU8
---@see Blob:getI16
---@see Blob:getU16
---@see Blob:getU32
---@see Blob:getF32
---@see Blob:getF64
---@param offset number? # A non-negative byte offset to read from. (default: 0)
---@param count number? # The number of integers to read. (default: 1)
---@return number # `count` signed 32-bit integers, from -2147483648 to 2147483647.
function Blob:getI32(offset, count) end

--- Returns unsigned 32-bit integers from the data in the Blob.
---@see Blob:setU32
---@see Blob:getI8
---@see Blob:getU8
---@see Blob:getI16
---@see Blob:getU16
---@see Blob:getI32
---@see Blob:getF32
---@see Blob:getF64
---@param offset number? # A non-negative byte offset to read from. (default: 0)
---@param count number? # The number of integers to read. (default: 1)
---@return number # `count` unsigned 32-bit integers, from 0 to 4294967296.
function Blob:getU32(offset, count) end

--- Returns 32-bit floating point numbers from the data in the Blob.
---@see Blob:setF32
---@see Blob:getI8
---@see Blob:getU8
---@see Blob:getI16
---@see Blob:getU16
---@see Blob:getI32
---@see Blob:getU32
---@see Blob:getF64
---@param offset number? # A non-negative byte offset to read from. (default: 0)
---@param count number? # The number of floats to read. (default: 1)
---@return number # `count` 32-bit floats.
function Blob:getF32(offset, count) end

--- Returns 64-bit floating point numbers from the data in the Blob.
---@see Blob:setF64
---@see Blob:getI8
---@see Blob:getU8
---@see Blob:getI16
---@see Blob:getU16
---@see Blob:getI32
---@see Blob:getU32
---@see Blob:getF32
---@param offset number? # A non-negative byte offset to read from. (default: 0)
---@param count number? # The number of doubles to read. (default: 1)
---@return number # `count` 64-bit doubles.
function Blob:getF64(offset, count) end

--- Writes 8-bit signed integers to the Blob.
---@see Blob:getI8
---@see Blob:setU8
---@see Blob:setI16
---@see Blob:setU16
---@see Blob:setI32
---@see Blob:setU32
---@see Blob:setF32
---@see Blob:setF64
---@overload fun(offset: number, table: {number})
---@param offset number # A non-negative byte offset to start writing at.
---@param ... number # Numbers to write to the blob as 8-bit signed integers (each taking up 1 byte, ranging from-127 to 128).
function Blob:setI8(offset, ...) end

--- Writes 8-bit unsigned integers to the Blob.
---@see Blob:getU8
---@see Blob:setI8
---@see Blob:setI16
---@see Blob:setU16
---@see Blob:setI32
---@see Blob:setU32
---@see Blob:setF32
---@see Blob:setF64
---@overload fun(offset: number, table: {number})
---@param offset number # A non-negative byte offset to start writing at.
---@param ... number # Numbers to write to the blob as 8-bit unsigned integers (each taking up 1 byte, ranging from 0 to 255).
function Blob:setU8(offset, ...) end

--- Writes 16-bit signed integers to the Blob.
---@see Blob:getI16
---@see Blob:setI8
---@see Blob:setU8
---@see Blob:setU16
---@see Blob:setI32
---@see Blob:setU32
---@see Blob:setF32
---@see Blob:setF64
---@overload fun(offset: number, table: {number})
---@param offset number # A non-negative byte offset to start writing at.
---@param ... number # Numbers to write to the blob as 16-bit signed integers (each taking up 2 bytes, ranging from-32768 to 32767).
function Blob:setI16(offset, ...) end

--- Writes 16-bit unsigned integers to the Blob.
---@see Blob:getU16
---@see Blob:setI8
---@see Blob:setU8
---@see Blob:setI16
---@see Blob:setI32
---@see Blob:setU32
---@see Blob:setF32
---@see Blob:setF64
---@overload fun(offset: number, table: {number})
---@param offset number # A non-negative byte offset to start writing at.
---@param ... number # Numbers to write to the blob as 16-bit unsigned integers (each taking up 2 bytes, ranging from 0 to 65535).
function Blob:setU16(offset, ...) end

--- Writes 32-bit signed integers to the Blob.
---@see Blob:getI32
---@see Blob:setI8
---@see Blob:setU8
---@see Blob:setI16
---@see Blob:setU16
---@see Blob:setU32
---@see Blob:setF32
---@see Blob:setF64
---@overload fun(offset: number, table: {number})
---@param offset number # A non-negative byte offset to start writing at.
---@param ... number # Numbers to write to the blob as 32-bit signed integers (each taking up 4 bytes, ranging from-2147483648 to 2147483647).
function Blob:setI32(offset, ...) end

--- Writes 32-bit unsigned integers to the Blob.
---@see Blob:getU32
---@see Blob:setI8
---@see Blob:setU8
---@see Blob:setI16
---@see Blob:setU16
---@see Blob:setI32
---@see Blob:setF32
---@see Blob:setF64
---@overload fun(offset: number, table: {number})
---@param offset number # A non-negative byte offset to start writing at.
---@param ... number # Numbers to write to the blob as 32-bit unsigned integers (each taking up 4 bytes, ranging from 0 to 4294967296).
function Blob:setU32(offset, ...) end

--- Writes 32-bit floating point numbers to the Blob.
---@see Blob:getF32
---@see Blob:setI8
---@see Blob:setU8
---@see Blob:setI16
---@see Blob:setU16
---@see Blob:setI32
---@see Blob:setU32
---@see Blob:setF64
---@overload fun(offset: number, table: {number})
---@param offset number # A non-negative byte offset to start writing at.
---@param ... number # Numbers to write to the blob as 32-bit floats (each taking up 4 bytes).
function Blob:setF32(offset, ...) end

--- Writes 64-bit floating point numbers to the Blob.
---@see Blob:getF64
---@see Blob:setI8
---@see Blob:setU8
---@see Blob:setI16
---@see Blob:setU16
---@see Blob:setI32
---@see Blob:setU32
---@see Blob:setF32
---@overload fun(offset: number, table: {number})
---@param offset number # A non-negative byte offset to start writing at.
---@param ... number # Numbers to write to the blob as 64-bit floating point numbers (each taking up 8 bytes).
function Blob:setF64(offset, ...) end

---@class Image
---@see lovr.data.newImage # (Constructor)
local Image = {}

--- Encodes the Image to an **uncompressed** png.  This intended mainly for debugging.
---@see lovr.filesystem.write
---@return Blob # A new Blob containing the PNG image data.
function Image:encode() end

--- Returns a Blob containing the raw bytes of the Image.
---@see Blob:getPointer
---@see Sound:getBlob
---@return Blob # The Blob instance containing the bytes for the `Image`.
function Image:getBlob() end

--- Returns the dimensions of the Image, in pixels.
---@see Image:getWidth
---@see Image:getHeight
---@see Texture:getDimensions
---@return number # The width of the Image, in pixels.
---@return number # The height of the Image, in pixels.
function Image:getDimensions() end

--- Returns the format of the Image.
---@see TextureFormat
---@see Texture:getFormat
---@return TextureFormat # The format of the pixels in the Image.
function Image:getFormat() end

--- Returns the height of the Image, in pixels.
---@see Image:getWidth
---@see Image:getDimensions
---@see Texture:getHeight
---@return number # The height of the Image, in pixels.
function Image:getHeight() end

--- Returns the value of a pixel of the Image.
---@see Image:setPixel
---@see Image:mapPixel
---@see TextureFormat
---@see Texture:getPixels
---@see Texture:setPixels
---@see Texture:newReadback
---@param x number # The x coordinate of the pixel to get (0-indexed).
---@param y number # The y coordinate of the pixel to get (0-indexed).
---@return number # The red component of the pixel, from 0.0 to 1.0.
---@return number # The green component of the pixel, from 0.0 to 1.0.
---@return number # The blue component of the pixel, from 0.0 to 1.0.
---@return number # The alpha component of the pixel, from 0.0 to 1.0.
function Image:getPixel(x, y) end

--- Returns a raw pointer to the Image's pixel data.  This can be used to interface with other C libraries or the LuaJIT FFI.
---@param level number? # The mipmap level to get the pointer of (for DDS and KTX images). (default: 1)
---@param layer number? # The array layer to get the pointer of (for DDS and KTX images). (default: 1)
---@return userdata # A pointer to the raw pixel data.
function Image:getPointer(level, layer) end

--- Returns the width of the Image, in pixels.
---@see Image:getHeight
---@see Image:getDimensions
---@see Texture:getWidth
---@return number # The width of the Image, in pixels.
function Image:getWidth() end

--- Transforms pixels in the Image using a function.
--- The callback function passed to this function will be called once for each pixel.  For each pixel, the function will be called with its x and y coordinate and the red, green, blue, and alpha components of its color.  Whatever the function returns will be used as the new color for the pixel.
--- The callback function will potentially be called thousands of times, so it's best to keep the amount of code in there small and fast.
---@see Image:setPixel
---@see Image:getPixel
---@see TextureFormat
---@see Texture:setPixels
---@param callback function # The function that will be called for each pixel.
---@param x number? # The x coordinate of the upper-left corner of the area of the Image to affect. (default: 0)
---@param y number? # The y coordinate of the upper-left corner of the area of the Image to affect. (default: 0)
---@param w number? # The width of the area to affect. (default: image:getWidth())
---@param h number? # The height of the area to affect. (default: image:getHeight())
function Image:mapPixel(callback, x, y, w, h) end

--- Copies a rectangle of pixels from one Image to this one.
---@see Image:getPixel
---@see Image:setPixel
---@see Texture:setPixels
---@param source Image # The Image to copy pixels from.
---@param x number? # The x coordinate to paste to (0-indexed). (default: 0)
---@param y number? # The y coordinate to paste to (0-indexed). (default: 0)
---@param fromX number? # The x coordinate in the source to paste from (0-indexed). (default: 0)
---@param fromY number? # The y coordinate in the source to paste from (0-indexed). (default: 0)
---@param width number? # The width of the region to copy. (default: source:getWidth())
---@param height number? # The height of the region to copy. (default: source:getHeight())
function Image:paste(source, x, y, fromX, fromY, width, height) end

--- Sets the value of a single pixel of the Image.
--- If you need to change a bunch of pixels, consider using `Image:mapPixel`.
---@see Image:mapPixel
---@see Image:getPixel
---@see TextureFormat
---@see Texture:setPixels
---@param x number # The x coordinate of the pixel to set (0-indexed).
---@param y number # The y coordinate of the pixel to set (0-indexed).
---@param r number # The red component of the pixel, from 0.0 to 1.0.
---@param g number # The green component of the pixel, from 0.0 to 1.0.
---@param b number # The blue component of the pixel, from 0.0 to 1.0.
---@param a number? # The alpha component of the pixel, from 0.0 to 1.0. (default: 1.0)
function Image:setPixel(x, y, r, g, b, a) end

---@class ModelData
---@see lovr.data.newModelData # (Constructor)
local ModelData = {}

--- Returns the number of channels in an animation.
--- A channel is a set of keyframes targeting a single property of a node.
---@see ModelData:getAnimationNode
---@see ModelData:getAnimationProperty
---@param animation number | string # The name or index of an animation.
---@return number # The number of channels in the animation.
function ModelData:getAnimationChannelCount(animation) end

--- Returns the number of animations in the model.
---@see Model:getAnimationCount
---@return number # The number of animations in the model.
function ModelData:getAnimationCount() end

--- Returns the duration of an animation.
---@see Model:getAnimationDuration
---@param animation string | number # The name or index of an animation.
---@return number # The duration of the animation, in seconds.
function ModelData:getAnimationDuration(animation) end

--- Returns a single keyframe in a channel of an animation.
---@see ModelData:getAnimationSmoothMode
---@see ModelData:getAnimationKeyframeCount
---@param animation number # The name or index of an animation.
---@param channel number # The index of a channel in the animation.
---@param keyframe number # The index of a keyframe in the channel.
---@return number # The timestamp of the keyframe.
---@return number # The data for the keyframe (3 or more numbers, depending on the property).
function ModelData:getAnimationKeyframe(animation, channel, keyframe) end

--- Returns the number of keyframes in a channel of an animation.
---@see ModelData:getAnimationSmoothMode
---@see ModelData:getAnimationKeyframe
---@param animation string | number # The name or index of an animation.
---@param channel number # The index of a channel in the animation.
---@return number # The number of keyframes in the channel.
function ModelData:getAnimationKeyframeCount(animation, channel) end

--- Returns the name of an animation.
---@see Model:getAnimationName
---@param index number # The index of an animation.
---@return string | nil # The name of the animation, or `nil` if the animation doesn't have a name.
function ModelData:getAnimationName(index) end

--- Returns the index of the node targeted by an animation's channel.
---@see ModelData:getAnimationProperty
---@see ModelData:getAnimationSmoothMode
---@param animation number # The index or name of an animation.
---@param channel number # The index of a channel in the animation.
---@return number # The index of the node targeted by the channel.
function ModelData:getAnimationNode(animation, channel) end

--- Returns the property targeted by an animation's channel.
---@see ModelData:getAnimationNode
---@see ModelData:getAnimationSmoothMode
---@param animation string | number # The name or index of an animation.
---@param channel number # The index of a channel in the animation.
---@return AnimationProperty # The property (translation, rotation, scale, or weights) affected by the keyframes.
function ModelData:getAnimationProperty(animation, channel) end

--- Returns the smooth mode of a channel in an animation.
---@see ModelData:getAnimationNode
---@see ModelData:getAnimationProperty
---@param animation string | number # The name or index of an animation.
---@param channel number # The index of a channel in the animation.
---@return SmoothMode # The smooth mode of the keyframes.
function ModelData:getAnimationSmoothMode(animation, channel) end

--- Returns the number of blend shapes in the model.
---@see ModelData:getBlendShapeName
---@see Model:getBlendShapeCount
---@return number # The number of blend shapes in the model.
function ModelData:getBlendShapeCount() end

--- Returns the name of a blend shape in the model.
---@see ModelData:getBlendShapeCount
---@see Model:getBlendShapeName
---@param index number # The index of a blend shape.
---@return string # The name of the blend shape.
function ModelData:getBlendShapeName(index) end

--- Returns one of the Blobs in the model, by index.
---@see ModelData:getBlobCount
---@see ModelData:getImage
---@param index number # The index of the Blob to get.
---@return Blob # The Blob object.
function ModelData:getBlob(index) end

--- Returns the number of Blobs in the model.
---@see ModelData:getBlob
---@see ModelData:getImageCount
---@return number # The number of Blobs in the model.
function ModelData:getBlobCount() end

--- Returns the 6 values of the model's axis-aligned bounding box.
---@see ModelData:getWidth
---@see ModelData:getHeight
---@see ModelData:getDepth
---@see ModelData:getDimensions
---@see ModelData:getCenter
---@see ModelData:getBoundingSphere
---@see Model:getBoundingBox
---@return number # The minimum x coordinate of the vertices in the model.
---@return number # The maximum x coordinate of the vertices in the model.
---@return number # The minimum y coordinate of the vertices in the model.
---@return number # The maximum y coordinate of the vertices in the model.
---@return number # The minimum z coordinate of the vertices in the model.
---@return number # The maximum z coordinate of the vertices in the model.
function ModelData:getBoundingBox() end

--- Returns a sphere approximately enclosing the vertices in the model.
---@see ModelData:getWidth
---@see ModelData:getHeight
---@see ModelData:getDepth
---@see ModelData:getDimensions
---@see ModelData:getCenter
---@see ModelData:getBoundingBox
---@see Model:getBoundingSphere
---@return number # The x coordinate of the position of the sphere.
---@return number # The y coordinate of the position of the sphere.
---@return number # The z coordinate of the position of the sphere.
---@return number # The radius of the bounding sphere.
function ModelData:getBoundingSphere() end

--- Returns the center of the model's axis-aligned bounding box, relative to the model's origin.
---@see ModelData:getWidth
---@see ModelData:getHeight
---@see ModelData:getDepth
---@see ModelData:getDimensions
---@see ModelData:getBoundingBox
---@see Model:getCenter
---@return number # The x offset of the center of the bounding box.
---@return number # The y offset of the center of the bounding box.
---@return number # The z offset of the center of the bounding box.
function ModelData:getCenter() end

--- Returns the depth of the model, computed from its axis-aligned bounding box.
---@see ModelData:getWidth
---@see ModelData:getHeight
---@see ModelData:getDimensions
---@see ModelData:getCenter
---@see ModelData:getBoundingBox
---@see Model:getDepth
---@return number # The depth of the model.
function ModelData:getDepth() end

--- Returns the width, height, and depth of the model, computed from its axis-aligned bounding box.
---@see ModelData:getWidth
---@see ModelData:getHeight
---@see ModelData:getDepth
---@see ModelData:getCenter
---@see ModelData:getBoundingBox
---@see Model:getDimensions
---@return number # The width of the model.
---@return number # The height of the model.
---@return number # The depth of the model.
function ModelData:getDimensions() end

--- Returns the height of the model, computed from its axis-aligned bounding box.
---@see ModelData:getWidth
---@see ModelData:getDepth
---@see ModelData:getDimensions
---@see ModelData:getCenter
---@see ModelData:getBoundingBox
---@see Model:getHeight
---@return number # The height of the model.
function ModelData:getHeight() end

--- Returns one of the Images in the model, by index.
---@see ModelData:getImageCount
---@see ModelData:getBlob
---@param index number # The index of the Image to get.
---@return Image # The Image object.
function ModelData:getImage(index) end

--- Returns the number of Images in the model.
---@see ModelData:getImage
---@see ModelData:getBlobCount
---@return number # The number of Images in the model.
function ModelData:getImageCount() end

--- Returns a table with all of the properties of a material.
---@see ModelData:getMaterialCount
---@see ModelData:getMeshMaterial
---@see lovr.graphics.newMaterial
---@see Model:getMaterial
---@param material number # The name or index of a material.
---@return table # The material properties.
function ModelData:getMaterial(material) end

--- Returns the number of materials in the model.
---@see ModelData:getMaterialName
---@see ModelData:getMeshMaterial
---@see ModelData:getMaterial
---@see Model:getMaterialCount
---@return number # The number of materials in the model.
function ModelData:getMaterialCount() end

--- Returns the name of a material in the model.
---@see ModelData:getMaterialCount
---@see ModelData:getMeshMaterial
---@see ModelData:getMaterial
---@see Model:getMaterialName
---@param index number # The index of a material.
---@return string # The name of the material, or nil if the material does not have a name.
function ModelData:getMaterialName(index) end

--- Returns the number of meshes in the model.
---@see ModelData:getNodeMeshes
---@return number # The number of meshes in the model.
function ModelData:getMeshCount() end

--- Returns the draw mode of a mesh.  This controls how its vertices are connected together (points, lines, or triangles).
---@param mesh number # The index of a mesh.
---@return ModelDrawMode # The draw mode of the mesh.
function ModelData:getMeshDrawMode(mesh) end

--- Returns one of the vertex indices in a mesh.  If a mesh has vertex indices, they define the order and connectivity of the vertices in the mesh, allowing a vertex to be reused multiple times without duplicating its data.
---@see ModelData:getMeshIndexFormat
---@see ModelData:getMeshIndexCount
---@see ModelData:getMeshVertex
---@see ModelData:getTriangles
---@param mesh number # The index of a mesh to get the vertex from.
---@param index number # The index of a vertex index in the mesh to retrieve.
---@return number # The vertex index.  Like all indices in Lua, this is 1-indexed.
function ModelData:getMeshIndex(mesh, index) end

--- Returns the number of vertex indices in a mesh.  Vertex indices allow for vertices to be reused when defining triangles.
---@param mesh number # The index of a mesh.
---@return number # The number of vertex indices in the mesh.
function ModelData:getMeshIndexCount(mesh) end

--- Returns the data format of vertex indices in a mesh.  If a mesh doesn't use vertex indices, this function returns nil.
---@see ModelData:getMeshVertexFormat
---@param mesh number # The index of a mesh.
---@return AttributeType # The data type of each vertex index (always u16 or u32).
---@return number # The index of a Blob in the mesh where the binary data is stored.
---@return number # A byte offset into the Blob's data where the index data starts.
---@return number # The number of bytes between subsequent vertex indices.  Indices are always tightly packed, so this will always be 2 or 4 depending on the data type.
function ModelData:getMeshIndexFormat(mesh) end

--- Returns the index of the material applied to a mesh.
---@param mesh number # The index of a mesh.
---@return number # The index of the material applied to the mesh, or nil if the mesh does not have a material.
function ModelData:getMeshMaterial(mesh) end

--- Returns the data for a single vertex in a mesh.  The data returned depends on the vertex format of a mesh, which is given by `ModelData:getMeshVertexFormat`.
---@see ModelData:getMeshVertexFormat
---@see ModelData:getMeshVertexCount
---@see ModelData:getMeshIndex
---@see ModelData:getTriangles
---@param mesh number # The index of a mesh to get the vertex from.
---@param vertex number # The index of a vertex in the mesh to retrieve.
---@return number # The data for all of the attributes of the vertex.
function ModelData:getMeshVertex(mesh, vertex) end

--- Returns the number of vertices in a mesh.
---@see ModelData:getMeshIndexCount
---@param mesh number # The index of a mesh.
---@return number # The number of vertices in the mesh.
function ModelData:getMeshVertexCount(mesh) end

--- Returns the vertex format of a mesh.  The vertex format defines the properties associated with each vertex (position, color, etc.), including their types and binary data layout.
---@see ModelData:getMeshIndexFormat
---@param mesh number # The index of a mesh.
---@return table # The vertex format of the mesh.
function ModelData:getMeshVertexFormat(mesh) end

--- Returns extra information stored in the model file.  Currently this is only implemented for glTF models and returns the JSON string from the glTF or glb file.  The metadata can be used to get application-specific data or add support for glTF extensions not supported by LÖVR.
---@see Model:getMetadata
---@return string # The metadata from the model file.
function ModelData:getMetadata() end

--- Given a parent node, this function returns a table with the indices of its children.
---@see ModelData:getNodeParent
---@see ModelData:getRootNode
---@see Model:getNodeChildren
---@param node string | number # The name or index of the parent node.
---@return {number} # A table containing the node index of each child of the parent node.
function ModelData:getNodeChildren(node) end

--- Returns the number of nodes in the model.
---@see Model:getNodeCount
---@return number # The number of nodes in the model.
function ModelData:getNodeCount() end

--- Returns a table of mesh indices attached to a node.  Meshes define the geometry and materials of a model, as opposed to the nodes which define the transforms and hierarchy.  A node can have multiple meshes, and meshes can be reused in multiple nodes.
---@see ModelData:getMeshCount
---@param node string | number # The name or index of a node.
---@return table # A table with the node's mesh indices.
function ModelData:getNodeMeshes(node) end

--- Returns the name of a node.
---@see Model:getNodeName
---@param index number # The index of the node.
---@return string # The name of the node.
function ModelData:getNodeName(index) end

--- Returns local orientation of a node, relative to its parent.
---@see ModelData:getNodePosition
---@see ModelData:getNodeScale
---@see ModelData:getNodePose
---@see ModelData:getNodeTransform
---@param node string | number # The name or index of a node.
---@return number # The number of radians the node is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function ModelData:getNodeOrientation(node) end

--- Given a child node, this function returns the index of its parent.
---@see ModelData:getNodeChildren
---@see ModelData:getRootNode
---@see Model:getNodeParent
---@param node string | number # The name or index of the child node.
---@return number # The index of the parent node.
function ModelData:getNodeParent(node) end

--- Returns local pose (position and orientation) of a node, relative to its parent.
---@see ModelData:getNodePosition
---@see ModelData:getNodeOrientation
---@see ModelData:getNodeScale
---@see ModelData:getNodeTransform
---@param node string | number # The name or index of a node.
---@return number # The x coordinate.
---@return number # The y coordinate.
---@return number # The z coordinate.
---@return number # The number of radians the node is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function ModelData:getNodePose(node) end

--- Returns local position of a node, relative to its parent.
---@see ModelData:getNodeOrientation
---@see ModelData:getNodeScale
---@see ModelData:getNodePose
---@see ModelData:getNodeTransform
---@param node string | number # The name or index of a node.
---@return number # The x coordinate.
---@return number # The y coordinate.
---@return number # The z coordinate.
function ModelData:getNodePosition(node) end

--- Returns local scale of a node, relative to its parent.
---@see ModelData:getNodePosition
---@see ModelData:getNodeOrientation
---@see ModelData:getNodePose
---@see ModelData:getNodeTransform
---@param node string | number # The name or index of a node.
---@return number # The x scale.
---@return number # The y scale.
---@return number # The z scale.
function ModelData:getNodeScale(node) end

--- Returns the index of the skin used by a node.  Skins are collections of joints used for skeletal animation.  A model can have multiple skins, and each node can use at most one skin to drive the animation of its meshes.
---@see ModelData:getSkinCount
---@param node string | number # The name or index of a node.
---@return number # The index of the node's skin, or nil if the node isn't skeletally animated.
function ModelData:getNodeSkin(node) end

--- Returns local transform (position, orientation, and scale) of a node, relative to its parent.
---@see ModelData:getNodePosition
---@see ModelData:getNodeOrientation
---@see ModelData:getNodeScale
---@see ModelData:getNodePose
---@param node string | number # The name or index of a node.
---@return number # The x coordinate.
---@return number # The y coordinate.
---@return number # The z coordinate.
---@return number # The x scale.
---@return number # The y scale.
---@return number # The z scale.
---@return number # The number of radians the node is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function ModelData:getNodeTransform(node) end

--- Returns the index of the model's root node.
---@see ModelData:getNodeCount
---@see ModelData:getNodeParent
---@see Model:getRootNode
---@return number # The index of the root node.
function ModelData:getRootNode() end

--- Returns the number of skins in the model.  A skin is a collection of joints targeted by an animation.
---@see Model:hasJoints
---@return number # The number of skins in the model.
function ModelData:getSkinCount() end

--- Returns the inverse bind matrix for a joint in the skin.
---@param skin number # The index of a skin.
---@param joint number # The index of a joint in the skin.
---@return number # The 16 components of the 4x4 inverse bind matrix, in column-major order.
function ModelData:getSkinInverseBindMatrix(skin, joint) end

--- Returns a table with the node indices of the joints in a skin.
---@param skin number # The index of a skin.
---@return table # The joints in the skin.
function ModelData:getSkinJoints(skin) end

--- Returns the total number of triangles in the model.  This count includes meshes that are attached to multiple nodes, and the count corresponds to the triangles returned by `ModelData:getTriangles`.
---@see ModelData:getTriangles
---@see ModelData:getVertexCount
---@see Model:getTriangleCount
---@return number # The total number of triangles in the model.
function ModelData:getTriangleCount() end

--- Returns the data for all triangles in the model.  There are a few differences between this and the mesh-specific functions like `ModelData:getMeshVertex` and `ModelData:getMeshIndex`:
--- - Only vertex positions are returned, not other vertex attributes.
--- - Positions are relative to the origin of the whole model, instead of local to a node.
--- - If a mesh is attached to more than one node, its vertices will be in the table multiple times.
--- - Vertex indices will be relative to the whole triangle list instead of a mesh.
---@see ModelData:getTriangleCount
---@see ModelData:getVertexCount
---@see Model:getTriangles
---@return table # The triangle vertex positions, returned as a flat (non-nested) table of numbers.  The position of each vertex is given as an x, y, and z coordinate.
---@return table # A list of numbers representing how to connect the vertices into triangles.  Each number is a 1-based index into the `vertices` table, and every 3 indices form a triangle.
function ModelData:getTriangles() end

--- Returns the total vertex count of a model.  This count includes meshes that are attached to multiple nodes, and the count corresponds to the vertices returned by `ModelData:getTriangles`.
---@see ModelData:getTriangles
---@see ModelData:getTriangleCount
---@see Model:getVertexCount
---@return number # The total number of vertices in the model.
function ModelData:getVertexCount() end

--- Returns the width of the model, computed from its axis-aligned bounding box.
---@see ModelData:getHeight
---@see ModelData:getDepth
---@see ModelData:getDimensions
---@see ModelData:getCenter
---@see ModelData:getBoundingBox
---@see Model:getWidth
---@return number # The width of the model.
function ModelData:getWidth() end

---@class Rasterizer
---@see lovr.data.newRasterizer # (Constructor)
local Rasterizer = {}

--- Returns the advance metric for a glyph, in pixels.  The advance is the horizontal distance to advance the cursor after rendering the glyph.
---@param glyph string | number # A character or codepoint.
---@return number # The advance of the glyph, in pixels.
function Rasterizer:getAdvance(glyph) end

--- Returns the ascent metric of the font, in pixels.  The ascent represents how far any glyph of the font ascends above the baseline.
---@see Rasterizer:getDescent
---@see Font:getAscent
---@return number # The ascent of the font, in pixels.
function Rasterizer:getAscent() end

--- Returns the bearing metric for a glyph, in pixels.  The bearing is the horizontal distance from the cursor to the edge of the glyph.
---@param glyph string | number # A character or codepoint.
---@return number # The bearing of the glyph, in pixels.
function Rasterizer:getBearing(glyph) end

--- Returns the bounding box of a glyph, or the bounding box surrounding all glyphs.  Note that font coordinates use a cartesian "y up" coordinate system.
---@see Rasterizer:getWidth
---@see Rasterizer:getHeight
---@see Rasterizer:getDimensions
---@overload fun(): number, number, number, number
---@param glyph string | number # A character or codepoint.
---@return number # The left edge of the bounding box, in pixels.
---@return number # The bottom edge of the bounding box, in pixels.
---@return number # The right edge of the bounding box, in pixels.
---@return number # The top edge of the bounding box, in pixels.
function Rasterizer:getBoundingBox(glyph) end

--- Returns the bezier curve control points defining the shape of a glyph.
---@see Curve
---@see Rasterizer:newImage
---@param glyph string | number # A character or codepoint.
---@param three boolean # Whether the control points should be 3D or 2D.
---@return table # A table of curves.  Each curve is a table of numbers representing the control points (2 for a line, 3 for a quadratic curve, etc.).
function Rasterizer:getCurves(glyph, three) end

--- Returns the descent metric of the font, in pixels.  The descent represents how far any glyph of the font descends below the baseline.
---@see Rasterizer:getAscent
---@see Font:getDescent
---@return number # The descent of the font, in pixels.
function Rasterizer:getDescent() end

--- Returns the dimensions of a glyph, or the largest dimensions of any glyph in the font.
---@see Rasterizer:getWidth
---@see Rasterizer:getHeight
---@see Rasterizer:getBoundingBox
---@overload fun(): number, number
---@param glyph string # A character or codepoint.
---@return number # The width, in pixels.
---@return number # The height, in pixels.
function Rasterizer:getDimensions(glyph) end

--- Returns the size of the font, in pixels.  This is the size the rasterizer was created with, and determines the size of images it rasterizes.
---@see Rasterizer:getHeight
---@return number # The font size, in pixels.
function Rasterizer:getFontSize() end

--- Returns the number of glyphs stored in the font file.
---@see Rasterizer:hasGlyphs
---@return number # The number of glyphs stored in the font file.
function Rasterizer:getGlyphCount() end

--- Returns the height of a glyph, or the maximum height of any glyph in the font.
---@see Rasterizer:getWidth
---@see Rasterizer:getDimensions
---@see Rasterizer:getBoundingBox
---@overload fun(): number
---@param glyph string | number # A character or codepoint.
---@return number # The height, in pixels.
function Rasterizer:getHeight(glyph) end

--- Returns the kerning between 2 glyphs, in pixels.  Kerning is a slight horizontal adjustment between 2 glyphs to improve the visual appearance.  It will often be negative.
---@see Font:getKerning
---@param first string | number # The character or codepoint representing the first glyph.
---@param second string | number # The character or codepoint representing the second glyph.
---@return number # The kerning between the two glyphs.
function Rasterizer:getKerning(first, second) end

--- Returns the leading metric of the font, in pixels.  This is the full amount of space between lines.
---@see Rasterizer:getAscent
---@see Rasterizer:getDescent
---@return number # The font leading, in pixels.
function Rasterizer:getLeading() end

--- Returns the width of a glyph, or the maximum width of any glyph in the font.
---@see Rasterizer:getHeight
---@see Rasterizer:getDimensions
---@see Rasterizer:getBoundingBox
---@overload fun(): number
---@param glyph string | number # A character or codepoint.
---@return number # The width, in pixels.
function Rasterizer:getWidth(glyph) end

--- Returns whether the Rasterizer can rasterize a set of glyphs.
---@see Rasterizer:getGlyphCount
---@param ... string | number # Strings (characters) or numbers (codepoints) to check for.
---@return boolean # true if the Rasterizer can rasterize all of the supplied characters, false otherwise.
function Rasterizer:hasGlyphs(...) end

--- Returns an `Image` containing a rasterized glyph.
---@see Rasterizer:getCurves
---@param glyph string | number # A character or codepoint to rasterize.
---@param spread number? # The width of the distance field, for signed distance field rasterization. (default: 4.0)
---@param padding number? # The number of pixels of padding to add at the edges of the image. (default: spread / 2)
---@return Image # The glyph image.  It will be in the `rgba32f` format.
function Rasterizer:newImage(glyph, spread, padding) end

---@class Sound
---@see lovr.data.newSound # (Constructor)
local Sound = {}

--- Returns a Blob containing the raw bytes of the Sound.
---@see Blob:getPointer
---@see Image:getBlob
---@return Blob # The Blob instance containing the bytes for the `Sound`.
function Sound:getBlob() end

--- Returns the byte stride of the Sound.  This is the size of each frame, in bytes.  For example, a stereo sound with a 32-bit floating point format would have a stride of 8 (4 bytes per sample, and 2 samples per frame).
---@see Sound:getChannelCount
---@see Sound:getFormat
---@return number # The size of a frame, in bytes.
function Sound:getByteStride() end

--- Returns the number of frames that can be written to the Sound.  For stream sounds, this is the number of frames that can currently be written without overwriting existing data.  For normal sounds, this returns the same value as `Sound:getFrameCount`.
---@see Sound:getFrameCount
---@see Sound:getSampleCount
---@see Source:getDuration
---@return number # The number of frames that can be written to the Sound.
function Sound:getCapacity() end

--- Returns the number of channels in the Sound.  Mono sounds have 1 channel, stereo sounds have 2 channels, and ambisonic sounds have 4 channels.
---@see Sound:getChannelLayout
---@see Sound:getByteStride
---@return number # The number of channels in the sound.
function Sound:getChannelCount() end

--- Returns the channel layout of the Sound.
---@see Sound:getChannelCount
---@see Sound:getByteStride
---@return ChannelLayout # The channel layout.
function Sound:getChannelLayout() end

--- Returns the duration of the Sound, in seconds.
---@see Sound:getFrameCount
---@see Sound:getSampleCount
---@see Sound:getSampleRate
---@see Source:getDuration
---@return number # The duration of the Sound, in seconds.
function Sound:getDuration() end

--- Returns the sample format of the Sound.
---@see Sound:getChannelLayout
---@see Sound:getByteStride
---@see Sound:getSampleRate
---@return SampleFormat # The data type of each sample.
function Sound:getFormat() end

--- Returns the number of frames in the Sound.  A frame stores one sample for each channel.
---@see Sound:getDuration
---@see Sound:getSampleCount
---@see Sound:getChannelCount
---@return number # The number of frames in the Sound.
function Sound:getFrameCount() end

--- Reads frames from the Sound into a table, Blob, or another Sound.
---@overload fun(t: table, count: number, srcOffset: number, dstOffset: number): {number}, number
---@overload fun(blob: Blob, count: number, srcOffset: number, dstOffset: number): number
---@overload fun(sound: Sound, count: number, srcOffset: number, dstOffset: number): number
---@param count number? # The number of frames to read.  If nil, reads as many frames as possible.Compressed sounds will automatically be decoded.Reading from a stream will ignore the source offset and read the oldest frames. (default: nil)
---@param srcOffset number? # A frame offset to apply to the sound when reading frames. (default: 0)
---@return {number} # A table containing audio frames.
---@return number # The number of frames read.
function Sound:getFrames(count, srcOffset) end

--- Returns the total number of samples in the Sound.
---@see Sound:getDuration
---@see Sound:getFrameCount
---@see Sound:getChannelCount
---@return number # The total number of samples in the Sound.
function Sound:getSampleCount() end

--- Returns the sample rate of the Sound, in Hz.  This is the number of frames that are played every second.  It's usually a high number like 48000.
---@return number # The number of frames per second in the Sound.
function Sound:getSampleRate() end

--- Returns whether the Sound is compressed.  Compressed sounds are loaded from compressed audio formats like MP3 and OGG.  They use a lot less memory but require some extra CPU work during playback.  Compressed sounds can not be modified using `Sound:setFrames`.
---@see Sound:isStream
---@see lovr.data.newSound
---@return boolean # Whether the Sound is compressed.
function Sound:isCompressed() end

--- Returns whether the Sound is a stream.
---@see Sound:isCompressed
---@see lovr.data.newSound
---@return boolean # Whether the Sound is a stream.
function Sound:isStream() end

--- Writes frames to the Sound.
---@param source table | Blob | Sound # A table, Blob, or Sound containing audio frames to write.
---@param count number? # How many frames to write.  If nil, writes as many as possible. (default: nil)
---@param dstOffset number? # A frame offset to apply when writing the frames. (default: 0)
---@param srcOffset number? # A frame, byte, or index offset to apply when reading frames from the source. (default: 0)
---@return number # The number of frames written.
function Sound:setFrames(source, count, dstOffset, srcOffset) end

_G.lovr.data = data
