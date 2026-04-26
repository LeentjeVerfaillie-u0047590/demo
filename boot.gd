extends Node

@export var main_scene: String = "res://main.tscn"
@export var loading_screen_scene: PackedScene = preload("res://loadingScreen.tscn")
@export var loading_texture_path: String = "res://art/loading/Loading.PNG" # adjust case!

@export var min_loading_time_sec: float = 2.5  # <-- artificial slowdown

var _loading_screen: CanvasLayer
var _start_time_ms: int
var _loaded_packed: PackedScene = null

func _ready() -> void:
	_start_time_ms = Time.get_ticks_msec()

	_loading_screen = loading_screen_scene.instantiate()
	add_child(_loading_screen)

	var tex := load(loading_texture_path) as Texture2D
	if tex:
		_loading_screen.set_background(tex)

	ResourceLoader.load_threaded_request(main_scene)

func _process(delta: float) -> void:
	# If not loaded yet, poll threaded loader
	if _loaded_packed == null:
		var progress := []
		var status := ResourceLoader.load_threaded_get_status(main_scene, progress)

		if progress.size() > 0:
			_loading_screen.set_progress(progress[0]) # 0..1

		if status == ResourceLoader.THREAD_LOAD_LOADED:
			_loaded_packed = ResourceLoader.load_threaded_get(main_scene) as PackedScene
			# Make bar look "finished" immediately when ready
			_loading_screen.set_progress(1.0)

		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Failed to load main scene: %s" % main_scene)
			return
	else:
		# Optional: keep animating bar a little while we wait
		# (prevents the bar from sitting frozen at 100%)
		pass

	# Enforce minimum display time
	var elapsed_sec := float(Time.get_ticks_msec() - _start_time_ms) / 1000.0
	if _loaded_packed != null and elapsed_sec >= min_loading_time_sec:
		get_tree().change_scene_to_packed(_loaded_packed)
