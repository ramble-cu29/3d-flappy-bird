extends CharacterBody3D

signal ded

@export var gravity = -20
@export var jump_impulse = 5
@export var speed = 5 # Horizontal speed

var target_velocity = Vector3.ZERO

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
	if Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	# Moving the Character
	velocity = target_velocity
	move_and_slide()

func die():
	ded.emit()
	queue_free()

func _on_floor_body_entered(body):
	print("Ball is kill")
	die()


	
	
	
