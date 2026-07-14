extends Node3D

## How much up and down
@export var float_height := 0.25
## How fast up and down
@export var float_duration := 1.6
## How fast side to side
@export var rotation_speed := 2.0
## How much side to side
@export var rock_angle := 2.0

var start_position: Vector3

func _ready():
	start_position = position
	start_float()
	start_rock()
	

## Rotates object around
func _process(delta):
	rotate_y(deg_to_rad(rotation_speed) * delta)

## Moves object up and down
func start_float():
	while true:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		## Move up
		tween.tween_property(
			self,
			"position",
			start_position + Vector3.UP * float_height,
			float_duration
		)
		## Back to start position
		tween.tween_property(
			self,
			"position",
			start_position,
			float_duration
		)

		await tween.finished

## Moves the object back side to side
func start_rock():
	while true:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		tween.tween_property(
			self,
			"rotation_degrees:x",
			rotation_degrees.x + rock_angle,
			2.5
		)

		tween.tween_property(
			self,
			"rotation_degrees:x",
			rotation_degrees.x - rock_angle,
			5.0
		)

		tween.tween_property(
			self,
			"rotation_degrees:x",
			rotation_degrees.x,
			2.5
		)

		await tween.finished

func scream():
	print(":3 angels")
	$AudioStreamPlayer.play()
