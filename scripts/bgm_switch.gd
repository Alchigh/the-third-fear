extends Area3D

@export var new_music: AudioStream
@onready var bgm: AudioStreamPlayer = $"../BGM"

var triggered := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print(body.name)
	if triggered:
		return

	if body is Player:
		triggered = true
		var tween = create_tween()
		tween.tween_property(bgm, "volume_db", -20, 0.5)
		await tween.finished

		tween = create_tween()
		tween.tween_property(bgm, "volume_db", -6, 0.5)
		bgm.stream = new_music
		bgm.play()
