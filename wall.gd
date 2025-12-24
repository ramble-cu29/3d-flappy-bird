extends CharacterBody3D

@export var speed = -5

func _physics_process(delta):
	move_and_slide()

func initialize(size: Vector3):
	velocity = Vector3(speed,0,0)
	
	
func teleport(point: Vector3) -> void:
	global_position = point
