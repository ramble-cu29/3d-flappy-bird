extends Node

signal despawn

@export var speed = -5
var wall = preload("res://wall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UserInterface/Message.hide()
	
func _on_player_ded():
	$UserInterface/Message.show()

func initialize(wall_obj: CharacterBody3D, height: float, coord: float):
	var mesh = wall_obj.get_node("MeshInstance3D")
	var col_shape = wall_obj.get_node("Area3D/CollisionShape3D")
	var size = Vector3(1.0, height, 20.0)
	var pos = Vector3(50.0, coord, 0.0)

	wall_obj.velocity = Vector3(speed, 0, 0)
	wall_obj.global_position = pos
	
	mesh.mesh.size = size
	col_shape.shape.size = size
	
func _on_wall_timer_timeout() -> void:
	# Add upper and lower walls to scene tree
	var upper = wall.instantiate()
	add_child(upper)
	var height_u = 1.0
	var coord_u = 12.0
	#initialize(upper, height_u, coord_u)
	upper.initialize(height_u, coord_u)

	var lower = wall.instantiate()
	add_child(lower)
	var height_l = 4.0 
	var coord_l = 4.0
	#initialize(lower, height_l, coord_l)
	lower.initialize(height_l, coord_l)
	
func _on_despawner_body_entered() -> void:
	despawn.emit()
