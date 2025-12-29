---@meta lovr.graphics

--- The graphics module renders graphics and performs computation using the GPU.
--- Most of the graphics functions are on the `Pass` object.
---@class lovr.graphics
local graphics = {}

--- Controls whether premultiplied alpha is enabled.
---@alias BlendAlphaMode
---| '"alphamultiply"' # Color channel values are multiplied by the alpha channel during blending.
---| '"premultiplied"' # Color channel values are not multiplied by the alpha.  Instead, it's assumed that the colors have already been multiplied by the alpha.  This should be used if the pixels being drawn have already been blended, or "pre-multiplied".

--- Different ways pixels can blend with the pixels behind them.
---@alias BlendMode
---| '"alpha"' # Colors will be mixed based on alpha.
---| '"add"' # Colors will be added to the existing color, alpha will not be changed.
---| '"subtract"' # Colors will be subtracted from the existing color, alpha will not be changed.
---| '"multiply"' # All color channels will be multiplied together, producing a darkening effect.
---| '"lighten"' # The maximum value of each color channel will be used.
---| '"darken"' # The minimum value of each color channel will be used.
---| '"screen"' # The opposite of multiply: the pixel colors are inverted, multiplied, and inverted again, producing a lightening effect.
---| '"none"' # The incoming colors will replace the existing colors.  This is the same as using a blend mode of `nil`.

--- The method used to compare depth and stencil values when performing the depth and stencil tests. Also used for compare modes in `Sampler`s.
---@alias CompareMode
---| '"none"' # The test does not take place, and acts as though it always passes.
---| '"equal"' # The test passes if the values are equal.
---| '"notequal"' # The test passes if the values are not equal.
---| '"less"' # The test passes if the value is less than the existing one.
---| '"lequal"' # The test passes if the value is less than or equal to the existing one.
---| '"greater"' # The test passes if the value is greater than the existing one.
---| '"gequal"' # The test passes if the value is greater than or equal to the existing one.

--- The different ways of doing triangle backface culling.
---@alias CullMode
---| '"none"' # Both sides of triangles will be drawn.
---| '"back"' # Skips rendering the back side of triangles.
---| '"front"' # Skips rendering the front side of triangles.

--- The different ways to pack Buffer fields into memory.
--- The default is `packed`, which is suitable for vertex buffers and index buffers.  It doesn't add any padding between elements, and so it doesn't waste any space.  However, this layout won't necessarily work for uniform buffers and storage buffers.
--- The `std140` layout corresponds to the std140 layout used for uniform buffers in GLSL.  It adds the most padding between fields, and requires the stride to be a multiple of 16.  Example:
---     layout(std140) uniform ObjectScales { float scales[64]; };
--- The `std430` layout corresponds to the std430 layout used for storage buffers in GLSL.  It adds some padding between certain types, and may round up the stride.  Example:
---     layout(std430) buffer TileSizes { vec2 sizes[]; }
---@alias DataLayout
---| '"packed"' # The packed layout, without any padding.
---| '"std140"' # The std140 layout.
---| '"std430"' # The std430 layout.

--- Different types for `Buffer` fields.  These are scalar, vector, or matrix types, usually packed into small amounts of space to reduce the amount of memory they occupy.
--- The names are encoded as follows:
--- - The data type:
---   - `i` for signed integer
---   - `u` for unsigned integer
---   - `sn` for signed normalized (-1 to 1)
---   - `un` for unsigned normalized (0 to 1)
---   - `f` for floating point
--- - The bit depth of each component
--- - The letter `x` followed by the component count (for vectors)
---@alias DataType
---| '"i8x4"' # Four 8-bit signed integers.
---| '"u8x4"' # Four 8-bit unsigned integers.
---| '"sn8x4"' # Four 8-bit signed normalized values.
---| '"un8x4"' # Four 8-bit unsigned normalized values (aka `color`).
---| '"sn10x3"' # Three 10-bit signed normalized values, and 2 padding bits.
---| '"un10x3"' # Three 10-bit unsigned normalized values, and 2 padding bits.
---| '"i16"' # One 16-bit signed integer.
---| '"i16x2"' # Two 16-bit signed integers.
---| '"i16x4"' # Four 16-bit signed integers.
---| '"u16"' # One 16-bit unsigned integer.
---| '"u16x2"' # Two 16-bit unsigned integers.
---| '"u16x4"' # Four 16-bit unsigned integers.
---| '"sn16x2"' # Two 16-bit signed normalized values.
---| '"sn16x4"' # Four 16-bit signed normalized values.
---| '"un16x2"' # Two 16-bit unsigned normalized values.
---| '"un16x4"' # Four 16-bit unsigned normalized values.
---| '"i32"' # One 32-bit signed integer (aka `int`).
---| '"i32x2"' # Two 32-bit signed integers.
---| '"i32x3"' # Three 32-bit signed integers.
---| '"i32x4"' # Four 32-bit signed integers.
---| '"u32"' # One 32-bit unsigned integer (aka `uint`).
---| '"u32x2"' # Two 32-bit unsigned integers.
---| '"u32x3"' # Three 32-bit unsigned integers.
---| '"u32x4"' # Four 32-bit unsigned integers.
---| '"f16x2"' # Two 16-bit floating point numbers.
---| '"f16x4"' # Four 16-bit floating point numbers.
---| '"f32"' # One 32-bit floating point number (aka `float`).
---| '"f32x2"' # Two 32-bit floating point numbers (aka `vec2`).
---| '"f32x3"' # Three 32-bit floating point numbers (aka `vec3`).
---| '"f32x4"' # Four 32-bit floating point numbers (aka `vec4`).
---| '"mat2"' # A 2x2 matrix containing four 32-bit floats.
---| '"mat3"' # A 3x3 matrix containing nine 32-bit floats.
---| '"mat4"' # A 4x4 matrix containing sixteen 32-bit floats.
---| '"index16"' # Like u16, but 1-indexed.
---| '"index32"' # Like u32, but 1-indexed.

--- The set of shaders built in to LÖVR.  These can be passed to `Pass:setShader` or `lovr.graphics.newShader` instead of writing GLSL code.  The shaders can be further customized by using the `flags` option to change their behavior.  If the active shader is set to `nil`, LÖVR picks one of these shaders to use.
---@alias DefaultShader
---| '"unlit"' # Basic shader without lighting that uses colors and a texture.
---| '"normal"' # Shades triangles based on their normal, resulting in a cool rainbow effect.
---| '"font"' # Renders font glyphs.
---| '"cubemap"' # Renders cubemaps.
---| '"equirect"' # Renders spherical textures.
---| '"fill"' # Renders a fullscreen triangle.

--- Different ways vertices in a mesh can be connected together and filled in with pixels.
---@alias DrawMode
---| '"points"' # Each vertex is rendered as a single point.  The size of the point can be controlled using the `pointSize` shader flag, or by writing to the `PointSize` variable in shaders.  The maximum point size is given by the `pointSize` limit from `lovr.graphics.getLimits`.
---| '"lines"' # Pairs of vertices are connected with line segments.  To draw a single line through all of the vertices, an index buffer can be used to repeat vertices.  It is not currently possible to change the width of the lines, although cylinders or capsules can be used as an alternative.
---| '"triangles"' # Every 3 vertices form a triangle, which is filled in with pixels (unless `Pass:setWireframe` is used).  This mode is the most commonly used.

--- Whether a shape should be drawn filled or outlined.
---@alias DrawStyle
---| '"fill"' # The shape will be filled in (the default).
---| '"line"' # The shape will be outlined.

--- Controls how `Sampler` objects smooth pixels in textures.
---@alias FilterMode
---| '"nearest"' # A pixelated appearance where the "nearest neighbor" pixel is used.
---| '"linear"' # A smooth appearance where neighboring pixels are averaged.
---| '"cubic"' # An even smoother appearance, but slower and typically only available on mobile GPUs. Use `lovr.graphics.isFormatSupported('format', 'cubic')` to check for support for a specific format, or `lovr.graphics.getFeatures().cubic` to see if cubic filtering is supported at all.Note that this can only be used for `min` and `mag` options in sampler.  Trying to use this for the `mip` filter mode will silently fall back to `linear`.

--- Different ways to horizontally align text with `Pass:text`.
---@alias HorizontalAlign
---| '"left"' # Left-aligned text.
---| '"center"' # Centered text.
---| '"right"' # Right-aligned text.

--- Whether a Mesh stores its data on the CPU or GPU.
---@alias MeshStorage
---| '"cpu"' # The Mesh will store a copy of the vertices on the CPU.
---| '"gpu"' # The Mesh will not keep a CPU copy, only storing vertices on the GPU.

--- Different coordinate spaces for nodes in a `Model`.
---@alias OriginType
---| '"root"' # Transforms are relative to the origin (root) of the Model.
---| '"parent"' # Transforms are relative to the parent of the node.

--- Different shader stages.  Graphics shaders have a `vertex` and `fragment` stage, and compute shaders have a single `compute` stage.
---@alias ShaderStage
---| '"vertex"' # The vertex stage, which computes transformed vertex positions.
---| '"fragment"' # The fragment stage, which computes pixel colors.
---| '"compute"' # The compute stage, which performs arbitrary computation.

--- The two types of shaders that can be created.
---@alias ShaderType
---| '"graphics"' # A graphics shader with a vertex and pixel stage.
---| '"compute"' # A compute shader with a single compute stage.

--- Different types of stacks that can be pushed and popped with `Pass:push` and `Pass:pop`.
---@alias StackType
---| '"transform"' # The transform stack (`Pass:transform`, `Pass:translate`, etc.).
---| '"state"' # Graphics state, like `Pass:setColor`, `Pass:setFont`, etc.  Notably this does not include camera poses/projections or shader variables changed with `Pass:send`.

--- Different ways of updating the stencil buffer with `Pass:setStencilWrite`.
---@alias StencilAction
---| '"keep"' # Stencil buffer pixels will not be changed by draws.
---| '"zero"' # Stencil buffer pixels will be set to zero.
---| '"replace"' # Stencil buffer pixels will be replaced with a custom value.
---| '"increment"' # Stencil buffer pixels will be incremented each time they're rendered to.
---| '"decrement"' # Stencil buffer pixels will be decremented each time they're rendered to.
---| '"incrementwrap"' # Similar to increment, but will wrap around to 0 when it exceeds 255.
---| '"decrementwrap"' # Similar to decrement, but will wrap around to 255 when it goes below 0.
---| '"invert"' # The bits in the stencil buffer pixels will be inverted.

--- These are the different ways `Texture` objects can be used.  These are passed in to `lovr.graphics.isFormatSupported` to see which texture operations are supported by the GPU for a given format.
---@alias TextureFeature
---| '"sample"' # The Texture can be sampled (e.g. used in a `Material` or sent to a `texture2D` variable in shaders).
---| '"render"' # The Texture can used as a canvas in a `Pass`.
---| '"storage"' # The Texture can be sent to a storage image variable in shaders (e.g. `image2D`).
---| '"blit"' # The Texture can be used with `Pass:blit` and `Pass:generateMipmaps`.
---| '"cubic"' # The Texture can be used with a sampler that uses a `cubic` filter mode.  See `FilterMode`.

--- Different types of textures.  Textures are multidimensional blocks of GPU memory, and the texture's type determines how many dimensions there are, and adds some semantics about what the 3rd dimension means.
---@alias TextureType
---| '"2d"' # A single 2D image, the most common type.
---| '"3d"' # A 3D image, where a sequence of 2D images defines a 3D volume.  Each mipmap level of a 3D texture gets smaller in the x, y, and z axes, unlike cubemap and array textures.
---| '"cube"' # Six square 2D images with the same dimensions that define the faces of a cubemap, used for skyboxes or other "directional" images.  Can also have higher multiples of 6 images, which will be interpreted as a cubemap array image.
---| '"array"' # Array textures are sequences of distinct 2D images that all have the same dimensions.

--- These are the different things `Texture`s can be used for.  When creating a Texture, a set of these flags can be provided, restricting what operations are allowed on the texture.  Using a smaller set of flags may improve performance.  If none are provided, the only usage flag applied is `sample`.
---@alias TextureUsage
---| '"sample"' # Whether the texture can be sampled from in Shaders (i.e. used in a material, or bound to a variable with a `texture` type, like `texture2D`).
---| '"render"' # Whether the texture can be rendered to (i.e. by using it as a render target in `lovr.graphics.pass`).
---| '"storage"' # Whether the texture can be used as a storage texture for compute operations (i.e. bound to a variable with an `image` type, like `image2D`).
---| '"transfer"' # Whether the texture can be used for transfer operations like `Texture:setPixels`, `Texture:blit`, etc.

--- Different ways to vertically align text with `Pass:text`.
---@alias VerticalAlign
---| '"top"' # Top-aligned text.
---| '"middle"' # Centered text.
---| '"bottom"' # Bottom-aligned text.

--- Indicates whether the front face of a triangle uses the clockwise or counterclockwise vertex order.
---@alias Winding
---| '"clockwise"' # Clockwise winding.
---| '"counterclockwise"' # Counterclockwise winding.

--- Controls how `Sampler` objects wrap textures.
---@alias WrapMode
---| '"clamp"' # Pixels will be clamped to the edge, with pixels outside the 0-1 uv range using colors from the nearest edge.
---| '"repeat"' # Tiles the texture.
---| '"mirror"' # Similar to `repeat`, but flips the texture each time it repeats.
---| '"border"' # Similar to `clamp`, but everything outside the 0-1 uv range will be filled with transparent black, i.e. `(0, 0, 0, 0)`.

---@class Buffer
local Buffer = {}

--- Clears a range of data in the Buffer to a value.
---@see Texture.clear
---@param offset number? # The offset of the range of the Buffer to clear, in bytes.  Must be a multiple of 4. (default: 0)
---@param extent number? # The number of bytes to clear.  If `nil`, clears to the end of the Buffer.  Must be a multiple of 4. (default: nil)
---@param value number? # The value to clear to.  This will be interpreted as a 32 bit number, which will be repeated across the clear range. (default: 0x00000000)
function Buffer:clear(offset, extent, value) end

--- Downloads the Buffer's data from VRAM and returns it as a table.  This function is very very slow because it stalls the CPU until the data is finished downloading, so it should only be used for debugging or non-interactive scripts.  `Buffer:newReadback` is an alternative that returns a `Readback` object, which will not block the CPU.
---@see Buffer.newReadback
---@see Buffer.mapData
---@see Readback.getData
---@param index number? # The index of the first item to read. (default: 1)
---@param count number? # The number of items to read.  If nil, reads the remainder of the buffer. (default: nil)
---@return table # The table with the Buffer's data.
function Buffer:getData(index, count) end

--- Returns the format the Buffer was created with.
---@see Buffer.getSize
---@see Buffer.getLength
---@see Buffer.getStride
---@return table # A list of fields comprising the format.
function Buffer:getFormat() end

--- Returns the length of the Buffer, or `nil` if the Buffer was not created with a format.
---@see Buffer.getSize
---@see Buffer.getStride
---@return number # The length of the Buffer.
function Buffer:getLength() end

--- Returns the size of the Buffer in VRAM, in bytes.  This is the same as `length * stride`.
--- The size of the Buffer can't change after it's created.
---@see Buffer.getLength
---@see Buffer.getStride
---@return number # The size of the Buffer, in bytes.
function Buffer:getSize() end

--- Returns the distance between each item in the Buffer, in bytes, or `nil` if the Buffer was not created with a format.
---@see Buffer.getSize
---@see Buffer.getLength
---@return number # The stride of the Buffer, in bytes.
function Buffer:getStride() end

--- Returns a pointer to GPU memory and schedules a copy from this pointer to the buffer's data. The data in the pointer will replace the data in the buffer.  This is intended for use with the LuaJIT FFI or for passing to C libraries.
---@see Blob.getPointer
---@param offset number? # A byte offset in the buffer to write to. (default: 0)
---@param extent number? # The number of bytes to replace.  If nil, writes to the rest of the buffer. (default: nil)
---@return lightuserdata # A pointer to the Buffer's memory.
function Buffer:mapData(offset, extent) end

--- Creates and returns a new `Readback` that will download the data in the Buffer from VRAM. Once the readback is complete, `Readback:getData` returns the data as a table, or `Readback:getBlob` returns the data as a `Blob`.
---@see Buffer.getData
---@see Texture.newReadback
---@param offset number? # A byte offset to read from. (default: 0)
---@param extent number? # The number of bytes to read.  If nil, reads the rest of the buffer. (default: nil)
---@return Readback # A new Readback object.
function Buffer:newReadback(offset, extent) end

--- Copies data to the Buffer from either a table, `Blob`, or `Buffer`.
---@param table table # A flat or nested table of items to copy to the Buffer (see notes for format).
---@param destinationIndex number? # The index of the first value in the Buffer to update. (default: 1)
---@param sourceIndex number? # The index in the table to copy from. (default: 1)
---@param count number? # The number of items to copy.  `nil` will copy as many items as possible, based on the lengths of the source and destination. (default: nil)
---@overload fun(self: Buffer, ...: number)
---@overload fun(self: Buffer, vector: any)
---@overload fun(self: Buffer, blob: Blob, destinationOffset?: number, sourceOffset?: number, size?: number)
---@overload fun(self: Buffer, buffer: Buffer, destinationOffset?: number, sourceOffset?: number, size?: number)
function Buffer:setData(table, destinationIndex, sourceIndex, count) end

---@class Font
local Font = {}

--- Returns the ascent of the font.  The ascent is the maximum amount glyphs ascend above the baseline.  The units depend on the font's pixel density.  With the default density, the units correspond to meters.
---@see Rasterizer.getAscent
---@see Font.getDescent
---@see Font.getHeight
---@see Font.getKerning
---@see Font.getWidth
---@return number # The ascent of the font.
function Font:getAscent() end

--- Returns the descent of the font.  The descent is the maximum amount glyphs descend below the baseline.  The units depend on the font's pixel density.  With the default density, the units correspond to meters.
---@see Rasterizer.getDescent
---@see Font.getAscent
---@see Font.getHeight
---@see Font.getKerning
---@see Font.getWidth
---@return number # The descent of the font.
function Font:getDescent() end

--- Returns the height of the font, sometimes also called the leading.  This is the full height of a line of text, including the space between lines.  Each line of a multiline string is separated on the y axis by this height, multiplied by the font's line spacing.  The units depend on the font's pixel density.  With the default density, the units correspond to meters.
---@see Rasterizer.getLeading
---@see Font.getLineSpacing
---@see Font.setLineSpacing
---@see Font.getAscent
---@see Font.getDescent
---@see Font.getKerning
---@see Font.getWidth
---@see Font.getLines
---@return number # The height of the font.
function Font:getHeight() end

--- Returns the kerning between 2 glyphs.  Kerning is a slight horizontal adjustment between 2 glyphs to improve the visual appearance.  It will often be negative.  The units depend on the font's pixel density.  With the default density, the units correspond to meters.
---@see Rasterizer.getKerning
---@see Font.getAscent
---@see Font.getDescent
---@see Font.getHeight
---@see Font.getWidth
---@param first string | number # The first character or codepoint.
---@param second string | number # The second character or codepoint.
---@return number # The kerning between the two glyphs.
function Font:getKerning(first, second) end

--- Returns the line spacing of the Font.  When spacing out lines, the height of the font is multiplied the line spacing to get the final spacing value.  The default is 1.0.
---@see Font.getHeight
---@return number # The line spacing of the font.
function Font:getLineSpacing() end

--- Returns a table of wrapped lines for a piece of text, given a line length limit.
--- By default the units for `limit` are in meters.  If text is being drawn with scale applied, make sure the scale is also applied to the `limit`.
---@see Font.getWidth
---@see Font.getHeight
---@see Pass.text
---@param string string # The text to wrap.
---@param wrap number # The line length to wrap at.
---@return string[] # A table of strings, one for each wrapped line.
---@overload fun(self: Font, strings: table, wrap: number): string[]
function Font:getLines(string, wrap) end

--- Returns the pixel density of the font.  The density is a "pixels per world unit" factor that controls how the pixels in the font's texture are mapped to units in the coordinate space.
--- The default pixel density is set to the height of the font.  This means that lines of text rendered with a scale of 1.0 come out to 1 unit (meter) tall.  However, if this font was drawn to a 2D texture where the units are in pixels, the font would still be drawn 1 unit (pixel) tall!  Scaling the coordinate space or the size of the text by the height of the font would fix this.  However, a more convenient option is to set the pixel density of the font to 1.0 when doing 2D rendering to make the font's size match up with the pixels of the canvas.
---@return number # The pixel density of the font.
function Font:getPixelDensity() end

--- Returns the Rasterizer object backing the Font.
---@see lovr.graphics.newFont
---@see lovr.data.newRasterizer
---@return Rasterizer # The Rasterizer.
function Font:getRasterizer() end

--- Returns a table of vertices for a piece of text, along with a Material to use when rendering it. The Material returned by this function may not be the same if the Font's texture atlas needs to be recreated with a bigger size to make room for more glyphs.
---@param string string # The text to render.
---@param wrap number? # The maximum line length.  The units depend on the pixel density of the font, but are in meters by default. (default: 0)
---@param halign HorizontalAlign # The horizontal align.
---@param valign VerticalAlign # The vertical align.
---@return number[] # The table of vertices.  See below for the format of each vertex.
---@return Material # A Material to use when rendering the vertices.
---@overload fun(self: Font, strings: table, wrap?: number, halign: HorizontalAlign, valign: VerticalAlign): number[], Material
function Font:getVertices(string, wrap, halign, valign) end

--- Returns the maximum width of a piece of text.  This function does not perform wrapping but does respect newlines in the text.
---@see Font.getAscent
---@see Font.getDescent
---@see Font.getHeight
---@see Font.getKerning
---@see Font.getLines
---@param string string # The text to measure.
---@return number # The maximum width of the text.
---@overload fun(self: Font, strings: table): number
function Font:getWidth(string) end

--- Sets the line spacing of the Font.  When spacing out lines, the height of the font is multiplied by the line spacing to get the final spacing value.  The default is 1.0.
---@see Font.getHeight
---@param spacing number # The new line spacing.
function Font:setLineSpacing(spacing) end

--- Sets the pixel density of the font.  The density is a "pixels per world unit" factor that controls how the pixels in the font's texture are mapped to units in the coordinate space.
--- The default pixel density is set to the height of the font.  This means that lines of text rendered with a scale of 1.0 come out to 1 unit (meter) tall.  However, if this font was drawn to a 2D texture where the units are in pixels, the font would still be drawn 1 unit (pixel) tall!  Scaling the coordinate space or the size of the text by the height of the font would fix this.  However, a more convenient option is to set the pixel density of the font to 1.0 when doing 2D rendering to make the font's size match up with the pixels of the canvas.
---@param density number # The new pixel density of the font.
---@overload fun(self: Font)
function Font:setPixelDensity(density) end

---@class Material
local Material = {}

--- Returns the properties of the Material in a table.
---@return table # The Material properties.
function Material:getProperties() end

---@class Mesh
local Mesh = {}

--- Computes the axis-aligned bounding box of the Mesh from its vertices.
--- If the Mesh was created with the `gpu` storage mode, this function will do nothing and return `false`.
--- If the Mesh does not have an attribute named `VertexPosition` with the `f32x3` (aka `vec3`) type, this function will do nothing and return `false`.
--- Otherwise, the bounding box will be set and the return value will be `true`.
--- The bounding box can also be assigned manually using `Mesh:setBoundingBox`, which can be used to set the bounding box on a `gpu` mesh or for cases where the bounding box is already known.
--- Passes will use the bounding box of a Mesh to cull it against the cameras when `Pass:setViewCull` is enabled, which avoids rendering it when it's out of view.
---@see Mesh.getBoundingBox
---@see Mesh.setBoundingBox
---@see Pass.setViewCull
---@see Collider.getAABB
---@see Shape.getAABB
---@see Model.getBoundingBox
---@see ModelData.getBoundingBox
---@return boolean # Whether the bounding box was updated.
function Mesh:computeBoundingBox() end

--- Returns the axis-aligned bounding box of the Mesh, or `nil` if the Mesh doesn't have a bounding box.
--- Meshes with the `cpu` storage mode can compute their bounding box automatically using `Mesh:computeBoundingBox`.  The bounding box can also be set manually using `Mesh:setBoundingBox`.
--- Passes will use the bounding box of a Mesh to cull it against the cameras when `Pass:setViewCull` is enabled, which avoids rendering it when it's out of view.
---@see Mesh.computeBoundingBox
---@see Pass.setViewCull
---@see Collider.getAABB
---@see Shape.getAABB
---@see Model.getBoundingBox
---@see ModelData.getBoundingBox
---@return number # The minimum x coordinate of the bounding box.
---@return number # The maximum x coordinate of the bounding box.
---@return number # The minimum y coordinate of the bounding box.
---@return number # The maximum y coordinate of the bounding box.
---@return number # The minimum z coordinate of the bounding box.
---@return number # The maximum z coordinate of the bounding box.
function Mesh:getBoundingBox() end

--- Returns the `DrawMode` of the mesh, which controls how the vertices in the Mesh are connected together to create pixels.  The default is `triangles`.
---@see Pass.setMeshMode
---@return DrawMode # The current draw mode.
function Mesh:getDrawMode() end

--- Returns the range of vertices drawn by the Mesh.  If different sets of mesh data are stored in a single Mesh object, the draw range can be used to select different sets of vertices to render.
---@see Mesh.setIndices
---@return number # The index of the first vertex that will be drawn (or the first index, if the Mesh has vertex indices).
---@return number # The number of vertices that will be drawn (or indices, if the Mesh has vertex indices).
---@return number # When the Mesh has vertex indices, an offset that will be added to the index values before fetching the corresponding vertex.  This is ignored if the Mesh does not have vertex indices.
---@overload fun(self: Mesh)
function Mesh:getDrawRange() end

--- Returns the `Buffer` object that holds the data for the vertex indices in the Mesh.
--- This can be `nil` if the Mesh doesn't have any indices.
--- If a Mesh uses the `cpu` storage mode, the index buffer is internal to the `Mesh` and this function will return `nil`.  This ensures that the CPU data for the Mesh does not get out of sync with the GPU data in the Buffer.
---@see Mesh.getIndices
---@see Mesh.setIndices
---@see Mesh.getVertexBuffer
---@return Buffer # The index buffer.
function Mesh:getIndexBuffer() end

--- Returns a table with the Mesh's vertex indices.
---@see Mesh.getIndexBuffer
---@see Mesh.setIndexBuffer
---@return number[] # A table of numbers with the 1-based vertex indices.
function Mesh:getIndices() end

--- Returns the `Material` applied to the Mesh.
---@see Pass.setMaterial
---@see Model.getMaterial
---@see lovr.graphics.newMaterial
---@return Material # The material.
function Mesh:getMaterial() end

--- Returns the `Buffer` object that holds the data for the vertices in the Mesh.
--- If a Mesh uses the `cpu` storage mode, the vertex buffer is internal to the `Mesh` and this function will return `nil`.  This ensures that the CPU data for the Mesh does not get out of sync with the GPU data in the Buffer.
---@see Mesh.getVertices
---@see Mesh.setVertices
---@see Mesh.getIndexBuffer
---@return Buffer # The vertex buffer.
function Mesh:getVertexBuffer() end

--- Returns the number of vertices in the Mesh.  The vertex count is set when the Mesh is created and can't change afterwards.
---@see Mesh.getVertexStride
---@see Mesh.getVertexFormat
---@see lovr.graphics.newMesh
---@see Model.getMesh
---@return number # The number of vertices in the Mesh.
function Mesh:getVertexCount() end

--- Returns the vertex format of the Mesh, which is a list of "attributes" that make up the data for each vertex (position, color, UV, etc.).
---@see Mesh.getVertexCount
---@see Mesh.getVertexStride
---@see lovr.graphics.newMesh
---@return table # The vertex format.
function Mesh:getVertexFormat() end

--- Returns the stride of the Mesh, which is the number of bytes used by each vertex.
---@see Mesh.getVertexCount
---@see Mesh.getVertexFormat
---@see lovr.graphics.newMesh
---@return number # The stride of the Mesh, in bytes.
function Mesh:getVertexStride() end

--- Returns the vertices in the Mesh.
---@see Mesh.getVertexBuffer
---@see Mesh.getVertexFormat
---@see Mesh.getIndices
---@see Mesh.setIndices
---@param index number? # The index of the first vertex to return. (default: 1)
---@param count number? # The number of vertices to return.  If nil, returns the "rest" of the vertices, based on the `index` argument. (default: nil)
---@return number[][] # A table of vertices.  Each vertex is a table of numbers for each vertex attribute, given by the vertex format of the Mesh.
function Mesh:getVertices(index, count) end

--- Sets or removes the axis-aligned bounding box of the Mesh.
--- Meshes with the `cpu` storage mode can compute their bounding box automatically using `Mesh:computeBoundingBox`.
--- Passes will use the bounding box of a Mesh to cull it against the cameras when `Pass:setViewCull` is enabled, which avoids rendering it when it's out of view.
---@see Mesh.computeBoundingBox
---@see Pass.setViewCull
---@see Collider.getAABB
---@see Shape.getAABB
---@see Model.getBoundingBox
---@see ModelData.getBoundingBox
---@param minx number # The minimum x coordinate of the bounding box.
---@param maxx number # The maximum x coordinate of the bounding box.
---@param miny number # The minimum y coordinate of the bounding box.
---@param maxy number # The maximum y coordinate of the bounding box.
---@param minz number # The minimum z coordinate of the bounding box.
---@param maxz number # The maximum z coordinate of the bounding box.
---@overload fun(self: Mesh)
function Mesh:setBoundingBox(minx, maxx, miny, maxy, minz, maxz) end

--- Changes the `DrawMode` of the mesh, which controls how the vertices in the Mesh are connected together to create pixels.  The default is `triangles`.
---@see Pass.setMeshMode
---@param mode DrawMode # The current draw mode.
function Mesh:setDrawMode(mode) end

--- Sets the range of vertices drawn by the Mesh.  If different sets of mesh data are stored in a single Mesh object, the draw range can be used to select different sets of vertices to render.
---@see Mesh.setIndices
---@param start number # The index of the first vertex that will be drawn (or the first index, if the Mesh has vertex indices).
---@param count number # The number of vertices that will be drawn (or indices, if the Mesh has vertex indices).
---@param offset number # When the Mesh has vertex indices, an offset that will be added to the index values before fetching the corresponding vertex.  This is ignored if the Mesh does not have vertex indices.
---@overload fun(self: Mesh)
function Mesh:setDrawRange(start, count, offset) end

--- Sets a `Buffer` object the Mesh will use for vertex indices.
--- This can only be used if the Mesh uses the `gpu` storage mode.
--- The Buffer must have a single field with the `u16`, `u32`, `index16`, or `index32` type.
---@see Mesh.getIndices
---@see Mesh.setIndices
---@see Mesh.getVertexBuffer
---@param buffer Buffer # The index buffer.
function Mesh:setIndexBuffer(buffer) end

--- Sets or clears the vertex indices of the Mesh.  Vertex indices define the list of triangles in the mesh.  They allow vertices to be reused multiple times without duplicating all their data, which can save a lot of memory and processing time if a vertex is used for multiple triangles.
--- If a Mesh doesn't have vertex indices, then the vertices are rendered in order.
---@see Mesh.getIndexBuffer
---@see Mesh.setIndexBuffer
---@see Mesh.setVertices
---@param t number[] # A list of numbers (1-based).
---@overload fun(self: Mesh, blob: Blob, type: DataType)
---@overload fun(self: Mesh)
function Mesh:setIndices(t) end

--- Sets a `Material` to use when drawing the Mesh.
---@see Pass.setMaterial
---@see Model.getMaterial
---@see lovr.graphics.newMaterial
---@param material Material # The material to use.
---@overload fun(self: Mesh, texture: Texture)
function Mesh:setMaterial(material) end

--- Sets the data for vertices in the Mesh.
---@see Mesh.getVertexBuffer
---@see Mesh.getVertexFormat
---@see Mesh.getIndices
---@see Mesh.setIndices
---@param vertices number[][] # A table of vertices, where each vertex is a table of numbers matching the vertex format of the Mesh.
---@param index number? # The index of the first vertex to set. (default: 1)
---@param count number? # The number of vertices to set. (default: nil)
---@overload fun(self: Mesh, blob: Blob, index?: number, count?: number)
function Mesh:setVertices(vertices, index, count) end

---@class Model
local Model = {}

--- Animates a Model by setting or blending the transforms of nodes using data stored in the keyframes of an animation.
--- The animation from the model file is evaluated at the timestamp, resulting in a set of node properties.  These properties are then applied to the nodes in the model, using an optional blend factor.  If the animation doesn't have keyframes that target a given node, the node will remain unchanged.
---@see Model.resetNodeTransforms
---@see Model.getAnimationCount
---@see Model.getAnimationName
---@see Model.getAnimationDuration
---@see Model.getNodePosition
---@see Model.setNodePosition
---@see Model.getNodeOrientation
---@see Model.setNodeOrientation
---@see Model.getNodeScale
---@see Model.setNodeScale
---@see Model.getNodeTransform
---@see Model.setNodeTransform
---@param animation string # The name or index of an animation in the model file.
---@param time number # The timestamp to evaluate the keyframes at, in seconds.
---@param blend number? # How much of the animation's pose to blend into the nodes, from 0 to 1. (default: 1.0)
function Model:animate(animation, time, blend) end

--- Returns a lightweight copy of a Model.  Most of the data will be shared between the two copies of the model, like the materials, textures, and metadata.  However, the clone has its own set of node transforms, allowing it to be animated separately from its parent.  This allows a single model to be rendered in multiple different animation poses in a frame.
---@see lovr.graphics.newModel
---@return Model # A genetically identical copy of the Model.
function Model:clone() end

--- Returns the number of animations in the Model.
---@see Model.getAnimationName
---@see Model.getAnimationDuration
---@see Model.animate
---@return number # The number of animations in the Model.
function Model:getAnimationCount() end

--- Returns the duration of an animation in the Model, in seconds.
---@see Model.getAnimationCount
---@see Model.getAnimationName
---@see Model.animate
---@param animation string | number # The name or index of an animation.
---@return number # The duration of the animation, in seconds.
function Model:getAnimationDuration(animation) end

--- Returns the name of an animation in the Model.
---@see Model.getAnimationCount
---@see Model.getAnimationDuration
---@param index number # The index of an animation.
---@return string | nil # The name of the animation, or `nil` if the animation doesn't have a name.
function Model:getAnimationName(index) end

--- Returns the number of blend shapes in the model.
---@see Model.getBlendShapeName
---@see ModelData.getBlendShapeCount
---@return number # The number of blend shapes in the model.
function Model:getBlendShapeCount() end

--- Returns the name of a blend shape in the model.
---@see Model.getBlendShapeCount
---@see ModelData.getBlendShapeName
---@param index number # The index of a blend shape.
---@return string # The name of the blend shape.
function Model:getBlendShapeName(index) end

--- Returns the weight of a blend shape.  A blend shape contains offset values for the vertices of one of the meshes in a Model.  Whenever the Model is drawn, the offsets are multiplied by the weight of the blend shape, allowing for smooth blending between different meshes.  A weight of zero won't apply any displacement and will skip processing of the blend shape.
---@see Model.getBlendShapeCount
---@see Model.getBlendShapeName
---@see Model.resetBlendShapes
---@param blendshape string | number # The name or index of a blend shape.
---@return number # The weight of the blend shape.
function Model:getBlendShapeWeight(blendshape) end

--- Returns the 6 values of the Model's axis-aligned bounding box.
---@see Model.getWidth
---@see Model.getHeight
---@see Model.getDepth
---@see Model.getDimensions
---@see Model.getCenter
---@see Model.getBoundingSphere
---@see ModelData.getBoundingBox
---@see Collider.getAABB
---@return number # The minimum x coordinate of the vertices in the Model.
---@return number # The maximum x coordinate of the vertices in the Model.
---@return number # The minimum y coordinate of the vertices in the Model.
---@return number # The maximum y coordinate of the vertices in the Model.
---@return number # The minimum z coordinate of the vertices in the Model.
---@return number # The maximum z coordinate of the vertices in the Model.
function Model:getBoundingBox() end

--- Returns a sphere approximately enclosing the vertices in the Model.
---@see Model.getWidth
---@see Model.getHeight
---@see Model.getDepth
---@see Model.getDimensions
---@see Model.getCenter
---@see Model.getBoundingBox
---@see ModelData.getBoundingSphere
---@return number # The x coordinate of the position of the sphere.
---@return number # The y coordinate of the position of the sphere.
---@return number # The z coordinate of the position of the sphere.
---@return number # The radius of the bounding sphere.
function Model:getBoundingSphere() end

--- Returns the center of the Model's axis-aligned bounding box, relative to the Model's origin.
---@see Model.getWidth
---@see Model.getHeight
---@see Model.getDepth
---@see Model.getDimensions
---@see Model.getBoundingBox
---@see ModelData.getCenter
---@return number # The x offset of the center of the bounding box.
---@return number # The y offset of the center of the bounding box.
---@return number # The z offset of the center of the bounding box.
function Model:getCenter() end

--- Returns the ModelData this Model was created from.
---@see lovr.data.newModelData
---@return ModelData # The ModelData.
function Model:getData() end

--- Returns the depth of the Model, computed from its axis-aligned bounding box.
---@see Model.getWidth
---@see Model.getHeight
---@see Model.getDimensions
---@see Model.getCenter
---@see Model.getBoundingBox
---@see ModelData.getDepth
---@return number # The depth of the Model.
function Model:getDepth() end

--- Returns the width, height, and depth of the Model, computed from its axis-aligned bounding box.
---@see Model.getWidth
---@see Model.getHeight
---@see Model.getDepth
---@see Model.getCenter
---@see Model.getBoundingBox
---@see ModelData.getDimensions
---@return number # The width of the Model.
---@return number # The height of the Model.
---@return number # The depth of the Model.
function Model:getDimensions() end

--- Returns the height of the Model, computed from its axis-aligned bounding box.
---@see Model.getWidth
---@see Model.getDepth
---@see Model.getDimensions
---@see Model.getCenter
---@see Model.getBoundingBox
---@see ModelData.getHeight
---@return number # The height of the Model.
function Model:getHeight() end

--- Returns the index buffer used by the Model.  The index buffer describes the order used to draw the vertices in each mesh.
---@see Model.getVertexBuffer
---@see Model.getMesh
---@return Buffer # The index buffer.
function Model:getIndexBuffer() end

--- Returns a `Material` loaded from the Model.
---@see Model.getMaterialCount
---@see Model.getMaterialName
---@param which string | number # The name or index of the Material to return.
---@return Material # The material.
function Model:getMaterial(which) end

--- Returns the number of materials in the Model.
---@see Model.getMaterialName
---@see Model.getMaterial
---@return number # The number of materials in the Model.
function Model:getMaterialCount() end

--- Returns the name of a material in the Model.
---@see Model.getMaterialCount
---@see Model.getMaterial
---@param index number # The index of a material.
---@return string # The name of the material.
function Model:getMaterialName(index) end

--- Returns a `Mesh` from the Model.
---@see Model.getMeshCount
---@see lovr.graphics.newMesh
---@param index number # The index of the Mesh to return.
---@return Mesh # The mesh object.
function Model:getMesh(index) end

--- Returns the number of meshes in the Model.
---@see Model.getMesh
---@return number # The number of meshes in the Model.
function Model:getMeshCount() end

--- Returns extra information stored in the model file.  Currently this is only implemented for glTF models and returns the JSON string from the glTF or glb file.  The metadata can be used to get application-specific data or add support for glTF extensions not supported by LÖVR.
---@return string # The metadata from the model file.
function Model:getMetadata() end

--- Given a parent node, this function returns a table with the indices of its children.
---@see Model.getNodeParent
---@see Model.getRootNode
---@param node string | number # The name or index of the parent node.
---@return number[] # A table containing the node index of each child of the parent node.
function Model:getNodeChildren(node) end

--- Returns the number of nodes in the model.
---@return number # The number of nodes in the model.
function Model:getNodeCount() end

--- Returns the name of a node.
---@see Model.getNodeCount
---@see Model.getAnimationName
---@see Model.getMaterialName
---@param index number # The index of the node.
---@return string # The name of the node.
function Model:getNodeName(index) end

--- Returns the orientation of a node.
---@see Model.getNodePosition
---@see Model.setNodePosition
---@see Model.getNodeScale
---@see Model.setNodeScale
---@see Model.getNodePose
---@see Model.setNodePose
---@see Model.getNodeTransform
---@see Model.setNodeTransform
---@see Model.animate
---@param node string | number # The name or index of a node.
---@param origin OriginType? # Whether the orientation should be returned relative to the root node or the node's parent. (default: 'root')
---@return number # The number of radians the node is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Model:getNodeOrientation(node, origin) end

--- Given a child node, this function returns the index of its parent.
---@see Model.getNodeChildren
---@see Model.getRootNode
---@param node number # The name or index of the child node.
---@return number # The index of the parent.
function Model:getNodeParent(node) end

--- Returns the pose (position and orientation) of a node.
---@see Model.getNodePosition
---@see Model.setNodePosition
---@see Model.getNodeOrientation
---@see Model.setNodeOrientation
---@see Model.getNodeScale
---@see Model.setNodeScale
---@see Model.getNodeTransform
---@see Model.setNodeTransform
---@see Model.animate
---@param node string | number # The name or index of a node.
---@param origin OriginType? # Whether the pose should be returned relative to the root node or the node's parent. (default: 'root')
---@return number # The x position of the node.
---@return number # The y position of the node.
---@return number # The z position of the node.
---@return number # The number of radians the node is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Model:getNodePose(node, origin) end

--- Returns the position of a node.
---@see Model.getNodeOrientation
---@see Model.setNodeOrientation
---@see Model.getNodeScale
---@see Model.setNodeScale
---@see Model.getNodePose
---@see Model.setNodePose
---@see Model.getNodeTransform
---@see Model.setNodeTransform
---@see Model.animate
---@param node string | number # The name or index of a node.
---@param space OriginType? # Whether the position should be returned relative to the root node or the node's parent. (default: 'root')
---@return number # The x coordinate.
---@return number # The y coordinate.
---@return number # The z coordinate.
function Model:getNodePosition(node, space) end

--- Returns the scale of a node.
---@see Model.getNodePosition
---@see Model.setNodePosition
---@see Model.getNodeOrientation
---@see Model.setNodeOrientation
---@see Model.getNodePose
---@see Model.setNodePose
---@see Model.getNodeTransform
---@see Model.setNodeTransform
---@see Model.animate
---@param node string | number # The name or index of a node.
---@param origin OriginType? # Whether the scale should be returned relative to the root node or the node's parent. (default: 'root')
---@return number # The x scale.
---@return number # The y scale.
---@return number # The z scale.
function Model:getNodeScale(node, origin) end

--- Returns the transform (position, scale, and rotation) of a node.
---@see Model.getNodePosition
---@see Model.setNodePosition
---@see Model.getNodeOrientation
---@see Model.setNodeOrientation
---@see Model.getNodeScale
---@see Model.setNodeScale
---@see Model.getNodePose
---@see Model.setNodePose
---@see Model.animate
---@param node string | number # The name or index of a node.
---@param origin OriginType? # Whether the transform should be returned relative to the root node or the node's parent. (default: 'root')
---@return number # The x position of the node.
---@return number # The y position of the node.
---@return number # The z position of the node.
---@return number # The x scale of the node.
---@return number # The y scale of the node.
---@return number # The z scale of the node.
---@return number # The number of radians the node is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Model:getNodeTransform(node, origin) end

--- Returns the index of the model's root node.
---@see Model.getNodeCount
---@see Model.getNodeParent
---@return number # The index of the root node.
function Model:getRootNode() end

--- Returns one of the textures in the Model.
---@see Model.getTextureCount
---@see Model.getMaterial
---@param index number # The index of the texture to get.
---@return Texture # The texture.
function Model:getTexture(index) end

--- Returns the number of textures in the Model.
---@see Model.getTexture
---@return number # The number of textures in the Model.
function Model:getTextureCount() end

--- Returns the total number of triangles in the Model.
---@see Model.getTriangles
---@see Model.getVertexCount
---@see ModelData.getTriangleCount
---@see Model.getMesh
---@return number # The total number of triangles in the Model.
function Model:getTriangleCount() end

--- Returns 2 tables containing mesh data for the Model.
--- The first table is a list of vertex positions and contains 3 numbers for the x, y, and z coordinate of each vertex.  The second table is a list of triangles and contains 1-based indices into the first table representing the first, second, and third vertices that make up each triangle.
--- The vertex positions will be affected by node transforms.
---@see Model.getTriangleCount
---@see Model.getVertexCount
---@see Model.getMesh
---@see ModelData.getTriangles
---@return number[] # The triangle vertex positions, returned as a flat (non-nested) table of numbers.  The position of each vertex is given as an x, y, and z coordinate.
---@return number[] # A list of numbers representing how to connect the vertices into triangles.  Each number is a 1-based index into the `vertices` table, and every 3 indices form a triangle.
function Model:getTriangles() end

--- Returns a `Buffer` that holds the vertices of all of the meshes in the Model.
---@see Model.getIndexBuffer
---@see Model.getMesh
---@return Buffer # The vertex buffer.
function Model:getVertexBuffer() end

--- Returns the total vertex count of the Model.
---@see Model.getTriangles
---@see Model.getTriangleCount
---@see ModelData.getVertexCount
---@return number # The total number of vertices.
function Model:getVertexCount() end

--- Returns the width of the Model, computed from its axis-aligned bounding box.
---@see Model.getHeight
---@see Model.getDepth
---@see Model.getDimensions
---@see Model.getCenter
---@see Model.getBoundingBox
---@see ModelData.getWidth
---@return number # The width of the Model.
function Model:getWidth() end

--- Returns whether the Model has any skeletal animations.
---@return boolean # Whether the animation uses joint nodes for skeletal animation.
function Model:hasJoints() end

--- Resets blend shape weights to the original ones defined in the model file.
---@see Model.resetNodeTransforms
---@see Model.getBlendShapeWeight
---@see Model.setBlendShapeWeight
function Model:resetBlendShapes() end

--- Resets node transforms to the original ones defined in the model file.
---@see Model.resetBlendShapes
function Model:resetNodeTransforms() end

--- Sets the weight of a blend shape.  A blend shape contains offset values for the vertices of one of the meshes in a Model.  Whenever the Model is drawn, the offsets are multiplied by the weight of the blend shape, allowing for smooth blending between different meshes.  A weight of zero won't apply any displacement and will skip processing of the blend shape.
---@see Model.getBlendShapeCount
---@see Model.getBlendShapeName
---@see Model.resetBlendShapes
---@param blendshape string | number # The name or index of a blend shape.
---@param weight number # The new weight for the blend shape.
function Model:setBlendShapeWeight(blendshape, weight) end

--- Sets or blends the orientation of a node to a new orientation.  This sets the local orientation of the node, relative to its parent.
---@see Model.getNodePosition
---@see Model.setNodePosition
---@see Model.getNodeScale
---@see Model.setNodeScale
---@see Model.getNodePose
---@see Model.setNodePose
---@see Model.getNodeTransform
---@see Model.setNodeTransform
---@see Model.animate
---@param node string | number # The name or index of a node.
---@param angle number # The number of radians the node should be rotated around its rotation axis.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@param blend number? # A number from 0 to 1 indicating how much of the target orientation to blend in.  A value of 0 will not change the node's orientation at all, whereas 1 will fully blend to the target orientation. (default: 1.0)
---@overload fun(self: Model, node: string | number, orientation: Quat, blend?: number)
function Model:setNodeOrientation(node, angle, ax, ay, az, blend) end

--- Sets or blends the pose (position and orientation) of a node to a new pose.  This sets the local pose of the node, relative to its parent.  The scale will remain unchanged.
---@see Model.getNodePosition
---@see Model.setNodePosition
---@see Model.getNodeOrientation
---@see Model.setNodeOrientation
---@see Model.getNodeScale
---@see Model.setNodeScale
---@see Model.getNodeTransform
---@see Model.setNodeTransform
---@see Model.animate
---@param node string | number # The name or index of a node.
---@param x number # The x component of the position.
---@param y number # The y component of the position.
---@param z number # The z component of the position.
---@param angle number # The number of radians the node should be rotated around its rotation axis.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@param blend number? # A number from 0 to 1 indicating how much of the target pose to blend in.  A value of 0 will not change the node's pose at all, whereas 1 will fully blend to the target pose. (default: 1.0)
---@overload fun(self: Model, node: string | number, position: Vec3, orientation: Quat, blend?: number)
function Model:setNodePose(node, x, y, z, angle, ax, ay, az, blend) end

--- Sets or blends the position of a node.  This sets the local position of the node, relative to its parent.
---@see Model.getNodeOrientation
---@see Model.setNodeOrientation
---@see Model.getNodeScale
---@see Model.setNodeScale
---@see Model.getNodePose
---@see Model.setNodePose
---@see Model.getNodeTransform
---@see Model.setNodeTransform
---@see Model.animate
---@param node string | number # The name or index of a node.
---@param x number # The x coordinate of the new position.
---@param y number # The y coordinate of the new position.
---@param z number # The z coordinate of the new position.
---@param blend number? # A number from 0 to 1 indicating how much of the new position to blend in.  A value of 0 will not change the node's position at all, whereas 1 will fully blend to the target position. (default: 1.0)
---@overload fun(self: Model, node: string | number, position: Vec3, blend?: number)
function Model:setNodePosition(node, x, y, z, blend) end

--- Sets or blends the scale of a node to a new scale.  This sets the local scale of the node, relative to its parent.
---@see Model.getNodePosition
---@see Model.setNodePosition
---@see Model.getNodeOrientation
---@see Model.setNodeOrientation
---@see Model.getNodePose
---@see Model.setNodePose
---@see Model.getNodeTransform
---@see Model.setNodeTransform
---@see Model.animate
---@param node string | number # The name or index of a node.
---@param sx number # The x scale.
---@param sy number # The y scale.
---@param sz number # The z scale.
---@param blend number? # A number from 0 to 1 indicating how much of the new scale to blend in.  A value of 0 will not change the node's scale at all, whereas 1 will fully blend to the target scale. (default: 1.0)
---@overload fun(self: Model, node: string | number, scale: Vec3, blend?: number)
function Model:setNodeScale(node, sx, sy, sz, blend) end

--- Sets or blends the transform of a node to a new transform.  This sets the local transform of the node, relative to its parent.
---@see Model.getNodePosition
---@see Model.setNodePosition
---@see Model.getNodeOrientation
---@see Model.setNodeOrientation
---@see Model.getNodeScale
---@see Model.setNodeScale
---@see Model.getNodePose
---@see Model.setNodePose
---@see Model.animate
---@param node string | number # The name or index of a node.
---@param x number # The x component of the position.
---@param y number # The y component of the position.
---@param z number # The z component of the position.
---@param sx number # The x component of the scale.
---@param sy number # The y component of the scale.
---@param sz number # The z component of the scale.
---@param angle number # The number of radians the node should be rotated around its rotation axis.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@param blend number? # A number from 0 to 1 indicating how much of the target transform to blend in.  A value of 0 will not change the node's transform at all, whereas 1 will fully blend to the target transform. (default: 1.0)
---@overload fun(self: Model, node: string | number, position: Vec3, scale: Vec3, orientation: Quat, blend?: number)
---@overload fun(self: Model, node: string | number, transform: Mat4, blend?: number)
function Model:setNodeTransform(node, x, y, z, sx, sy, sz, angle, ax, ay, az, blend) end

---@class Pass
local Pass = {}

--- Synchronizes compute work.
--- By default, within a single Pass, multiple calls to `Pass:compute` can run on the GPU in any order, or all at the same time.  This is great because it lets the GPU process the work as efficiently as possible, but sometimes multiple compute dispatches need to be sequenced.
--- Calling this function will insert a barrier.  All compute operations on the Pass after the barrier will only start once all of the previous compute operations on the Pass are finished.
---@see Pass.compute
function Pass:barrier() end

--- Begins a new tally.  The tally will count the number of pixels touched by any draws that occur while the tally is active.  If a pixel fails the depth test or stencil test then it won't be counted, so the tally is a way to detect if objects are visible.
--- The results for all the tallies in the pass can be copied to a `Buffer` when the Pass finishes by setting a buffer with `Pass:setTallyBuffer`.
---@see Pass.finishTally
---@return number # The index of the tally that was started.
function Pass:beginTally() end

--- Draw a box.  This is like `Pass:cube`, except it takes 3 separate values for the scale.
---@see Pass.cube
---@param x number? # The x coordinate of the center of the box. (default: 0)
---@param y number? # The y coordinate of the center of the box. (default: 0)
---@param z number? # The z coordinate of the center of the box. (default: 0)
---@param width number? # The width of the box. (default: 1)
---@param height number? # The height of the box. (default: 1)
---@param depth number? # The depth of the box. (default: 1)
---@param angle number? # The rotation of the box around its rotation axis, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param style DrawStyle? # Whether the box should be drawn filled or outlined. (default: 'fill')
---@overload fun(self: Pass, position: Vec3, size: Vec3, orientation: Quat, style?: DrawStyle)
---@overload fun(self: Pass, transform: Mat4, style?: DrawStyle)
function Pass:box(x, y, z, width, height, depth, angle, ax, ay, az, style) end

--- Draws a capsule.  A capsule is shaped like a cylinder with a hemisphere on each end.
---@param x number? # The x coordinate of the center of the capsule. (default: 0)
---@param y number? # The y coordinate of the center of the capsule. (default: 0)
---@param z number? # The z coordinate of the center of the capsule. (default: 0)
---@param radius number? # The radius of the capsule. (default: 1.0)
---@param length number? # The length of the capsule. (default: 1)
---@param angle number? # The rotation of the capsule around its rotation axis, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param segments number? # The number of circular segments to render. (default: 32)
---@overload fun(self: Pass, position: Vec3, radius?: number, length?: number, orientation: Quat, segments?: number)
---@overload fun(self: Pass, transform: Mat4, segments?: number)
---@overload fun(self: Pass, p1: Vec3, p2: Vec3, radius?: number, segments?: number)
function Pass:capsule(x, y, z, radius, length, angle, ax, ay, az, segments) end

--- Draws a circle.
---@param x number? # The x coordinate of the center of the circle. (default: 0)
---@param y number? # The y coordinate of the center of the circle. (default: 0)
---@param z number? # The z coordinate of the center of the circle. (default: 0)
---@param radius number? # The radius of the circle. (default: 1)
---@param angle number? # The rotation of the circle around its rotation axis, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param style DrawStyle? # Whether the circle should be filled or outlined. (default: 'fill')
---@param angle1 number? # The angle of the beginning of the arc. (default: 0)
---@param angle2 number? # angle of the end of the arc. (default: 2 * math.pi)
---@param segments number? # The number of segments to render. (default: 64)
---@overload fun(self: Pass, position: Vec3, radius?: number, orientation: Quat, style?: DrawStyle, angle1?: number, angle2?: number, segments?: number)
---@overload fun(self: Pass, transform: Mat4, style?: DrawStyle, angle1?: number, angle2?: number, segments?: number)
function Pass:circle(x, y, z, radius, angle, ax, ay, az, style, angle1, angle2, segments) end

--- Runs a compute shader.  There must be an active compute shader set using `Pass:setShader`.
--- All of the compute shader dispatches in a Pass will run **before** all of the draws in the Pass (if any).  They will also run at the same time in parallel, unless `Pass:barrier` is used to control the order.
---@see Pass.barrier
---@see Pass.setShader
---@see Pass.send
---@see lovr.graphics.getLimits
---@param x number? # The number of workgroups to dispatch in the x dimension. (default: 1)
---@param y number? # The number of workgroups to dispatch in the y dimension. (default: 1)
---@param z number? # The number of workgroups to dispatch in the z dimension. (default: 1)
---@overload fun(self: Pass, buffer: Buffer, offset?: number)
function Pass:compute(x, y, z) end

--- Draws a cone.
---@param x number? # The x coordinate of the center of the base of the cone. (default: 0)
---@param y number? # The y coordinate of the center of the base of the cone. (default: 0)
---@param z number? # The z coordinate of the center of the base of the cone. (default: 0)
---@param radius number? # The radius of the cone. (default: 1)
---@param length number? # The length of the cone. (default: 1)
---@param angle number? # The rotation of the cone around its rotation axis, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param segments number? # The number of segments in the cone. (default: 64)
---@overload fun(self: Pass, position: Vec3, radius?: number, length?: number, orientation: Quat, segments?: number)
---@overload fun(self: Pass, transform: Mat4, segments?: number)
---@overload fun(self: Pass, p1: Vec3, p2: Vec3, radius?: number, segments?: number)
function Pass:cone(x, y, z, radius, length, angle, ax, ay, az, segments) end

--- Draws a cube.
---@param x number? # The x coordinate of the center of the cube. (default: 0)
---@param y number? # The y coordinate of the center of the cube. (default: 0)
---@param z number? # The z coordinate of the center of the cube. (default: 0)
---@param size number? # The size of the cube. (default: 1)
---@param angle number? # The rotation of the cube around its rotation axis, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param style DrawStyle? # Whether the cube should be drawn filled or outlined. (default: 'fill')
---@overload fun(self: Pass, position: Vec3, size?: number, orientation: Quat, style?: DrawStyle)
---@overload fun(self: Pass, transform: Mat4, style?: DrawStyle)
function Pass:cube(x, y, z, size, angle, ax, ay, az, style) end

--- Draws a cylinder.
---@param x number? # The x coordinate of the center of the cylinder. (default: 0)
---@param y number? # The y coordinate of the center of the cylinder. (default: 0)
---@param z number? # The z coordinate of the center of the cylinder. (default: 0)
---@param radius number? # The radius of the cylinder. (default: 1)
---@param length number? # The length of the cylinder. (default: 1)
---@param angle number? # The rotation of the cylinder around its rotation axis, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param capped boolean? # Whether the tops and bottoms of the cylinder should be rendered. (default: true)
---@param angle1 number? # The angle of the beginning of the arc. (default: 0)
---@param angle2 number? # angle of the end of the arc. (default: 2 * math.pi)
---@param segments number? # The number of circular segments to render. (default: 64)
---@overload fun(self: Pass, position: Vec3, radius?: number, length?: number, orientation: Quat, capped?: boolean, angle1?: number, angle2?: number, segments?: number)
---@overload fun(self: Pass, transform: Mat4, capped?: boolean, angle1?: number, angle2?: number, segments?: number)
---@overload fun(self: Pass, p1: Vec3, p2: Vec3, radius?: number, capped?: boolean, angle1?: number, angle2?: number, segments?: number)
function Pass:cylinder(x, y, z, radius, length, angle, ax, ay, az, capped, angle1, angle2, segments) end

--- Draws a `Model`, `Mesh`, or `Texture`.
---@param object Model | Mesh | Texture # The object to draw.
---@param x number? # The x coordinate to draw the object at. (default: 0)
---@param y number? # The y coordinate to draw the object at. (default: 0)
---@param z number? # The z coordinate to draw the object at. (default: 0)
---@param scale number? # The scale of the object. (default: 1)
---@param angle number? # The rotation of the object around its rotation axis, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param instances number? # The number of instances to draw. (default: 1)
---@overload fun(self: Pass, object: Model | Mesh | Texture, position: Vec3, scale3: Vec3, orientation: Quat, instances?: number)
---@overload fun(self: Pass, object: Model | Mesh | Texture, transform: Mat4, instances?: number)
function Pass:draw(object, x, y, z, scale, angle, ax, ay, az, instances) end

--- Draws a fullscreen triangle.  The `fill` shader is used, which stretches the triangle across the screen.
---@param texture Texture # The texture to fill.  If nil, the texture from the active material is used.
---@overload fun(self: Pass)
function Pass:fill(texture) end

--- Finishes a tally that was previously started with `Pass:beginTally`.  This will stop counting the number of pixels affected by draws.
--- The results for all the tallies in the pass can be copied to a `Buffer` when the Pass finishes by setting a buffer with `Pass:setTallyBuffer`.
---@see Pass.beginTally
---@return number # The index of the tally that was finished.
function Pass:finishTally() end

--- Returns the Pass's canvas, or `nil` if the Pass doesn't have a canvas.  The canvas is a set of textures that the Pass will draw to when it's submitted.
---@see Pass.getClear
---@see Pass.setClear
---@see Pass.getWidth
---@see Pass.getHeight
---@see Pass.getDimensions
---@return table # The canvas.  Numeric keys will contain the color Textures, along with the following keys:
---@overload fun(self: Pass)
function Pass:getCanvas() end

--- Returns the clear values of the pass.
---@see Pass.getCanvas
---@return table # The clear values for the pass.  Each color texture's clear value is stored at its index, as either a 4-number rgba table or a boolean.  If the pass has a depth texture, there will also be a `depth` key with its clear value as a number or boolean.
function Pass:getClear() end

--- Returns the dimensions of the textures of the Pass's canvas, in pixels.
---@see Pass.getWidth
---@see Pass.getHeight
---@see Pass.getViewCount
---@see Pass.getCanvas
---@see Pass.setCanvas
---@see lovr.system.getWindowDimensions
---@see lovr.headset.getDisplayDimensions
---@return number # The texture width.
---@return number # The texture height.
function Pass:getDimensions() end

--- Returns the height of the textures of the Pass's canvas, in pixels.
---@see Pass.getWidth
---@see Pass.getDimensions
---@see Pass.getViewCount
---@see Pass.getCanvas
---@see Pass.setCanvas
---@see lovr.system.getWindowHeight
---@see lovr.headset.getDisplayHeight
---@return number # The texture height.
function Pass:getHeight() end

--- Returns the debug label of the Pass, which will show up when the Pass is printed and in some graphics debugging tools.  This is set when the Pass is created, and can't be changed afterwards.
---@see lovr.graphics.newPass
---@see Texture.getLabel
---@see Shader.getLabel
---@return string # The label, or nil if none was set.
function Pass:getLabel() end

--- Returns the projection for a single view.
---@see lovr.headset.getViewAngles
---@see lovr.headset.getViewCount
---@see Pass.getViewPose
---@see Pass.setViewPose
---@param view number # The view index.
---@return number # The left field of view angle, in radians.
---@return number # The right field of view angle, in radians.
---@return number # The top field of view angle, in radians.
---@return number # The bottom field of view angle, in radians.
---@overload fun(self: Pass, view: number, matrix: Mat4): Mat4
function Pass:getProjection(view) end

--- Returns statistics for the Pass.
---@see lovr.graphics.isTimingEnabled
---@see lovr.graphics.setTimingEnabled
---@see Pass.setViewCull
---@return table # A table with statistics.
function Pass:getStats() end

--- Returns the Buffer that tally results will be written to.  Each time the render pass finishes, the results of all the tallies will be copied to the Buffer at the specified offset.  The buffer can be used in a later pass in a compute shader, or the data in the buffer can be read back using e.g. `Buffer:newReadback`.
--- If no buffer has been set, this function will return `nil`.
---@see Pass.beginTally
---@see Pass.finishTally
---@return Buffer # The buffer.
---@return number # An offset in the buffer where results will be written.
function Pass:getTallyBuffer() end

--- Returns the view count of a render pass.  This is the layer count of the textures it is rendering to.
---@see Pass.getViewPose
---@see Pass.setViewPose
---@see Pass.getProjection
---@see Pass.setProjection
---@see lovr.headset.getViewCount
---@return number # The view count.
function Pass:getViewCount() end

--- Get the pose of a single view.
---@see lovr.headset.getViewPose
---@see lovr.headset.getViewCount
---@see Pass.getProjection
---@see Pass.setProjection
---@param view number # The view index.
---@return number # The x position of the viewer, in meters.
---@return number # The y position of the viewer, in meters.
---@return number # The z position of the viewer, in meters.
---@return number # The number of radians the viewer is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
---@overload fun(self: Pass, view: number, matrix: Mat4, invert: boolean): Mat4
function Pass:getViewPose(view) end

--- Returns the width of the textures of the Pass's canvas, in pixels.
---@see Pass.getHeight
---@see Pass.getDimensions
---@see Pass.getViewCount
---@see Pass.getCanvas
---@see Pass.setCanvas
---@see lovr.system.getWindowWidth
---@see lovr.headset.getDisplayWidth
---@return number # The texture width.
function Pass:getWidth() end

--- Draws a line between points.  `Pass:mesh` can also be used to draw line segments using the `line` `DrawMode`.
---@param x1 number # The x coordinate of the first point.
---@param y1 number # The y coordinate of the first point.
---@param z1 number # The z coordinate of the first point.
---@param x2 number # The x coordinate of the next point.
---@param y2 number # The y coordinate of the next point.
---@param z2 number # The z coordinate of the next point.
---@param ... number # More points to add to the line.
---@overload fun(self: Pass, t: (number|Vec3)[])
---@overload fun(self: Pass, v1: Vec3, v2: Vec3, ...: Vec3)
function Pass:line(x1, y1, z1, x2, y2, z2, ...) end

--- Draws a mesh.
---@see Pass.setMeshMode
---@param vertices Buffer? # The buffer containing the vertices to draw. (default: nil)
---@param x number? # The x coordinate of the position to draw the mesh at. (default: 0)
---@param y number? # The y coordinate of the position to draw the mesh at. (default: 0)
---@param z number? # The z coordinate of the position to draw the mesh at. (default: 0)
---@param scale number? # The scale of the mesh. (default: 1)
---@param angle number? # The number of radians the mesh is rotated around its rotational axis. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param start number? # The 1-based index of the first vertex to render from the vertex buffer (or the first index, when using an index buffer). (default: 1)
---@param count number? # The number of vertices to render (or the number of indices, when using an index buffer). When `nil`, as many vertices or indices as possible will be drawn (based on the length of the Buffers and `start`). (default: nil)
---@param instances number? # The number of copies of the mesh to render. (default: 1)
---@overload fun(self: Pass, vertices?: Buffer, position: Vec3, scales: Vec3, orientation: Quat, start?: number, count?: number, instances?: number)
---@overload fun(self: Pass, vertices?: Buffer, transform: Mat4, start?: number, count?: number, instances?: number)
---@overload fun(self: Pass, vertices?: Buffer, indices: Buffer, x?: number, y?: number, z?: number, scale?: number, angle?: number, ax?: number, ay?: number, az?: number, start?: number, count?: number, instances?: number, base?: number)
---@overload fun(self: Pass, vertices?: Buffer, indices: Buffer, position: Vec3, scales: Vec3, orientation: Quat, start?: number, count?: number, instances?: number, base?: number)
---@overload fun(self: Pass, vertices?: Buffer, indices: Buffer, transform: Mat4, start?: number, count?: number, instances?: number, base?: number)
---@overload fun(self: Pass, vertices?: Buffer, indices: Buffer, draws: Buffer, drawcount?: number, offset?: number, stride?: number)
function Pass:mesh(vertices, x, y, z, scale, angle, ax, ay, az, start, count, instances) end

--- Resets the transform back to the origin.
---@see Pass.translate
---@see Pass.rotate
---@see Pass.scale
---@see Pass.transform
---@see Pass.push
---@see Pass.pop
function Pass:origin() end

--- Draws a plane.
---@param x number? # The x coordinate of the center of the plane. (default: 0)
---@param y number? # The y coordinate of the center of the plane. (default: 0)
---@param z number? # The z coordinate of the center of the plane. (default: 0)
---@param width number? # The width of the plane. (default: 1)
---@param height number? # The height of the plane. (default: 1)
---@param angle number? # The rotation of the plane around its rotation axis, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param style DrawStyle? # Whether the plane should be drawn filled or outlined. (default: 'fill')
---@param columns number? # The number of horizontal segments in the plane. (default: 1)
---@param rows number? # The number of vertical segments in the plane. (default: columns)
---@overload fun(self: Pass, position: Vec3, size: Vec2, orientation: Quat, style?: DrawStyle, columns?: number, rows?: number)
---@overload fun(self: Pass, transform: Mat4, style?: DrawStyle, columns?: number, rows?: number)
function Pass:plane(x, y, z, width, height, angle, ax, ay, az, style, columns, rows) end

--- Draws points.  `Pass:mesh` can also be used to draw points using a `Buffer`.
---@param x number # The x coordinate of the first point.
---@param y number # The y coordinate of the first point.
---@param z number # The z coordinate of the first point.
---@param ... any # More points.
---@overload fun(self: Pass, t: (number|Vec3)[])
---@overload fun(self: Pass, v: Vec3, ...: any)
function Pass:points(x, y, z, ...) end

--- Draws a polygon.  The 3D vertices must be coplanar (all lie on the same plane), and the polygon must be convex (does not intersect itself or have any angles between vertices greater than 180 degrees), otherwise rendering artifacts may occur.
---@see Pass.points
---@see Pass.line
---@see Pass.draw
---@param x1 number # The x coordinate of the first vertex.
---@param y1 number # The y coordinate of the first vertex.
---@param z1 number # The z coordinate of the first vertex.
---@param x2 number # The x coordinate of the next vertex.
---@param y2 number # The y coordinate of the next vertex.
---@param z2 number # The z coordinate of the next vertex.
---@param ... any # More vertices to add to the polygon.
---@overload fun(self: Pass, t: (number|Vec3)[])
---@overload fun(self: Pass, v1: Vec3, v2: Vec3, ...: any)
function Pass:polygon(x1, y1, z1, x2, y2, z2, ...) end

--- Pops the transform or render state stack, restoring it to the state it was in when it was last pushed.
---@see Pass.push
---@see StackType
---@param stack StackType? # The type of stack to pop. (default: 'transform')
function Pass:pop(stack) end

--- Saves a copy of the transform or render states.  Further changes can be made to the transform or render states, and afterwards `Pass:pop` can be used to restore the original state.  Pushes and pops can be nested, but it's an error to pop without a corresponding push.
---@see Pass.pop
---@see StackType
---@param stack StackType? # The type of stack to push. (default: 'transform')
function Pass:push(stack) end

--- Resets the Pass, clearing all of its draws and computes and resetting all of its state to the default values.
function Pass:reset() end

--- Rotates the coordinate system.
---@see Pass.translate
---@see Pass.scale
---@see Pass.transform
---@see Pass.origin
---@see Pass.push
---@see Pass.pop
---@param angle number # The amount to rotate the coordinate system by, in radians.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@overload fun(self: Pass, rotation: Quat)
function Pass:rotate(angle, ax, ay, az) end

--- Draws a rounded rectangle.
---@param x number? # The x coordinate of the center of the rectangle. (default: 0)
---@param y number? # The y coordinate of the center of the rectangle. (default: 0)
---@param z number? # The z coordinate of the center of the rectangle. (default: 0)
---@param width number? # The width of the rectangle. (default: 1)
---@param height number? # The height of the rectangle. (default: 1)
---@param thickness number? # The thickness of the rectangle. (default: 1)
---@param angle number? # The rotation of the rectangle around its rotation axis, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param radius number? # The radius of the rectangle corners.  If the radius is zero or negative, the rectangle will have sharp corners. (default: 0)
---@param segments number? # The number of circular segments to use for each corner.  This increases the smoothness, but increases the number of vertices in the mesh. (default: 8)
---@overload fun(self: Pass, position: Vec3, size: Vec3, orientation: Quat, radius?: number, segments?: number)
---@overload fun(self: Pass, transform: Mat4, radius?: number, segments?: number)
function Pass:roundrect(x, y, z, width, height, thickness, angle, ax, ay, az, radius, segments) end

--- Scales the coordinate system.
---@see Pass.translate
---@see Pass.rotate
---@see Pass.transform
---@see Pass.origin
---@see Pass.push
---@see Pass.pop
---@param sx number # The x component of the scale.
---@param sy number? # The y component of the scale. (default: sx)
---@param sz number? # The z component of the scale. (default: sx)
---@overload fun(self: Pass, scale: Vec3)
function Pass:scale(sx, sy, sz) end

--- Sends a value to a variable in the Pass's active `Shader`.  The active shader is changed using `Pass:setShader`.
---@param name string # The name of the Shader variable.
---@param buffer Buffer # The Buffer to assign.
---@param offset number? # An offset from the start of the buffer where data will be read, in bytes. (default: 0)
---@param extent number? # The number of bytes that will be available for reading.  If zero, as much data as possible will be bound, depending on the offset, buffer size, and the `uniformBufferRange` or `storageBufferRange` limit. (default: 0)
---@overload fun(self: Pass, name: string, texture: Texture)
---@overload fun(self: Pass, name: string, sampler: Sampler)
---@overload fun(self: Pass, name: string, data: any)
function Pass:send(name, buffer, offset, extent) end

--- Sets whether alpha to coverage is enabled.  Alpha to coverage factors the alpha of a pixel into antialiasing calculations.  It can be used to get antialiased edges on textures with transparency.  It's often used for foliage.
---@param enable boolean # Whether alpha to coverage should be enabled.
function Pass:setAlphaToCoverage(enable) end

--- Sets the blend mode.  When a pixel is drawn, the blend mode controls how it is mixed with the color and alpha of the pixel underneath it.
---@param blend BlendMode # The blend mode.
---@param alphaBlend BlendAlphaMode # The alpha blend mode, used to control premultiplied alpha.
---@overload fun(self: Pass)
---@overload fun(self: Pass, index: number, blend: BlendMode, alphaBlend: BlendAlphaMode)
---@overload fun(self: Pass, index: number)
function Pass:setBlendMode(blend, alphaBlend) end

--- Sets the Pass's canvas.  The canvas is a set of textures that the Pass will draw to when it's submitted, along with configuration for the depth buffer and antialiasing.
---@see Pass.getClear
---@see Pass.setClear
---@see Pass.getWidth
---@see Pass.getHeight
---@see Pass.getDimensions
---@param ... Texture # One or more color textures the pass will render to.
---@overload fun(self: Pass, canvas: table)
---@overload fun(self: Pass)
function Pass:setCanvas(...) end

--- Sets the clear values of the pass.  This controls the initial colors of the canvas texture pixels at the beginning of the render pass.  For each color texture, it can be one of the following:
--- - A specific RGBA color value (or number for the depth texture).
--- - `true`, to do a "fast clear" to undefined values.  This is useful if the pass is going to end
---   up drawing to all of the texture's pixels.
--- - `false`, to avoid clearing and load the texture's existing pixels.  This can be slow on mobile
---   GPUs.
---@see Pass.setCanvas
---@see Texture.clear
---@param hex number # A hexcode color to clear all color textures to.
---@overload fun(self: Pass, r: number, g: number, b: number, a?: number)
---@overload fun(self: Pass, clear: boolean)
---@overload fun(self: Pass, t: table)
function Pass:setClear(hex) end

--- Sets the color used for drawing.  Color components are from 0 to 1.
---@param r number # The red component of the color.
---@param g number # The green component of the color.
---@param b number # The blue component of the color.
---@param a number? # The alpha component of the color. (default: 1.0)
---@overload fun(self: Pass, t: number[])
---@overload fun(self: Pass, hex: number, a?: number)
function Pass:setColor(r, g, b, a) end

--- Sets the color channels affected by drawing, on a per-channel basis.  Disabling color writes is often used to render to the depth or stencil buffer without affecting existing pixel colors.
---@see Pass.setDepthWrite
---@see Pass.setStencilWrite
---@param enable boolean # Whether all color components should be affected by draws.
---@overload fun(self: Pass, r: boolean, g: boolean, b: boolean, a: boolean)
---@overload fun(self: Pass, index: number, enable: boolean)
---@overload fun(self: Pass, index: number, r: boolean, g: boolean, b: boolean, a: boolean)
function Pass:setColorWrite(enable) end

--- Sets whether the front or back faces of triangles are culled.
---@see Pass.setViewCull
---@see Pass.setWinding
---@param mode CullMode # Whether `front` faces, `back` faces, or `none` of the faces should be culled.
---@overload fun(self: Pass)
function Pass:setCullMode(mode) end

--- Enables or disables depth clamp.  Normally, when pixels fall outside of the clipping planes, they are clipped (not rendered).  Depth clamp will instead render these pixels, clamping their depth on to the clipping planes.
---@see Pass.setDepthTest
---@see Pass.setDepthWrite
---@see Pass.setDepthOffset
---@param enable boolean # Whether depth clamp should be enabled.
function Pass:setDepthClamp(enable) end

--- Set the depth offset.  This is a constant offset added to the depth value of pixels, as well as a "sloped" depth offset that is scaled based on the "slope" of the depth at the pixel.
--- This can be used to fix Z fighting when rendering decals or other nearly-overlapping objects, and is also useful for shadow biasing when implementing shadow mapping.
---@see Pass.setDepthTest
---@see Pass.setDepthWrite
---@param offset number? # The depth offset. (default: 0.0)
---@param sloped number? # The sloped depth offset. (default: 0.0)
function Pass:setDepthOffset(offset, sloped) end

--- Sets the depth test.
---@see Pass.setDepthWrite
---@see Pass.setDepthOffset
---@see Pass.setDepthClamp
---@see Pass.setStencilTest
---@see Pass.setProjection
---@param test CompareMode # The new depth test to use.
---@overload fun(self: Pass)
function Pass:setDepthTest(test) end

--- Sets whether draws write to the depth buffer.  When a pixel is drawn, if depth writes are enabled and the pixel passes the depth test, the depth buffer will be updated with the pixel's depth value.
---@see Pass.setStencilWrite
---@see Pass.setColorWrite
---@see Pass.setDepthTest
---@param write boolean # Whether the depth buffer should be affected by draws.
function Pass:setDepthWrite(write) end

--- Sets whether the front or back faces of triangles are culled.
---@see Pass.setViewCull
---@see Pass.setWinding
---@param mode CullMode # Whether `front` faces, `back` faces, or `none` of the faces should be culled.
---@overload fun(self: Pass)
function Pass:setFaceCull(mode) end

--- Sets the font used for `Pass:text`.
---@see Pass.text
---@see lovr.graphics.newFont
---@see lovr.graphics.getDefaultFont
---@param font Font # The Font to use when rendering text.
function Pass:setFont(font) end

--- Sets the material.  This will apply to most drawing, except for text, skyboxes, and models, which use their own materials.
---@param material Texture | Material # The texture or material to apply to surfaces.
---@overload fun(self: Pass)
function Pass:setMaterial(material) end

--- Changes the way vertices are connected together when drawing using `Pass:mesh`.
---@param mode DrawMode # The mesh mode to use.
function Pass:setMeshMode(mode) end

--- Sets the projection for a single view.  4 field of view angles can be used, similar to the field of view returned by `lovr.headset.getViewAngles`.  Alternatively, a projection matrix can be used for other types of projections like orthographic, oblique, etc.
--- Up to 6 views are supported.  The Pass returned by `lovr.headset.getPass` will have its views automatically configured to match the headset.
---@see lovr.headset.getViewAngles
---@see lovr.headset.getViewCount
---@see Pass.getViewPose
---@see Pass.setViewPose
---@param view number # The index of the view to update.
---@param left number # The left field of view angle, in radians.
---@param right number # The right field of view angle, in radians.
---@param up number # The top field of view angle, in radians.
---@param down number # The bottom field of view angle, in radians.
---@param near number? # The near clipping plane distance, in meters. (default: .01)
---@param far number? # The far clipping plane distance, in meters. (default: 0.0)
---@overload fun(self: Pass, view: number, matrix: Mat4)
function Pass:setProjection(view, left, right, up, down, near, far) end

--- Sets the default `Sampler` to use when sampling textures.  It is also possible to send a custom sampler to a shader using `Pass:send` and use that instead, which allows customizing the sampler on a per-texture basis.
---@param sampler Sampler | FilterMode? # The Sampler shaders will use when reading from textures.  It can also be a `FilterMode`, for convenience (other sampler settings will use their defaults). (default: 'linear')
function Pass:setSampler(sampler) end

--- Sets the scissor rectangle.  Any pixels outside the scissor rectangle will not be drawn.
---@see Pass.setViewport
---@param x number # The x coordinate of the upper-left corner of the scissor rectangle.
---@param y number # The y coordinate of the upper-left corner of the scissor rectangle.
---@param w number # The width of the scissor rectangle.
---@param h number # The height of the scissor rectangle.
---@overload fun(self: Pass)
function Pass:setScissor(x, y, w, h) end

--- Sets the active shader.  The Shader will affect all drawing operations until it is changed again.
---@see Pass.send
---@see Pass.compute
---@param shader Shader | DefaultShader # The shader to use.
---@overload fun(self: Pass)
function Pass:setShader(shader) end

--- Sets the stencil test.  Any pixels that fail the stencil test won't be drawn.  For example, setting the stencil test to `('equal', 1)` will only draw pixels that have a stencil value of 1. The stencil buffer can be modified by drawing while stencil writes are enabled with `lovr.graphics.setStencilWrite`.
---@see Pass.setStencilWrite
---@see Pass.setDepthTest
---@param test CompareMode # The new stencil test to use.
---@param value number # The stencil value to compare against.
---@param mask number? # An optional mask to apply to stencil values before the comparison. (default: 0xff)
---@overload fun(self: Pass)
function Pass:setStencilTest(test, value, mask) end

--- Sets or disables stencil writes.  When stencil writes are enabled, any pixels drawn will update the values in the stencil buffer using the `StencilAction` set.
---@see Pass.setStencilTest
---@see Pass.setDepthTest
---@param action StencilAction[] # How pixels should update the stencil buffer when they are drawn.  Can also be a list of 3 stencil actions, used when a pixel fails the stencil test, fails the depth test, or passes the stencil test, respectively.
---@param value number? # When using the 'replace' action, this is the value to replace with. (default: 1)
---@param mask number? # An optional mask to apply to stencil values before writing. (default: 0xff)
---@overload fun(self: Pass)
function Pass:setStencilWrite(action, value, mask) end

--- Sets the Buffer where tally results will be written to.  Each time the render pass finishes, the results of all the tallies will be copied to the Buffer at the specified offset.  The buffer can be used in a later pass in a compute shader, or the data in the buffer can be read back using e.g. `Buffer:newReadback`.
---@see Pass.beginTally
---@see Pass.finishTally
---@param buffer Buffer # The buffer.
---@param offset number # A byte offset where results will be written.  Must be a multiple of 4.
---@overload fun(self: Pass)
function Pass:setTallyBuffer(buffer, offset) end

--- Enables or disables view frustum culling.  When enabled, if an object is drawn outside of the camera view, the draw will be skipped.  This can improve performance.
---@see Pass.setCullMode
---@see Mesh.computeBoundingBox
---@see Mesh.setBoundingBox
---@see Pass.setViewPose
---@see Pass.setProjection
---@param enable boolean # Whether frustum culling should be enabled.
function Pass:setViewCull(enable) end

--- Sets the pose for a single view.  Objects rendered in this view will appear as though the camera is positioned using the given pose.
--- Up to 6 views are supported.  When rendering to the headset, views are changed to match the eye positions.  These view poses are also available using `lovr.headset.getViewPose`.
---@see lovr.headset.getViewPose
---@see lovr.headset.getViewCount
---@see Pass.getProjection
---@see Pass.setProjection
---@param view number # The index of the view to update.
---@param x number # The x position of the viewer, in meters.
---@param y number # The y position of the viewer, in meters.
---@param z number # The z position of the viewer, in meters.
---@param angle number # The number of radians the viewer is rotated around its axis of rotation.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@overload fun(self: Pass, view: number, position: Vec3, orientation: Quat)
---@overload fun(self: Pass, view: number, matrix: Mat4, inverted: boolean)
function Pass:setViewPose(view, x, y, z, angle, ax, ay, az) end

--- Sets the viewport.  Everything rendered will get mapped to the rectangle defined by the viewport.  More specifically, this defines the transformation from normalized device coordinates to pixel coordinates.
---@see Pass.setScissor
---@see Pass.getDimensions
---@param x number # The x coordinate of the upper-left corner of the viewport.
---@param y number # The y coordinate of the upper-left corner of the viewport.
---@param w number # The width of the viewport.  Must be positive.
---@param h number # The height of the viewport.  May be negative.
---@param dmin number? # The min component of the depth range, between 0 and 1. (default: 0.0)
---@param dmax number? # The max component of the depth range, between 0 and 1. (default: 1.0)
---@overload fun(self: Pass)
function Pass:setViewport(x, y, w, h, dmin, dmax) end

--- Sets whether vertices in the clockwise or counterclockwise order vertices are considered the "front" face of a triangle.  This is used for culling with `Pass:setCullMode`.
---@see Pass.setCullMode
---@param winding Winding # Whether triangle vertices are ordered `clockwise` or `counterclockwise`.
function Pass:setWinding(winding) end

--- Enables or disables wireframe rendering.  This will draw all triangles as lines while active. It's intended to be used for debugging, since it usually has a performance cost.
---@see Pass.setMeshMode
---@param enable boolean # Whether wireframe rendering should be enabled.
function Pass:setWireframe(enable) end

--- Draws a skybox.
---@param skybox Texture # The skybox to render.  Its `TextureType` can be `cube` to render as a cubemap, or `2d` to render as an equirectangular (spherical) 2D image.
---@overload fun(self: Pass)
function Pass:skybox(skybox) end

--- Draws a sphere
---@param x number? # The x coordinate of the center of the sphere. (default: 0)
---@param y number? # The y coordinate of the center of the sphere. (default: 0)
---@param z number? # The z coordinate of the center of the sphere. (default: 0)
---@param radius number? # The radius of the sphere. (default: 1)
---@param angle number? # The rotation of the sphere around its rotation axis, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param longitudes number? # The number of "horizontal" segments. (default: 48)
---@param latitudes number? # The number of "vertical" segments. (default: longitudes / 2)
---@overload fun(self: Pass, position: Vec3, radius?: number, orientation: Quat, longitudes?: number, latitudes?: number)
---@overload fun(self: Pass, transform: Mat4, longitudes?: number, latitudes?: number)
function Pass:sphere(x, y, z, radius, angle, ax, ay, az, longitudes, latitudes) end

--- Draws text.  The font can be changed using `Pass:setFont`.
---@see Pass.setFont
---@see lovr.graphics.getDefaultFont
---@see Pass.setShader
---@see Font.getWidth
---@see Font.getHeight
---@see Font.getLines
---@see Font.getVertices
---@see Font
---@param text string # The text to render.
---@param x number? # The x coordinate of the text origin. (default: 0)
---@param y number? # The y coordinate of the text origin. (default: 0)
---@param z number? # The z coordinate of the text origin. (default: 0)
---@param scale number? # The scale of the text (with the default pixel density, units are meters). (default: 1)
---@param angle number? # The rotation of the text around its rotation axis, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param wrap number? # The maximum width of each line in meters (before scale is applied).  When zero, the text will not wrap. (default: 0)
---@param halign HorizontalAlign? # The horizontal alignment relative to the text origin. (default: 'center')
---@param valign VerticalAlign? # The vertical alignment relative to the text origin. (default: 'middle')
---@overload fun(self: Pass, text: string, position: Vec3, scale?: number, orientation: Quat, wrap?: number, halign?: HorizontalAlign, valign?: VerticalAlign)
---@overload fun(self: Pass, text: string, transform: Mat4, wrap?: number, halign?: HorizontalAlign, valign?: VerticalAlign)
---@overload fun(self: Pass, colortext: table, x?: number, y?: number, z?: number, scale?: number, angle?: number, ax?: number, ay?: number, az?: number, wrap?: number, halign?: HorizontalAlign, valign?: VerticalAlign)
---@overload fun(self: Pass, colortext: table, position: Vec3, scale?: number, orientation: Quat, wrap?: number, halign?: HorizontalAlign, valign?: VerticalAlign)
---@overload fun(self: Pass, colortext: table, transform: Mat4, wrap?: number, halign?: HorizontalAlign, valign?: VerticalAlign)
function Pass:text(text, x, y, z, scale, angle, ax, ay, az, wrap, halign, valign) end

--- Draws a torus.
---@param x number? # The x coordinate of the center of the torus. (default: 0)
---@param y number? # The y coordinate of the center of the torus. (default: 0)
---@param z number? # The z coordinate of the center of the torus. (default: 0)
---@param radius number? # The radius of the torus. (default: 1)
---@param thickness number? # The thickness of the torus. (default: 1)
---@param angle number? # The rotation of the torus around its rotation axis, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 1)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param tsegments number? # The number of toroidal (circular) segments to render. (default: 64)
---@param psegments number? # The number of poloidal (tubular) segments to render. (default: 32)
---@overload fun(self: Pass, position: Vec3, scale: Vec3, orientation: Quat, tsegments?: number, psegments?: number)
---@overload fun(self: Pass, transform: Mat4, tsegments?: number, psegments?: number)
function Pass:torus(x, y, z, radius, thickness, angle, ax, ay, az, tsegments, psegments) end

--- Transforms the coordinate system.
---@see Pass.translate
---@see Pass.rotate
---@see Pass.scale
---@see Pass.origin
---@see Pass.push
---@see Pass.pop
---@param x number # The x component of the translation.
---@param y number # The y component of the translation.
---@param z number # The z component of the translation.
---@param sx number # The x component of the scale.
---@param sy number # The y component of the scale.
---@param sz number # The z component of the scale.
---@param angle number # The amount to rotate the coordinate system by, in radians.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@overload fun(self: Pass, translation: Vec3, scale: Vec3, rotation: Quat)
---@overload fun(self: Pass, transform: Mat4)
function Pass:transform(x, y, z, sx, sy, sz, angle, ax, ay, az) end

--- Translates the coordinate system.
---@see Pass.rotate
---@see Pass.scale
---@see Pass.transform
---@see Pass.origin
---@see Pass.push
---@see Pass.pop
---@param x number # The x component of the translation.
---@param y number # The y component of the translation.
---@param z number # The z component of the translation.
---@overload fun(self: Pass, translation: Vec3)
function Pass:translate(x, y, z) end

---@class Readback
local Readback = {}

--- Returns the Readback's data as a Blob.
---@see Readback.getData
---@see Readback.getImage
---@return Blob # The Blob.
function Readback:getBlob() end

--- Returns the data from the Readback, as a table.  See `Buffer:getData` for the way the table is structured.
---@see Readback.getBlob
---@see Readback.getImage
---@return table # A table containing the data that was read back.
function Readback:getData() end

--- Returns the Readback's data as an Image.
---@see Readback.getData
---@see Readback.getBlob
---@return Image # The Image.
function Readback:getImage() end

--- Returns whether the Readback has completed on the GPU and its data is available.
---@return boolean # Whether the readback is complete.
function Readback:isComplete() end

--- Blocks the CPU until the Readback is finished on the GPU.
---@return boolean # Whether the CPU had to be blocked for waiting.
function Readback:wait() end

---@class Sampler
local Sampler = {}

--- Returns the anisotropy level of the Sampler.  Anisotropy smooths out a texture's appearance when viewed at grazing angles.
---@see Sampler.getFilter
---@see Sampler.getWrap
---@see Sampler.getCompareMode
---@see Sampler.getMipmapRange
---@return number # The anisotropy level of the sampler.
function Sampler:getAnisotropy() end

--- Returns the compare mode of the Sampler.  This is a feature typically only used for shadow mapping.  Using a sampler with a compare mode requires it to be declared in a shader as a `samplerShadow` instead of a `sampler` variable, and used with a texture that has a depth format.  The result of sampling a depth texture with a shadow sampler is a number between 0 and 1, indicating the percentage of sampled pixels that passed the comparison.
---@see Sampler.getFilter
---@see Sampler.getWrap
---@see Sampler.getAnisotropy
---@see Sampler.getMipmapRange
---@return CompareMode # The compare mode of the sampler.
function Sampler:getCompareMode() end

--- Returns the filter mode of the Sampler.
---@see Sampler.getWrap
---@see Sampler.getCompareMode
---@see Sampler.getAnisotropy
---@see Sampler.getMipmapRange
---@return FilterMode # The filter mode used when the texture is minified.
---@return FilterMode # The filter mode used when the texture is magnified.
---@return FilterMode # The filter mode used to select a mipmap level.
function Sampler:getFilter() end

--- Returns the mipmap range of the Sampler.  This is used to clamp the range of mipmap levels that can be accessed from a texture.
---@see Sampler.getFilter
---@see Sampler.getWrap
---@see Sampler.getCompareMode
---@see Sampler.getAnisotropy
---@return number # The minimum mipmap level that will be sampled (0 is the largest image).
---@return number # The maximum mipmap level that will be sampled.
function Sampler:getMipmapRange() end

--- Returns the wrap mode of the sampler, used to wrap or clamp texture coordinates when the extend outside of the 0-1 range.
---@see Sampler.getFilter
---@see Sampler.getCompareMode
---@see Sampler.getAnisotropy
---@see Sampler.getMipmapRange
---@return WrapMode # The wrap mode used in the horizontal direction.
---@return WrapMode # The wrap mode used in the vertical direction.
---@return WrapMode # The wrap mode used in the "z" direction, for 3D textures only.
function Sampler:getWrap() end

---@class Shader
local Shader = {}

--- Clones a shader.  This creates an inexpensive copy of it with different flags.  It can be used to create several variants of a shader with different behavior.
---@param source Shader # The Shader to clone.
---@param flags table # The flags used by the clone.
---@return Shader # The new Shader.
function Shader:clone(source, flags) end

--- Returns the format of a buffer declared in shader code.  The return type matches the same syntax used by `lovr.graphics.newBuffer` and `Buffer:getFormat`, so it can be used to quickly create a Buffer that matches a variable from a Shader.
---@see lovr.graphics.newBuffer
---@see Buffer.getFormat
---@param name string # The name of the buffer variable to return the format of.
---@return table # A list of fields that match the type declaration of the buffer in the shader code.  Each field has `name`, `type`, and `offset` keys.  If the field is an array, it will have `length` and `stride` keys as well.  The top-level table also has a `stride` key.  Offsets and strides are in bytes.
---@return number # The number of items in the buffer (or 1 if the buffer is not an array).
function Shader:getBufferFormat(name) end

--- Returns the debug label of the Shader, which will show up when the Shader is printed and in some graphics debugging tools.  This is set when the Shader is created, and can't be changed afterwards.
---@see lovr.graphics.newShader
---@see Texture.getLabel
---@see Pass.getLabel
---@return string # The label, or nil if none was set.
function Shader:getLabel() end

--- Returns whether the shader is a graphics or compute shader.
---@see Shader.hasStage
---@see lovr.graphics.newShader
---@return ShaderType # The type of the Shader.
function Shader:getType() end

--- Returns the workgroup size of a compute shader.  The workgroup size defines how many times a compute shader is invoked for each workgroup dispatched by `Pass:compute`.
---@see Pass.compute
---@see lovr.graphics.getLimits
---@return number # The x size of a workgroup.
---@return number # The y size of a workgroup.
---@return number # The z size of a workgroup.
function Shader:getWorkgroupSize() end

--- Returns whether the Shader has a vertex attribute, by name or location.
---@param name string # The name of an attribute.
---@return boolean # Whether the Shader has the attribute.
---@overload fun(self: Shader, location: number): boolean
function Shader:hasAttribute(name) end

--- Returns whether the Shader has a given stage.
---@see Shader.getType
---@param stage ShaderStage # The stage.
---@return boolean # Whether the Shader has the stage.
function Shader:hasStage(stage) end

--- Returns whether the Shader has a variable.
---@see Pass.send
---@param name string # The name of the variable to check.
---@return boolean # Whether the Shader has the variable.
function Shader:hasVariable(name) end

---@class Texture
local Texture = {}

--- Clears layers and mipmaps in a texture to a given color.
--- When a Texture is being used as a canvas for a `Pass`, the clear color can be set with `Pass:setClear`, which a more efficient way to clear the texture before rendering.
---@see Buffer.clear
---@see Texture.setPixels
---@see Pass.setClear
---@overload fun(self: Texture, hex: number, layer?: number, layerCount?: number, mipmap?: number, mipmapCount?: number)
---@overload fun(self: Texture, r: number, g: number, b: number, a: number, layer?: number, layerCount?: number, mipmap?: number, mipmapCount?: number)
---@overload fun(self: Texture, t: number[], layer?: number, layerCount?: number, mipmap?: number, mipmapCount?: number)
---@overload fun(self: Texture, v3: Vec3, layer?: number, layerCount?: number, mipmap?: number, mipmapCount?: number)
---@overload fun(self: Texture, v4: Vec4, layer?: number, layerCount?: number, mipmap?: number, mipmapCount?: number)
function Texture:clear() end

--- Regenerates mipmap levels of a texture.  This downscales pixels from the texture to progressively smaller sizes and saves them.  If the texture is drawn at a smaller scale later, the mipmaps are used, which smooths out the appearance and improves performance.
---@see Texture.setPixels
---@see Texture.getMipmapCount
---@param base number? # The base mipmap level which will be used to generate subsequent mipmaps. (default: 1)
---@param count number? # The number of mipmap levels to generate.  If nil, the rest of the mipmaps will be generated. (default: nil)
function Texture:generateMipmaps(base, count) end

--- Returns the width, height, and depth of the Texture.
---@see Texture.getWidth
---@see Texture.getHeight
---@see Texture.getLayerCount
---@return number # The width of the Texture.
---@return number # The height of the Texture.
---@return number # The number of layers in the Texture.
function Texture:getDimensions() end

--- Returns the format of the texture.
---@return TextureFormat # The format of the Texture.
---@return boolean # Whether the format is linear or srgb.
function Texture:getFormat() end

--- Returns the height of the Texture, in pixels.
---@see Texture.getWidth
---@see Texture.getLayerCount
---@see Texture.getDimensions
---@return number # The height of the Texture, in pixels.
function Texture:getHeight() end

--- Returns the debug label of the Texture, which will show up when the Texture is printed and in some graphics debugging tools.  This is set when the Texture is created, and can't be changed afterwards.
---@see lovr.graphics.newTexture
---@see Shader.getLabel
---@see Pass.getLabel
---@return string # The label, or nil if none was set.
function Texture:getLabel() end

--- Returns the layer count of the Texture.  2D textures always have 1 layer and cubemaps always have a layer count divisible by 6.  3D and array textures have a variable number of layers.
---@see Texture.getWidth
---@see Texture.getHeight
---@see Texture.getDimensions
---@return number # The layer count of the Texture.
function Texture:getLayerCount() end

--- Returns the number of mipmap levels in the Texture.
---@see lovr.graphics.newTexture
---@see Sampler.getMipmapRange
---@see Texture.generateMipmaps
---@return number # The number of mipmap levels in the Texture.
function Texture:getMipmapCount() end

--- Creates and returns a new `Image` object with the current pixels of the Texture.  This function is very very slow because it stalls the CPU until the download is complete.  It should only be used for debugging, non-interactive scripts, etc.  For an asynchronous version that doesn't stall the CPU, see `Texture:newReadback`.
---@see Texture.newReadback
---@param x number? # The x offset of the region to download. (default: 0)
---@param y number? # The y offset of the region to download. (default: 0)
---@param layer number? # The index of the layer to download. (default: 1)
---@param mipmap number? # The index of the mipmap level to download. (default: 1)
---@param width number? # The width of the pixel rectangle to download.  If nil, the "rest" of the width will be used, based on the texture width and x offset. (default: nil)
---@param height number? # The height of the pixel rectangle to download.  If nil, the "rest" of the height will be used, based on the texture height and y offset. (default: nil)
---@return Image # The new image with the pixels.
function Texture:getPixels(x, y, layer, mipmap, width, height) end

--- Returns the number of samples in the texture.  Multiple samples are used for multisample antialiasing when rendering to the texture.  Currently, the sample count is either 1 (not antialiased) or 4 (antialiased).
---@see lovr.graphics.newTexture
---@see Pass.setCanvas
---@return number # The number of samples in the Texture.
function Texture:getSampleCount() end

--- Returns the Sampler object previously assigned with `Texture:setSampler`.
--- This API is experimental, and subject to change in the future!
---@return Sampler # The Sampler object.
function Texture:getSampler() end

--- Returns the type of the texture.
---@return TextureType # The type of the Texture.
function Texture:getType() end

--- Returns the width of the Texture, in pixels.
---@see Texture.getHeight
---@see Texture.getLayerCount
---@see Texture.getDimensions
---@return number # The width of the Texture, in pixels.
function Texture:getWidth() end

--- Returns whether a Texture was created with a set of `TextureUsage` flags.  Usage flags are specified when the Texture is created, and restrict what you can do with a Texture object.  By default, only the `sample` usage is enabled.  Applying a smaller set of usage flags helps LÖVR optimize things better.
---@see lovr.graphics.newTexture
---@param ... TextureUsage # One or more usage flags.
---@return boolean # Whether the Texture has all the provided usage flags.
function Texture:hasUsage(...) end

--- Creates and returns a new `Readback` that will download the pixels in the Texture from VRAM. Once the readback is complete, `Readback:getImage` returns an `Image` with a CPU copy of the data.
---@see Texture.getPixels
---@see Buffer.newReadback
---@param x number? # The x offset of the region to download. (default: 0)
---@param y number? # The y offset of the region to download. (default: 0)
---@param layer number? # The index of the layer to download. (default: 1)
---@param mipmap number? # The index of the mipmap level to download. (default: 1)
---@param width number? # The width of the pixel rectangle to download.  If nil, the "rest" of the width will be used, based on the texture width and x offset. (default: nil)
---@param height number? # The height of the pixel rectangle to download.  If nil, the "rest" of the height will be used, based on the texture height and y offset. (default: nil)
---@return Readback # A new Readback object.
function Texture:newReadback(x, y, layer, mipmap, width, height) end

--- Sets pixels in the texture.  The source data can be an `Image` with the pixels to upload, or another `Texture` object to copy from.
---@see Texture.newReadback
---@see Texture.generateMipmaps
---@see Image.paste
---@param source Texture | Image # The source texture or image to copy to this texture.
---@param dstx number? # The x offset to copy to. (default: 0)
---@param dsty number? # The y offset to copy to. (default: 0)
---@param dstlayer number? # The index of the layer to copy to. (default: 1)
---@param dstmipmap number? # The index of the mipmap level to copy to. (default: 1)
---@param srcx number? # The x offset to copy from. (default: 0)
---@param srcy number? # The y offset to copy from. (default: 0)
---@param srclayer number? # The index of the layer to copy from. (default: 1)
---@param srcmipmap number? # The index of the mipmap level to copy from. (default: 1)
---@param width number? # The width of the region of pixels to copy.  If nil, the maximum possible width will be used, based on the widths of the source/destination and the offset parameters. (default: nil)
---@param height number? # The height of the region of pixels to copy.  If nil, the maximum possible height will be used, based on the heights of the source/destination and the offset parameters. (default: nil)
---@param layers number? # The number of layers to copy.  If nil, copies as many layers as possible. (default: nil)
function Texture:setPixels(source, dstx, dsty, dstlayer, dstmipmap, srcx, srcy, srclayer, srcmipmap, width, height, layers) end

--- Sets sampler settings for the texture.  This can either be a `FilterMode` like `nearest`, or a `Sampler` object, which allows configuring all of the filtering and wrapping settings.
--- There are other ways of using custom samplers for a texture, but they have disadvantages:
--- - `Sampler` objects can be sent to shaders and used to sample from the texture, but this
---   requires writing custom shader code and sending sampler objects with `Pass:send`, which is
---   inconvenient.
--- - `Pass:setSampler` exists, but it applies to all textures in all draws in the Pass.  It doesn't
---   allow for changing filtering settings on a per-texture basis.
--- This API is experimental, and subject to change in the future!
---@param mode FilterMode # The FilterMode shaders will use when reading pixels from the texture.
---@overload fun(self: Texture, sampler: Sampler)
---@overload fun(self: Texture)
function Texture:setSampler(mode) end

--- Compiles shader code to SPIR-V bytecode.  The bytecode can be passed to `lovr.graphics.newShader` to create shaders, which will be faster than creating it from GLSL. The bytecode is portable, so bytecode compiled on one platform will work on other platforms. This allows shaders to be precompiled in a build step.
---@see lovr.graphics.newShader
---@see Shader
---@param stage ShaderStage # The type of shader to compile.
---@param source string | Blob # A string, filename, or Blob with shader code.
---@return Blob # A Blob containing compiled SPIR-V code.
function graphics.compileShader(stage, source) end

--- Returns the global background color.  The textures in a render pass will be cleared to this color at the beginning of the pass if no other clear option is specified.  Additionally, the headset and window will be cleared to this color before rendering.
---@see lovr.graphics.newPass
---@see Pass.setClear
---@see Texture.clear
---@see Pass.fill
---@return number # The red component of the background color.
---@return number # The green component of the background color.
---@return number # The blue component of the background color.
---@return number # The alpha component of the background color.
function graphics.getBackgroundColor() end

--- Returns the default Font.  The default font is Varela Round, created at 32px with a spread value of `4.0`.  It's used by `Pass:text` if no Font is provided.
---@see Pass.text
---@see lovr.graphics.newFont
---@return Font # The default Font object.
function graphics.getDefaultFont() end

--- Returns information about the graphics device and driver.
---@see lovr.graphics.getFeatures
---@see lovr.graphics.getLimits
---@return table
function graphics.getDevice() end

--- Returns a table indicating which features are supported by the GPU.
---@see lovr.graphics.isFormatSupported
---@see lovr.graphics.getDevice
---@see lovr.graphics.getLimits
---@return table # 
function graphics.getFeatures() end

--- Returns limits of the current GPU.
---@see lovr.graphics.isFormatSupported
---@see lovr.graphics.getDevice
---@see lovr.graphics.getFeatures
---@return table # 
function graphics.getLimits() end

--- Returns the window pass.  This is a builtin render `Pass` object that renders to the desktop window texture.  If the desktop window was not open when the graphics module was initialized, this function will return `nil`.
---@return Pass | nil # The window pass, or `nil` if there is no window.
function graphics.getWindowPass() end

--- Returns the type of operations the GPU supports for a texture format, if any.
---@see lovr.graphics.getDevice
---@see lovr.graphics.getFeatures
---@see lovr.graphics.getLimits
---@param format TextureFormat # The texture format to query.
---@param ... TextureFeature # Zero or more features to check.  If no features are given, this function will return whether the GPU supports *any* feature for this format.  Otherwise, this function will only return true if *all* of the input features are supported.
---@return boolean # Whether the GPU supports these operations for textures with this format, when created with the `linear` flag set to `true`.
---@return boolean # Whether the GPU supports these operations for textures with this format, when created with the `linear` flag set to `false`.
function graphics.isFormatSupported(format, ...) end

--- Returns whether the **super experimental** HDR mode is active.
--- To enable HDR, add `t.graphics.hdr` to `lovr.conf`.  When enabled, LÖVR will try to create an HDR10 window.  If the GPU supports it, then this function will return true and the window texture will be HDR:
--- - Its format will be `rgb10a2` instead of `rgba8`.
--- - The display will assume its colors are in the Rec.2020 color space, instead of sRGB.
--- - The display will assume its colors are encoded with the PQ transfer function, instead of sRGB.
--- For now, it's up to you to write PQ-encoded Rec.2020 color data from your shader when rendering to the window.
---@return boolean # Whether HDR is enabled.
function graphics.isHDR() end

--- Returns whether timing stats are enabled.  When enabled, `Pass:getStats` will return `submitTime` and `gpuTime` durations.  Timing is enabled by default when `t.graphics.debug` is set in `lovr.conf`.  Timing has a small amount of overhead, so it should only be enabled when needed.
---@see Pass.getStats
---@return boolean # Whether timing is enabled.
function graphics.isTimingEnabled() end

--- Creates a Buffer.
---@see Shader.getBufferFormat
---@param size number # The size of the Buffer, in bytes.
---@return Buffer # The new Buffer.
---@overload fun(blob: Blob): Buffer
---@overload fun(format: table | DataType, length?: number): Buffer
---@overload fun(format: table | DataType, data: table | Blob): Buffer
function graphics.newBuffer(size) end

--- Creates a new Font.
---@see lovr.graphics.getDefaultFont
---@see lovr.data.newRasterizer
---@see Pass.text
---@param file string | Blob # A filename or Blob containing a TTF or BMFont file.
---@param size number? # The size of the Font in pixels (TTF only).  Larger sizes are slower to initialize and use more memory, but have better quality. (default: 32)
---@param spread number? # For signed distance field fonts (currently all fonts), the width of the SDF, in pixels.  The greater the distance the font is viewed from, the larger this value needs to be for the font to remain properly antialiased.  Increasing this will have a performance penalty similar to increasing the size of the font. (default: 4)
---@return Font # The new Font.
---@overload fun(size?: number, spread?: number): Font
---@overload fun(rasterizer: Rasterizer, spread?: number): Font
function graphics.newFont(file, size, spread) end

--- Creates a new Material from a table of properties and textures.  All fields are optional.  Once a Material is created, its properties can not be changed.  Instead, a new Material should be created with the updated properties.
---@param properties table # Material properties.
---@return Material # The new material.
function graphics.newMaterial(properties) end

--- Creates a Mesh.  The capacity of the Mesh must be provided upfront, using either a vertex count or the vertex data itself.  A custom vertex format can be given to specify the set of attributes in each vertex, which get sent to the vertex shader.  If the format isn't given, the default vertex format will be used:
---     {
---       { 'VertexPosition', 'vec3' },
---       { 'VertexNormal', 'vec3' },
---       { 'VertexUV', 'vec2' }
---     }
---@see lovr.graphics.newBuffer
---@see lovr.graphics.newModel
---@param count number # The number of vertices in the Mesh.
---@param storage MeshStorage? # The storage mode of the Mesh. (default: 'cpu')
---@return Mesh # The new Mesh.
---@overload fun(vertices: table, storage?: MeshStorage): Mesh
---@overload fun(blob: Blob, storage?: MeshStorage): Mesh
---@overload fun(format: table, count: number, storage?: MeshStorage): Mesh
---@overload fun(format: table, vertices: table, storage?: MeshStorage): Mesh
---@overload fun(format: table, blob: Blob, storage?: MeshStorage): Mesh
---@overload fun(buffer: Buffer): Mesh
function graphics.newMesh(count, storage) end

--- Loads a 3D model from a file.  Currently, OBJ, glTF, and binary STL files are supported.
---@see lovr.data.newModelData
---@see Pass.draw
---@param file string | Blob # A filename or Blob containing 3D model data to import.
---@param options table? # An optional table of Model options. (default: nil)
---@return Model # The new Model.
---@overload fun(modelData: ModelData, options?: table): Model
function graphics.newModel(file, options) end

--- Creates and returns a new Pass object.  The canvas (the set of textures the Pass renders to) can be specified when creating the Pass, or later using `Pass:setCanvas`.
---@see lovr.graphics.submit
---@see lovr.graphics.getWindowPass
---@see lovr.headset.getPass
---@param ... Texture # One or more textures the pass will render to.  This can be changed later using `Pass:setCanvas`.
---@return Pass # The new Pass.
---@overload fun(canvas: table): Pass
---@overload fun(): Pass
function graphics.newPass(...) end

--- Creates a new Sampler.  Samplers are immutable, meaning their parameters can not be changed after the sampler is created.  Instead, a new sampler should be created with the updated properties.
---@see Pass.setSampler
---@param parameters table # Parameters for the sampler.
---@return Sampler # The new sampler.
function graphics.newSampler(parameters) end

--- Creates a Shader, which is a small program that runs on the GPU.
--- Shader code is usually written in GLSL and compiled to SPIR-V bytecode.  SPIR-V is faster to load but requires a build step.  Either form can be used to create a shader.
--- By default, the provided shader code is expected to implement a `vec4 lovrmain() { ... }` function that is called for each vertex or fragment.  If the `raw` option is set to `true`, the code is treated as a raw shader and the `lovrmain` function is not required. In this case, the shader code is expected to implement its own `main` function.
---@see lovr.graphics.compileShader
---@see ShaderType
---@see ShaderStage
---@param vertex string | DefaultShader | Blob # A string, path to a file, or Blob containing GLSL or SPIR-V code for the vertex stage.  Can also be a `DefaultShader` to use that shader's vertex code.
---@param fragment string | DefaultShader | Blob # A string, path to a file, or Blob containing GLSL or SPIR-V code for the fragment stage. Can also be a `DefaultShader` to use that shader's fragment code.
---@param options table? # An optional table of Shader options. (default: nil)
---@return Shader # The new shader.
---@overload fun(compute: string | Blob, options?: table): Shader
---@overload fun(defaultshader: DefaultShader, options?: table): Shader
function graphics.newShader(vertex, fragment, options) end

--- Creates a new Texture.  Image filenames or `Image` objects can be used to provide the initial pixel data and the dimensions, format, and type.  Alternatively, dimensions can be provided, which will create an empty texture.
---@see lovr.graphics.newTextureView
---@param file string | Blob # A filename or Blob containing an image file to load.
---@param options table? # Texture options. (default: nil)
---@return Texture # The new Texture.
---@overload fun(width: number, height: number, options?: table): Texture
---@overload fun(width: number, height: number, layers: number, options?: table): Texture
---@overload fun(image: string, options?: table): Texture
---@overload fun(images: (string|Blob|Image)[], options?: table): Texture
function graphics.newTexture(file, options) end

--- Creates a new Texture view.  A texture view does not store any pixels on its own, but instead uses the pixel data of a "parent" Texture object.  The width, height, format, sample count, and usage flags all match the parent.  The view may have a different `TextureType`, and it may reference a subset of the parent texture's layers and mipmap levels.
--- Texture views are used for:
--- - Reinterpretation of texture contents.  For example, a cubemap can be treated as an array
---   texture.
--- - Rendering to a particular array layer or mipmap level of a texture.
--- - Binding a particular range of layers or mipmap levels to a shader.
---@see lovr.graphics.newTexture
---@param parent Texture # The parent Texture to create a view of.
---@param options table? # Options for the texture view. (default: nil)
---@return Texture # The new texture view.
function graphics.newTextureView(parent, options) end

--- Presents the window texture to the desktop window.  This function is called automatically by the default implementation of `lovr.run`, so it normally does not need to be called.
---@see lovr.graphics.submit
---@see lovr.graphics.getWindowPass
function graphics.present() end

--- Changes the global background color.  The textures in a render pass will be cleared to this color at the beginning of the pass if no other clear option is specified.  Additionally, the headset and window will be cleared to this color before rendering.
---@see lovr.graphics.newPass
---@see Pass.setClear
---@see Texture.clear
---@see Pass.fill
---@param r number # The red component of the background color.
---@param g number # The green component of the background color.
---@param b number # The blue component of the background color.
---@param a number? # The alpha component of the background color. (default: 1.0)
---@overload fun(hex: number, a?: number)
---@overload fun(table: number[])
function graphics.setBackgroundColor(r, g, b, a) end

--- Enables or disables timing stats.  When enabled, `Pass:getStats` will return `submitTime` and `gpuTime` durations.  Timing is enabled by default when `t.graphics.debug` is set in `lovr.conf`.  Timing has a small amount of overhead, so it should only be enabled when needed.
---@see Pass.getStats
---@param enable boolean # Whether timing should be enabled.
function graphics.setTimingEnabled(enable) end

--- Submits work to the GPU.
---@see lovr.graphics.wait
---@param ... Pass | boolean | nil # The pass objects to submit.  Falsy values will be skipped.
---@return boolean # Always returns true, for convenience when returning from `lovr.draw`.
---@overload fun(t: (Pass|boolean)[]): boolean
function graphics.submit(...) end

--- Waits for all submitted GPU work to finish.  A normal application that is trying to render graphics at a high framerate should never use this function, since waiting like this prevents the CPU from doing other useful work.  Otherwise, reasons to use this function might be for debugging or to force a `Readback` to finish immediately.
---@see lovr.graphics.submit
function graphics.wait() end

_G.lovr.graphics = graphics
