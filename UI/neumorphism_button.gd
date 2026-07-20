#@tool
extends Button
@onready var itch_icon = preload("res://assets/itchio_logo.svg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$front_button.text = text
	if self.name == "itch_button":
		$front_button.icon = itch_icon
