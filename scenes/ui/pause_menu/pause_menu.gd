extends CanvasLayer

signal game_unpaused()

@onready var resume_button = %ResumeButton
@onready var quit_button = %QuitButton
@onready var color_rect = $ColorRect
var can_change:bool = true
@export_range(0.0,2.0) var max_blur:float = 2.0
@export_range(0.0,1.0) var min_brightness:float = 0.9
@export_range(0.0,1.0) var tween_speed:float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	if(Input.mouse_mode != Input.MOUSE_MODE_VISIBLE):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	resume_button.pressed.connect(disable_pause_menu)
	quit_button.pressed.connect(get_tree().quit)
	color_rect.material.set_shader_parameter("blur", 0.0)
	color_rect.material.set_shader_parameter("brightness", 1.0)
	enable_pause_menu()


func enable_pause_menu() -> void:
	if(can_change):
		can_change = false
		var begin_tween = create_tween()
		begin_tween.set_parallel(true)
		begin_tween.tween_property(color_rect.material,"shader_parameter/blur", max_blur, tween_speed).set_ease(Tween.EASE_OUT)
		begin_tween.tween_property(color_rect.material,"shader_parameter/brightness", min_brightness, tween_speed).set_ease(Tween.EASE_OUT)
		begin_tween.finished.connect(func(): can_change = true)

func disable_pause_menu() -> void:
	if(can_change):
		can_change = false
		var end_tween = create_tween()
		end_tween.set_parallel(true)
		end_tween.tween_property(color_rect.material,"shader_parameter/blur", 0.0, tween_speed).set_ease(Tween.EASE_OUT)
		end_tween.tween_property(color_rect.material,"shader_parameter/brightness", 1.0, tween_speed).set_ease(Tween.EASE_OUT)
		end_tween.finished.connect(unpause)

func unpause() -> void:
	get_tree().paused = false
	emit_signal("game_unpaused")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()
