extends CharacterBody3D

@export var speed = -5

func _physics_process(delta):
	move_and_slide()

func initialize(height: float, coord: float):
	var size = Vector3(1.0, height, 20.0)
	var pos = Vector3(50.0, coord, 0.0)

	velocity = Vector3(speed, 0, 0)
	global_position = pos
	
	$MeshInstance3D.mesh.size = size
	$Area3D/CollisionShape3D.shape.size = size
	
