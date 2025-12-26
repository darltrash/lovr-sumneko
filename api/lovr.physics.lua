---@meta lovr.physics

--- The `lovr.physics` module simulates 3D rigid body physics.
---@class lovr.physics: { [any]: any }
local physics = {}

--- Represents the different types of physics Joints available.
---@alias JointType
---| '"ball"' # A BallJoint.
---| '"distance"' # A DistanceJoint.
---| '"hinge"' # A HingeJoint.
---| '"slider"' # A SliderJoint.

--- The different ways the motor on a joint can be used.
---@alias MotorMode
---| '"position"' # The motor drives to a particular value.
---| '"velocity"' # The motor drives to a particular speed.

--- Represents the different types of physics Shapes available.
---@alias ShapeType
---| '"box"' # A box.
---| '"sphere"' # A sphere.
---| '"capsule"' # A capsule (cylinder with rounded ends).
---| '"cylinder"' # A cylinder.
---| '"convex"' # A convex hull.
---| '"mesh"' # A triangle mesh.  Colliders with this shape can not move.
---| '"terrain"' # A heightfield.  Colliders with this shape can not move.

--- Creates a new BallJoint.
---@see lovr.physics.newConeJoint
---@see lovr.physics.newDistanceJoint
---@see lovr.physics.newHingeJoint
---@see lovr.physics.newSliderJoint
---@see lovr.physics.newWeldJoint
---@see lovr.physics
---@overload fun(colliderA: Collider, colliderB: Collider, anchor: Vec3): BallJoint
---@param colliderA Collider # The first collider to attach the Joint to, or `nil` to attach the joint to a fixed position in the World.
---@param colliderB Collider # The second collider to attach the Joint to.
---@param x number # The x position of the joint anchor point, in world coordinates.
---@param y number # The y position of the joint anchor point, in world coordinates.
---@param z number # The z position of the joint anchor point, in world coordinates.
---@return BallJoint # The new BallJoint.
function physics.newBallJoint(colliderA, colliderB, x, y, z) end

--- Creates a new BoxShape.
---@see BoxShape
---@see lovr.physics.newSphereShape
---@see lovr.physics.newCapsuleShape
---@see lovr.physics.newCylinderShape
---@see lovr.physics.newConvexShape
---@see lovr.physics.newMeshShape
---@see lovr.physics.newTerrainShape
---@see lovr.physics
---@param width number? # The width of the box, in meters. (default: 1)
---@param height number? # The height of the box, in meters. (default: width)
---@param depth number? # The depth of the box, in meters. (default: width)
---@return BoxShape # The new BoxShape.
function physics.newBoxShape(width, height, depth) end

--- Creates a new CapsuleShape.  Capsules are cylinders with hemispheres on each end.
---@see CapsuleShape
---@see lovr.physics.newBoxShape
---@see lovr.physics.newSphereShape
---@see lovr.physics.newCylinderShape
---@see lovr.physics.newConvexShape
---@see lovr.physics.newMeshShape
---@see lovr.physics.newTerrainShape
---@see lovr.physics
---@param radius number? # The radius of the capsule, in meters. (default: 1)
---@param length number? # The length of the capsule, not including the caps, in meters. (default: 1)
---@return CapsuleShape # The new CapsuleShape.
function physics.newCapsuleShape(radius, length) end

--- Creates a new ConeJoint.
---@see lovr.physics.newWeldJoint
---@see lovr.physics.newBallJoint
---@see lovr.physics.newDistanceJoint
---@see lovr.physics.newHingeJoint
---@see lovr.physics.newSliderJoint
---@see lovr.physics
---@overload fun(colliderA: Collider, colliderB: Collider, anchor: Vec3, axis: Vec3): ConeJoint
---@param colliderA Collider # The first collider to attach the Joint to, or `nil` to attach the joint to a fixed position in the World.
---@param colliderB Collider # The second collider to attach the Joint to.
---@param x number # The x position of the joint anchor point, in world space.
---@param y number # The y position of the joint anchor point, in world space.
---@param z number # The z position of the joint anchor point, in world space.
---@param ax number # The x component of the cone axis, in world space.
---@param ay number # The y component of the cone axis, in world space.
---@param az number # The z component of the cone axis, in world space.
---@return ConeJoint # The new ConeJoint.
function physics.newConeJoint(colliderA, colliderB, x, y, z, ax, ay, az) end

--- Creates a new ConvexShape.
---@see ConvexShape
---@see lovr.physics.newBoxShape
---@see lovr.physics.newSphereShape
---@see lovr.physics.newCapsuleShape
---@see lovr.physics.newCylinderShape
---@see lovr.physics.newMeshShape
---@see lovr.physics.newTerrainShape
---@see lovr.physics
---@overload fun(modelData: ModelData, scale: number): ConvexShape
---@overload fun(model: Model, scale: number): ConvexShape
---@overload fun(mesh: Mesh, scale: number): ConvexShape
---@overload fun(template: ConvexShape, scale: number): ConvexShape
---@param points table # A list of vertices to compute a convex hull from.  Can be a table of tables (each with 3 numbers) or a table of numbers (every 3 numbers form a 3D point).
---@param scale number? # A scale to apply to the points. (default: 1.0)
---@return ConvexShape # The new ConvexShape.
function physics.newConvexShape(points, scale) end

--- Creates a new CylinderShape.
---@see CylinderShape
---@see lovr.physics.newBoxShape
---@see lovr.physics.newSphereShape
---@see lovr.physics.newCapsuleShape
---@see lovr.physics.newConvexShape
---@see lovr.physics.newMeshShape
---@see lovr.physics.newTerrainShape
---@see lovr.physics
---@param radius number? # The radius of the cylinder, in meters. (default: 1)
---@param length number? # The length of the cylinder, in meters. (default: 1)
---@return CylinderShape # The new CylinderShape.
function physics.newCylinderShape(radius, length) end

--- Creates a new DistanceJoint.
---@see lovr.physics.newBallJoint
---@see lovr.physics.newConeJoint
---@see lovr.physics.newHingeJoint
---@see lovr.physics.newSliderJoint
---@see lovr.physics.newWeldJoint
---@see lovr.physics
---@overload fun(colliderA: Collider, colliderB: Collider, first: Vec3, second: Vec3): DistanceJoint
---@param colliderA Collider # The first collider to attach the Joint to, or `nil` to attach the joint to a fixed position in the World.
---@param colliderB Collider # The second collider to attach the Joint to.
---@param x1 number # The x position of the first anchor point, in world coordinates.
---@param y1 number # The y position of the first anchor point, in world coordinates.
---@param z1 number # The z position of the first anchor point, in world coordinates.
---@param x2 number # The x position of the second anchor point, in world coordinates.
---@param y2 number # The y position of the second anchor point, in world coordinates.
---@param z2 number # The z position of the second anchor point, in world coordinates.
---@return DistanceJoint # The new DistanceJoint.
function physics.newDistanceJoint(colliderA, colliderB, x1, y1, z1, x2, y2, z2) end

--- Creates a new HingeJoint.
---@see lovr.physics.newBallJoint
---@see lovr.physics.newConeJoint
---@see lovr.physics.newDistanceJoint
---@see lovr.physics.newSliderJoint
---@see lovr.physics.newWeldJoint
---@see lovr.physics
---@overload fun(colliderA: Collider, colliderB: Collider, anchor: Vec3, axis: Vec3): HingeJoint
---@param colliderA Collider # The first collider to attach the Joint to, or `nil` to attach the joint to a fixed position in the World.
---@param colliderB Collider # The second collider to attach the Joint to.
---@param x number # The x position of the hinge anchor, in world coordinates.
---@param y number # The y position of the hinge anchor, in world coordinates.
---@param z number # The z position of the hinge anchor, in world coordinates.
---@param ax number # The x component of the hinge axis direction.
---@param ay number # The y component of the hinge axis direction.
---@param az number # The z component of the hinge axis direction.
---@return HingeJoint # The new HingeJoint.
function physics.newHingeJoint(colliderA, colliderB, x, y, z, ax, ay, az) end

--- Creates a new MeshShape.
---@see MeshShape
---@see lovr.physics.newBoxShape
---@see lovr.physics.newSphereShape
---@see lovr.physics.newCapsuleShape
---@see lovr.physics.newCylinderShape
---@see lovr.physics.newConvexShape
---@see lovr.physics.newTerrainShape
---@see Model:getTriangles
---@see lovr.physics
---@overload fun(modelData: ModelData, scale: number): MeshShape
---@overload fun(model: Model, scale: number): MeshShape
---@overload fun(mesh: Mesh, scale: number): MeshShape
---@overload fun(template: MeshShape, scale: number): MeshShape
---@param vertices table # The table of vertices in the mesh.  Each vertex is a table with 3 numbers.
---@param indices table # A table of triangle indices representing how the vertices are connected in the Mesh.
---@param scale number? # A scale to apply to the mesh vertices. (default: 1.0)
---@return MeshShape # The new MeshShape.
function physics.newMeshShape(vertices, indices, scale) end

--- Creates a new SliderJoint.
---@see lovr.physics.newBallJoint
---@see lovr.physics.newConeJoint
---@see lovr.physics.newDistanceJoint
---@see lovr.physics.newHingeJoint
---@see lovr.physics.newWeldJoint
---@see lovr.physics
---@overload fun(colliderA: Collider, colliderB: Collider, axis: Vec3): SliderJoint
---@param colliderA Collider # The first collider to attach the Joint to, or `nil` to attach the joint to a fixed position in the World.
---@param colliderB Collider # The second collider to attach the Joint to.
---@param ax number # The x component of the slider axis.
---@param ay number # The y component of the slider axis.
---@param az number # The z component of the slider axis.
---@return SliderJoint # The new SliderJoint.
function physics.newSliderJoint(colliderA, colliderB, ax, ay, az) end

--- Creates a new SphereShape.
---@see SphereShape
---@see lovr.physics.newBoxShape
---@see lovr.physics.newCapsuleShape
---@see lovr.physics.newCylinderShape
---@see lovr.physics.newConvexShape
---@see lovr.physics.newMeshShape
---@see lovr.physics.newTerrainShape
---@see lovr.physics
---@param radius number? # The radius of the sphere, in meters. (default: 1)
---@return SphereShape # The new SphereShape.
function physics.newSphereShape(radius) end

--- Creates a new TerrainShape.
---@see TerrainShape
---@see lovr.physics.newBoxShape
---@see lovr.physics.newSphereShape
---@see lovr.physics.newCapsuleShape
---@see lovr.physics.newCylinderShape
---@see lovr.physics.newConvexShape
---@see lovr.physics.newMeshShape
---@see lovr.data.newImage
---@see lovr.physics
---@overload fun(scale: number, heightmap: Image, stretch: number): TerrainShape
---@overload fun(scale: number, callback: function, samples: number): TerrainShape
---@param scale number # The width and depth of the terrain, in meters.
---@return TerrainShape # The new TerrainShape.
function physics.newTerrainShape(scale) end

--- Creates a new WeldJoint.
---@see lovr.physics.newBallJoint
---@see lovr.physics.newConeJoint
---@see lovr.physics.newDistanceJoint
---@see lovr.physics.newHingeJoint
---@see lovr.physics.newSliderJoint
---@see lovr.physics
---@param colliderA Collider # The first collider to attach the Joint to, or `nil` to attach the joint to a fixed position in the World.
---@param colliderB Collider # The second collider to attach the Joint to.
---@return WeldJoint # The new WeldJoint.
function physics.newWeldJoint(colliderA, colliderB) end

--- Creates a new physics World.
---@see World:update
---@see lovr.physics
---@param settings table # An optional table with settings for the physics simulation.
---@return World # A whole new World.
function physics.newWorld(settings) end

---@class BallJoint
local BallJoint = {}

---@class BoxShape
local BoxShape = {}

--- Returns the width, height, and depth of the BoxShape.
---@see BoxShape:setDimensions
---@see BoxShape
---@return number # The width of the box, in meters.
---@return number # The height of the box, in meters.
---@return number # The depth of the box, in meters.
function BoxShape:getDimensions() end

--- Sets the width, height, and depth of the BoxShape.
---@see BoxShape:getDimensions
---@see BoxShape
---@param width number # The width of the box, in meters.
---@param height number # The height of the box, in meters.
---@param depth number # The depth of the box, in meters.
function BoxShape:setDimensions(width, height, depth) end

---@class CapsuleShape
local CapsuleShape = {}

--- Returns the length of the CapsuleShape, not including the caps.
---@see CapsuleShape:getRadius
---@see CapsuleShape:setRadius
---@see CapsuleShape:setLength
---@see CapsuleShape
---@return number # The length of the capsule, in meters.
function CapsuleShape:getLength() end

--- Returns the radius of the CapsuleShape.
---@see CapsuleShape:getLength
---@see CapsuleShape:setLength
---@see CapsuleShape:setRadius
---@see CapsuleShape
---@return number # The radius of the capsule, in meters.
function CapsuleShape:getRadius() end

--- Sets the length of the CapsuleShape.
---@see CapsuleShape:getRadius
---@see CapsuleShape:setRadius
---@see CapsuleShape:getLength
---@see CapsuleShape
---@param length number # The new length, in meters, not including the caps.
function CapsuleShape:setLength(length) end

--- Sets the radius of the CapsuleShape.
---@see CapsuleShape:getLength
---@see CapsuleShape:setLength
---@see CapsuleShape:getRadius
---@see CapsuleShape
---@param radius number # The new radius, in meters.
function CapsuleShape:setRadius(radius) end

---@class Collider
local Collider = {}

--- Attaches a Shape to the collider.
---@see Collider:removeShape
---@see Collider:getShapes
---@see Collider:getShape
---@see Shape
---@see Collider
---@param shape Shape # The Shape to attach.
function Collider:addShape(shape) end

--- Applies an angular impulse to the Collider.
--- An impulse is a single instantaneous push.  Impulses are independent of time, and are meant to only be applied once.  Use `Collider:applyTorque` for a time-dependent push that happens over multiple frames.
---@see Collider:applyTorque
---@see Collider:applyForce
---@see Collider:applyLinearImpulse
---@see Collider
---@overload fun(impulse: Vec3)
---@param x number # The x component of the world-space impulse vector, in newton meter seconds.
---@param y number # The y component of the world-space impulse vector, in newton meter seconds.
---@param z number # The z component of the world-space impulse vector, in newton meter seconds.
function Collider:applyAngularImpulse(x, y, z) end

--- Applies a force to the Collider.
---@see Collider:applyLinearImpulse
---@see Collider:applyTorque
---@see Collider:applyAngularImpulse
---@see Collider
---@overload fun(x: number, y: number, z: number, px: number, py: number, pz: number)
---@overload fun(force: Vec3)
---@overload fun(force: Vec3, position: Vec3)
---@param x number # The x component of the world-space force vector, in newtons.
---@param y number # The y component of the world-space force vector, in newtons.
---@param z number # The z component of the world-space force vector, in newtons.
function Collider:applyForce(x, y, z) end

--- Applies a linear impulse to the Collider.
--- An impulse is a single instantaneous push.  Impulses are independent of time, and are meant to only be applied once.  Use `Collider:applyForce` for a time-dependent push that happens over multiple frames.
---@see Collider:applyForce
---@see Collider:applyTorque
---@see Collider:applyAngularImpulse
---@see Collider
---@overload fun(x: number, y: number, z: number, px: number, py: number, pz: number)
---@overload fun(impulse: Vec3)
---@overload fun(impulse: Vec3, position: Vec3)
---@param x number # The x component of the world-space impulse vector, in newton seconds.
---@param y number # The y component of the world-space impulse vector, in newton seconds.
---@param z number # The z component of the world-space impulse vector, in newton seconds.
function Collider:applyLinearImpulse(x, y, z) end

--- Applies torque to the Collider.
---@see Collider:applyAngularImpulse
---@see Collider:applyForce
---@see Collider:applyLinearImpulse
---@see Collider
---@overload fun(torque: Vec3)
---@param x number # The x component of the world-space torque vector, in newton meters.
---@param y number # The y component of the world-space torque vector, in newton meters.
---@param z number # The z component of the world-space torque vector, in newton meters.
function Collider:applyTorque(x, y, z) end

--- Destroys the Collider, removing it from the World and destroying all Shapes and Joints attached to it.
---@see Collider:isDestroyed
---@see Collider:setEnabled
---@see World:destroy
---@see Shape:destroy
---@see Joint:destroy
---@see Collider
function Collider:destroy() end

--- Returns the world-space axis-aligned bounding box of the Collider, computed from attached shapes.
---@see Shape:getAABB
---@see World:queryBox
---@see Collider
---@return number # The minimum x coordinate of the box.
---@return number # The maximum x coordinate of the box.
---@return number # The minimum y coordinate of the box.
---@return number # The maximum y coordinate of the box.
---@return number # The minimum z coordinate of the box.
---@return number # The maximum z coordinate of the box.
function Collider:getAABB() end

--- Returns the angular damping of the Collider.  Angular damping is similar to drag or air resistance, reducing the Collider's angular velocity over time.
---@see Collider:getLinearDamping
---@see Collider:setLinearDamping
---@see Collider:getInertia
---@see Collider:setInertia
---@see Collider:setAngularDamping
---@see Collider
---@return number # The angular damping.
function Collider:getAngularDamping() end

--- Returns the angular velocity of the Collider.
---@see Collider:getLinearVelocity
---@see Collider:setLinearVelocity
---@see Collider:applyTorque
---@see Collider:getOrientation
---@see Collider:setOrientation
---@see Collider:setAngularVelocity
---@see Collider
---@return number # The x component of the angular velocity.
---@return number # The y component of the angular velocity.
---@return number # The z component of the angular velocity.
function Collider:getAngularVelocity() end

--- Returns whether automatic mass is enabled for the Collider.
--- When enabled, the Collider's mass, inertia, and center of mass will be recomputed when:
--- - A shape is added to or removed from the Collider.
--- - A shape attached to the Collider changes shape (e.g. `SphereShape:setRadius`).
--- - A shape attached to the Collider is moved using `Shape:setOffset`.
--- - A shape attached to the Collider changes its density using `Shape:setDensity`.
--- Additionally, changing the center of mass of a Collider will automatically update its inertia when automatic mass is enabled.
--- Disable this to manage the mass properties manually.  When automatic mass is disabled, `Collider:resetMassData` can still be used to reset the mass from attached shapes if needed.
---@see Collider:resetMassData
---@see Collider:getMass
---@see Collider:setMass
---@see Collider:getInertia
---@see Collider:setInertia
---@see Collider:getCenterOfMass
---@see Collider:setCenterOfMass
---@see Collider:setAutomaticMass
---@see Collider
---@return boolean # Whether automatic mass is enabled.
function Collider:getAutomaticMass() end

--- Returns the Collider's center of mass, in the Collider's local coordinate space.
---@see Shape:getCenterOfMass
---@see Collider:getMass
---@see Collider:setMass
---@see Collider:getInertia
---@see Collider:setInertia
---@see Collider:getAutomaticMass
---@see Collider:setAutomaticMass
---@see Collider:resetMassData
---@see Shape:getOffset
---@see Shape:setOffset
---@see Collider:setCenterOfMass
---@see Collider
---@return number # The x component of the center of mass.
---@return number # The y component of the center of mass.
---@return number # The z component of the center of mass.
function Collider:getCenterOfMass() end

--- Get the degrees of freedom of the Collider.
---@see Collider:setDegreesOfFreedom
---@see Collider
---@return string # A string containing the world-space axes the Collider is allowed to move on.  The string will have 'x', 'y', and 'z' letters representing which axes are enabled.  If no axes are enabled then it will be an empty string.
---@return string # A string containing the world-space axes the Collider is allowed to rotate around.  The string will have 'x', 'y', and 'z' letters representing which axes are enabled.  If no axes are enabled then it will be an empty string.
function Collider:getDegreesOfFreedom() end

--- Returns the friction of the Collider.  Friction determines how easy it is for two colliders to slide against each other.  Low friction makes it easier for a collider to slide, simulating a smooth surface.
---@see Contact:getFriction
---@see Contact:setFriction
---@see Collider:getRestitution
---@see Collider:setRestitution
---@see Collider:setFriction
---@see Collider
---@return number # The friction of the Collider.
function Collider:getFriction() end

--- Returns the gravity scale of the Collider.  This is multiplied with the global gravity from the World, so 1.0 is regular gravity, 0.0 will ignore gravity, etc.
---@see World:getGravity
---@see World:setGravity
---@see Collider:getLinearDamping
---@see Collider:setLinearDamping
---@see Collider:setGravityScale
---@see Collider
---@return number # The gravity scale.
function Collider:getGravityScale() end

--- Returns the inertia of the Collider.
--- Inertia is kind of like "angular mass".  Regular mass determines how resistant the Collider is to linear forces (movement), whereas inertia determines how resistant the Collider is to torque (rotation).  Colliders with less inertia are more spinny.
--- In 3D, inertia is represented by a 3x3 matrix, called a tensor.  To make calculations easier, the physics engine stores the inertia using eigenvalue decomposition, splitting the matrix into a diagonal matrix and a rotation.  It's complicated!
--- In a realistic simulation, mass and inertia follow a linear relationship.  If the mass of an object increases, the diagonal part of its inertia should increase proportionally.
---@see Collider:getMass
---@see Collider:setMass
---@see Collider:getCenterOfMass
---@see Collider:setCenterOfMass
---@see Collider:getAutomaticMass
---@see Collider:setAutomaticMass
---@see Collider:resetMassData
---@see Shape:getInertia
---@see Collider:setInertia
---@see Collider
---@return number # The x component of the diagonal matrix.
---@return number # The y component of the diagonal matrix.
---@return number # The z component of the diagonal matrix.
---@return number # The angle of the inertia rotation.
---@return number # The x component of the inertia rotation axis.
---@return number # The y component of the inertia rotation axis.
---@return number # The z component of the inertia rotation axis.
function Collider:getInertia() end

--- Returns a list of Joints attached to the Collider.
---@see World:getJoints
---@see Joint:getColliders
---@see Joint:destroy
---@see Collider
---@return table # A list of `Joint` objects attached to the Collider.
function Collider:getJoints() end

--- Returns the linear damping of the Collider.  Linear damping is similar to drag or air resistance, slowing the Collider down over time.
---@see Collider:getAngularDamping
---@see Collider:setAngularDamping
---@see Collider:getGravityScale
---@see Collider:setGravityScale
---@see Collider:setLinearDamping
---@see Collider
---@return number # The linear damping.
function Collider:getLinearDamping() end

--- Returns the world-space linear velocity of the center of mass of the Collider, in meters per second.
---@see Collider:applyForce
---@see Collider:getLinearVelocityFromLocalPoint
---@see Collider:getLinearVelocityFromWorldPoint
---@see Collider:getAngularVelocity
---@see Collider:setAngularVelocity
---@see Collider:getPosition
---@see Collider:setPosition
---@see Collider:setLinearVelocity
---@see Collider
---@return number # The x component of the velocity.
---@return number # The y component of the velocity.
---@return number # The z component of the velocity.
function Collider:getLinearVelocity() end

--- Returns the linear velocity of a point on the Collider.  This includes the velocity of the center of mass plus the angular velocity at that point.
---@see Collider:getLinearVelocity
---@see Collider:getLinearVelocityFromWorldPoint
---@see Collider
---@overload fun(point: Vec3): number, number, number
---@param x number # The x position in local space.
---@param y number # The y position in local space.
---@param z number # The z position in local space.
---@return number # The x velocity of the point.
---@return number # The y velocity of the point.
---@return number # The z velocity of the point.
function Collider:getLinearVelocityFromLocalPoint(x, y, z) end

--- Returns the linear velocity of a point on the Collider.  This includes the velocity of the center of mass plus the angular velocity at that point.
---@see Collider:getLinearVelocity
---@see Collider:getLinearVelocityFromLocalPoint
---@see Collider
---@overload fun(point: Vec3): number, number, number
---@param x number # The x position in world space.
---@param y number # The y position in world space.
---@param z number # The z position in world space.
---@return number # The x velocity of the point.
---@return number # The y velocity of the point.
---@return number # The z velocity of the point.
function Collider:getLinearVelocityFromWorldPoint(x, y, z) end

--- Transforms a point from world coordinates into local coordinates relative to the Collider.
---@see Collider:getWorldPoint
---@see Collider:getLocalVector
---@see Collider:getWorldVector
---@see Collider
---@overload fun(point: Vec3): number, number, number
---@param wx number # The x component of the world point.
---@param wy number # The y component of the world point.
---@param wz number # The z component of the world point.
---@return number # The x component of the local point.
---@return number # The y component of the local point.
---@return number # The z component of the local point.
function Collider:getLocalPoint(wx, wy, wz) end

--- Transforms a direction vector from world space to local space.
---@see Collider:getWorldVector
---@see Collider:getLocalPoint
---@see Collider:getWorldPoint
---@see Collider
---@overload fun(vector: Vec3): number, number, number
---@param wx number # The x component of the world vector.
---@param wy number # The y component of the world vector.
---@param wz number # The z component of the world vector.
---@return number # The x component of the local vector.
---@return number # The y component of the local vector.
---@return number # The z component of the local vector.
function Collider:getLocalVector(wx, wy, wz) end

--- Returns the mass of the Collider.
--- The relative mass of colliders determines how they react when they collide.  A heavier collider has more momentum than a lighter collider moving the same speed, and will impart more force on the lighter collider.
--- More generally, heavier colliders react less to forces they receive, including forces applied with functions like `Collider:applyForce`.
--- Colliders with higher mass do not fall faster.  Use `Collider:setLinearDamping` to give a collider drag to make it fall slower or `Collider:setGravityScale` to change the way it reacts to gravity.
---@see Collider:getInertia
---@see Collider:setInertia
---@see Collider:getCenterOfMass
---@see Collider:setCenterOfMass
---@see Collider:getAutomaticMass
---@see Collider:setAutomaticMass
---@see Collider:resetMassData
---@see Shape:getDensity
---@see Shape:setDensity
---@see Shape:getVolume
---@see Shape:getMass
---@see Collider:setMass
---@see Collider
---@return number # The mass of the Collider, in kilograms.
function Collider:getMass() end

--- Returns the orientation of the Collider in angle/axis representation.
---@see Collider:applyTorque
---@see Collider:getAngularVelocity
---@see Collider:setAngularVelocity
---@see Collider:getPosition
---@see Collider:setPosition
---@see Collider:getPose
---@see Collider:setPose
---@see Collider:setOrientation
---@see Collider
---@return number # The number of radians the Collider is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Collider:getOrientation() end

--- Returns the position and orientation of the Collider.
---@see Collider:getPosition
---@see Collider:getOrientation
---@see Collider:setPose
---@see Collider
---@return number # The x position of the Collider, in meters.
---@return number # The y position of the Collider, in meters.
---@return number # The z position of the Collider, in meters.
---@return number # The number of radians the Collider is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Collider:getPose() end

--- Returns the position of the Collider.
---@see Collider:applyForce
---@see Collider:getLinearVelocity
---@see Collider:setLinearVelocity
---@see Collider:getOrientation
---@see Collider:setOrientation
---@see Collider:getPose
---@see Collider:setPose
---@see Collider:setPosition
---@see Collider
---@return number # The x position of the Collider, in meters.
---@return number # The y position of the Collider, in meters.
---@return number # The z position of the Collider, in meters.
function Collider:getPosition() end

--- Returns the restitution of the Collider.  Restitution makes a Collider bounce when it collides with other objects.  A restitution value of zero would result in an inelastic collision response, whereas 1.0 would result in an elastic collision that preserves all of the velocity. The restitution can be bigger than 1.0 to make the collision even more bouncy.
---@see Contact:getRestitution
---@see Contact:setRestitution
---@see Collider:getFriction
---@see Collider:setFriction
---@see Collider:setRestitution
---@see Collider
---@return number # The restitution of the Collider.
function Collider:getRestitution() end

--- Returns a Shape attached to the Collider.
--- For the common case where a Collider only has a single shape, this is more convenient and efficient than extracting it from the table returned by `Collider:getShapes`.  It is always equivalent to `Collider:getShapes()[1]`.
---@see Collider:getShapes
---@see Collider:addShape
---@see Collider:removeShape
---@see Shape
---@see Collider
---@return Shape # One of the `Shape` objects attached to the Collider.
function Collider:getShape() end

--- Returns a list of Shapes attached to the Collider.
---@see Collider:getShape
---@see Collider:addShape
---@see Collider:removeShape
---@see Shape
---@see Collider
---@return table # A list of `Shape` objects attached to the Collider.
function Collider:getShapes() end

--- Returns the Collider's tag.
--- Tags are strings that represent the category of a collider.  Use `World:enableCollisionBetween` and `World:disableCollisionBetween` to control which pairs of tags should collide with each other.  Physics queries like `World:raycast` also use tags to filter their results.
--- The list of available tags is set in `lovr.physics.newWorld`.
---@see World:getTags
---@see World:disableCollisionBetween
---@see World:enableCollisionBetween
---@see World:isCollisionEnabledBetween
---@see lovr.physics.newWorld
---@see Collider:setTag
---@see Collider
---@return string # The Collider's tag.
function Collider:getTag() end

--- Returns the Lua value associated with the Collider.
---@see Shape:getUserData
---@see Shape:setUserData
---@see Joint:getUserData
---@see Joint:setUserData
---@see Collider:setUserData
---@see Collider
---@return any # The custom value associated with the Collider.
function Collider:getUserData() end

--- Returns the World the Collider is in.
---@see Collider
---@return World # The World the Collider is in.
function Collider:getWorld() end

--- Transforms a local point relative to the collider to a point in world coordinates.
---@see Collider:getLocalPoint
---@see Collider:getLocalVector
---@see Collider:getWorldVector
---@see Collider
---@overload fun(point: Vec3): number, number, number
---@param x number # The x component of the local point.
---@param y number # The y component of the local point.
---@param z number # The z component of the local point.
---@return number # The x component of the world point.
---@return number # The y component of the world point.
---@return number # The z component of the world point.
function Collider:getWorldPoint(x, y, z) end

--- Transforms a direction vector from local space to world space.
---@see Collider:getLocalVector
---@see Collider:getLocalPoint
---@see Collider:getWorldPoint
---@see Collider
---@overload fun(vector: Vec3): number, number, number
---@param x number # The x component of the local vector.
---@param y number # The y component of the local vector.
---@param z number # The z component of the local vector.
---@return number # The x component of the world vector.
---@return number # The y component of the world vector.
---@return number # The z component of the world vector.
function Collider:getWorldVector(x, y, z) end

--- Returns whether the Collider is awake.
---@see Collider:isSleepingAllowed
---@see Collider:setSleepingAllowed
---@see Collider:setAwake
---@see Collider
---@return boolean # Whether the Collider is finally awake.
function Collider:isAwake() end

--- Returns whether the Collider uses continuous collision detection.
--- Normally on each timestep a Collider will "teleport" to its new position based on its velocity. Usually this works fine, but if a Collider is going really fast relative to its size, then it might miss collisions with objects or pass through walls.  Enabling continuous collision detection means the Collider will check for obstacles along its path before moving to the new location.  This prevents the Collider from going through walls, but reduces performance.  It's usually used for projectiles, which tend to be small and really fast.
---@see Collider:setContinuous
---@see Collider
---@return boolean # Whether the Collider uses continuous collision detection.
function Collider:isContinuous() end

--- Returns whether the collider has been destroyed.
---@see Collider:destroy
---@see World:destroy
---@see Shape:destroy
---@see Joint:destroy
---@see Collider
---@return boolean # Whether the collider has been destroyed.
function Collider:isDestroyed() end

--- Returns whether the Collider is enabled.  When a Collider is disabled, it is removed from the World and does not impact the physics simulation in any way.  The Collider keeps all of its state and can be re-enabled to add it back to the World.
---@see Collider:destroy
---@see Collider:setEnabled
---@see Collider
---@return boolean # Whether the Collider is enabled.
function Collider:isEnabled() end

--- Returns whether the Collider is currently ignoring gravity.
---@see Collider:setGravityIgnored
---@see Collider
---@return boolean # Whether gravity is ignored for this Collider.
function Collider:isGravityIgnored() end

--- Returns whether the Collider is kinematic.
--- Kinematic colliders behave like they have infinite mass.  They ignore forces applied to them from gravity, joints, and collisions, but they can still move if given a velocity.  Kinematic colliders don't collide with other kinematic colliders.  They're useful for static environment objects in a level, or for objects that have their position managed outside of the physics system like tracked hands.
---@see Collider:setKinematic
---@see Collider
---@return boolean # Whether the Collider is kinematic.
function Collider:isKinematic() end

--- Returns whether the Collider is a sensor.  Sensors do not collide with other objects, but they can still sense collisions with the collision callbacks set by `World:setCallbacks`.  Use them to trigger gameplay behavior when an object is inside a region of space.
---@see Collider:setKinematic
---@see Collider:setEnabled
---@see World:overlapShape
---@see World:setCallbacks
---@see Collider:setSensor
---@see Collider
---@return boolean # Whether the Collider is a sensor.
function Collider:isSensor() end

--- Returns whether the Collider is allowed to automatically go to sleep.
--- When enabled, the Collider will go to sleep if it hasn't moved in a while.  The physics engine does not simulate movement for colliders that are asleep, which saves a lot of CPU for a typical physics world where most objects are at rest at any given time.
---@see Collider:isAwake
---@see Collider:setAwake
---@see Collider:setSleepingAllowed
---@see Collider
---@return boolean # Whether the Collider can go to sleep.
function Collider:isSleepingAllowed() end

--- Moves the collider towards a destination pose.  The velocity of the collider is set so that the collider reaches the destination in `dt` seconds.
---@see Collider:setLinearVelocity
---@see Collider:setAngularVelocity
---@see Collider:applyForce
---@see Collider:applyTorque
---@see Collider
---@overload fun(position: Vec3, orientation: Quat, dt: number)
---@param x number # The x position of the target, in meters.
---@param y number # The y position of the target, in meters.
---@param z number # The z position of the target, in meters.
---@param angle number # The angle of the target orientation.
---@param ax number # The x component of the target axis of rotation.
---@param ay number # The y component of the target axis of rotation.
---@param az number # The z component of the target axis of rotation.
---@param dt number # How long it should take to reach the destination.
function Collider:moveKinematic(x, y, z, angle, ax, ay, az, dt) end

--- Removes a Shape from the Collider.
---@see Collider:addShape
---@see Collider:getShapes
---@see Shape
---@see Collider
---@param shape Shape # The Shape to remove.
function Collider:removeShape(shape) end

--- Resets the mass, inertia, and center of mass of the Collider based on its attached shapes.
--- If automatic mass is enabled, these properties will be kept up to date automatically.  Use this function when automatic mass is disabled or if mass needs to be reset after being overridden.
---@see Collider:getAutomaticMass
---@see Collider:setAutomaticMass
---@see Collider:getMass
---@see Collider:setMass
---@see Collider:getInertia
---@see Collider:setInertia
---@see Collider:getCenterOfMass
---@see Collider:setCenterOfMass
---@see Collider
function Collider:resetMassData() end

--- Sets the angular damping of the Collider.  Angular damping is similar to drag or air resistance, reducing the Collider's angular velocity over time.
---@see Collider:getLinearDamping
---@see Collider:setLinearDamping
---@see Collider:getInertia
---@see Collider:setInertia
---@see Collider:getAngularDamping
---@see Collider
---@param damping number # The angular damping.
function Collider:setAngularDamping(damping) end

--- Sets the angular velocity of the Collider.
---@see Collider:applyTorque
---@see Collider:applyAngularImpulse
---@see Collider:getLinearVelocity
---@see Collider:setLinearVelocity
---@see Collider:getOrientation
---@see Collider:setOrientation
---@see Collider:getAngularVelocity
---@see Collider
---@overload fun(velocity: Vec3)
---@param vx number # The x component of the angular velocity.
---@param vy number # The y component of the angular velocity.
---@param vz number # The z component of the angular velocity.
function Collider:setAngularVelocity(vx, vy, vz) end

--- Enables or disables automatic mass for the Collider.
--- When enabled, the Collider's mass, inertia, and center of mass will be recomputed when:
--- - A shape is added to or removed from the Collider.
--- - A shape attached to the Collider changes shape (e.g. `SphereShape:setRadius`).
--- - A shape attached to the Collider is moved using `Shape:setOffset`.
--- - A shape attached to the Collider changes its density using `Shape:setDensity`.
--- Additionally, changing the center of mass of a Collider will automatically update its inertia when automatic mass is enabled.
--- Disable this to manage the mass properties manually.  When automatic mass is disabled, `Collider:resetMassData` can still be used to reset the mass from attached shapes if needed.
---@see Collider:resetMassData
---@see Collider:getMass
---@see Collider:setMass
---@see Collider:getInertia
---@see Collider:setInertia
---@see Collider:getCenterOfMass
---@see Collider:setCenterOfMass
---@see Collider:getAutomaticMass
---@see Collider
---@param enable boolean # Whether automatic mass should be enabled.
function Collider:setAutomaticMass(enable) end

--- Puts the Collider to sleep or wakes it up manually.
---@see Collider:isSleepingAllowed
---@see Collider:setSleepingAllowed
---@see Collider:isAwake
---@see Collider
---@param awake boolean # Whether the Collider should be awake.
function Collider:setAwake(awake) end

--- Sets the Collider's center of mass, in the Collider's local coordinate space.
--- This does not change the Collider's position.
---@see Shape:getCenterOfMass
---@see Collider:getMass
---@see Collider:setMass
---@see Collider:getInertia
---@see Collider:setInertia
---@see Collider:getAutomaticMass
---@see Collider:setAutomaticMass
---@see Collider:resetMassData
---@see Shape:getOffset
---@see Shape:setOffset
---@see Collider:getCenterOfMass
---@see Collider
---@overload fun(center: Vec3)
---@param x number # The x component of the center of mass.
---@param y number # The y component of the center of mass.
---@param z number # The z component of the center of mass.
function Collider:setCenterOfMass(x, y, z) end

--- Sets whether the Collider uses continuous collision detection.
--- Normally on each timestep a Collider will "teleport" to its new position based on its velocity. Usually this works fine, but if a Collider is going really fast relative to its size, then it might miss collisions with objects or pass through walls.  Enabling continuous collision detection means the Collider will check for obstacles along its path before moving to the new location.  This prevents the Collider from going through walls, but reduces performance.  It's usually used for projectiles, which tend to be small and really fast.
---@see Collider:isContinuous
---@see Collider
---@param continuous boolean # Whether the Collider uses continuous collision detection.
function Collider:setContinuous(continuous) end

--- Set the degrees of freedom of the Collider.
---@see Collider:getDegreesOfFreedom
---@see Collider
---@param translation string # A string containing the world-space axes the Collider is allowed to move on.  The string should have 'x', 'y', and 'z' letters representing the axes to enable.  Use nil or an empty string to disable all translation.
---@param rotation string # A string containing the world-space axes the Collider is allowed to rotate on.  The string should have 'x', 'y', and 'z' letters representing the axes to enable.  Use nil or an empty string to disable all rotation.
function Collider:setDegreesOfFreedom(translation, rotation) end

--- Enables or disables the Collider.  When a Collider is disabled, it is removed from the World and does not impact the physics simulation in any way.  The Collider keeps all of its state and can be re-enabled to add it back to the World.
---@see Collider:destroy
---@see Collider:isEnabled
---@see Collider
---@param enable boolean # Whether the Collider should be enabled.
function Collider:setEnabled(enable) end

--- Sets the friction of the Collider.  Friction determines how easy it is for two colliders to slide against each other.  Low friction makes it easier for a collider to slide, simulating a smooth surface.
---@see Contact:getFriction
---@see Contact:setFriction
---@see Collider:getRestitution
---@see Collider:setRestitution
---@see Collider:getFriction
---@see Collider
---@param friction number # The friction of the Collider.
function Collider:setFriction(friction) end

--- Sets whether the Collider should ignore gravity.
---@see Collider:isGravityIgnored
---@see Collider
---@param ignored boolean # Whether gravity should be ignored.
function Collider:setGravityIgnored(ignored) end

--- Sets the gravity scale of the Collider.  This is multiplied with the global gravity from the World, so 1.0 is regular gravity, 0.0 will ignore gravity, etc.
---@see World:getGravity
---@see World:setGravity
---@see Collider:getLinearDamping
---@see Collider:setLinearDamping
---@see Collider:getGravityScale
---@see Collider
---@param scale number # The gravity scale.
function Collider:setGravityScale(scale) end

--- Sets the inertia of the Collider.
--- Inertia is kind of like "angular mass".  Regular mass determines how resistant the Collider is to linear forces (movement), whereas inertia determines how resistant the Collider is to torque (rotation).  Colliders with less inertia are more spinny.
--- In 3D, inertia is represented by a 3x3 matrix, called a tensor.  To make calculations easier, the physics engine stores the inertia using eigenvalue decomposition, splitting the matrix into a diagonal matrix and a rotation.  It's complicated!
--- In a realistic simulation, mass and inertia follow a linear relationship.  If the mass of an object increases, the diagonal part of its inertia should increase proportionally.
---@see Collider:getMass
---@see Collider:setMass
---@see Collider:getCenterOfMass
---@see Collider:setCenterOfMass
---@see Collider:getAutomaticMass
---@see Collider:setAutomaticMass
---@see Collider:resetMassData
---@see Shape:getInertia
---@see Collider:getInertia
---@see Collider
---@overload fun(diagonal: Vec3, rotation: Quat)
---@param dx number # The x component of the diagonal matrix.
---@param dy number # The y component of the diagonal matrix.
---@param dz number # The z component of the diagonal matrix.
---@param angle number # The angle of the inertia rotation, in radians.
---@param ax number # The x component of the rotation axis.
---@param ay number # The y component of the rotation axis.
---@param az number # The z component of the rotation axis.
function Collider:setInertia(dx, dy, dz, angle, ax, ay, az) end

--- Sets whether the Collider is kinematic.
--- Kinematic colliders behave like they have infinite mass.  They ignore forces applied to them from gravity, joints, and collisions, but they can still move if given a velocity.  Kinematic colliders don't collide with other kinematic colliders.  They're useful for static environment objects in a level, or for objects that have their position managed outside of the physics system like tracked hands.
---@see Collider:isKinematic
---@see Collider
---@param kinematic boolean # Whether the Collider should be kinematic.
function Collider:setKinematic(kinematic) end

--- Sets the linear damping of the Collider.  Linear damping is similar to drag or air resistance, slowing the Collider down over time.
---@see Collider:getAngularDamping
---@see Collider:setAngularDamping
---@see Collider:getGravityScale
---@see Collider:setGravityScale
---@see Collider:getLinearDamping
---@see Collider
---@param damping number # The linear damping.
function Collider:setLinearDamping(damping) end

--- Sets the world-space linear velocity of the center of mass of the Collider.
---@see Collider:applyForce
---@see Collider:applyLinearImpulse
---@see Collider:getLinearVelocityFromLocalPoint
---@see Collider:getLinearVelocityFromWorldPoint
---@see Collider:getAngularVelocity
---@see Collider:setAngularVelocity
---@see Collider:getPosition
---@see Collider:setPosition
---@see Collider:getLinearVelocity
---@see Collider
---@overload fun(velocity: Vec3)
---@param vx number # The x component of the new velocity, in meters per second.
---@param vy number # The y component of the new velocity, in meters per second.
---@param vz number # The z component of the new velocity, in meters per second.
function Collider:setLinearVelocity(vx, vy, vz) end

--- Sets the mass of the Collider.
--- The relative mass of colliders determines how they react when they collide.  A heavier collider has more momentum than a lighter collider moving the same speed, and will impart more force on the lighter collider.
--- More generally, heavier colliders react less to forces they receive, including forces applied with functions like `Collider:applyForce`.
--- Colliders with higher mass do not fall faster.  Use `Collider:setLinearDamping` to give a collider drag to make it fall slower or `Collider:setGravityScale` to change the way it reacts to gravity.
---@see Collider:getInertia
---@see Collider:setInertia
---@see Collider:getCenterOfMass
---@see Collider:setCenterOfMass
---@see Collider:getAutomaticMass
---@see Collider:setAutomaticMass
---@see Collider:resetMassData
---@see Shape:getDensity
---@see Shape:setDensity
---@see Shape:getVolume
---@see Shape:getMass
---@see Collider:getMass
---@see Collider
---@param mass number # The new mass for the Collider, in kilograms.
function Collider:setMass(mass) end

--- Sets the orientation of the Collider in angle/axis representation.
---@see Collider:applyTorque
---@see Collider:getAngularVelocity
---@see Collider:setAngularVelocity
---@see Collider:getPosition
---@see Collider:setPosition
---@see Collider:getPose
---@see Collider:setPose
---@see Collider:getOrientation
---@see Collider
---@overload fun(orientation: Quat)
---@param angle number # The number of radians the Collider is rotated around its axis of rotation.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function Collider:setOrientation(angle, ax, ay, az) end

--- Sets the position and orientation of the Collider.
---@see Collider:setPosition
---@see Collider:setOrientation
---@see Collider:getPose
---@see Collider
---@overload fun(position: Vec3, orientation: Quat)
---@param x number # The x position of the Collider, in meters.
---@param y number # The y position of the Collider, in meters.
---@param z number # The z position of the Collider, in meters.
---@param angle number # The number of radians the Collider is rotated around its axis of rotation.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function Collider:setPose(x, y, z, angle, ax, ay, az) end

--- Sets the position of the Collider.
---@see Collider:applyForce
---@see Collider:getLinearVelocity
---@see Collider:setLinearVelocity
---@see Collider:getOrientation
---@see Collider:setOrientation
---@see Collider:getPose
---@see Collider:setPose
---@see Collider:getPosition
---@see Collider
---@overload fun(position: Vec3)
---@param x number # The x position of the Collider, in meters.
---@param y number # The y position of the Collider, in meters.
---@param z number # The z position of the Collider, in meters.
function Collider:setPosition(x, y, z) end

--- Sets the restitution of the Collider.  Restitution makes a Collider bounce when it collides with other objects.  A restitution value of zero would result in an inelastic collision response, whereas 1.0 would result in an elastic collision that preserves all of the velocity.
---@see Contact:getRestitution
---@see Contact:setRestitution
---@see Collider:getFriction
---@see Collider:setFriction
---@see Collider:getRestitution
---@see Collider
---@param restitution number # The restitution of the Collider.
function Collider:setRestitution(restitution) end

--- Sets whether the Collider should be a sensor.  Sensors do not collide with other objects, but they can still sense collisions with the collision callbacks set by `World:setCallbacks`.  Use them to trigger gameplay behavior when an object is inside a region of space.
---@see Collider:setKinematic
---@see Collider:setEnabled
---@see World:overlapShape
---@see World:setCallbacks
---@see Collider:isSensor
---@see Collider
---@param sensor boolean # Whether the Collider should be a sensor.
function Collider:setSensor(sensor) end

--- Sets whether the Collider is allowed to automatically go to sleep.
--- When enabled, the Collider will go to sleep if it hasn't moved in a while.  The physics engine does not simulate movement for colliders that are asleep, which saves a lot of CPU for a typical physics world where most objects are at rest at any given time.
---@see Collider:isAwake
---@see Collider:setAwake
---@see Collider:isSleepingAllowed
---@see Collider
---@param sleepy boolean # Whether the Collider can go to sleep.
function Collider:setSleepingAllowed(sleepy) end

--- Sets the Collider's tag.
--- Tags are strings that represent the category of a collider.  Use `World:enableCollisionBetween` and `World:disableCollisionBetween` to control which pairs of tags should collide with each other.  Physics queries like `World:raycast` also use tags to filter their results.
--- The list of available tags is set in `lovr.physics.newWorld`.
---@see World:getTags
---@see World:disableCollisionBetween
---@see World:enableCollisionBetween
---@see World:isCollisionEnabledBetween
---@see lovr.physics.newWorld
---@see Collider:getTag
---@see Collider
---@overload fun()
---@param tag string # The Collider's tag.
function Collider:setTag(tag) end

--- Associates a Lua value with the Collider.
---@see Shape:getUserData
---@see Shape:setUserData
---@see Joint:getUserData
---@see Joint:setUserData
---@see Collider:getUserData
---@see Collider
---@param data any # The custom value to associate with the Collider.
function Collider:setUserData(data) end

---@class ConeJoint
local ConeJoint = {}

--- Returns the axis of the ConeJoint, in world space.  The axis is relative to the first Collider connected to the Joint, so it will rotate as the collider does.  The relative angle between the axis and the second collider will be constrained based on the ConeJoint's angle limit.
---@see ConeJoint
---@return number # The x component of the axis.
---@return number # The y component of the axis.
---@return number # The z component of the axis.
function ConeJoint:getAxis() end

--- Returns the angle limit of the ConeJoint.  The relative angle between the ConeJoint's axis and the second Collider will be constrained to this limit.
---@see ConeJoint:setLimit
---@see ConeJoint
---@return number # The angle limit, in radians.
function ConeJoint:getLimit() end

--- Sets the angle limit of the ConeJoint.  The relative angle between the ConeJoint's axis and the second Collider will be constrained to this limit.
---@see ConeJoint:getLimit
---@see ConeJoint
---@param limit number # The new limit in radians, between 0 and pi.
function ConeJoint:setLimit(limit) end

---@class Contact
local Contact = {}

--- Returns the two Colliders that are in contact.
---@see Contact:getShapes
---@see Contact
---@return Collider # The first collider.
---@return Collider # The second collider.
function Contact:getColliders() end

--- Returns the friction of the Contact.  Lower friction makes it easier for the colliders to slide against each other.
---@see Collider:getFriction
---@see Collider:setFriction
---@see Contact:getRestitution
---@see Contact:setRestitution
---@see Contact:setFriction
---@see Contact
---@return number # The contact friction.
function Contact:getFriction() end

--- Returns the normal vector of the Contact.  This is a direction vector that represents which direction the second collider should move to resolve the collision.
---@see Contact:getOverlap
---@see Contact:getPoints
---@see Contact
---@return number # The x component of the normal vector.
---@return number # The y component of the normal vector.
---@return number # The z component of the normal vector.
function Contact:getNormal() end

--- Returns the amount of overlap between the colliders.
---@see Contact:getNormal
---@see Contact
---@return number # The amount of overlap, in meters.
function Contact:getOverlap() end

--- Returns the contact points of the Contact.  These are the points where the colliders are intersecting.
---@see Contact
---@return number # Triplets of x/y/z numbers, one for each contact point.
function Contact:getPoints() end

--- Returns the restitution of the Contact.  Restitution makes the Colliders bounce off of each other.  A restitution value of zero results in an inelastic collision response, whereas 1.0 results in an elastic collision that preserves all of the velocity.  Restitution can be bigger than 1.0 to make the collision even more bouncy.
---@see Collider:getRestitution
---@see Collider:setRestitution
---@see Contact:getFriction
---@see Contact:setFriction
---@see Contact:setRestitution
---@see Contact
---@return number # The contact restitution.
function Contact:getRestitution() end

--- Returns the two Shapes that are in contact.
---@see Contact:getColliders
---@see Contact
---@return Shape # The first shape.
---@return Shape # The second shape.
function Contact:getShapes() end

--- Returns the world space surface velocity of the Contact.  This can be used to achieve a conveyor belt effect.
---@see Contact:setSurfaceVelocity
---@see Contact
---@return number # The x component of the surface velocity.
---@return number # The y component of the surface velocity.
---@return number # The z component of the surface velocity.
function Contact:getSurfaceVelocity() end

--- Returns whether the Contact is enabled.  Disabled contacts do not generate any collision response.  Use `Contact:setEnabled` to disable a contact to selectively ignore certain collisions.
---@see Collider:isEnabled
---@see Collider:setEnabled
---@see World:setCallbacks
---@see Contact:setEnabled
---@see Contact
---@return boolean # Whether the Contact is enabled.
function Contact:isEnabled() end

--- Enables or disables the Contact.  Disabled contacts do not generate any collision response.
---@see Contact:isEnabled
---@see Contact
---@param enable boolean # Whether the Contact should be enabled.
function Contact:setEnabled(enable) end

--- Sets the friction of the Contact.  Lower friction makes it easier for the colliders to slide against each other.  This overrides the default friction computed by the friction of the two Colliders.
---@see Collider:getFriction
---@see Collider:setFriction
---@see Contact:getRestitution
---@see Contact:setRestitution
---@see Contact:getFriction
---@see Contact
---@param friction number # The contact friction.
function Contact:setFriction(friction) end

--- Sets the restitution of the Contact.  Restitution makes the Colliders bounce off of each other. A restitution value of zero results in an inelastic collision response, whereas 1.0 results in an elastic collision that preserves all of the velocity.  Restitution can be bigger than 1.0 to make the collision even more bouncy.
---@see Collider:getRestitution
---@see Collider:setRestitution
---@see Contact:getFriction
---@see Contact:setFriction
---@see Contact:getRestitution
---@see Contact
---@param restitution number # The contact restitution.
function Contact:setRestitution(restitution) end

--- Sets the world space surface velocity of the Contact.  This can be used to achieve a conveyor belt effect.
---@see Contact:getSurfaceVelocity
---@see Contact
---@overload fun(velocity: Vec3)
---@param x number # The x component of the surface velocity.
---@param y number # The y component of the surface velocity.
---@param z number # The z component of the surface velocity.
function Contact:setSurfaceVelocity(x, y, z) end

---@class ConvexShape
local ConvexShape = {}

--- Returns the indices of points that make up one of the faces of the convex hull.
---@see ConvexShape:getPoint
---@see ConvexShape:getFaceCount
---@see ConvexShape
---@param index number # The index of the face.
---@return table # A table with point indices.  Use `ConvexShape:getPoint` to get the coordinates.  The points are given in counterclockwise order.
function ConvexShape:getFace(index) end

--- Returns the number of faces in the convex hull.
---@see ConvexShape:getFace
---@see ConvexShape
---@return number # The number of faces.
function ConvexShape:getFaceCount() end

--- Returns one of the points in the convex hull, in local space.
---@see ConvexShape:getPointCount
---@see ConvexShape
---@param index number # The index of the point.
---@return number # The x coordinate.
---@return number # The y coordinate.
---@return number # The z coordinate.
function ConvexShape:getPoint(index) end

--- Returns the number of points in the convex hull.
---@see ConvexShape:getPoint
---@see ConvexShape
---@return number # The number of points.
function ConvexShape:getPointCount() end

--- Returns the scale the ConvexShape was created with.
---@see lovr.physics.newConvexShape
---@see World:newConvexCollider
---@see ConvexShape
---@return number # The scale.
function ConvexShape:getScale() end

---@class CylinderShape
local CylinderShape = {}

--- Returns the length of the CylinderShape.
---@see CylinderShape:getRadius
---@see CylinderShape:setRadius
---@see CylinderShape:setLength
---@see CylinderShape
---@return number # The length of the cylinder, in meters.
function CylinderShape:getLength() end

--- Returns the radius of the CylinderShape.
---@see CylinderShape:getLength
---@see CylinderShape:setLength
---@see CylinderShape:setRadius
---@see CylinderShape
---@return number # The radius of the cylinder, in meters.
function CylinderShape:getRadius() end

--- Sets the length of the CylinderShape.
---@see CylinderShape:getRadius
---@see CylinderShape:setRadius
---@see CylinderShape:getLength
---@see CylinderShape
---@param length number # The new length, in meters.
function CylinderShape:setLength(length) end

--- Sets the radius of the CylinderShape.
---@see CylinderShape:getLength
---@see CylinderShape:setLength
---@see CylinderShape:getRadius
---@see CylinderShape
---@param radius number # The new radius, in meters.
function CylinderShape:setRadius(radius) end

---@class DistanceJoint
local DistanceJoint = {}

--- Returns the minimum and maximum distance allowed between the Colliders.
---@see DistanceJoint:setLimits
---@see DistanceJoint
---@return number # The minimum distance, in meters.  The Colliders won't be able to get closer than this.
---@return number # The maximum distance, in meters.  The Colliders won't be able to get further than this.
function DistanceJoint:getLimits() end

--- Returns the DistanceJoint's spring parameters.  Use this to control how fast the joint pulls the colliders back together at the distance limits.
---@see DistanceJoint:setSpring
---@see DistanceJoint
---@return number # The frequency of the spring, in hertz.  Higher frequencies make the spring more stiff.  When zero, the spring is disabled.
---@return number # The damping ratio of the spring.
function DistanceJoint:getSpring() end

--- Sets the minimum and maximum distance allowed between the Colliders.
---@see DistanceJoint:getLimits
---@see DistanceJoint
---@overload fun()
---@param min number? # The minimum distance, in meters.  The Colliders won't be able to get closer than this. (default: 0)
---@param max number? # The maximum distance, in meters.  The Colliders won't be able to get further than this. (default: min)
function DistanceJoint:setLimits(min, max) end

--- Sets the DistanceJoint's spring parameters.  Use this to control how fast the joint pulls the colliders back together at the distance limits.
---@see DistanceJoint:getSpring
---@see DistanceJoint
---@param frequency number? # The frequency of the spring, in hertz.  Higher frequencies make the spring more stiff.  When zero, the spring is disabled. (default: 0.0)
---@param damping number? # The damping ratio of the spring. (default: 1.0)
function DistanceJoint:setSpring(frequency, damping) end

---@class HingeJoint
local HingeJoint = {}

--- Returns the current angle of the HingeJoint, relative to the rest position.
---@see HingeJoint:getAxis
---@see HingeJoint:getLimits
---@see HingeJoint:setLimits
---@see HingeJoint
---@return number # The hinge angle, in radians.
function HingeJoint:getAngle() end

--- Returns the axis of the hinge, in world space.
---@see HingeJoint:getAngle
---@see Joint:getAnchors
---@see HingeJoint
---@return number # The x component of the axis.
---@return number # The y component of the axis.
---@return number # The z component of the axis.
function HingeJoint:getAxis() end

--- Returns the friction of the HingeJoint.  This is a maximum torque force that will be applied, in newton meters.
---@see HingeJoint:setFriction
---@see HingeJoint
---@return number # The friction, in newton meters.
function HingeJoint:getFriction() end

--- Returns the angle limits of the HingeJoint.  The "zero" angle is determined by the relative position of the colliders at the time the joint was created.
---@see HingeJoint:getAngle
---@see HingeJoint:setLimits
---@see HingeJoint
---@return number # The minimum angle, in radians.  Always between -π and 0.
---@return number # The maximum angle, in radians.  Always between 0 and π.
function HingeJoint:getLimits() end

--- Returns the maximum amount of torque the motor can use to reach its target, in newton meters.
--- There are separate limits for each direction the hinge can move.  They're usually kept the same, but one of them can be set to zero to make a motor that can only push in one direction.  Note that both limits are positive.
---@see HingeJoint:getMotorTorque
---@see HingeJoint:setMaxMotorTorque
---@see HingeJoint
---@return number # The maximum amount of torque the motor can use to push the hinge in the "positive" direction, in newton meters.
---@return number # The maximum amount of torque the motor can use to push the hinge in the "negative" direction, in newton meters.
function HingeJoint:getMaxMotorTorque() end

--- Returns the motor mode of the HingeJoint.  When enabled, the motor will drive the hinge to a target angle (for the `position` mode) or a target speed (for the `velocity` mode), set by `HingeJoint:setMotorTarget`.
---@see HingeJoint:getMotorTarget
---@see HingeJoint:setMotorTarget
---@see HingeJoint:setMotorMode
---@see HingeJoint
---@return MotorMode # The mode of the motor, or `nil` if the motor is disabled.
function HingeJoint:getMotorMode() end

--- Returns the spring parameters of the motor target.  These are similar to the spring parameters set by `HingeJoint:setSpring`, but they apply to the motor when it reaches its target instead of the angle limits of the hinge joint.  Note that these only take effect when the motor mode is `position`.
---@see HingeJoint:getSpring
---@see HingeJoint:setSpring
---@see HingeJoint:getMotorTarget
---@see HingeJoint:setMotorTarget
---@see HingeJoint:setMotorSpring
---@see HingeJoint
---@return number # The frequency of the spring, in hertz.  Higher frequencies make the spring more stiff.  When zero, the spring is disabled.
---@return number # The damping ratio of the spring.
function HingeJoint:getMotorSpring() end

--- Returns the target value for the HingeJoint's motor.  This is either a target angle or a target velocity, based on the mode set by `HingeJoint:setMotorMode`.
---@see HingeJoint:getMotorMode
---@see HingeJoint:setMotorMode
---@see HingeJoint
---@return number # The target value, in radians or radians per second, depending on the mode.
function HingeJoint:getMotorTarget() end

--- Returns the current torque the motor is using to reach its target, in newton meters.
---@see HingeJoint:getMaxMotorTorque
---@see HingeJoint:setMaxMotorTorque
---@see HingeJoint
---@return number # The current torque, in newton meters.
function HingeJoint:getMotorTorque() end

--- Returns the spring parameters of the HingeJoint.  Use this to make the angle limits of the hinge "soft".  When the motor is active, a separate set of spring parameters can be set on the motor, see `HingeJoint:setMotorSpring`.
---@see HingeJoint:getMotorSpring
---@see HingeJoint:setMotorSpring
---@see HingeJoint:setSpring
---@see HingeJoint
---@return number # The frequency of the spring, in hertz.  Higher frequencies make the spring more stiff.  When zero, the spring is disabled.
---@return number # The damping ratio of the spring.
function HingeJoint:getSpring() end

--- Sets the friction of the HingeJoint.  This is a maximum torque force that will be applied, in newton meters.
---@see HingeJoint:getFriction
---@see HingeJoint
---@param friction number # The friction, in newton meters.
function HingeJoint:setFriction(friction) end

--- Sets the angle limits of the HingeJoint.  The "zero" angle is determined by the relative position of the colliders at the time the joint was created.
---@see HingeJoint:getAngle
---@see HingeJoint:getLimits
---@see HingeJoint
---@overload fun()
---@param min number # The minimum angle, in radians.  Should be between -π and 0.
---@param max number # The maximum angle, in radians.  Should be between 0 and π.
function HingeJoint:setLimits(min, max) end

--- Sets the maximum amount of torque the motor can use to reach its target, in newton meters.
--- There are separate limits for each direction the hinge can move.  They're usually kept the same, but one of them can be set to zero to make a motor that can only push in one direction.  Note that both limits are positive.
---@see HingeJoint:getMotorTorque
---@see HingeJoint:getMaxMotorTorque
---@see HingeJoint
---@param positive number? # The maximum amount of torque the motor can use to push the hinge in the "positive" direction, in newton meters. (default: math.huge)
---@param negative number? # The maximum amount of torque the motor can use to push the hinge in the "negative" direction, in newton meters. (default: positive)
function HingeJoint:setMaxMotorTorque(positive, negative) end

--- Sets the motor mode of the HingeJoint.  When enabled, the motor will drive the hinge to a target angle (for the `position` mode) or a target speed (for the `velocity` mode), set by `HingeJoint:setMotorTarget`.
---@see HingeJoint:getMotorTarget
---@see HingeJoint:setMotorTarget
---@see HingeJoint:getMotorMode
---@see HingeJoint
---@overload fun()
---@param mode MotorMode # The mode of the motor.
function HingeJoint:setMotorMode(mode) end

--- Sets the spring parameters of the motor target.  These are similar to the spring parameters set by `HingeJoint:setSpring`, but they apply to the motor when it reaches its target instead of the angle limits of the hinge joint.  Note that these only take effect when the motor mode is `position`.
---@see HingeJoint:getSpring
---@see HingeJoint:setSpring
---@see HingeJoint:getMotorTarget
---@see HingeJoint:setMotorTarget
---@see HingeJoint:getMotorSpring
---@see HingeJoint
---@param frequency number? # The frequency of the spring, in hertz.  Higher frequencies make the spring more stiff.  When zero, the spring is disabled. (default: 0.0)
---@param damping number? # The damping ratio of the spring. (default: 1.0)
function HingeJoint:setMotorSpring(frequency, damping) end

--- Sets the target value for the HingeJoint's motor.  This is either a target angle or a target velocity, based on the mode set by `HingeJoint:setMotorMode`.
---@see HingeJoint:getMotorMode
---@see HingeJoint:setMotorMode
---@see HingeJoint:getMotorTarget
---@see HingeJoint
---@param target number # The target value, in radians or radians per second, depending on the mode.
function HingeJoint:setMotorTarget(target) end

--- Sets the spring parameters of the HingeJoint.  Use this to make the angle limits of the hinge "soft".  When the motor is active, a separate set of spring parameters can be set on the motor, see `HingeJoint:setMotorSpring`.
---@see HingeJoint:getMotorSpring
---@see HingeJoint:setMotorSpring
---@see HingeJoint:getSpring
---@see HingeJoint
---@param frequency number? # The frequency of the spring, in hertz.  Higher frequencies make the spring more stiff.  When zero, the spring is disabled. (default: 0.0)
---@param damping number? # The damping ratio of the spring. (default: 1.0)
function HingeJoint:setSpring(frequency, damping) end

---@class Joint
local Joint = {}

--- Destroys the Joint, removing it from the World and breaking the connection between its Colliders.  There is no way to get the Joint back after destroying it, and attempting to use it will throw an error.  To temporarily disable a Joint, use `Joint:setEnabled`.
---@see Joint:isDestroyed
---@see Joint:setEnabled
---@see Collider:destroy
---@see Shape:destroy
---@see World:destroy
---@see Joint
function Joint:destroy() end

--- Returns the world space anchor points of the Joint.  Joints are attached to each collider at a single point, which is defined when the Joint is created.
---@see Joint:getColliders
---@see Joint
---@return number # The x coordinate of the anchor point on the first Collider, in world space.
---@return number # The y coordinate of the anchor point on the first Collider, in world space.
---@return number # The z coordinate of the anchor point on the first Collider, in world space.
---@return number # The x coordinate of the anchor point on the second Collider, in world space.
---@return number # The y coordinate of the anchor point on the second Collider, in world space.
---@return number # The z coordinate of the anchor point on the second Collider, in world space.
function Joint:getAnchors() end

--- Returns the Colliders the Joint is attached to.
---@see Collider:getJoints
---@see Joint
---@return Collider # The first Collider.
---@return Collider # The second Collider.
function Joint:getColliders() end

--- Returns the magnitude of the force used to satisfy the Joint's constraint during the last physics update, in newtons.
--- This is useful for breakable joints.  Use `Joint:destroy` to break the joint if its force goes above a threshold.
---@see Joint:getTorque
---@see SliderJoint:getMotorForce
---@see Joint
---@return number # The magnitude of the force used to satisfy the Joint's constraint.
function Joint:getForce() end

--- Returns the priority of the Joint.  Joints with a higher priority are more likely to be solved correctly.  Priority values are non-negative integers.
---@see Joint:setPriority
---@see Joint
---@return number # The integer priority value.
function Joint:getPriority() end

--- Returns the magnitude of the torque used to satisfy the Joint's constraint during the last physics update, in newton meters.
--- This is useful for breakable joints.  Use `Joint:destroy` to break the joint if its torque goes above a threshold.
---@see Joint:getForce
---@see HingeJoint:getMotorTorque
---@see Joint
---@return number # The magnitude of the torque used to satisfy the Joint's constraint.
function Joint:getTorque() end

--- Returns the type of the Joint.
---@see Joint
---@return JointType # The type of the Joint.
function Joint:getType() end

--- Returns the Lua value associated with the Joint.
---@see Collider:getUserData
---@see Collider:setUserData
---@see Shape:getUserData
---@see Shape:setUserData
---@see Joint:setUserData
---@see Joint
---@return any # The custom value associated with the Joint.
function Joint:getUserData() end

--- Returns whether a Joint has been destroyed.  This the only method that can be called on a destroyed Joint, using the Joint in any other way will error.
---@see Joint:destroy
---@see Joint:isEnabled
---@see Joint:setEnabled
---@see Collider:destroy
---@see Shape:destroy
---@see World:destroy
---@see Joint
---@return boolean # Whether the Joint has been destroyed.
function Joint:isDestroyed() end

--- Returns whether the Joint is enabled.  Disabled joints do not affect the simulation in any way. Use `Joint:setEnabled` to reactivate the Joint later.  If the Joint is no longer needed, `Joint:destroy` is a better option that completely removes the Joint from the simulation.
---@see Joint:destroy
---@see Joint:setEnabled
---@see Joint
---@return boolean # Whether the Joint is enabled.
function Joint:isEnabled() end

--- Enable or disable the Joint.  Disabled joints do not affect the simulation in any way.  If the Joint is no longer needed, `Joint:destroy` is a better option that completely removes the Joint from the simulation.
---@see Joint:destroy
---@see Joint:isEnabled
---@see Joint
---@param enabled boolean # Whether the Joint should be enabled.
function Joint:setEnabled(enabled) end

--- Sets the priority of the Joint.  Joints with a higher priority are more likely to be solved correctly.  Priority values are non-negative integers.
---@see Joint:getPriority
---@see Joint
---@param priority number # The integer priority value.
function Joint:setPriority(priority) end

--- Associates a Lua value with the Joint.
---@see Collider:getUserData
---@see Collider:setUserData
---@see Shape:getUserData
---@see Shape:setUserData
---@see Joint:getUserData
---@see Joint
---@param data any # The custom value to associate with the Joint.
function Joint:setUserData(data) end

---@class MeshShape
local MeshShape = {}

--- Returns the scale the MeshShape was created with.
---@see lovr.physics.newMeshShape
---@see World:newMeshCollider
---@see MeshShape
---@return number # The scale.
function MeshShape:getScale() end

---@class Shape
local Shape = {}

--- Returns whether a point is inside the Shape.
--- This takes into account the pose of the Shape's collider (if any), as well as its local offset set with `Shape:setOffset`.
---@see Shape:raycast
---@see World:raycast
---@see World:shapecast
---@see World:overlapShape
---@see World:queryBox
---@see World:querySphere
---@see Shape
---@overload fun(point: Vec3): boolean
---@param x number # The x coordinate of the point.
---@param y number # The y coordinate of the point.
---@param z number # The z coordinate of the point.
---@return boolean # Whether the point is inside the Shape.
function Shape:containsPoint(x, y, z) end

--- Destroys the Shape, removing it from the Collider it's attached to.
---@see Shape:isDestroyed
---@see Collider:destroy
---@see Joint:destroy
---@see World:destroy
---@see Shape
function Shape:destroy() end

--- Returns the axis aligned bounding box of the Shape.
---@see Collider:getAABB
---@see Shape
---@return number # The minimum x coordinate of the box.
---@return number # The maximum x coordinate of the box.
---@return number # The minimum y coordinate of the box.
---@return number # The maximum y coordinate of the box.
---@return number # The minimum z coordinate of the box.
---@return number # The maximum z coordinate of the box.
function Shape:getAABB() end

--- Returns the center of mass of the Shape.  Currently the only shape that can have a non-zero center of mass is `ConvexShape`.
---@see Collider:getCenterOfMass
---@see Shape:getOffset
---@see Shape:setOffset
---@see Shape
---@return number # The x position of the center of mass.
---@return number # The y position of the center of mass.
---@return number # The z position of the center of mass.
function Shape:getCenterOfMass() end

--- Returns the Collider the Shape is attached to.
--- This function will return `nil` if the Shape is not attached to a Collider.  When a Shape isn't attached to a Collider, the Shape can still be used for queries with `World:overlapShape` and `World:shapecast`.
---@see Collider
---@see Collider:getShape
---@see Collider:getShapes
---@see Collider:addShape
---@see Collider:removeShape
---@see Shape
---@return Collider # The Collider the Shape is attached to, or nil if the Shape isn't attached to a Collider.
function Shape:getCollider() end

--- Returns the density of the Shape, in kilograms per cubic meter.  The density, combined with the volume of the Shape, determines the Shape's overall mass.
---@see Shape:getVolume
---@see Shape:getMass
---@see Shape:setDensity
---@see Shape
---@return number # The density of the Shape, in kilograms per cubic meter.
function Shape:getDensity() end

--- Returns the inertia of the Shape.
--- Inertia is kind of like "angular mass".  Regular mass determines how resistant a Collider is to linear forces (movement), whereas inertia determines how resistant the Collider is to torque (rotation).  Colliders with less inertia are more spinny.
--- In 3D, inertia is represented by a 3x3 matrix, called a tensor.  To make calculations easier, the physics engine stores the inertia using eigenvalue decomposition, splitting the matrix into a diagonal matrix and a rotation.  It's complicated!
--- In a realistic simulation, mass and inertia follow a linear relationship.  If the mass of an object increases, the diagonal part of its inertia should increase proportionally.
---@see Shape:getMass
---@see Shape:getCenterOfMass
---@see Collider:getInertia
---@see Shape
---@return number # The x component of the diagonal matrix.
---@return number # The y component of the diagonal matrix.
---@return number # The z component of the diagonal matrix.
---@return number # The angle of the inertia rotation.
---@return number # The x component of the inertia rotation axis.
---@return number # The y component of the inertia rotation axis.
---@return number # The z component of the inertia rotation axis.
function Shape:getInertia() end

--- Returns the mass of the Shape, in kilograms.  The mass is the volume multiplied by the density.
---@see Collider:getMass
---@see Collider:setMass
---@see Collider:resetMassData
---@see Shape:getVolume
---@see Shape:getDensity
---@see Shape:setDensity
---@see Shape:getInertia
---@see Shape:getCenterOfMass
---@see Shape
---@return number # The mass of the Shape, in kilograms.
function Shape:getMass() end

--- Returns the local offset of the Shape.  When the Shape is attached to a Collider, it will have this offset relative to the Collider.
---@see Shape:getPosition
---@see Shape:getOrientation
---@see Shape:getPose
---@see Shape:setOffset
---@see Shape
---@return number # The local x offset of the Shape, in meters.
---@return number # The local y offset of the Shape, in meters.
---@return number # The local z offset of the Shape, in meters.
---@return number # The number of radians the Shape is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Shape:getOffset() end

--- Get the orientation of the Shape in world space, taking into account the position and orientation of the Collider it's attached to, if any.  Shapes that aren't attached to a Collider will return their local offset.
---@see Shape:getPosition
---@see Shape:getPose
---@see Shape:getOffset
---@see Shape:setOffset
---@see Shape
---@return number # The number of radians the Shape is rotated.
---@return number # The x component of the rotation axis.
---@return number # The y component of the rotation axis.
---@return number # The z component of the rotation axis.
function Shape:getOrientation() end

--- Returns the position and orientation of the Shape in world space, taking into the account the position and orientation of the Collider it's attached to, if any.  Shapes that aren't attached to a Collider will return their local offset.
---@see Shape:getPosition
---@see Shape:getOrientation
---@see Shape:getOffset
---@see Shape:setOffset
---@see Shape
---@return number # The x position of the Shape, in meters.
---@return number # The y position of the Shape, in meters.
---@return number # The z position of the Shape, in meters.
---@return number # The number of radians the Shape is rotated around its axis of rotation.
---@return number # The x component of the axis of rotation.
---@return number # The y component of the axis of rotation.
---@return number # The z component of the axis of rotation.
function Shape:getPose() end

--- Returns the position of the Shape in world space, taking into the account the position and orientation of the Collider it's attached to, if any.  Shapes that aren't attached to a Collider will return their local offset.
---@see Shape:getOrientation
---@see Shape:getPose
---@see Shape:getOffset
---@see Shape:setOffset
---@see Shape
---@return number # The x position, in world space.
---@return number # The y position, in world space.
---@return number # The z position, in world space.
function Shape:getPosition() end

--- Returns the type of the Shape.
---@see Shape
---@return ShapeType # The type of the Shape.
function Shape:getType() end

--- Returns the Lua value associated with the Shape.
---@see Collider:getUserData
---@see Collider:setUserData
---@see Joint:getUserData
---@see Joint:setUserData
---@see Shape:setUserData
---@see Shape
---@return any # The custom value associated with the Shape.
function Shape:getUserData() end

--- Returns the volume of the Shape, in cubic meters.
---@see Shape:getDensity
---@see Shape:setDensity
---@see Shape:getMass
---@see Shape:getAABB
---@see Shape
---@return number # The volume of the shape, in cubic meters.
function Shape:getVolume() end

--- Returns whether the Shape has been destroyed.  Destroyed shapes can not be used for anything.
---@see Shape:destroy
---@see Collider:isDestroyed
---@see Joint:isDestroyed
---@see World:isDestroyed
---@see Shape
---@return boolean # Whether the Shape has been destroyed.
function Shape:isDestroyed() end

--- Casts a ray against the Shape and returns the first intersection.
--- This takes into account the pose of the Shape's collider (if any), as well as its local offset set with `Shape:setOffset`.
---@see World:raycast
---@see Shape:containsPoint
---@see World:shapecast
---@see World:overlapShape
---@see Shape
---@overload fun(origin: Vec3, endpoint: Vec3): number, number, number, number, number, number, number
---@param x1 number # The x coordinate of the origin of the ray.
---@param y1 number # The y coordinate of the origin of the ray.
---@param z1 number # The z coordinate of the origin of the ray.
---@param x2 number # The x coordinate of the endpoint of the ray.
---@param y2 number # The y coordinate of the endpoint of the ray.
---@param z2 number # The z coordinate of the endpoint of the ray.
---@return number # The x coordinate of the impact point.
---@return number # The y coordinate of the impact point.
---@return number # The z coordinate of the impact point.
---@return number # The x component of the normal vector.
---@return number # The y component of the normal vector.
---@return number # The z component of the normal vector.
---@return number # The index of the triangle that was hit, or `nil` if this is not a MeshShape.
function Shape:raycast(x1, y1, z1, x2, y2, z2) end

--- Sets the density of the Shape, in kilograms per cubic meter.  The density, combined with the volume of the Shape, determines the Shape's overall mass.
---@see Shape:getVolume
---@see Shape:getMass
---@see Shape:getDensity
---@see Shape
---@param density number # The density of the Shape, in kilograms per cubic meter.
function Shape:setDensity(density) end

--- Sets the local offset of the Shape.  When the Shape is attached to a Collider, it will have this offset relative to the Collider.
---@see Shape:getPosition
---@see Shape:getOrientation
---@see Shape:getPose
---@see Shape
---@overload fun(position: Vec3, rotation: Quat)
---@param x number # The local x offset of the Shape, in meters.
---@param y number # The local y offset of the Shape, in meters.
---@param z number # The local z offset of the Shape, in meters.
---@param angle number # The number of radians the Shape is rotated around its axis of rotation.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function Shape:setOffset(x, y, z, angle, ax, ay, az) end

--- Associates a Lua value with the Shape.
---@see Collider:getUserData
---@see Collider:setUserData
---@see Joint:getUserData
---@see Joint:setUserData
---@see Shape:getUserData
---@see Shape
---@param data any # The custom value to associate with the Shape.
function Shape:setUserData(data) end

---@class SliderJoint
local SliderJoint = {}

--- Returns the axis of the slider, in world space.
---@see SliderJoint:getPosition
---@see SliderJoint
---@return number # The x component of the axis.
---@return number # The y component of the axis.
---@return number # The z component of the axis.
function SliderJoint:getAxis() end

--- Returns the friction of the SliderJoint.  This is a maximum friction force that will be applied, in newtons, opposing movement along the slider axis.
---@see SliderJoint:setFriction
---@see SliderJoint
---@return number # The maximum friction force, in newtons.
function SliderJoint:getFriction() end

--- Returns the position limits of the SliderJoint.  The "zero" position is determined by the relative position of the colliders at the time the joint was created, and positive positions are further apart along the slider axis.
---@see SliderJoint:getPosition
---@see SliderJoint:setLimits
---@see SliderJoint
---@return number # The minimum position, in meters.  Must be less than or equal to zero.
---@return number # The maximum position, in meters.  Must be greater than or equal to zero.
function SliderJoint:getLimits() end

--- Returns the maximum amount of force the motor can use to reach its target, in newtons.
--- There are separate limits for each direction the slider can move.  They're usually kept the same, but one of them can be set to zero to make a motor that can only push in one direction. Note that both limits are positive.
---@see SliderJoint:getMotorForce
---@see SliderJoint:setMaxMotorForce
---@see SliderJoint
---@return number # The maximum amount of force the motor can use to push the slider in the "positive" direction, in newtons.
---@return number # The maximum amount of force the motor can use to push the slider in the "negative" direction, in newtons.
function SliderJoint:getMaxMotorForce() end

--- Returns the current force the motor is using to reach its target, in newtons.
---@see SliderJoint:getMaxMotorForce
---@see SliderJoint:setMaxMotorForce
---@see SliderJoint
---@return number # The current force, in newtons.
function SliderJoint:getMotorForce() end

--- Returns the motor mode of the SliderJoint.  When enabled, the motor will drive the slider to a target position (for the `position` mode) or a target speed (for the `velocity` mode), set by `SliderJoint:setMotorTarget`.
---@see SliderJoint:getMotorTarget
---@see SliderJoint:setMotorTarget
---@see SliderJoint:setMotorMode
---@see SliderJoint
---@return MotorMode # The mode of the motor, or `nil` if the motor is disabled.
function SliderJoint:getMotorMode() end

--- Returns the spring parameters of the motor target.  These are similar to the spring parameters set by `SliderJoint:setSpring`, but they apply to the motor when it reaches its target instead of the position limits of the slider joint.  Note that these only take effect when the motor mode is `position`.
---@see SliderJoint:getSpring
---@see SliderJoint:setSpring
---@see SliderJoint:getMotorTarget
---@see SliderJoint:setMotorTarget
---@see SliderJoint:setMotorSpring
---@see SliderJoint
---@return number # The frequency of the spring, in hertz.  Higher frequencies make the spring more stiff.  When zero, the spring is disabled.
---@return number # The damping ratio of the spring.
function SliderJoint:getMotorSpring() end

--- Returns the target value for the SliderJoint's motor.  This is either a target position or a target velocity, based on the mode set by `SliderJoint:setMotorMode`.
---@see SliderJoint:getMotorMode
---@see SliderJoint:setMotorMode
---@see SliderJoint
---@return number # The target value, in meters or meters per second, depending on the mode.
function SliderJoint:getMotorTarget() end

--- Returns the position of the slider joint.  The "zero" position is the relative distance the colliders were at when the joint is created, and positive positions are further apart along the slider's axis.
---@see SliderJoint:getAxis
---@see SliderJoint:setLimits
---@see SliderJoint
---@return number # The position of the slider joint, in meters.
function SliderJoint:getPosition() end

--- Returns the spring parameters of the SliderJoint.  Use this to make the position limits of the slider "soft".  When the motor is active, a separate set of spring parameters can be set on the motor, see `SliderJoint:setMotorSpring`.
---@see SliderJoint:getMotorSpring
---@see SliderJoint:setMotorSpring
---@see SliderJoint:setSpring
---@see SliderJoint
---@return number # The frequency of the spring, in hertz.  Higher frequencies make the spring more stiff.  When zero, the spring is disabled.
---@return number # The damping ratio of the spring.
function SliderJoint:getSpring() end

--- Sets the friction of the SliderJoint.  This is a maximum friction force that will be applied, in newtons, opposing movement along the slider axis.
---@see SliderJoint:getFriction
---@see SliderJoint
---@param friction number # The maximum friction force, in newtons.
function SliderJoint:setFriction(friction) end

--- Sets the position limits of the SliderJoint.  The "zero" position is determined by the relative position of the colliders at the time the joint was created, and positive distances are further apart on the slider axis.
---@see SliderJoint:getPosition
---@see SliderJoint:getLimits
---@see SliderJoint
---@overload fun()
---@param min number # The minimum position, in meters.  Must be less than or equal to zero.
---@param max number # The maximum position, in meters.  Must be greater than or equal to zero.
function SliderJoint:setLimits(min, max) end

--- Sets the maximum amount of force the motor can use to reach its target, in newtons.
--- There are separate limits for each direction the slider can move.  They're usually kept the same, but one of them can be set to zero to make a motor that can only push in one direction. Note that both limits are positive.
---@see SliderJoint:getMotorForce
---@see SliderJoint:getMaxMotorForce
---@see SliderJoint
---@param positive number? # The maximum amount of force the motor can use to push the slider in the "positive" direction, in newtons. (default: math.huge)
---@param negative number? # The maximum amount of force the motor can use to push the slider in the "negative" direction, in newtons. (default: positive)
function SliderJoint:setMaxMotorForce(positive, negative) end

--- Sets the motor mode of the SliderJoint.  When enabled, the motor will drive the slider to a target position (for the `position` mode) or a target speed (for the `velocity` mode), set by `SliderJoint:setMotorTarget`.
---@see SliderJoint:getMotorTarget
---@see SliderJoint:setMotorTarget
---@see SliderJoint:getMotorMode
---@see SliderJoint
---@overload fun()
---@param mode MotorMode # The mode of the motor.
function SliderJoint:setMotorMode(mode) end

--- Sets the spring parameters of the motor target.  These are similar to the spring parameters set by `SldierJoint:setSpring`, but they apply to the motor when it reaches its target instead of the position limits of the slider joint.  Note that these only take effect when the motor mode is `position`.
---@see SliderJoint:getSpring
---@see SliderJoint:setSpring
---@see SliderJoint:getMotorTarget
---@see SliderJoint:setMotorTarget
---@see SliderJoint:getMotorSpring
---@see SliderJoint
---@param frequency number? # The frequency of the spring, in hertz.  Higher frequencies make the spring more stiff.  When zero, the spring is disabled. (default: 0.0)
---@param damping number? # The damping ratio of the spring. (default: 1.0)
function SliderJoint:setMotorSpring(frequency, damping) end

--- Sets the target value for the SliderJoint's motor.  This is either a target position or a target velocity, based on the mode set by `SliderJoint:setMotorMode`.
---@see SliderJoint:getMotorMode
---@see SliderJoint:setMotorMode
---@see SliderJoint:getMotorTarget
---@see SliderJoint
---@param target number # The target value, in meters or meters per second, depending on the mode.
function SliderJoint:setMotorTarget(target) end

--- Sets the spring parameters of the SliderJoint.  Use this to make the position limits of the slider "soft".  When the motor is active, a separate set of spring parameters can be set on the motor, see `SliderJoint:setMotorSpring`.
---@see SliderJoint:getMotorSpring
---@see SliderJoint:setMotorSpring
---@see SliderJoint:getSpring
---@see SliderJoint
---@param frequency number? # The frequency of the spring, in hertz.  Higher frequencies make the spring more stiff.  When zero, the spring is disabled. (default: 0.0)
---@param damping number? # The damping ratio of the spring. (default: 1.0)
function SliderJoint:setSpring(frequency, damping) end

---@class SphereShape
local SphereShape = {}

--- Returns the radius of the SphereShape.
---@see SphereShape:setRadius
---@see SphereShape
---@return number # The radius of the sphere, in meters.
function SphereShape:getRadius() end

--- Sets the radius of the SphereShape.
---@see SphereShape:getRadius
---@see SphereShape
---@param radius number # The radius of the sphere, in meters.
function SphereShape:setRadius(radius) end

---@class TerrainShape
local TerrainShape = {}

---@class WeldJoint
local WeldJoint = {}

---@class World
local World = {}

--- Destroys the World.  This will destroy all colliders, shapes, and joints in the world.  After calling this function, the world can no longer be used.  Attempting to call a method on the World after destroying it will error, with the exception of `World:isDestroyed`.
---@see Collider:destroy
---@see Shape:destroy
---@see Joint:destroy
---@see World
function World:destroy() end

--- Disables collision between two tags.  Use `Collider:setTag` to set a Collider's tag.
---@see World:enableCollisionBetween
---@see World:isCollisionEnabledBetween
---@see lovr.physics.newWorld
---@see World:getTags
---@see Collider:setTag
---@see World
---@param tag1 string # The first tag.
---@param tag2 string # The second tag.
function World:disableCollisionBetween(tag1, tag2) end

--- Enables collision between two tags.  Use `Collider:setTag` to set a Collider's tag.
---@see World:disableCollisionBetween
---@see World:isCollisionEnabledBetween
---@see lovr.physics.newWorld
---@see World:getTags
---@see Collider:setTag
---@see World
---@param tag1 string # The first tag.
---@param tag2 string # The second tag.
function World:enableCollisionBetween(tag1, tag2) end

--- Returns the angular damping parameters of the World.  Angular damping makes things less "spinny", making them slow down their angular velocity over time.
---@see Collider:getAngularDamping
---@see Collider:setAngularDamping
---@see World:setAngularDamping
---@see World
---@return number # The angular damping.
---@return number # Velocity limit below which the damping is not applied.
function World:getAngularDamping() end

--- - Returns the callbacks assigned to the World.
--- - The callbacks are described in more detail on `World:setCallbacks`.
---@see World:setCallbacks
---@see World
---@return table # The World collision callbacks.
function World:getCallbacks() end

--- Returns the number of colliders in the world.  This includes sleeping and disabled colliders.
---@see World:getColliders
---@see World:getJointCount
---@see World
---@return number # The number of colliders in the World.
function World:getColliderCount() end

--- Returns a list of colliders in the world.  This includes sleeping and disabled colliders.
---@see World:getColliderCount
---@see World:getJoints
---@see World
---@return table # The list of `Collider` objects in the World.
function World:getColliders() end

--- Returns the World's gravity.  Gravity is a constant acceleration applied to all colliders.  The default is `(0, -9.81, 0)` meters per second squared, causing colliders to fall downward.
--- Use `Collider:setGravityScale` to change gravity strength for a single collider.
---@see Collider:getGravityScale
---@see Collider:setGravityScale
---@see Collider:getLinearDamping
---@see Collider:setLinearDamping
---@see World:setGravity
---@see World
---@return number # The x component of the gravity force, in meters per second squared.
---@return number # The y component of the gravity force, in meters per second squared.
---@return number # The z component of the gravity force, in meters per second squared.
function World:getGravity() end

--- Returns the number of joints in the world.  This includes disabled joints.
---@see World:getJoints
---@see World:getColliderCount
---@see World
---@return number # The number of joints in the World.
function World:getJointCount() end

--- Returns a table with all the joints in the World.  This includes disabled joints.
---@see World:getJointCount
---@see World:getColliders
---@see World
---@return table # The list of `Joint` objects in the World.
function World:getJoints() end

--- Returns the linear damping parameters of the World.  Linear damping is similar to drag or air resistance, slowing down colliders over time as they move.
---@see Collider:getLinearDamping
---@see Collider:setLinearDamping
---@see World:setLinearDamping
---@see World
---@return number # The linear damping.
---@return number # Velocity limit below which the damping is not applied.
function World:getLinearDamping() end

--- Returns the response time factor of the World.
--- The response time controls how relaxed collisions and joints are in the physics simulation, and functions similar to inertia.  A low response time means collisions are resolved quickly, and higher values make objects more spongy and soft.
--- The value can be any positive number.  It can be changed on a per-joint basis for `DistanceJoint` and `BallJoint` objects.
---@see World:setResponseTime
---@see World
---@return number # The response time setting for the World.
function World:getResponseTime() end

--- Returns the step count of the World.  The step count influences how many steps are taken during a call to `World:update`.  A higher number of steps will be slower, but more accurate.  The default step count is 20.
---@see World:update
---@see World:setStepCount
---@see World
---@return number # The step count.
function World:getStepCount() end

--- Returns the list of collision tags that were specified when the World was created.  Tags are assigned to colliders using `Collider:setTag`, and collision can be enabled/disabled for pairs of tags with `World:enableCollisionBetween` and `World:disableCollisionBetween`.
---@see lovr.physics.newWorld
---@see Collider:getTag
---@see Collider:setTag
---@see World:enableCollisionBetween
---@see World:disableCollisionBetween
---@see World:isCollisionEnabledBetween
---@see World
---@return table # A table of collision tags (strings).
function World:getTags() end

--- Returns the tightness of joints in the World.
--- The tightness controls how much force is applied to colliders connected by joints.  With a value of 0, no force will be applied and joints won't have any effect.  With a tightness of 1, a strong force will be used to try to keep the Colliders constrained.  A tightness larger than 1 will overcorrect the joints, which can sometimes be desirable.  Negative tightness values are not supported.
---@see World:setTightness
---@see World
---@return number # The tightness of the World.
function World:getTightness() end

--- Interpolates collider poses between their previous pose and their current pose.  Methods like `Collider:getPosition` and `Collider:getOrientation` will return the smoothed values.
--- After `World:update` is called, any interpolation is reset and `World:interpolate` will need to be called again to recompute the interpolated poses.
--- This can be used to decouple the physics tick rate from the rendering rate.  For example, the physics simulation can be run at a fixed rate of 30Hz, and collider poses can be interpolated before rendering.  This leads to a more stable simulation, and allows the physics rate to be increased or decreased as desired, independent of the current display refresh rate.
---@see World
---@param alpha number # The interpolation parameter.  An alpha of zero will use the previous collider pose, an alpha of 1.0 will use the latest collider pose, etc.  Can be less than zero or greater than one.
function World:interpolate(alpha) end

--- Returns whether collisions are enabled between a pair of tags.
---@see World:disableCollisionBetween
---@see World:enableCollisionBetween
---@see lovr.physics.newWorld
---@see World:getTags
---@see Collider:setTag
---@see World
---@param tag1 string # The first tag.
---@param tag2 string # The second tag.
---@return boolean # Whether or not two colliders with the specified tags will collide.
function World:isCollisionEnabledBetween(tag1, tag2) end

--- Returns whether the World has been destroyed.  Destroyed worlds can not be used for anything.
---@see World:destroy
---@see Collider:isDestroyed
---@see Shape:isDestroyed
---@see Joint:isDestroyed
---@see World
---@return boolean # Whether the World has been destroyed.
function World:isDestroyed() end

--- Returns whether colliders can go to sleep in the World.
---@see Collider:isSleepingAllowed
---@see Collider:setSleepingAllowed
---@see Collider:isAwake
---@see Collider:setAwake
---@see World:setSleepingAllowed
---@see World
---@return boolean # Whether colliders can sleep.
function World:isSleepingAllowed() end

--- Adds a Collider to the world and attaches a `BoxShape`.
---@see BoxShape
---@see Collider
---@see World:newCollider
---@see World:newSphereCollider
---@see World:newCapsuleCollider
---@see World:newCylinderCollider
---@see World:newConvexCollider
---@see World:newMeshCollider
---@see World:newTerrainCollider
---@see World
---@overload fun(position: Vec3, size: Vec3): Collider
---@param x number? # The x coordinate of the center of the box, in meters. (default: 0)
---@param y number? # The y coordinate of the center of the box, in meters. (default: 0)
---@param z number? # The z coordinate of the center of the box, in meters. (default: 0)
---@param width number? # The width of the box, in meters. (default: 1)
---@param height number? # The height of the box, in meters. (default: width)
---@param depth number? # The depth of the box, in meters. (default: width)
---@return Collider # The new Collider.
function World:newBoxCollider(x, y, z, width, height, depth) end

--- Adds a Collider to the world and attaches a `CapsuleShape`.
---@see CapsuleShape
---@see Collider
---@see World:newCollider
---@see World:newBoxCollider
---@see World:newSphereCollider
---@see World:newCylinderCollider
---@see World:newConvexCollider
---@see World:newMeshCollider
---@see World:newTerrainCollider
---@see World
---@overload fun(position: Vec3, radius: number, length: number): Collider
---@param x number? # The x coordinate of the center of the capsule, in meters. (default: 0)
---@param y number? # The y coordinate of the center of the capsule, in meters. (default: 0)
---@param z number? # The z coordinate of the center of the capsule, in meters. (default: 0)
---@param radius number? # The radius of the capsule, in meters. (default: 1)
---@param length number? # The length of the capsule, not including the caps, in meters. (default: 1)
---@return Collider # The new Collider.
function World:newCapsuleCollider(x, y, z, radius, length) end

--- Adds a new Collider to the World, without attaching any Shapes to it.  Use `Collider:addShape` to add shapes.
---@see World:newBoxCollider
---@see World:newSphereCollider
---@see World:newCapsuleCollider
---@see World:newCylinderCollider
---@see World:newConvexCollider
---@see World:newMeshCollider
---@see World:newTerrainCollider
---@see Collider:addShape
---@see Collider
---@see Shape
---@see World
---@overload fun(position: Vec3): Collider
---@param x number # The x position of the Collider.
---@param y number # The y position of the Collider.
---@param z number # The z position of the Collider.
---@return Collider # The new Collider.
function World:newCollider(x, y, z) end

--- Adds a Collider to the world and attaches a `ConvexShape`.  A `ConvexShape` is a convex hull of a set of points, kinda like if you wrapped them in wrapping paper.
---@see ConvexShape
---@see Collider
---@see World:newCollider
---@see World:newBoxCollider
---@see World:newSphereCollider
---@see World:newCapsuleCollider
---@see World:newCylinderCollider
---@see World:newMeshCollider
---@see World:newTerrainCollider
---@see World
---@overload fun(position: Vec3, points: table, scale: number): Collider
---@overload fun(x: number, y: number, z: number, modelData: ModelData, scale: number): Collider
---@overload fun(position: Vec3, modelData: ModelData, scale: number): Collider
---@overload fun(x: number, y: number, z: number, model: Model, scale: number): Collider
---@overload fun(position: Vec3, model: Model, scale: number): Collider
---@overload fun(x: number, y: number, z: number, mesh: Mesh, scale: number): Collider
---@overload fun(position: Vec3, mesh: Mesh, scale: number): Collider
---@overload fun(x: number, y: number, z: number, template: ConvexShape, scale: number): Collider
---@overload fun(position: Vec3, template: ConvexShape, scale: number): Collider
---@param x number? # The x coordinate of the collider, in meters. (default: 0)
---@param y number? # The y coordinate of the collider, in meters. (default: 0)
---@param z number? # The z coordinate of the collider, in meters. (default: 0)
---@param points table # A list of vertices to compute a convex hull from.  Can be a table of tables (each with 3 numbers) or a table of numbers (every 3 numbers form a 3D point).
---@param scale number? # A scale to apply to the points. (default: 1.0)
---@return Collider # The new Collider.
function World:newConvexCollider(x, y, z, points, scale) end

--- Adds a Collider to the world and attaches a `CylinderShape`.
---@see CylinderShape
---@see Collider
---@see World:newCollider
---@see World:newBoxCollider
---@see World:newSphereCollider
---@see World:newCapsuleCollider
---@see World:newConvexCollider
---@see World:newMeshCollider
---@see World:newTerrainCollider
---@see World
---@overload fun(position: Vec3, radius: number, length: number): Collider
---@param x number? # The x coordinate of the center of the cylinder, in meters. (default: 0)
---@param y number? # The y coordinate of the center of the cylinder, in meters. (default: 0)
---@param z number? # The z coordinate of the center of the cylinder, in meters. (default: 0)
---@param radius number? # The radius of the cylinder, in meters. (default: 1)
---@param length number? # The length of the cylinder, in meters. (default: 1)
---@return Collider # The new Collider.
function World:newCylinderCollider(x, y, z, radius, length) end

--- Adds a Collider to the world and attaches a `MeshShape`.
--- Colliders with mesh shapes are immobile and can only be used for static environment objects. The collider will be kinematic and forces/velocities will not move it.  Also, these colliders will not detect collisions with other kinematic objects.
--- MeshShapes are not treated as solid objects, but instead a collection of triangles.  They do not have mass or volume, and there is no concept of being "inside" a mesh.  `ConvexShape` is a good alternative for making solid objects.
---@see Collider
---@see MeshShape
---@see World:newCollider
---@see World:newBoxCollider
---@see World:newSphereCollider
---@see World:newCapsuleCollider
---@see World:newCylinderCollider
---@see World:newConvexCollider
---@see World:newTerrainCollider
---@see Model:getTriangles
---@see World
---@overload fun(modelData: ModelData): Collider
---@overload fun(model: Model): Collider
---@overload fun(mesh: Mesh): Collider
---@overload fun(template: MeshShape): Collider
---@param vertices table # A table of vertices in the mesh.  Can be a table of tables (each with 3 numbers) or a table of numbers (every 3 numbers form a 3D vertex).
---@param indices table # A table of triangle indices representing how the vertices are connected together into triangles.
---@return Collider # The new Collider.
function World:newMeshCollider(vertices, indices) end

--- Adds a Collider to the world and attaches a `SphereShape`.
---@see SphereShape
---@see Collider
---@see World:newCollider
---@see World:newBoxCollider
---@see World:newCapsuleCollider
---@see World:newCylinderCollider
---@see World:newConvexCollider
---@see World:newMeshCollider
---@see World:newTerrainCollider
---@see World
---@overload fun(position: Vec3, radius: number): Collider
---@param x number? # The x coordinate of the center of the sphere, in meters. (default: 0)
---@param y number? # The y coordinate of the center of the sphere, in meters. (default: 0)
---@param z number? # The z coordinate of the center of the sphere, in meters. (default: 0)
---@param radius number? # The radius of the sphere, in meters. (default: 1)
---@return Collider # The new Collider.
function World:newSphereCollider(x, y, z, radius) end

--- Adds a Collider to the world and attaches a `TerrainShape`.
--- Colliders with terrain shapes are immobile and can only be used for static environment objects. The collider will be kinematic and forces/velocities will not move it.  Also, these colliders will not detect collisions with other kinematic objects.
--- TerrainShapes are not treated as solid objects, but instead a collection of triangles.  They do not have mass or volume, and there is no concept of being "inside" the terrain.
---@see Collider
---@see TerrainShape
---@see World:newCollider
---@see World:newBoxCollider
---@see World:newCapsuleCollider
---@see World:newCylinderCollider
---@see World:newSphereCollider
---@see World:newMeshCollider
---@see lovr.data.newImage
---@see World
---@overload fun(scale: number, heightmap: Image, stretch: number): Collider
---@overload fun(scale: number, callback: function, samples: number): Collider
---@param scale number # The width and depth of the terrain, in meters.
---@return Collider # The new Collider.
function World:newTerrainCollider(scale) end

--- Places a shape in the World, returning any shapes it intersects.
--- A tag filter can be given to filter out shapes by their collider's tag:
--- - Use nil to skip filtering.
--- - Pass a tag name to only return shapes whose collider has that tag.
--- - Pass a tag name with a ~ in front of it to exclude colliders with that tag.
--- - Pass multiple tags separated by spaces to include multiple tags (works with ~ too).
--- Provide an optional callback to call for each shape detected.  If the callbacks nil, this function returns the first shape detected.  In either case this function returns the shape, the hit position, and a penetration vector.  The penetration vector represents the direction and distance the shape would need to move so that it is no longer colliding with the input shape.
---@see World:shapecast
---@see World:raycast
---@see World:queryBox
---@see World:querySphere
---@see World
---@overload fun(shape: Shape, position: Vec3, orientation: Quat, maxDistance: number, filter: string, callback: function)
---@overload fun(shape: Shape, x: number, y: number, z: number, angle: number, ax: number, ay: number, az: number, maxDistance: number, filter: string): Collider, Shape, number, number, number, number, number, number
---@overload fun(shape: Shape, position: Vec3, orientation: Quat, maxDistance: number, filter: string): Collider, Shape, number, number, number, number, number, number
---@param shape Shape # The Shape to test.
---@param x number # The x position to place the shape at, in meters.
---@param y number # The y position to place the shape at, in meters.
---@param z number # The z position to place the shape at, in meters.
---@param angle number # The angle the shape is rotated around its rotation axis, in radians.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
---@param maxDistance number? # The maximum distance at which a shape can be detected, in meters.  Zero will detect shapes touching the input shape, 1.0 will detect shapes within 1 meter of the input shape, etc. (default: 0)
---@param filter string? # Tags to filter by, or nil for no filter. (default: nil)
---@param callback function # The callback to call for each intersection detected.
function World:overlapShape(shape, x, y, z, angle, ax, ay, az, maxDistance, filter, callback) end

--- Find colliders within an axis-aligned bounding box.  This is a fast but imprecise query that only checks a rough box around colliders.  Use `World:overlapShape` for an exact collision test.
--- Rough queries like this are useful for doing a quick check before doing lots of more expensive collision testing.
--- Pass a callback function to call for each collider detected, or leave the callback off and this function will return the first collider found.
---@see World:querySphere
---@see World:overlapShape
---@see World:shapecast
---@see World:raycast
---@see World
---@overload fun(position: Vec3, size: Vec3, filter: string, callback: function)
---@overload fun(x: number, y: number, z: number, width: number, height: number, depth: number, filter: string): Collider
---@overload fun(position: Vec3, size: Vec3, filter: string): Collider
---@param x number # The x coordinate of the center of the box, in meters.
---@param y number # The y coordinate of the center of the box, in meters.
---@param z number # The z coordinate of the center of the box, in meters.
---@param width number # The width of the box, in meters
---@param height number # The height of the box, in meters
---@param depth number # The depth of the box, in meters.
---@param filter string? # An optional tag filter.  Pass one or more tags separated by spaces to only return colliders with those tags.  Or, put `~` in front of the tags to exclude colliders with those tags. (default: nil)
---@param callback function # A function to call when a collider is detected.  The function will be called with a single `Collider` argument.
function World:queryBox(x, y, z, width, height, depth, filter, callback) end

--- Find colliders within a sphere.  This is a fast but imprecise query that only checks a rough box around colliders.  Use `World:overlapShape` for an exact collision test.
--- Rough queries like this are useful for doing a quick check before doing lots of more expensive collision testing.
--- Pass a callback function to call for each collider detected, or leave the callback off and this function will return the first collider found.
---@see World:queryBox
---@see World:overlapShape
---@see World:shapecast
---@see World:raycast
---@see World
---@overload fun(position: Vec3, radius: number, filter: string, callback: function)
---@overload fun(x: number, y: number, z: number, radius: number, filter: string): Collider
---@overload fun(position: Vec3, radius: number, filter: string): Collider
---@param x number # The x coordinate of the center of the sphere.
---@param y number # The y coordinate of the center of the sphere.
---@param z number # The z coordinate of the center of the sphere.
---@param radius number # The radius of the sphere, in meters
---@param filter string? # An optional tag filter.  Pass one or more tags separated by spaces to only return colliders with those tags.  Or, put `~` in front of the tags to exclude colliders with those tags. (default: nil)
---@param callback function # A function to call when an intersection is detected.  The function will be called with a single `Collider` argument.
function World:querySphere(x, y, z, radius, filter, callback) end

--- Traces a ray through the world and calls a function for each collider that was hit.
--- The callback can be left off, in which case the closest hit will be returned.
---@see Shape:raycast
---@see World:shapecast
---@see World:overlapShape
---@see World:queryBox
---@see World:querySphere
---@see World
---@overload fun(origin: Vec3, endpoint: Vec3, filter: string, callback: function)
---@overload fun(x1: number, y1: number, z1: number, x2: number, y2: number, z2: number, filter: string): Collider, Shape, number, number, number, number, number, number, number
---@overload fun(origin: Vec3, endpoint: Vec3, filter: string): Collider, Shape, number, number, number, number, number, number, number
---@param x1 number # The x coordinate of the origin of the ray.
---@param y1 number # The y coordinate of the origin of the ray.
---@param z1 number # The z coordinate of the origin of the ray.
---@param x2 number # The x coordinate of the endpoint of the ray.
---@param y2 number # The y coordinate of the endpoint of the ray.
---@param z2 number # The z coordinate of the endpoint of the ray.
---@param filter string? # An optional tag filter.  Pass one or more tags separated by spaces to only return colliders with those tags.  Or, put `~` in front the tags to exclude colliders with those tags. (default: nil)
---@param callback function # The function to call when an intersection is detected (see notes).
function World:raycast(x1, y1, z1, x2, y2, z2, filter, callback) end

--- Sets the angular damping of the World.  Angular damping makes things less "spinny", making them slow down their angular velocity over time. Damping is only applied when angular velocity is over the threshold value.
---@see Collider:getAngularDamping
---@see Collider:setAngularDamping
---@see World:getAngularDamping
---@see World
---@param damping number # The angular damping.
---@param threshold number? # Velocity limit below which the damping is not applied. (default: 0)
function World:setAngularDamping(damping, threshold) end

--- Assigns collision callbacks to the world.  These callbacks are used to filter collisions or get notifications when colliders start or stop touching.  Callbacks are called during `World:update`.
--- ### Filter
--- Filters collisions.  Receives two colliders and returns a boolean indicating if they should collide.  Note that it is much faster to use tags and `World:enableCollisionBetween` to control collision.  This should only be used when the logic for filtering the collision is highly dynamic.
--- ### Enter
--- Called when two colliders begin touching.  Receives two colliders and a `Contact` object with more information about the collision.  The `contact` callback will also be called for this collision.
--- ### Exit
--- Called when two colliders stop touching.  Receives two colliders.
--- ### Contact
--- Called continuously while two colliders are touching.  Receives two colliders and a `Contact` object with more information about the collision.  The contact can also be disabled to disable the collision response, and its friction/resitution/velocity can be changed.  There can be multiple active contact areas (called "manifolds") between a pair of colliders; this callback will be called for each one.
---@see World:update
---@see Contact
---@see World:getCallbacks
---@see World
---@param callbacks table # The World collision callbacks.
function World:setCallbacks(callbacks) end

--- Sets the World's gravity.  Gravity is a constant acceleration applied to all colliders.  The default is `(0, -9.81, 0)` meters per second squared, causing colliders to fall downward.
--- Use `Collider:setGravityScale` to change gravity strength for a single collider.
---@see Collider:getGravityScale
---@see Collider:setGravityScale
---@see Collider:getLinearDamping
---@see Collider:setLinearDamping
---@see World:getGravity
---@see World
---@overload fun(gravity: Vec3)
---@param xg number # The x component of the gravity force.
---@param yg number # The y component of the gravity force.
---@param zg number # The z component of the gravity force.
function World:setGravity(xg, yg, zg) end

--- Sets the linear damping of the World.  Linear damping is similar to drag or air resistance, slowing down colliders over time as they move. Damping is only applied when linear velocity is over the threshold value.
---@see Collider:getLinearDamping
---@see Collider:setLinearDamping
---@see World:getLinearDamping
---@see World
---@param damping number # The linear damping.
---@param threshold number? # Velocity limit below which the damping is not applied. (default: 0)
function World:setLinearDamping(damping, threshold) end

--- Sets the response time factor of the World.
--- The response time controls how relaxed collisions and joints are in the physics simulation, and functions similar to inertia.  A low response time means collisions are resolved quickly, and higher values make objects more spongy and soft.
--- The value can be any positive number.  It can be changed on a per-joint basis for `DistanceJoint` and `BallJoint` objects.
---@see World:getResponseTime
---@see World
---@param responseTime number # The new response time setting for the World.
function World:setResponseTime(responseTime) end

--- Sets whether colliders can go to sleep in the World.
---@see Collider:isSleepingAllowed
---@see Collider:setSleepingAllowed
---@see Collider:isAwake
---@see Collider:setAwake
---@see World:isSleepingAllowed
---@see World
---@param allowed boolean # Whether colliders can sleep.
function World:setSleepingAllowed(allowed) end

--- Sets the step count of the World.  The step count influences how many steps are taken during a call to `World:update`.  A higher number of steps will be slower, but more accurate.  The default step count is 20.
---@see World:update
---@see World:getStepCount
---@see World
---@param steps number # The new step count.
function World:setStepCount(steps) end

--- Sets the tightness of joints in the World.
--- The tightness controls how much force is applied to colliders connected by joints.  With a value of 0, no force will be applied and joints won't have any effect.  With a tightness of 1, a strong force will be used to try to keep the Colliders constrained.  A tightness larger than 1 will overcorrect the joints, which can sometimes be desirable.  Negative tightness values are not supported.
---@see World:getTightness
---@see World
---@param tightness number # The new tightness for the World.
function World:setTightness(tightness) end

--- Moves a shape from a starting point to an endpoint and returns any colliders it touches along its path.
--- This is similar to a raycast, but with a `Shape` instead of a point.
---@see World:raycast
---@see World:overlapShape
---@see World:queryBox
---@see World:querySphere
---@see World
---@overload fun(shape: Shape, position: Vec3, destination: Vec3, orientation: Quat, filter: string, callback: function)
---@overload fun(shape: Shape, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number, angle: number, ax: number, ay: number, az: number, filter: string): Collider, Shape, number, number, number, number, number, number, number, number
---@overload fun(shape: Shape, position: Vec3, destination: Vec3, orientation: Quat, filter: string): Collider, Shape, number, number, number, number, number, number, number, number
---@param shape Shape # The Shape to cast.
---@param x1 number # The x position to start at.
---@param y1 number # The y position to start at.
---@param z1 number # The z position to start at.
---@param x2 number # The x position to move the shape to.
---@param y2 number # The y position to move the shape to.
---@param z2 number # The z position to move the shape to.
---@param angle number # The rotation of the shape around its rotation axis, in radians.
---@param ax number # The x component of the rotation axis.
---@param ay number # The y component of the rotation axis.
---@param az number # The z component of the rotation axis.
---@param filter string? # An optional tag filter.  Pass one or more tags separated by spaces to only return colliders with those tags.  Or, put `~` in front the tags to exclude colliders with those tags. (default: nil)
---@param callback function # The function to call when an intersection is detected (see notes).
function World:shapecast(shape, x1, y1, z1, x2, y2, z2, angle, ax, ay, az, filter, callback) end

--- Updates the World, advancing the physics simulation forward in time and moving all the colliders.
---@see lovr.physics.newWorld
---@see World
---@param dt number # The amount of time to advance the simulation forward.
function World:update(dt) end

_G.lovr.physics = physics
