extends Node3D

@export var speed:float = 15.0
@export var damage:float = 5.0
@onready var mesh = $MeshInstance3D
@onready var area_3d = $Area3D

@onready var particles = $GPUParticles3D

func _process(delta):
	position += transform.basis * Vector3(0.0,0.0,-speed) * delta


func _on_timer_timeout():
	queue_free()



func _on_area_3d_body_entered(body):
	if !body.is_in_group("player"):
		mesh.visible = false
		print(body)
		if body.has_method("take_damage"):
			body.take_damage(damage)
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
