extends CharacterBody3D

signal ded
signal incr

@export var gravity = -20
@export var jump_acceleration = 50
@export var speed = 5 # Horizontal speed

var target_velocity = Vector3.ZERO
var swing_time = 0.1
var horiz_swing_dist = 1.0
var vert_swing_dist = 1.0
var camera_dist = -2.5


func _process(delta):
	
	var tween = create_tween()
	
	var apparent_velocity = Vector3(10.0, velocity.y, velocity.z)
	var app_vel_norm = apparent_velocity.normalized()
	 
	print(app_vel_norm)
	
	var camera_pos = Vector3(camera_dist*app_vel_norm.x, camera_dist*app_vel_norm.y, camera_dist*app_vel_norm.z)
	
	tween.tween_property($CameraPivot, "position", camera_pos, swing_time)
	$CameraPivot.look_at($Pivot.global_position)
	
	# Depending on what key was pressed, edit the tween to swing the camera left or right	
	#if Input.is_action_pressed("move_left"):
		#tween.parallel().tween_property($CameraPivot, "position", Vector3(-3.0, 0.0, horiz_swing_dist), swing_time)
	#	tween.tween_property($Pivot, "global_rotation", Vector3(0.0, 45.0, 0.0), 0.1)
		
	#elif Input.is_action_pressed("move_right"):
		#tween.parallel().tween_property($CameraPivot, "position", Vector3(-3.0, 0.0, -horiz_swing_dist), swing_time)
	#	tween.tween_property($Pivot, "global_rotation", Vector3(0.0, -450, 0.0), 0.1)
	#else:
		#tween.parallel().tween_property($CameraPivot, "position", Vector3(-3.0, 0.0, 0.0), swing_time)
	#	tween.tween_property($Pivot, "global_rotation", Vector3(0.0, 0.0, 0.0), 0.1)
	
func _physics_process(delta):
	var direction = Vector3.ZERO
	
	# Setting strafing direction of player
	if Input.is_action_pressed("move_left"):
		direction.z = -1
	if Input.is_action_pressed("move_right"):
		direction.z = 1
		
	# Horizontal Velocity
	target_velocity.z = direction.z * speed
	
	# Vertical Velocity
	if not is_on_floor():
		target_velocity.y = target_velocity.y + (gravity * delta)
		
	# Jumping
	if Input.is_action_pressed("jump"):
		target_velocity.y = target_velocity.y + (jump_acceleration * delta)
		
	# Moving the Character
	velocity = target_velocity
	move_and_slide()

func die():
	ded.emit()
	
func increment():
	incr.emit()

func _on_hit_box_body_entered(body: Node3D) -> void: 
	if body.is_in_group("score_walls"):
		print("Incrementing score")
		increment()
	else:
		print("Ball is kill")
		target_velocity = Vector3.ZERO
		die()
