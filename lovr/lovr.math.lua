---@meta lovr.math

--- The `lovr.math` module provides math helpers commonly used for 3D applications.
---@class lovr.math
local math = {}

---@class Curve
local Curve = {}

--- Inserts a new control point into the Curve at the specified index.
---@see Curve.getPointCount
---@see Curve.getPoint
---@see Curve.setPoint
---@see Curve.removePoint
---@param x number # The x coordinate of the control point.
---@param y number # The y coordinate of the control point.
---@param z number # The z coordinate of the control point.
---@param index number? # The index to insert the control point at.  If nil, the control point is added to the end of the list of control points. (default: nil)
function Curve:addPoint(x, y, z, index) end

--- Returns a point on the Curve given a parameter `t` from 0 to 1.  0 will return the first control point, 1 will return the last point, .5 will return a point in the "middle" of the Curve, etc.
---@see Curve.getTangent
---@see Curve.render
---@see Curve.slice
---@param t number # The parameter to evaluate the Curve at.
---@return number # The x position of the point.
---@return number # The y position of the point.
---@return number # The z position of the point.
function Curve:evaluate(t) end

--- Returns a control point of the Curve.
---@see Curve.getPointCount
---@see Curve.setPoint
---@see Curve.addPoint
---@see Curve.removePoint
---@param index number # The index to retrieve.
---@return number # The x coordinate of the control point.
---@return number # The y coordinate of the control point.
---@return number # The z coordinate of the control point.
function Curve:getPoint(index) end

--- Returns the number of control points in the Curve.
---@see Curve.getPoint
---@see Curve.setPoint
---@see Curve.addPoint
---@see Curve.removePoint
---@return number # The number of control points.
function Curve:getPointCount() end

--- Returns a direction vector for the Curve given a parameter `t` from 0 to 1.  0 will return the direction at the first control point, 1 will return the direction at the last point, .5 will return the direction at the "middle" of the Curve, etc.
---@see Curve.evaluate
---@see Curve.render
---@see Curve.slice
---@param t number # Where on the Curve to compute the direction.
---@return number # The x position of the point.
---@return number # The y position of the point.
---@return number # The z position of the point.
function Curve:getTangent(t) end

--- Removes a control point from the Curve.
---@see Curve.getPointCount
---@see Curve.getPoint
---@see Curve.setPoint
---@see Curve.addPoint
---@param index number # The index of the control point to remove.
function Curve:removePoint(index) end

--- Returns a list of points on the Curve.  The number of points can be specified to get a more or less detailed representation, and it is also possible to render a subsection of the Curve.
---@see Curve.evaluate
---@see Curve.slice
---@see Pass.points
---@see Pass.line
---@see Pass.mesh
---@param n number? # The number of points to use. (default: 32)
---@param t1 number? # How far along the curve to start rendering. (default: 0)
---@param t2 number? # How far along the curve to stop rendering. (default: 1)
---@return number[] # A (flat) table of 3D points along the curve.
function Curve:render(n, t1, t2) end

--- Changes the position of a control point on the Curve.
---@see Curve.getPointCount
---@see Curve.getPoint
---@see Curve.addPoint
---@see Curve.removePoint
---@param index number # The index to modify.
---@param x number # The new x coordinate.
---@param y number # The new y coordinate.
---@param z number # The new z coordinate.
function Curve:setPoint(index, x, y, z) end

--- Returns a new Curve created by slicing the Curve at the specified start and end points.
---@see Curve.evaluate
---@see Curve.render
---@param t1 number # The starting point to slice at.
---@param t2 number # The ending point to slice at.
---@return Curve # A new Curve.
function Curve:slice(t1, t2) end

---@class Mat4: number[]
---@operator mul(Mat4): Mat4
---@operator mul(Vec3): Vec3
---@operator mul(Vec4): Vec4
local Mat4 = {}

--- Returns whether a matrix is approximately equal to another matrix.
---@see Vec2.equals
---@see Vec3.equals
---@see Vec4.equals
---@see Quat.equals
---@param n Mat4 # The other matrix.
---@return boolean # Whether the 2 matrices approximately equal each other.
function Mat4:equals(n) end

--- Sets a projection matrix using raw projection angles and clipping planes.
--- This can be used for asymmetric or oblique projections.
---@see Mat4.orthographic
---@see Mat4.perspective
---@see Pass.setProjection
---@param left number # The left half-angle of the projection, in radians.
---@param right number # The right half-angle of the projection, in radians.
---@param up number # The top half-angle of the projection, in radians.
---@param down number # The bottom half-angle of the projection, in radians.
---@param near number # The near plane of the projection.
---@param far number? # The far plane.  Zero is a special value that will set an infinite far plane with a reversed Z range, which improves depth buffer precision and is the default. (default: 0)
---@return Mat4 # The modified matrix.
function Mat4:fov(left, right, up, down, near, far) end

--- Returns the angle/axis rotation of the matrix.
---@see Mat4.getPosition
---@see Mat4.getScale
---@see Mat4.getPose
---@see Mat4.unpack
---@see Mat4.set
---@return number # The number of radians the matrix rotates around its rotation axis.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Mat4:getOrientation() end

--- Returns the position and rotation of the matrix.
---@see Mat4.getPosition
---@see Mat4.getOrientation
---@see Mat4.getScale
---@see Mat4.unpack
---@see Mat4.set
---@return number # The x translation.
---@return number # The y translation.
---@return number # The z translation.
---@return number # The number of radians the matrix rotates around its rotation axis.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Mat4:getPose() end

--- Returns the translation of the matrix.  This is the last column of the matrix.
---@see Mat4.getOrientation
---@see Mat4.getScale
---@see Mat4.getPose
---@see Mat4.unpack
---@see Mat4.set
---@return number # The x translation.
---@return number # The y translation.
---@return number # The z translation.
function Mat4:getPosition() end

--- Returns the scale factor of the matrix.
---@see Mat4.getPosition
---@see Mat4.getOrientation
---@see Mat4.getPose
---@see Mat4.unpack
---@see Mat4.set
---@return number # The x scale.
---@return number # The y scale.
---@return number # The z scale.
function Mat4:getScale() end

--- Resets the matrix to the identity, effectively setting its translation to zero, its scale to 1, and clearing any rotation.
---@see Pass.origin
---@return Mat4 # The modified matrix.
function Mat4:identity() end

--- Inverts the matrix, causing it to represent the opposite of its old transform.
---@return Mat4 # The inverted matrix.
function Mat4:invert() end

--- Sets a view transform matrix that moves and orients camera to look at a target point.
--- This is useful for changing camera position and orientation.
--- The lookAt() function produces same result as target() after matrix inversion.
---@see Mat4.target
---@see Quat.direction
---@param from Vec3 # The position of the viewer.
---@param to Vec3 # The position of the target.
---@param up Vec3? # The up vector of the viewer. (default: Vec3(0, 1, 0))
---@return Mat4 # The modified matrix.
function Mat4:lookAt(from, to, up) end

--- Multiplies this matrix by another value.  Multiplying by a matrix combines their two transforms together.  Multiplying by a vector applies the transformation from the matrix to the vector and returns the vector.
---@see Mat4.translate
---@see Mat4.rotate
---@see Mat4.scale
---@param n Mat4 # The matrix.
---@return Mat4 # The modified matrix.
---@overload fun(self: Mat4, v3: Vec3): Vec3
---@overload fun(self: Mat4, v4: Vec4): Vec4
function Mat4:mul(n) end

--- Sets this matrix to represent an orthographic projection, useful for 2D/isometric rendering.
--- This can be used with `Pass:setProjection`, or it can be sent to a `Shader` for use in GLSL.
---@see Mat4.perspective
---@see Mat4.fov
---@see Pass.setProjection
---@param left number # The left edge of the projection.
---@param right number # The right edge of the projection.
---@param bottom number # The bottom edge of the projection.
---@param top number # The top edge of the projection.
---@param near number # The position of the near clipping plane.
---@param far number # The position of the far clipping plane.
---@return Mat4 # The modified matrix.
---@overload fun(self: Mat4, width: number, height: number, near: number, far: number): Mat4
function Mat4:orthographic(left, right, bottom, top, near, far) end

--- Sets this matrix to represent a perspective projection.
--- This can be used with `Pass:setProjection`, or it can be sent to a `Shader` for use in GLSL.
---@see Mat4.orthographic
---@see Mat4.fov
---@see Pass.setProjection
---@param fov number # The vertical field of view (in radians).
---@param aspect number # The horizontal aspect ratio of the projection (width / height).
---@param near number # The near plane.
---@param far number? # The far plane.  Zero is a special value that will set an infinite far plane with a reversed Z range, which improves depth buffer precision and is the default. (default: 0)
---@return Mat4 # The modified matrix.
function Mat4:perspective(fov, aspect, near, far) end

--- Turns the matrix into a reflection matrix that transforms values as though they were reflected across a plane.
---@param position Vec3 # The position of the plane.
---@param normal Vec3 # The normal vector of the plane.
---@return Mat4 # The reflected matrix.
function Mat4:reflect(position, normal) end

--- Rotates the matrix using a quaternion or an angle/axis rotation.
---@see Mat4.translate
---@see Mat4.scale
---@see Mat4.identity
---@param q Quat # The rotation to apply to the matrix.
---@return Mat4 # The rotated matrix.
---@overload fun(self: Mat4, angle: number, ax?: number, ay?: number, az?: number): Mat4
function Mat4:rotate(q) end

--- Scales the matrix.
---@see Mat4.translate
---@see Mat4.rotate
---@see Mat4.identity
---@param scale Vec3 # The 3D scale to apply.
---@return Mat4 # The modified matrix.
---@overload fun(self: Mat4, sx: number, sy?: number, sz?: number): Mat4
function Mat4:scale(scale) end

--- Sets the components of the matrix from separate position, rotation, and scale arguments or an existing matrix.
---@see Mat4.unpack
---@return Mat4 # The input matrix.
---@overload fun(self: Mat4, n: Mat4): Mat4
---@overload fun(self: Mat4, x: number, y: number, z: number, sx: number, sy: number, sz: number, angle: number, ax: number, ay: number, az: number): Mat4
---@overload fun(self: Mat4, x: number, y: number, z: number, angle: number, ax: number, ay: number, az: number): Mat4
---@overload fun(self: Mat4, position: Vec3, scale: Vec3, rotation: Quat): Mat4
---@overload fun(self: Mat4, position: Vec3, rotation: Quat): Mat4
---@overload fun(self: Mat4, ...: number): Mat4
---@overload fun(self: Mat4, d: number): Mat4
function Mat4:set() end

--- Sets a model transform matrix that moves to `from` and orients model towards `to` point.
--- This is used when rendered model should always point towards a point of interest. The resulting Mat4 object can be used as model pose.
--- The target() function produces same result as lookAt() after matrix inversion.
---@see Mat4.lookAt
---@see Quat.direction
---@param from Vec3 # The position of the viewer.
---@param to Vec3 # The position of the target.
---@param up Vec3? # The up vector of the viewer. (default: Vec3(0, 1, 0))
---@return Mat4 # The modified matrix.
function Mat4:target(from, to, up) end

--- Translates the matrix.
---@see Mat4.rotate
---@see Mat4.scale
---@see Mat4.identity
---@param v Vec3 # The translation vector.
---@return Mat4 # The translated matrix.
---@overload fun(self: Mat4, x: number, y: number, z: number): Mat4
function Mat4:translate(v) end

--- Transposes the matrix, mirroring its values along the diagonal.
---@return Mat4 # The transposed matrix.
function Mat4:transpose() end

--- Returns the components of matrix, either as 10 separated numbers representing the position, scale, and rotation, or as 16 raw numbers representing the individual components of the matrix in column-major order.
---@see Mat4.set
---@see Mat4.getPosition
---@see Mat4.getOrientation
---@see Mat4.getScale
---@see Mat4.getPose
---@param raw boolean? # Whether to return the 16 raw components. (default: false)
---@return number # The requested components of the matrix.
function Mat4:unpack(raw) end

---@class Quat
---@operator mul(Quat): Quat
---@operator mul(Vec3): Vec3
local Quat = {}

--- Conjugates the input quaternion in place, returning the input.  If the quaternion is normalized, this is the same as inverting it.  It negates the (x, y, z) components of the quaternion.
---@return Quat # The inverted quaternion.
function Quat:conjugate() end

--- Creates a new temporary vec3 facing the forward direction, rotates it by this quaternion, and returns the vector.
---@see Mat4.lookAt
---@return Vec3 # The direction vector.
function Quat:direction() end

--- Returns whether a quaternion is approximately equal to another quaternion.
---@see Vec2.equals
---@see Vec3.equals
---@see Vec4.equals
---@see Mat4.equals
---@param r Quat # The other quaternion.
---@return boolean # Whether the 2 quaternions approximately equal each other.
function Quat:equals(r) end

--- Returns the euler angles of the quaternion, in YXZ order.
---@return number # The pitch (x axis rotation).
---@return number # The yaw (y axis rotation).
---@return number # The roll (z axis rotation).
function Quat:getEuler() end

--- Returns the length of the quaternion.
---@see Quat.normalize
---@return number # The length of the quaternion.
function Quat:length() end

--- Multiplies this quaternion by another value.  If the value is a quaternion, the rotations in the two quaternions are applied sequentially and the result is stored in the first quaternion.  If the value is a vector, then the input vector is rotated by the quaternion and returned.
---@param r Quat # A quaternion to combine with the original.
---@return Quat # The modified quaternion.
---@overload fun(self: Quat, v3: Vec3): Vec3
function Quat:mul(r) end

--- Adjusts the values in the quaternion so that its length becomes 1.
---@see Quat.length
---@return Quat # The normalized quaternion.
function Quat:normalize() end

--- Sets the components of the quaternion.  There are lots of different ways to specify the new components, the summary is:
--- - Four numbers can be used to specify an angle/axis rotation, similar to other LÖVR functions.
--- - Four numbers plus the fifth `raw` flag can be used to set the raw values of the quaternion.
--- - An existing quaternion can be passed in to copy its values.
--- - A single direction vector can be specified to turn its direction (relative to the default
---   forward direction of "negative z") into a rotation.
--- - Two direction vectors can be specified to set the quaternion equal to the rotation between the
---   two vectors.
--- - A matrix can be passed in to extract the rotation of the matrix into a quaternion.
---@see Quat.unpack
---@param angle number? # The angle to use for the rotation, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 0)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param raw boolean? # Whether the components should be interpreted as raw `(x, y, z, w)` components. (default: false)
---@return Quat # The modified quaternion.
---@overload fun(self: Quat, r: Quat): Quat
---@overload fun(self: Quat, v: Vec3): Quat
---@overload fun(self: Quat, v: Vec3, u: Vec3): Quat
---@overload fun(self: Quat, m: Mat4): Quat
---@overload fun(self: Quat): Quat
function Quat:set(angle, ax, ay, az, raw) end

--- Sets the value of the quaternion using euler angles.  The rotation order is YXZ.
---@param pitch number # The pitch (x axis rotation).
---@param yaw number # The yaw (y axis rotation).
---@param roll number # The roll (z axis rotation).
---@return Quat # The modified quaternion.
function Quat:setEuler(pitch, yaw, roll) end

--- Performs a spherical linear interpolation between this quaternion and another one, which can be used for smoothly animating between two rotations.
--- The amount of interpolation is controlled by a parameter `t`.  A `t` value of zero leaves the original quaternion unchanged, whereas a `t` of one sets the original quaternion exactly equal to the target.  A value between `0` and `1` returns a rotation between the two based on the value.
---@see Vec3.lerp
---@param r Quat # The quaternion to slerp towards.
---@param t number # The lerping parameter.
---@return Quat # The modified quaternion, containing the new lerped values.
function Quat:slerp(r, t) end

--- Returns the components of the quaternion as numbers, either in an angle/axis representation or as raw quaternion values.
---@see Quat.set
---@param raw boolean? # Whether the values should be returned as raw values instead of angle/axis. (default: false)
---@return number # The angle in radians, or the x value.
---@return number # The x component of the rotation axis or the y value.
---@return number # The y component of the rotation axis or the z value.
---@return number # The z component of the rotation axis or the w value.
function Quat:unpack(raw) end

---@class RandomGenerator
local RandomGenerator = {}

--- Returns the seed used to initialize the RandomGenerator.
---@see lovr.math.newRandomGenerator
---@return number # The lower 32 bits of the seed.
---@return number # The upper 32 bits of the seed.
function RandomGenerator:getSeed() end

--- Returns the current state of the RandomGenerator.  This can be used with `RandomGenerator:setState` to reliably restore a previous state of the generator.
---@return string # The serialized state.
function RandomGenerator:getState() end

--- Returns the next uniformly distributed pseudo-random number from the RandomGenerator's sequence.
---@see lovr.math.random
---@see RandomGenerator.randomNormal
---@return number # A pseudo-random number.
---@overload fun(self: RandomGenerator, high: number): number
---@overload fun(self: RandomGenerator, low: number, high: number): number
function RandomGenerator:random() end

--- Returns a pseudo-random number from a normal distribution (a bell curve).  You can control the center of the bell curve (the mean value) and the overall width (sigma, or standard deviation).
---@see lovr.math.randomNormal
---@see RandomGenerator.random
---@param sigma number? # The standard deviation of the distribution.  This can be thought of how "wide" the range of numbers is or how much variability there is. (default: 1)
---@param mu number? # The average value returned. (default: 0)
---@return number # A normally distributed pseudo-random number.
function RandomGenerator:randomNormal(sigma, mu) end

--- Seed the RandomGenerator with a new seed.  Each seed will cause the RandomGenerator to produce a unique sequence of random numbers.
---@param seed number # The random seed.
---@overload fun(self: RandomGenerator, low: number, high: number)
function RandomGenerator:setSeed(seed) end

--- Sets the state of the RandomGenerator, as previously obtained using `RandomGenerator:getState`. This can be used to reliably restore a previous state of the generator.
---@param state string # The serialized state.
function RandomGenerator:setState(state) end

---@class Vec2
---@field x number
---@field y number
---@operator add(Vec2): Vec2
---@operator div(Vec2): Vec2
---@operator mul(Vec2): Vec2
---@operator sub(Vec2): Vec2
local Vec2 = {}

--- Adds a vector or a number to the vector.
---@see Vec2.sub
---@see Vec2.mul
---@see Vec2.div
---@param u Vec2 # The other vector.
---@return Vec2 # The modified vector.
---@overload fun(self: Vec2, x: number, y?: number): Vec2
function Vec2:add(u) end

--- Returns the angle between vectors.
---@see Vec2.distance
---@see Vec2.length
---@param u Vec2 # The other vector.
---@return number # The angle to the other vector, in radians.
---@overload fun(self: Vec2, x: number, y: number): number
function Vec2:angle(u) end

--- Returns the distance to another vector.
---@see Vec2.angle
---@see Vec2.length
---@param u Vec2 # The vector to measure the distance to.
---@return number # The distance to `u`.
---@overload fun(self: Vec2, x: number, y: number): number
function Vec2:distance(u) end

--- Divides the vector by a vector or a number.
---@see Vec2.add
---@see Vec2.sub
---@see Vec2.mul
---@param u Vec2 # The other vector to divide the components by.
---@return Vec2 # The modified vector.
---@overload fun(self: Vec2, x: number, y?: number): Vec2
function Vec2:div(u) end

--- Returns the dot product between this vector and another one.
---@param u Vec2 # The vector to compute the dot product with.
---@return number # The dot product between `v` and `u`.
---@overload fun(self: Vec2, x: number, y: number): number
function Vec2:dot(u) end

--- Returns whether a vector is approximately equal to another vector.
---@see Vec3.equals
---@see Vec4.equals
---@see Quat.equals
---@see Mat4.equals
---@param u Vec2 # The other vector.
---@return boolean # Whether the 2 vectors approximately equal each other.
---@overload fun(self: Vec2, x: number, y: number): boolean
function Vec2:equals(u) end

--- Returns the length of the vector.
---@see Vec2.normalize
---@see Vec2.distance
---@return number # The length of the vector.
function Vec2:length() end

--- Performs a linear interpolation between this vector and another one, which can be used to smoothly animate between two vectors, based on a parameter value.  A parameter value of `0` will leave the vector unchanged, a parameter value of `1` will set the vector to be equal to the input vector, and a value of `.5` will set the components to be halfway between the two vectors.
---@see Quat.slerp
---@param u Vec2 # The vector to lerp towards.
---@param t number # The lerping parameter.
---@return Vec2 # The interpolated vector.
---@overload fun(self: Vec2, x: number, y: number, t: number): Vec2
function Vec2:lerp(u, t) end

--- Multiplies the vector by a vector or a number.
---@see Vec2.add
---@see Vec2.sub
---@see Vec2.div
---@param u Vec2 # The other vector to multiply the components by.
---@return Vec2 # The modified vector.
---@overload fun(self: Vec2, x: number, y?: number): Vec2
function Vec2:mul(u) end

--- Adjusts the values in the vector so that its direction stays the same but its length becomes 1.
---@see Vec2.length
---@return Vec2 # The normalized vector.
function Vec2:normalize() end

--- Sets the components of the vector, either from numbers or an existing vector.
---@see Vec2.unpack
---@param x number? # The new x value of the vector. (default: 0)
---@param y number? # The new y value of the vector. (default: x)
---@return Vec2 # The input vector.
---@overload fun(self: Vec2, u: Vec2): Vec2
function Vec2:set(x, y) end

--- Subtracts a vector or a number from the vector.
---@see Vec2.add
---@see Vec2.mul
---@see Vec2.div
---@param u Vec2 # The other vector.
---@return Vec2 # The modified vector.
---@overload fun(self: Vec2, x: number, y?: number): Vec2
function Vec2:sub(u) end

--- Returns the 2 components of the vector as numbers.
---@see Vec2.set
---@return number # The x value.
---@return number # The y value.
function Vec2:unpack() end

---@class Vec3
---@field x number
---@field y number
---@field z number
---@operator add(Vec3): Vec3
---@operator div(Vec3): Vec3
---@operator mul(Vec3): Vec3
---@operator sub(Vec3): Vec3
local Vec3 = {}

--- Adds a vector or a number to the vector.
---@see Vec3.sub
---@see Vec3.mul
---@see Vec3.div
---@param u Vec3 # The other vector.
---@return Vec3 # The modified vector.
---@overload fun(self: Vec3, x: number, y?: number, z?: number): Vec3
function Vec3:add(u) end

--- Returns the angle between vectors.
---@see Vec3.distance
---@see Vec3.length
---@param u Vec3 # The other vector.
---@return number # The angle to the other vector, in radians.
---@overload fun(self: Vec3, x: number, y: number, z: number): number
function Vec3:angle(u) end

--- Sets this vector to be equal to the cross product between this vector and another one.  The new `v` will be perpendicular to both the old `v` and `u`.
---@see Vec3.dot
---@param u Vec3 # The vector to compute the cross product with.
---@return Vec3 # The modified vector.
---@overload fun(self: Vec3, x: number, y: number, z: number): Vec3
function Vec3:cross(u) end

--- Returns the distance to another vector.
---@see Vec3.angle
---@see Vec3.length
---@param u Vec3 # The vector to measure the distance to.
---@return number # The distance to `u`.
---@overload fun(self: Vec3, x: number, y: number, z: number): number
function Vec3:distance(u) end

--- Divides the vector by a vector or a number.
---@see Vec3.add
---@see Vec3.sub
---@see Vec3.mul
---@param u Vec3 # The other vector to divide the components by.
---@return Vec3 # The modified vector.
---@overload fun(self: Vec3, x: number, y?: number, z?: number): Vec3
function Vec3:div(u) end

--- Returns the dot product between this vector and another one.
---@see Vec3.cross
---@param u Vec3 # The vector to compute the dot product with.
---@return number # The dot product between `v` and `u`.
---@overload fun(self: Vec3, x: number, y: number, z: number): number
function Vec3:dot(u) end

--- Returns whether a vector is approximately equal to another vector.
---@see Vec2.equals
---@see Vec4.equals
---@see Quat.equals
---@see Mat4.equals
---@param u Vec3 # The other vector.
---@return boolean # Whether the 2 vectors approximately equal each other.
---@overload fun(self: Vec3, x: number, y: number, z: number): boolean
function Vec3:equals(u) end

--- Returns the length of the vector.
---@see Vec3.normalize
---@see Vec3.distance
---@return number # The length of the vector.
function Vec3:length() end

--- Performs a linear interpolation between this vector and another one, which can be used to smoothly animate between two vectors, based on a parameter value.  A parameter value of `0` will leave the vector unchanged, a parameter value of `1` will set the vector to be equal to the input vector, and a value of `.5` will set the components to be halfway between the two vectors.
---@see Quat.slerp
---@param u Vec3 # The vector to lerp towards.
---@param t number # The lerping parameter.
---@return Vec3 # The interpolated vector.
---@overload fun(self: Vec3, x: number, y: number, z: number, t: number): Vec3
function Vec3:lerp(u, t) end

--- Multiplies the vector by a vector or a number.
---@see Vec3.add
---@see Vec3.sub
---@see Vec3.div
---@param u Vec3 # The other vector to multiply the components by.
---@return Vec3 # The modified vector.
---@overload fun(self: Vec3, x: number, y?: number, z?: number): Vec3
function Vec3:mul(u) end

--- Adjusts the values in the vector so that its direction stays the same but its length becomes 1.
---@see Vec3.length
---@return Vec3 # The normalized vector.
function Vec3:normalize() end

--- Applies a rotation to the vector, using a `Quat` or an angle/axis rotation.
---@see Quat.mul
---@param q Quat # The quaternion to apply.
---@return Vec3 # The modified vector.
---@overload fun(self: Vec3, angle: number, ax: number, ay: number, az: number): Vec3
function Vec3:rotate(q) end

--- Sets the components of the vector, either from numbers or an existing vector.
---@see Vec3.unpack
---@param x number? # The new x value of the vector. (default: 0)
---@param y number? # The new y value of the vector. (default: x)
---@param z number? # The new z value of the vector. (default: x)
---@return Vec3 # The input vector.
---@overload fun(self: Vec3, u: Vec3): Vec3
---@overload fun(self: Vec3, q: Quat): Vec3
---@overload fun(self: Vec3, m: Mat4): Vec3
function Vec3:set(x, y, z) end

--- Subtracts a vector or a number from the vector.
---@see Vec3.add
---@see Vec3.mul
---@see Vec3.div
---@param u Vec3 # The other vector.
---@return Vec3 # The modified vector.
---@overload fun(self: Vec3, x: number, y?: number, z?: number): Vec3
function Vec3:sub(u) end

--- Applies a transform (translation, rotation, scale) to the vector using a `Mat4` or numbers. This is the same as multiplying the vector by a matrix.  This treats the vector as a point.
---@see Mat4.mul
---@see Vec4.transform
---@see Vec3.rotate
---@param m Mat4 # The matrix to apply.
---@return Vec3 # The original vector, with transformed components.
---@overload fun(self: Vec3, x?: number, y?: number, z?: number, scale?: number, angle?: number, ax?: number, ay?: number, az?: number): Vec3
---@overload fun(self: Vec3, translation: Vec3, scale?: number, rotation: Quat): Vec3
function Vec3:transform(m) end

--- Returns the 3 components of the vector as numbers.
---@see Vec3.set
---@return number # The x value.
---@return number # The y value.
---@return number # The z value.
function Vec3:unpack() end

---@class Vec4
---@field x number
---@field y number
---@field z number
---@field w number
---@operator add(Vec4): Vec4
---@operator div(Vec4): Vec4
---@operator mul(Vec4): Vec4
---@operator sub(Vec4): Vec4
local Vec4 = {}

--- Adds a vector or a number to the vector.
---@see Vec4.sub
---@see Vec4.mul
---@see Vec4.div
---@param u Vec4 # The other vector.
---@return Vec4 # The modified vector.
---@overload fun(self: Vec4, x: number, y?: number, z?: number, w?: number): Vec4
function Vec4:add(u) end

--- Returns the angle between vectors.
---@see Vec4.distance
---@see Vec4.length
---@param u Vec4 # The other vector.
---@return number # The angle to other vector, in radians.
---@overload fun(self: Vec4, x: number, y: number, z: number, w: number): number
function Vec4:angle(u) end

--- Returns the distance to another vector.
---@see Vec4.angle
---@see Vec4.length
---@param u Vec4 # The vector to measure the distance to.
---@return number # The distance to `u`.
---@overload fun(self: Vec4, x: number, y: number, z: number, w: number): number
function Vec4:distance(u) end

--- Divides the vector by a vector or a number.
---@see Vec4.add
---@see Vec4.sub
---@see Vec4.mul
---@param u Vec4 # The other vector to divide the components by.
---@return Vec4 # The modified vector.
---@overload fun(self: Vec4, x: number, y?: number, z?: number, w?: number): Vec4
function Vec4:div(u) end

--- Returns the dot product between this vector and another one.
---@param u Vec4 # The vector to compute the dot product with.
---@return number # The dot product between `v` and `u`.
---@overload fun(self: Vec4, x: number, y: number, z: number, w: number): number
function Vec4:dot(u) end

--- Returns whether a vector is approximately equal to another vector.
---@see Vec2.equals
---@see Vec3.equals
---@see Quat.equals
---@see Mat4.equals
---@param u Vec4 # The other vector.
---@return boolean # Whether the 2 vectors approximately equal each other.
---@overload fun(self: Vec4, x: number, y: number, z: number, w: number): boolean
function Vec4:equals(u) end

--- Returns the length of the vector.
---@see Vec4.normalize
---@see Vec4.distance
---@return number # The length of the vector.
function Vec4:length() end

--- Performs a linear interpolation between this vector and another one, which can be used to smoothly animate between two vectors, based on a parameter value.  A parameter value of `0` will leave the vector unchanged, a parameter value of `1` will set the vector to be equal to the input vector, and a value of `.5` will set the components to be halfway between the two vectors.
---@see Quat.slerp
---@param u Vec4 # The vector to lerp towards.
---@param t number # The lerping parameter.
---@return Vec4 # The interpolated vector.
---@overload fun(self: Vec4, x: number, y: number, z: number, w: number, t: number): Vec4
function Vec4:lerp(u, t) end

--- Multiplies the vector by a vector or a number.
---@see Vec4.add
---@see Vec4.sub
---@see Vec4.div
---@param u Vec4 # The other vector to multiply the components by.
---@return Vec4 # The modified vector.
---@overload fun(self: Vec4, x: number, y?: number, z?: number, w?: number): Vec4
function Vec4:mul(u) end

--- Adjusts the values in the vector so that its direction stays the same but its length becomes 1.
---@see Vec4.length
---@return Vec4 # The normalized vector.
function Vec4:normalize() end

--- Sets the components of the vector, either from numbers or an existing vector.
---@see Vec4.unpack
---@param x number? # The new x value of the vector. (default: 0)
---@param y number? # The new y value of the vector. (default: x)
---@param z number? # The new z value of the vector. (default: x)
---@param w number? # The new w value of the vector. (default: x)
---@return Vec4 # The input vector.
---@overload fun(self: Vec4, u: Vec4): Vec4
function Vec4:set(x, y, z, w) end

--- Subtracts a vector or a number from the vector.
---@see Vec4.add
---@see Vec4.mul
---@see Vec4.div
---@param u Vec4 # The other vector.
---@return Vec4 # The modified vector.
---@overload fun(self: Vec4, x: number, y?: number, z?: number, w?: number): Vec4
function Vec4:sub(u) end

--- Applies a transform (translation, rotation, scale) to the vector using a `Mat4` or numbers. This is the same as multiplying the vector by a matrix.
---@see Mat4.mul
---@see Vec3.transform
---@param m Mat4 # The matrix to apply.
---@return Vec4 # The original vector, with transformed components.
---@overload fun(self: Vec4, x?: number, y?: number, z?: number, scale?: number, angle?: number, ax?: number, ay?: number, az?: number): Vec4
---@overload fun(self: Vec4, translation: Vec3, scale?: number, rotation: Quat): Vec4
function Vec4:transform(m) end

--- Returns the 4 components of the vector as numbers.
---@see Vec4.set
---@return number # The x value.
---@return number # The y value.
---@return number # The z value.
---@return number # The w value.
function Vec4:unpack() end

---@class Vectors
local Vectors = {}

--- Drains the temporary vector pool, invalidating existing temporary vectors.
--- This is called automatically at the end of each frame.
function math.drain() end

--- Converts a color from gamma space to linear space.
---@see lovr.math.linearToGamma
---@param gr number # The red component of the gamma-space color.
---@param gg number # The green component of the gamma-space color.
---@param gb number # The blue component of the gamma-space color.
---@return number # The red component of the resulting linear-space color.
---@return number # The green component of the resulting linear-space color.
---@return number # The blue component of the resulting linear-space color.
---@overload fun(color: number[]): number, number, number
---@overload fun(x: number): number
function math.gammaToLinear(gr, gg, gb) end

--- Get the seed used to initialize the random generator.
---@return number # The new seed.
function math.getRandomSeed() end

--- Converts a color from linear space to gamma space.
---@see lovr.math.gammaToLinear
---@param lr number # The red component of the linear-space color.
---@param lg number # The green component of the linear-space color.
---@param lb number # The blue component of the linear-space color.
---@return number # The red component of the resulting gamma-space color.
---@return number # The green component of the resulting gamma-space color.
---@return number # The blue component of the resulting gamma-space color.
---@overload fun(color: number[]): number, number, number
---@overload fun(x: number): number
function math.linearToGamma(lr, lg, lb) end

--- Creates a temporary 4D matrix.  This function takes the same arguments as `Mat4:set`.
---@see lovr.math.newMat4
---@see Mat4
---@see Vectors
---@return Mat4 # The new matrix.
---@overload fun(n: Mat4): Mat4
---@overload fun(position?: Vec3, scale?: Vec3, rotation?: Quat): Mat4
---@overload fun(position?: Vec3, rotation?: Quat): Mat4
---@overload fun(...: number): Mat4
---@overload fun(d: number): Mat4
function math.mat4() end

--- Creates a new `Curve` from a list of control points.
---@param x number # The x coordinate of the first control point.
---@param y number # The y coordinate of the first control point.
---@param z number # The z coordinate of the first control point.
---@param ... any # Additional control points.
---@return Curve # The new Curve.
---@overload fun(v: Vec3, ...: any): Curve
---@overload fun(points: table): Curve
---@overload fun(n: number): Curve
function math.newCurve(x, y, z, ...) end

--- Creates a new 4D matrix.  This function takes the same arguments as `Mat4:set`.
---@see lovr.math.mat4
---@see Mat4
---@see Vectors
---@return Mat4 # The new matrix.
---@overload fun(n: Mat4): Mat4
---@overload fun(position?: Vec3, scale?: Vec3, rotation?: Quat): Mat4
---@overload fun(position?: Vec3, rotation?: Quat): Mat4
---@overload fun(...: number): Mat4
---@overload fun(d: number): Mat4
function math.newMat4() end

--- Creates a new quaternion.  This function takes the same arguments as `Quat:set`.
---@see lovr.math.quat
---@see Quat
---@see Vectors
---@param angle number? # An angle to use for the rotation, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 0)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param raw boolean? # Whether the components should be interpreted as raw `(x, y, z, w)` components. (default: false)
---@return Quat # The new quaternion.
---@overload fun(r: Quat): Quat
---@overload fun(v: Vec3): Quat
---@overload fun(v: Vec3, u: Vec3): Quat
---@overload fun(m: Mat4): Quat
---@overload fun(): Quat
function math.newQuat(angle, ax, ay, az, raw) end

--- Creates a new `RandomGenerator`, which can be used to generate random numbers. If you just want some random numbers, you can use `lovr.math.random`. Individual RandomGenerator objects are useful if you need more control over the random sequence used or need a random generator isolated from other instances.
---@return RandomGenerator # The new RandomGenerator.
---@overload fun(seed: number): RandomGenerator
---@overload fun(low: number, high: number): RandomGenerator
function math.newRandomGenerator() end

--- Creates a new 2D vector.  This function takes the same arguments as `Vec2:set`.
---@see lovr.math.vec2
---@see Vec2
---@see Vectors
---@param x number? # The x value of the vector. (default: 0)
---@param y number? # The y value of the vector. (default: x)
---@return Vec2 # The new vector.
---@overload fun(u: Vec2): Vec2
function math.newVec2(x, y) end

--- Creates a new 3D vector.  This function takes the same arguments as `Vec3:set`.
---@see lovr.math.vec3
---@see Vec3
---@see Vectors
---@param x number? # The x value of the vector. (default: 0)
---@param y number? # The y value of the vector. (default: x)
---@param z number? # The z value of the vector. (default: x)
---@return Vec3 # The new vector.
---@overload fun(u: Vec3): Vec3
---@overload fun(m: Mat4): Vec3
---@overload fun(q: Quat): Vec3
function math.newVec3(x, y, z) end

--- Creates a new 4D vector.  This function takes the same arguments as `Vec4:set`.
---@see lovr.math.vec4
---@see Vec4
---@see Vectors
---@param x number? # The x value of the vector. (default: 0)
---@param y number? # The y value of the vector. (default: x)
---@param z number? # The z value of the vector. (default: x)
---@param w number? # The w value of the vector. (default: x)
---@return Vec4 # The new vector.
---@overload fun(u: Vec4): Vec4
function math.newVec4(x, y, z, w) end

--- Returns a 1D, 2D, 3D, or 4D simplex noise value.  The number will be between 0 and 1.
---@see lovr.math.random
---@param x number # The x coordinate of the input.
---@return number # The noise value, between 0 and 1.
---@overload fun(x: number, y: number): number
---@overload fun(x: number, y: number, z: number): number
---@overload fun(x: number, y: number, z: number, w: number): number
function math.noise(x) end

--- Creates a temporary quaternion.  This function takes the same arguments as `Quat:set`.
---@see lovr.math.newQuat
---@see Quat
---@see Vectors
---@param angle number? # An angle to use for the rotation, in radians. (default: 0)
---@param ax number? # The x component of the axis of rotation. (default: 0)
---@param ay number? # The y component of the axis of rotation. (default: 0)
---@param az number? # The z component of the axis of rotation. (default: 0)
---@param raw boolean? # Whether the components should be interpreted as raw `(x, y, z, w)` components. (default: false)
---@return Quat # The new quaternion.
---@overload fun(r: Quat): Quat
---@overload fun(v: Vec3): Quat
---@overload fun(v: Vec3, u: Vec3): Quat
---@overload fun(m: Mat4): Quat
---@overload fun(): Quat
function math.quat(angle, ax, ay, az, raw) end

--- Returns a uniformly distributed pseudo-random number.  This function has improved randomness over Lua's `math.random` and also guarantees that the sequence of random numbers will be the same on all platforms (given the same seed).
---@see lovr.math.randomNormal
---@see RandomGenerator
---@see lovr.math.noise
---@return number # A pseudo-random number.
---@overload fun(high: number): number
---@overload fun(low: number, high: number): number
function math.random() end

--- Returns a pseudo-random number from a normal distribution (a bell curve).  You can control the center of the bell curve (the mean value) and the overall width (sigma, or standard deviation).
---@see lovr.math.random
---@see RandomGenerator
---@param sigma number? # The standard deviation of the distribution.  This can be thought of how "wide" the range of numbers is or how much variability there is. (default: 1)
---@param mu number? # The average value returned. (default: 0)
---@return number # A normally distributed pseudo-random number.
function math.randomNormal(sigma, mu) end

--- Seed the random generator with a new seed.  Each seed will cause `lovr.math.random` and `lovr.math.randomNormal` to produce a unique sequence of random numbers.  This is done once automatically at startup by `lovr.run`.
---@param seed number # The new seed.
function math.setRandomSeed(seed) end

--- Creates a temporary 2D vector.  This function takes the same arguments as `Vec2:set`.
---@see lovr.math.newVec2
---@see Vec2
---@see Vectors
---@param x number? # The x value of the vector. (default: 0)
---@param y number? # The y value of the vector. (default: x)
---@return Vec2 # The new vector.
---@overload fun(u: Vec2): Vec2
function math.vec2(x, y) end

--- Creates a temporary 3D vector.  This function takes the same arguments as `Vec3:set`.
---@see lovr.math.newVec3
---@see Vec3
---@see Vectors
---@param x number? # The x value of the vector. (default: 0)
---@param y number? # The y value of the vector. (default: x)
---@param z number? # The z value of the vector. (default: x)
---@return Vec3 # The new vector.
---@overload fun(u: Vec3): Vec3
---@overload fun(m: Mat4): Vec3
---@overload fun(q: Quat): Vec3
function math.vec3(x, y, z) end

--- Creates a temporary 4D vector.  This function takes the same arguments as `Vec4:set`.
---@see lovr.math.newVec4
---@see Vec4
---@see Vectors
---@param x number? # The x value of the vector. (default: 0)
---@param y number? # The y value of the vector. (default: x)
---@param z number? # The z value of the vector. (default: x)
---@param w number? # The w value of the vector. (default: x)
---@return Vec4 # The new vector.
---@overload fun(u: Vec4): Vec4
function math.vec4(x, y, z, w) end

_G.lovr.math = math
