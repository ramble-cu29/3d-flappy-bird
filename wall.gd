extends CharacterBody3D

@export var speed = -5

func _physics_process(delta):
	move_and_slide()
