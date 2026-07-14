extends CharacterBody3D
class_name Player

@export_group("Movement")
## Movement speed
@export var speed = 8 
## Movement acceleration
@export var acceleration = 16.0
## Jump height
@export var jump = 8
## Fall damage threshold
@export var fall_dmg_threshold = 25

@export_subgroup("Crouch")
@export var crouch_speed = 0.5
@export var crouch_height = 2.0
@export var crouch_transition = 8.0

@export_group("Camera")
## Camera moment speed
@export var sensitivity = 0.5
## Max angle when looking down
@export var min_angle = -80
## Max angle when looking up
@export var max_angle = 90

@onready var head: Node3D = $Head
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var top_cast: ShapeCast3D = $TopCast
@onready var label: Label = $Label

# Get the gravity from project settings
var gravity = 2 * ProjectSettings.get_setting("physics/3d/default_gravity")
var look_rot : Vector2
var stand_height : float
var og_vel : float = 0.0
var start_local : Vector3

@export_group("Rock")
@export var rock_scene: PackedScene
@export var throw_force = 15.0
@onready var throw_point : Marker3D = $Head/Marker3D

func _ready():
	#Hides the cursor
	stand_height = collision_shape.shape.height
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	start_local = self.position

func _physics_process(delta: float) -> void:
	var move_speed = speed
	
	# jump and crouch
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump
		elif Input.is_action_pressed("crouch") or top_cast.is_colliding():
			move_speed = crouch_speed
			crouch(delta)
		else:
			crouch(delta, true)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * move_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, acceleration * delta)

	move_and_slide()
	
	# camera mouse movement
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
		
	# fall damage
	label.text = " " + str(og_vel)
	if og_vel < 0: 
		var diff = velocity.y - og_vel
		if diff > fall_dmg_threshold: 
			print("D:")
			crouch(delta)
			self.position = start_local
			## TODO: Call monster sound. Turn screen white noise etc.
	og_vel = velocity.y

## Camera moment and throw
func _input(event):
	# mouse look
	if event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)
	# throw
	if event.is_action_pressed("throw"):
		throw_rock()

## Makes player smaller when CTRL is held down.
func crouch(delta : float, reverse = false):
	var target_height : float = crouch_height if not reverse else stand_height
	collision_shape.shape.height = lerp(collision_shape.shape.height, target_height, crouch_transition * delta)
	collision_shape.position.y = lerp(collision_shape.position.y, target_height * 0.5, crouch_transition * delta)
	head.position.y = lerp(head.position.y, target_height - 1, crouch_transition * delta)

## Spawns a rock when R is pressed
func throw_rock():
	var rock = rock_scene.instantiate()
	rock.add_collision_exception_with(self)
	get_tree().current_scene.add_child(rock)
	
	rock.global_transform = throw_point.global_transform
	var forward = -throw_point.global_transform.basis.z
	rock.linear_velocity = forward * throw_force + Vector3.UP
