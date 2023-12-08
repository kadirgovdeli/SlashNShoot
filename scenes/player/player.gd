extends CharacterBody3D


@export_range(0.0,20.0) var movement_speed = 10.0
@export_range(0.0,20.0) var acceleration = 5.0
@export_range(0.0,10.0) var jump_height = 1.25
const LERP_VALUE = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _speed = 0.0

func _ready():
	_speed = movement_speed
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * 2.0 * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = sqrt(jump_height * 2.0 * gravity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		if is_on_floor():
			velocity.x = lerp(velocity.x , direction.x * _speed, acceleration * delta)
			velocity.z = lerp(velocity.z , direction.z * _speed, acceleration * delta)
		else:
			velocity.x = lerp(velocity.x , direction.x * _speed, acceleration / 2.0 * delta)
			velocity.z = lerp(velocity.z , direction.z * _speed, acceleration / 2.0 * delta)
	else:
			velocity.x = lerp(velocity.x , 0.0, LERP_VALUE * delta)
			velocity.z = lerp(velocity.z , 0.0, LERP_VALUE * delta)

	move_and_slide()
