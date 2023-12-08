extends Node

@export var capture_mouse_on_begin:bool = false

@export var pause_menu = preload("res://scenes/ui/pause_menu/pause_menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	if capture_mouse_on_begin and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if(event.is_action_pressed("pause_game")):
		pause_game()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func pause_game() -> void:
	var menu = pause_menu.instantiate()
	add_child(menu)
	get_tree().paused = true
