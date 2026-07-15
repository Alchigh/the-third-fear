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
@onready var angel: Node3D = $"../terrain/angel"
@onready var god_bass: AudioStreamPlayer = $"../terrain/angel/god_bass"
@onready var ray_cast: RayCast3D = $Head/RayCast3D
var looking_at_angel := false

# Get the gravity from project settings
var gravity = 2 * ProjectSettings.get_setting("physics/3d/default_gravity")
var look_rot : Vector2
var stand_height : float
var og_vel : float = 0.0
## Where player start
var start_local : Vector3

var force_look : bool = false
var look_timer := 0.0
signal loud_noise

@export_group("Rock")
@export var rock_scene: PackedScene
@export var throw_force = 15.0
@onready var throw_point : Marker3D = $Head/Marker3D

func _ready():
	#Hides the cursor
	stand_height = collision_shape.shape.height
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	start_local = self.position
	look_rot.y = rotation_degrees.y
	loud_noise.connect(angel.scream)

func _physics_process(delta: float) -> void:
	var move_speed = speed
	# jump and crouch
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump
			%footsteps3d.play()
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
	
	## Footsteps on a timer
	#if !%footsteps3d.playing:
		#%footsteps3d.play()
	if is_on_floor() and direction != Vector3.ZERO and !force_look:
		if $Timer.time_left <= 0:
			%footsteps3d.play()
			$Timer.start(0.5)
	
	if !force_look:
		move_and_slide()
	
	# camera mouse movement
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	
	# fall damage and force camera
	label.text = " " + str(og_vel)
	if og_vel < 0 and force_look != true: 
		var diff = velocity.y - og_vel
		if diff > fall_dmg_threshold: 
			crouch(delta)
			fall_event()
			
	og_vel = velocity.y
		
	## Turn keep camera locked to towards the target
	if force_look:
		fl(delta)
		look_timer -= delta
		if look_timer <= 0.0:
			position = start_local
			force_look = false
	
	## Pump bass is looking at the angel
	if ray_cast.is_colliding() and ray_cast.get_collider().is_in_group("angel"):
		if !looking_at_angel:
			looking_at_angel = true
			god_bass.play()
	else:
		if looking_at_angel:
			looking_at_angel = false
			god_bass.stop()

## Pans camera towards a target
func fl(delta):
	var dir = (angel.global_position - head.global_position).normalized()
	var target_y = rad_to_deg(atan2(-dir.x, -dir.z))
	var target_x = rad_to_deg(asin(dir.y))
	look_rot.y = rad_to_deg(lerp_angle(deg_to_rad(look_rot.y),deg_to_rad(target_y),2.0 * delta))
	look_rot.x = lerp(look_rot.x,target_x,2.0 * delta)

## Fall event
func fall_event():
	%footsteps3d.play()
	force_look = true
	look_timer = 3.0
	print("Monster Sound") #TODO: Call monster sound. Turn screen white noise etc.
	loud_noise.emit()

## Camera moment and throw
func _input(event):
	if force_look: return
	
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
	
	rock.loud_noise.connect(angel.scream)
