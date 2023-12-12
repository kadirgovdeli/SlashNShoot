extends CharacterBody3D

@export_category("Combat")
@export_range(1.0,100.0) var max_health:float = 100.0
@export_range(1.0,100.0) var health:float = 100.0
@export_range(1.0,100.0) var melee_damage:float = 10.0

@export_category("Movement")
@export_range(0.0,20.0) var movement_speed = 10.0
@export_range(0.0,20.0) var acceleration = 10.0
@export_range(0.0,100.0) var dash_speed = 40.0
@export_range(0.0,2.0) var dash_time = 0.1
@export_range(0.0,5.0) var dash_cooldown = 1.5
@export_range(0.0,10.0) var jump_height = 5.0
const LERP_VALUE = 10.0
var dash_timer:Timer
var dash_cooldown_timer:Timer



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _speed:float = 0.0

var can_dash:bool = true
var is_dashing:bool = false
var dash_dir:Vector3 = Vector3.ZERO

var is_aiming:bool = false

@onready var fps_camera = $FpsCamera
@onready var combat_anim_player = $CombatAnimPlayer
@onready var hit_area = $FpsCamera/HitArea
@onready var gun_anim = $FpsCamera/Camera3D/Gun/AnimationPlayer
@onready var gun_barrel = $FpsCamera/Camera3D/Gun/RayCast3D

var bullet_res = load("res://scenes/Bullet/Bullet.tscn")
@onready var marker_3d = $FpsCamera/Marker3D

func _ready():
	_speed = movement_speed
	dash_timer = Timer.new()
	dash_cooldown_timer = Timer.new()
	add_child(dash_timer)
	add_child(dash_cooldown_timer)
	dash_timer.timeout.connect(func(): is_dashing = false)
	dash_cooldown_timer.timeout.connect(func(): can_dash = true)

func _unhandled_input(event):
	if Input.is_action_just_pressed("dash"):
		handle_dash_state_change()
	if Input.is_action_just_pressed("aim"):
		is_aiming = true
		combat_anim_player.play("Aim")
	if Input.is_action_just_released("aim"):
		is_aiming = false
		combat_anim_player.play_backwards("Aim")

func _physics_process(delta):
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	if is_dashing:
		move_and_collide(direction * dash_speed * delta)
	else:
		handle_default_movement(direction, delta)
	
	if Input.is_action_just_pressed("attack"):
		if is_aiming:
			shoot()
		else:
			attack()

func attack() -> void:
	combat_anim_player.play("sword_swing")
	var hit_targets = hit_area.get_overlapping_bodies()
	print(hit_targets)
	for target in hit_targets:
		if target.has_method("take_damage"):
			target.take_damage(melee_damage)

func shoot() -> void:
	if !gun_anim.is_playing():
		gun_anim.play("shoot")
		var bullet = bullet_res.instantiate()
		bullet.position = marker_3d.global_position
		bullet.transform.basis = marker_3d.global_transform.basis
		get_parent().add_child(bullet)

func handle_dash_state_change() -> void:
	if not can_dash:
		return
	can_dash = false
	is_dashing = true
	dash_timer.start(dash_time)
	dash_cooldown_timer.start(dash_cooldown)

func handle_default_movement(direction:Vector3 ,delta:float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * 2.0 * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2.0 * gravity)

	
	if direction:
		if is_on_floor():
			velocity.x = lerp(velocity.x , direction.x * _speed, acceleration * delta)
			velocity.z = lerp(velocity.z , direction.z * _speed, acceleration * delta)
		else:
			velocity.x = lerp(velocity.x , direction.x * _speed, acceleration / 2.0 * delta)
			velocity.z = lerp(velocity.z , direction.z * _speed, acceleration / 2.0 * delta)
	else:
		velocity.x = lerp(velocity.x , 0.0, 10.0 * delta)
		velocity.z = lerp(velocity.z , 0.0, 10.0 * delta)

	move_and_slide()
