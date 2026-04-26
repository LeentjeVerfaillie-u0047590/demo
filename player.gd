extends CharacterBody2D

@onready var animated_sprite = $Diver  # Add this line

# Diving parameters
@export var max_speed: float = 1000.0
@export var acceleration: float = 2000.0
@export var friction: float = 0.85  # Drag coefficient (lower = more drag)
@export var buoyancy: float = 0.3   # Slight upward drift
@export var max_dive_speed: float = 1000.0  # Speed at which player automatically descends

# Oxygen parameters
@export var max_oxygen: float = 100.0
@export var oxygen_drain_rate: float = 5.0  # Oxygen lost per second while diving
var current_oxygen: float
var current_dive_speed: float

func _ready() -> void:
	current_oxygen = max_oxygen
	current_dive_speed = max_dive_speed/4.0

func _physics_process(delta: float) -> void:
	if current_dive_speed == 0:
		animated_sprite.stop()  # Stop animation when breathing
		return
		
		# Play diving animation
	if not animated_sprite.is_playing():
		animated_sprite.play("dive")
	# Get input direction
	var input_direction = Vector2.ZERO
	input_direction.x = Input.get_axis("ui_left", "ui_right")
	input_direction = input_direction.normalized()
	
	velocity.y = current_dive_speed
	
	# Apply buoyancy (slight upward drift)
	velocity.y -= buoyancy * delta
	
	# Smooth acceleration/deceleration (only horizontal)
	if input_direction.length() > 0:
		velocity.x = move_toward(velocity.x, input_direction.x * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * delta * 2)
	
	# Apply drag/friction
	velocity *= friction
	
	# Drain oxygen while diving
	current_oxygen = max(0, current_oxygen - oxygen_drain_rate * delta)
	
	# Game over or respawn logic when oxygen runs out
	if current_oxygen <= 0:
		_on_oxygen_depleted()
	
	move_and_slide()

func _on_oxygen_depleted() -> void:
	print("Player ran out of oxygen!")
	current_dive_speed = 0
	# Add your game over logic here (e.g., respawn, scene reload)
	# get_tree().reload_current_scene()
	get_tree().paused = true
	get_tree().get_root().add_child(load("res://death_screen.tscn").instantiate())

func restore_oxygen(amount: float) -> void:
	current_oxygen = min(max_oxygen, current_oxygen + amount)
