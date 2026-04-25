extends CanvasLayer

@onready var oxygen_bar: ProgressBar = $Control/OxygenBar
@onready var player = $"../Player"

func _process(_delta: float) -> void:
	
	if player:
		oxygen_bar.max_value = player.max_oxygen
		oxygen_bar.value = player.current_oxygen
