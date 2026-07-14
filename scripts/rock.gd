extends RigidBody3D

@export var min_fall_distance := 17.0
var sound_played := false
var previous_velocity := Vector3.ZERO

signal loud_noise

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(_delta):
	previous_velocity = linear_velocity

func _on_body_entered(_body):
	if sound_played: return
	sound_played = true
	var impact_speed = previous_velocity.length()
	$AudioStreamPlayer3D.play()
	await $AudioStreamPlayer3D.finished
	print(impact_speed)
	if impact_speed > min_fall_distance:
		loud_noise.emit()
		
