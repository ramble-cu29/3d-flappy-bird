extends CharacterBody3D

signal ded
signal incr

@export var gravity = -20
@export var jump_impulse = 5
@export var speed = 5 # Horizontal speed

var target_velocity = Vector3.ZERO

func _process(delta):
	if Input.is_action_pressed("move_left"):
		$Marker3D.position = Vector3(-5, 0, -1)
	elif Input.is_action_pressed("move_right"):
		$Marker3D.position = Vector3(-5, 0, 1)
	else:
		$Marker3D.position = Vector3(-5, 0, 0)
	
	
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
	print($Marker3D.position)

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
