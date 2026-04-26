extends Area2D

@export var win_screen_scene: PackedScene = preload("res://win_screen.tscn")

var _triggered := false

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if _triggered:
		return
	if area.is_in_group("player"):
		_triggered = true
		get_tree().paused = true
		get_tree().get_root().add_child(win_screen_scene.instantiate())
