extends Camera2D

@onready var player = $".."
@export var follow_speed: float = 1000.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x = get_viewport_rect().size.x / 2.0
	if player:
		# Smoothly follow only Y position
		global_position.y = lerp(global_position.y, player.global_position.y, follow_speed * delta)
