extends Area3D

@export var bad_jump : bool

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	print(self.name)

func _on_body_entered(body):
	if body is Player:
		print(body.name + "Hello")
	if body.is_in_group("rocks"):
		print("A rock entered!")
	else:
		print(":D" + str(body.name))
