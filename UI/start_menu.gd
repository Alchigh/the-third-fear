extends Control

var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.state = "Start"
	%play.pressed.connect(_on_play_pressed)
	%quit.pressed.connect(_on_quit_pressed)
	
	%settings.pressed.connect(_on_settings_pressed)
	%credits.pressed.connect(_on_credits_pressed)
	#%Yes.pressed.connect(_on_yes)
	#%No.pressed.connect(_on_no)
	
	#%ItchButton.pressed.connect(_on_itchIo)
	%itch_logo.pressed.connect(_on_itchIo)

func _on_play_pressed() -> void:
	await tween_animation(%play)
	AudioManager.play()
	AudioManager.state = "Game"
	$BGM.stop()
	get_tree().change_scene_to_file("res://scenes/gameworld.tscn")

func _on_settings_pressed() -> void:
	await tween_animation(%settings)
	AudioManager.play()
	#AudioManager.settings()
	AudioManager.settings_canvas.visible = true
	
func _on_credits_pressed() -> void:
	await tween_animation(%settings)
	AudioManager.play()
	$credits.show()

func _on_quit_pressed() -> void:
	AudioManager.play()
	await tween_animation(%quit)
	#$"Really?".show()
	get_tree().quit()

## What Itch.Io button does
func _on_itchIo() -> void:
	#%ItchIoLogo.scale = Vector2(0.15, 0.15)
	AudioManager.play()
	await tween_animation(%itch_logo)
	OS.shell_open("https://alchigh.itch.io/the-third-fear")

## Animates buttons presses
func tween_animation(input):
	print(input.name)
	var input_scale = input.scale
	reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(false)
	tween.tween_property(input, "scale", input_scale * 0.95, 0.05)
	tween.chain().tween_property(input, "scale", input_scale, 0.06)
	await tween.finished

## Kills tween
func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu") and AudioManager.settings_canvas.visible:
		AudioManager.settings_canvas.visible = false
	elif event.is_action_pressed("menu") and $credits.visible:
		$credits.hide()
