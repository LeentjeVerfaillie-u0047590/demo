extends Area2D

@export var oxygen_restore_amount: float = 90.0
@export var restore_speed: float = 30.0  # How fast oxygen restores per second
@export var min_scale: float = 0.8
@export var max_scale: float = 1.2
var playerArea: Area2D
var player: CharacterBody2D
var is_player_inside: bool = false
var player_dive_speed_to_restore_at_exit: float
var initial_scale: Vector2

func _ready() -> void:
	initial_scale = scale
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	

func _process(delta: float) -> void:
	if is_player_inside:
		if player.current_dive_speed > 0:
			player_dive_speed_to_restore_at_exit = player.current_dive_speed
		
		player.current_dive_speed = 0

		# Restore oxygen while player is in bubble
		player.current_oxygen = min(oxygen_restore_amount, player.current_oxygen + restore_speed * delta)
		
		# Animate bubble scale based on oxygen restoration progress
		var restore_progress = player.current_oxygen / oxygen_restore_amount
		var target_scale = lerp(min_scale, max_scale, restore_progress)
		scale = initial_scale * target_scale
				
		# Bubble disappears when oxygen reaches target
		if player.current_oxygen >= oxygen_restore_amount:	
			player.current_dive_speed = player_dive_speed_to_restore_at_exit		
			queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		playerArea = area
		player = playerArea.get_parent()
		is_player_inside = true

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_player_inside = false
		playerArea = null
		player = null
