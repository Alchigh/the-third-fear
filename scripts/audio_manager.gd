extends Node

@onready var settings_canvas: CanvasLayer = $settings
@onready var menu_click: AudioStreamPlayer = $menu_click
var settings_open: bool = false

func play() -> void:
	menu_click.play()

func settings() -> void:
	$settings.visible = not $settings.visible
	if !settings_open:
		settings_open = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		settings_open = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
