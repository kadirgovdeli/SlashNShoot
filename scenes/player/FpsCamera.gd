class_name FpsCamera extends Node3D

@export var player:CharacterBody3D
@export_range(0.0,20.0)
var mouse_sensitivity:float = 7.5
@export_range(45.0,90.0)
var max_pich_value:float = 89.0

@onready var camera_3d = $Camera3D

const BOB_FREQ = 2.0
const BOB_AMOUTH = 0.05
var head_bob = 0.0

func _ready():
	if player == null:
		player = owner as CharacterBody3D

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var rot:Vector2 = event.relative / get_viewport().get_visible_rect().size
		player.rotate_y(-rot.x * mouse_sensitivity)
		rotate_x(-rot.y * mouse_sensitivity)
		rotation_degrees.x = clamp(rotation_degrees.x, -max_pich_value, max_pich_value)

func _physics_process(delta):
	head_bob += player.velocity.length() * delta
	if player.is_on_floor():
		camera_3d.position.y = sin(head_bob * BOB_FREQ) * BOB_AMOUTH
		camera_3d.position.x = cos(head_bob * BOB_FREQ) * BOB_AMOUTH
