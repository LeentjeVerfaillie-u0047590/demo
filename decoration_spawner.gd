extends Node2D

@onready var player = $"../Player"
@onready var tilemap: TileMapLayer = $"../TileMapLayer"

@export var fish_scene: PackedScene = load("res://fish.tscn")
@export var crab_scene: PackedScene = load("res://crab.tscn")

@export var fish_left_textures: Array[Texture2D] = [
	load("res://godot-skeleton-main/art/decorations/fishRedL.PNG"),
	load("res://godot-skeleton-main/art/decorations/fishGreenL.PNG"),
	load("res://godot-skeleton-main/art/decorations/fishBlueL.PNG"),
]
@export var fish_right_textures: Array[Texture2D] = [
	load("res://godot-skeleton-main/art/decorations/fishRedR.PNG"),
	load("res://godot-skeleton-main/art/decorations/fishGreenR.PNG"),
	load("res://godot-skeleton-main/art/decorations/FishBlueR.PNG"),
]
@export var crab_texture: Texture2D = load("res://godot-skeleton-main/art/decorations/crab.PNG")

@export var spawn_interval: float = 1.2
@export var spawn_distance_below: float = 900.0
@export var spawn_spread_x: float = 500.0
@export var spawn_spread_y: float = 250.0

@export var fish_chance: float = 0.8
@export var crab_chance: float = 0.2

@export var min_scale: float = 0.1
@export var max_scale: float = 0.5

var _timer := 0.0

func _process(delta: float) -> void:
	if not player or not tilemap:
		return

	_timer -= delta
	if _timer > 0:
		return
	_timer = spawn_interval

	_spawn_one()

func _spawn_one() -> void:
	var r := randf()

	if r < coral_chance:
		_spawn_coral()
	elif r < coral_chance + fish_chance:
		_spawn_fish()
	else:
		_spawn_crab()

func _random_spawn_position() -> Vector2:
	var x : float = player.global_position.x + randf_range(-spawn_spread_x, spawn_spread_x)
	var y : float = player.global_position.y + spawn_distance_below + randf_range(-spawn_spread_y, spawn_spread_y)
	return Vector2(x, y)

func _tile_at_global(pos: Vector2) -> bool:
	var tile_coords := tilemap.local_to_map(tilemap.to_local(pos))
	return tilemap.get_cell_source_id(tile_coords) != -1

func _spawn_fish() -> void:
	if fish_scene == null:
		return

	var go_left := randf() < 0.5
	var textures := fish_left_textures if go_left else fish_right_textures
	if textures.is_empty():
		return

	var tries := 20
	while tries > 0:
		tries -= 1
		var pos := _random_spawn_position()

		# Fish should be "between tiles" => avoid spawning inside a tile
		if _tile_at_global(pos):
			continue

		var fish := fish_scene.instantiate()
		add_child(fish)

		var spr := fish.get_node_or_null("Sprite2D") as Sprite2D
		if spr:
			spr.texture = textures.pick_random()

		# Set direction on the fish script if it exists
		if fish.has_method("set"):
			# fish_decoration.gd exports `direction`
			fish.set("direction", Vector2.LEFT if go_left else Vector2.RIGHT)

		fish.global_position = pos
		var s := randf_range(min_scale, max_scale)
		fish.scale = Vector2(s, s)
		return

func _spawn_crab() -> void:
	if crab_scene == null or crab_texture == null:
		return

	var tries := 20
	while tries > 0:
		tries -= 1
		var pos := _random_spawn_position()

		# Crab swims upwards; best to start it in open space (not inside tiles)
		if _tile_at_global(pos):
			continue

		var crab := crab_scene.instantiate()
		add_child(crab)

		var spr := crab.get_node_or_null("Sprite2D") as Sprite2D
		if spr:
			spr.texture = crab_texture

		crab.global_position = pos
		var s := randf_range(min_scale, max_scale)
		crab.scale = Vector2(s, s)
		return
