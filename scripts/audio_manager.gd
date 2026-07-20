extends Node

@onready var menu_click: AudioStreamPlayer = $menu_click
var settings_open := false

func play():
	menu_click.play()

func settings():
	$settings.visible = not $settings.visible
	if !settings_open:
		settings_open = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		settings_open = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("menu"):
		#$settings.visible = false
