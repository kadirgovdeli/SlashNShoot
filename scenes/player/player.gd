extends CharacterBody3D


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
var _speed = 0.0

var can_dash:bool = true
var is_dashing = false

@onready var fps_camera = $FpsCamera

func _ready():
	_speed = movement_speed
	dash_timer = Timer.new()
	dash_cooldown_timer = Timer.new()
	add_child(dash_timer)
	add_child(dash_cooldown_timer)
	dash_timer.timeout.connect(func(): is_dashing = false)
	dash_cooldown_timer.timeout.connect(func(): can_dash = true)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * 2.0 * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2.0 * gravity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if direction and not is_dashing:
		if is_on_floor():
			velocity.x = lerp(velocity.x , direction.x * _speed, acceleration * delta)
			velocity.z = lerp(velocity.z , direction.z * _speed, acceleration * delta)
		else:
			velocity.x = lerp(velocity.x , direction.x * _speed, acceleration / 2.0 * delta)
			velocity.z = lerp(velocity.z , direction.z * _speed, acceleration / 2.0 * delta)
	elif not is_dashing:
		velocity.x = lerp(velocity.x , 0.0, 10.0 * delta)
		velocity.z = lerp(velocity.z , 0.0, 10.0 * delta)

	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		is_dashing = true
		velocity = direction * dash_speed
		dash_timer.start(dash_time)
		dash_cooldown_timer.start(dash_cooldown)

	move_and_slide()
