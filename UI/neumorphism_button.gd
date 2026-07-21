#@tool
extends Button
@onready var itch_icon = preload("res://assets/itchio_logo.svg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !mouse_behavior_recursive == MOUSE_BEHAVIOR_DISABLED:
		pivot_offset_ratio = Vector2(0.5, 0.5)
		
	$front_button.text = text
	if self.name == "itch_button":
		$front_button.icon = itch_icon
