extends Area2D

var playerArea: Area2D
var player: CharacterBody2D
var player_touched: bool = false
var speed_adapted: bool = false
var player_speed_to_restore_at_timeout: float
var time_increased_speed = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_touched:
		
		if speed_adapted != true:
			player_speed_to_restore_at_timeout = player.current_dive_speed
			print("increasing speed")
			player.current_dive_speed *= 2.0
			speed_adapted = true
			
		time_increased_speed += delta
		
		if time_increased_speed > 7:
			print("resetting speed to ", player_speed_to_restore_at_timeout)
			player.current_dive_speed = player_speed_to_restore_at_timeout
			playerArea = null
			player = null
			player_touched = false
			time_increased_speed = 0
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		playerArea = area
		player = playerArea.get_parent()
		player_touched = true
