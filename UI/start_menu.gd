extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%play.pressed.connect(_on_play_pressed)
	%quit.pressed.connect(_on_quit_pressed)
	
	%settings.pressed.connect(_on_settings_pressed)
	%credits.pressed.connect(_on_credits_pressed)
	#%Yes.pressed.connect(_on_yes)
	#%No.pressed.connect(_on_no)
	
	#%ItchButton.pressed.connect(_on_itchIo)


func _on_play_pressed() -> void:
	AudioManager.play()
	$BGM.stop()
	get_tree().change_scene_to_file("res://scenes/gameworld.tscn")

func _on_settings_pressed() -> void:
	AudioManager.play()
	AudioManager.settings()
	
func _on_credits_pressed() -> void:
	AudioManager.play()
	$credits.show()

func _on_quit_pressed() -> void:
	#$"Really?".show()
	get_tree().quit()
