extends Label

@onready var player = $"../../Player"
var depth: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	depth = 0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		depth = player.position.y
		text = "Dive depth " + str(int(depth)/32) + "m"
	
