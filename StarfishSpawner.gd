extends Node

@onready var player = $"../Player"
@export var starfish_scene: PackedScene = preload("res://starfish.tscn")  # Assign your starfish scene here
@export var spawn_distance_below: float = 325.0  # How far below player to spawn
@export var spawn_distance_horizontal: float = 234.0  # Random horizontal offset
@export var spawn_interval: float = 25.0  # Seconds between spawns

var spawn_timer: float = 0.0

func _process(delta: float) -> void:
	spawn_timer -= delta
	
	if spawn_timer <= 0 and player and starfish_scene:
		spawn_starfish()
		spawn_timer = spawn_interval

func spawn_starfish() -> void:
	var starfish = starfish_scene.instantiate()
	
	# Random position below player
	var random_offset = randf_range(-spawn_distance_horizontal, spawn_distance_horizontal)
	var spawn_position = player.global_position + Vector2(random_offset, spawn_distance_below)
	
	starfish.global_position = spawn_position
	add_child(starfish)
