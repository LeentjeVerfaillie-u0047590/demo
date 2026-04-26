extends CanvasLayer

@onready var player = $"../Player"
@onready var tilemap: TileMapLayer = $"../TileMapLayer"

@export var minimap_size: Vector2 = Vector2(180, 300)
@export var minimap_position: Vector2 = Vector2(820, 20)

@export var look_ahead_distance: float = 500.0
@export var half_width_world: float = 400.0 # world units shown left/right of player
@export var tile_draw_size: Vector2 = Vector2(20, 20) # pixels on minimap

var minimap_control: Control

func _ready() -> void:
	minimap_control = Control.new()
	add_child(minimap_control)
	minimap_control.draw.connect(_on_draw)

func _process(_delta: float) -> void:
	# Request redraw each frame (or only when player moved)
	minimap_control.queue_redraw()

func _on_draw() -> void:
	# Background + border
	var mm_rect := Rect2(minimap_position, minimap_size)
	minimap_control.draw_rect(mm_rect, Color(0, 0, 0, 0.7))
	minimap_control.draw_rect(mm_rect, Color.WHITE, false, 2.0)

	if not is_instance_valid(player) or not is_instance_valid(tilemap):
		return

	# Define visible window in GLOBAL coordinates
	var start_y : float = player.global_position.y
	var end_y : float = player.global_position.y + look_ahead_distance

	var left_x : float = player.global_position.x - half_width_world
	var right_x : float = player.global_position.x + half_width_world

	for cell in tilemap.get_used_cells():
		# cell -> LOCAL (TileMapLayer space) -> GLOBAL
		var cell_local := tilemap.map_to_local(cell)
		var cell_global := tilemap.to_global(cell_local)

		# Cull in world space (both axes)
		if cell_global.y < start_y or cell_global.y > end_y:
			continue
		if cell_global.x < left_x or cell_global.x > right_x:
			continue

		# Normalize into minimap [0..1]
		var t_y := (cell_global.y - start_y) / look_ahead_distance
		var t_x := (cell_global.x - left_x) / (right_x - left_x)

		# Map to minimap pixels
		var minimap_pos := minimap_position + Vector2(t_x * minimap_size.x, t_y * minimap_size.y)

		# Clip to minimap rect (prevents drawing outside due to rounding/tile size)
		if not mm_rect.has_point(minimap_pos):
			continue

		minimap_control.draw_rect(Rect2(minimap_pos, tile_draw_size), Color.GRAY)

	# Player marker (near top center)
	var player_marker := minimap_position + Vector2(minimap_size.x * 0.5, 20)
	minimap_control.draw_circle(player_marker, 5, Color.GREEN)
