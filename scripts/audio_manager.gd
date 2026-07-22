extends Node

@onready var settings_canvas: CanvasLayer = $settings
@onready var menu_click: AudioStreamPlayer = $menu_click
var settings_open: bool = false
var state: String = "Start"

func _ready() -> void:
	%back.pressed.connect(_on_back_pressed)
	%volume.pressed.connect(_on_volume_pressed)
	%controls.pressed.connect(_on_keybinds_pressed)
	%main_menu.pressed.connect(_on_main_menu_pressed)

func play() -> void:
	menu_click.play()

func settings() -> void:
	$settings.visible = not $settings.visible
	if $settings.visible:
		settings_open = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		settings_open = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_back_pressed() -> void:
	menu_click.play()
	if state == "Start": $settings.hide()
	else: settings()

func _on_volume_pressed() -> void:
	menu_click.play()
	%volume_sliders.visible = not %volume_sliders.visible
	if %keybinds.visible: %keybinds.hide()

func _on_keybinds_pressed() -> void:
	menu_click.play()
	%keybinds.visible = not %keybinds.visible
	if %volume_sliders.visible: %volume_sliders.hide()

func _on_main_menu_pressed() -> void:
	menu_click.play()
	$settings.visible = false
	settings_open = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://UI/start_menu.tscn")
