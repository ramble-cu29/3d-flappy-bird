extends CharacterBody3D

signal ded
signal incr

@export var gravity = -20
@export var jump_impulse = 5
@export var speed = 5 # Horizontal speed

var target_velocity = Vector3.ZERO
var swing_time = 0.2
var horiz_swing_dist = 0.5
var vert_swing_dist = 1.0

func tween_animation(tween: Tween, pos: Vector3):
	tween.tween_property($CameraPivot, "position", pos, swing_time)

func _process(delta):
	
	#var state: States = States.CENTER
	var tween = create_tween()
	
	if Input.is_action_pressed("move_left"):
		if velocity.y < 0:
			tween_animation(tween, Vector3(-5.0, vert_swing_dist, horiz_swing_dist))
		elif velocity.y > 0:
			tween_animation(tween, Vector3(-5.0, -vert_swing_dist, horiz_swing_dist))
		else:
			tween_animation(tween, Vector3(-5.0, 0.0, horiz_swing_dist))
	elif Input.is_action_pressed("move_right"):
		if velocity.y < 0:
			tween_animation(tween, Vector3(-5.0, vert_swing_dist, -horiz_swing_dist))
		elif velocity.y > 0:
			tween_animation(tween, Vector3(-5.0, -vert_swing_dist, -horiz_swing_dist))
		else:	
			tween_animation(tween, Vector3(-5.0, 0.0, -horiz_swing_dist))
	else:
		tween_animation(tween, Vector3(-5.0, 0.0, 0.0))
	
	
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
		target_velocity.y = jump_impulse
		
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	print($CameraPivot.position)

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
