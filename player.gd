extends CharacterBody3D

signal ded
signal incr

@export var gravity = -20
@export var jump_acceleration = 100
@export var side_acceleration = 50
@export var speed = 5 # Horizontal speed

var target_velocity = Vector3.ZERO
var swing_time = 0.5
var camera_dist = -2.5

var side_velocity_limit = 5


func interpolate(weight:float, start_basis:Basis, target_basis:Basis):
	basis = start_basis.slerp(target_basis, weight)

func _process(_delta):

	var tween = create_tween()
	
	# Generate velocity normal of player	
	var apparent_velocity = Vector3(10.0, velocity.y, velocity.z)
	var app_vel_norm = apparent_velocity.normalized()

 	# Create target vectors for both rotation of player and camera position
	var target_basis = Basis.looking_at($Pivot.position + app_vel_norm, Vector3.UP)
	var camera_pos = $Pivot.global_position + Vector3(camera_dist*app_vel_norm.x, camera_dist*app_vel_norm.y, camera_dist*app_vel_norm.z)

	# Tween to the target vectors
	tween.tween_method(interpolate.bind($Pivot.basis, target_basis), 0.0, 1.0, 0.01)	
	#tween.parallel().tween_property($CameraPivot, "position", camera_pos.clamp(Vector3(0.0, -10.0, -10.0), Vector3(2.5, 10.0, 10.0)), swing_time)
	tween.parallel().tween_property($CameraPivot, "global_position", camera_pos, swing_time)
	
	$CameraPivot.look_at(global_position)
	print("Camera pos actual: " + str($CameraPivot.position))
	print("Camera pos modeled: " + str(camera_pos))


func _physics_process(delta):
	var direction = Vector3.ZERO
	
	# Setting strafing direction of player
	if Input.is_action_pressed("move_left"):
		direction.z = -1
	elif Input.is_action_pressed("move_right"):
		direction.z = 1
	else:
		direction.z = sign(target_velocity.z)*-1
	
	# Horizontal Velocity
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		target_velocity.z = clampf(target_velocity.z + (direction.z * side_acceleration * delta), -side_velocity_limit, side_velocity_limit)
	else:
		target_velocity.z = target_velocity.z + (direction.z * 20 * delta)
		if abs(target_velocity.z) < 0.1:
			target_velocity.z = 0

	if Input.is_action_pressed("jump"):
		target_velocity.y = clampf(target_velocity.y + (jump_acceleration * delta), 0.0, 7.0)
	else:
		target_velocity.y = target_velocity.y + (gravity * delta)
	
	
	#
	#if target_velocity.y <= 5:
		## Vertical Velocity
		#if not is_on_floor():
			#target_velocity.y = target_velocity.y + (gravity * delta)
		#
		## Jumping
		#if Input.is_action_pressed("jump"):
			#target_velocity.y = target_velocity.y + (jump_acceleration * delta)
	#else:
		#target_velocity.y = 5
			#
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
