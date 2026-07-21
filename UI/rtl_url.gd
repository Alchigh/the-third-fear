extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	meta_clicked.connect(_on_rich_text_label_meta_clicked)

func _on_rich_text_label_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))
