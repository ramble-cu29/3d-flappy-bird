extends CharacterBody3D

@export var speed = -5

func _physics_process(delta):
	move_and_slide()

func teleport(point: Vector3) -> void:
	global_position = point

func initialize(size: Vector3, position: Vector3):
	velocity = Vector3(speed,0,0)
	$Area3D/CollisionShape3D.shape.size = size
	$MeshInstance3D.mesh.size = size 
	teleport(position)
	
