extends Node3D

@export var speed:float = 10.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(transform.basis * Vector3(0.0,0.0,speed * delta))
