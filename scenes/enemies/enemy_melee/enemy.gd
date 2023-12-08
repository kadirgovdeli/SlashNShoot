extends CharacterBody3D

@export var speed:float = 5.0
@export var player:CharacterBody3D;
@onready var player_detector = $PlayerDetector
@onready var nav = $NavigationAgent3D
@onready var detected_label = $DetectedLabel



func _physics_process(delta):
	if player != null:
		nav.set_target_position(player.position)
		var dir = global_position.direction_to(nav.get_next_path_position())
		velocity = dir * speed
		move_and_slide()

func _on_player_detector_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		detected_label.visible = true
		print("Player Detected!")


func _on_navigation_agent_3d_target_reached():
	print("ur dead. lul noob :p")
