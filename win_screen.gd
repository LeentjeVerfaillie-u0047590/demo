extends CanvasLayer

func _ready() -> void:
	$Control/RestartButton.pressed.connect(_on_restart_pressed)

func _on_restart_pressed() -> void:
	print("restart pressed")
	queue_free()  # Remove the win screen
	get_tree().reload_current_scene()
