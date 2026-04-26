extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var player = $"../Player"
@onready var light = $"../Player/DiveLight"
@export var surface_color: Color = Color(1,1,1,0.05) # Light blue at surface
@export var deep_color: Color = Color(0,0,0,0.3) # Black in the depths
@export var depth_transition: float = 5000.0   # How deep before fully dark
@export var light_energy_shallow: float = 0.2
@export var light_energy_deep: float = 1.5

func _ready() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Allow clicks to pass through

func _process(_delta: float) -> void:
	if player:
		var player_depth = player.global_position.y
		var depth_ratio = min(player_depth / depth_transition, 1.0)
		var colorToAssign = surface_color.lerp(deep_color, depth_ratio)
		color_rect.color = colorToAssign
		
		# Increase light energy the deeper you go
		if light:
			light.energy = lerp(light_energy_shallow, light_energy_deep, depth_ratio)
