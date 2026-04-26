extends CanvasLayer

@onready var background: TextureRect = $Root/Background
@onready var bar: ProgressBar = $Root/LoadingBar

func set_background(tex: Texture2D) -> void:
	background.texture = tex

func set_progress(p: float) -> void:
	# p in [0..1]
	bar.value = clamp(p, 0.0, 1.0) * 100.0
