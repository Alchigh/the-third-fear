extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Player:
		body.fall_event()
		body.og_vel = body.velocity.y
