extends Node

@export var capture_mouse_on_begin:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if capture_mouse_on_begin and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
