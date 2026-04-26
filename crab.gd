extends Node2D

@export var speed: float = 20.0

func _process(delta: float) -> void:
	position += Vector2.UP * speed * delta
