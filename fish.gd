extends Node2D

@export var speed: float = 60.0
@export var direction: Vector2 = Vector2.RIGHT # set to LEFT for left-fish

func _process(delta: float) -> void:
	position += direction * speed * delta
