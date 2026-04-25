extends CanvasLayer

@onready var oxygen_bar: ProgressBar = $OxygenBar
@onready var player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	
	if player:
		oxygen_bar.max_value = player.max_oxygen
		oxygen_bar.value = player.current_oxygen
