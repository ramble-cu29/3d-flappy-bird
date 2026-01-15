extends CharacterBody3D

signal ded
signal incr

@export var gravity = -20
@export var jump_acceleration = 100
@export var side_acceleration = 10
@export var speed = 5 # Horizontal speed

var target_velocity = Vector3.ZERO
var swing_time = 0.5
var camera_dist = -2.5

var start_basis = Basis.IDENTITY  

func interpolate(weight:float, start_basis:Basis, target_basis:Basis):
	basis = start_basis.slerp(target_basis, weight)

func _process(delta):

	var tween = create_tween()
	
	var apparent_velocity = Vector3(10.0, velocity.y, velocity.z)
	var app_vel_norm = apparent_velocity.normalized()	

	#var target_vector = Vector3(app_vel_norm.y, app_vel_norm.x, app_vel_norm.z)
 
	var target_basis = Basis.looking_at($Pivot.position + app_vel_norm, Vector3.UP)
	var camera_pos = Vector3(camera_dist*app_vel_norm.x, camera_dist*app_vel_norm.y, camera_dist*app_vel_norm.z)
	#print("Camera pos: " + str(camera_pos))
	tween.tween_method(interpolate.bind($Pivot.basis, target_basis), 0.0, 1.0, 0.05)
	
	tween.parallel().tween_property($CameraPivot, "global_position", $Pivot.global_position + camera_pos, swing_time)
	
	
	$CameraPivot.look_at(global_position)
	print("Camera pos actual: " + str($CameraPivot.position))
	print("Camera pos modeled: " + str(camera_pos))

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	# Setting strafing direction of player
	if Input.is_action_pressed("move_left"):
		direction.z = -1
	if Input.is_action_pressed("move_right"):
		direction.z = 1
		
	# Horizontal Velocity
	target_velocity.z = target_velocity.z + (direction.z * side_acceleration * delta)
	
	if Input.is_action_pressed("jump"):
		target_velocity.y = target_velocity.y + (jump_acceleration * delta)
		if target_velocity.y > 5:
			target_velocity.y = 5
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
