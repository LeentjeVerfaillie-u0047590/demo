extends Node

@onready var player = $"../Player"
@onready var tilemap = $"../TileMapLayer"  # Reference to your TileMap
@export var bubble_scene: PackedScene = preload("res://oxygen.tscn")  # Assign your bubble scene here
@export var spawn_distance_below: float = 300.0  # How far below player to spawn
@export var spawn_distance_vertical: float = 100 # Random vertical offset
@export var spawn_distance_horizontal: float = 200.0  # Random horizontal offset
@export var spawn_interval: float = 3.0  # Seconds between spawns

var spawn_timer: float = 0.0

func _process(delta: float) -> void:
	spawn_timer -= delta
	
	if spawn_timer <= 0 and player and bubble_scene:
		spawn_bubble()
		spawn_timer = spawn_interval
		spawn_interval = 3 + randf_range(-1, 1)

func spawn_bubble() -> void:
	var bubble = bubble_scene.instantiate()
	
	# Random position below player
	var random_offset_h = randf_range(-spawn_distance_horizontal, spawn_distance_horizontal)
	var random_offset_v = randf_range(spawn_distance_below-spawn_distance_vertical, spawn_distance_below+spawn_distance_vertical)
	var spawn_position = player.global_position + Vector2(random_offset_h, random_offset_v)
	
	# Check if there's a tile at this position
	if is_tile_at_position(spawn_position):
		return  # Don't spawn if there's a tile
	
	bubble.global_position = spawn_position
	add_child(bubble)
	
func is_tile_at_position(position: Vector2) -> bool:
	var tile_coords = tilemap.local_to_map(tilemap.to_local(position))
	return tilemap.get_cell_source_id(tile_coords) != -1  # -1 means no tile
