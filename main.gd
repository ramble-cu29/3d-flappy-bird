extends Node

signal despawn

@export var speed = -5
var wall = preload("res://wall.tscn")
var score_wall = preload("res://score_wall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UserInterface/Message.hide()
	
func _on_player_ded():
	$UserInterface/Message.show()
	
func _on_wall_timer_timeout() -> void:
	# Add upper and lower walls to scene tree
	var upper = wall.instantiate()
	add_child(upper)
	var height_u = 1.0
	var coord_u = 12.0
	upper.initialize(height_u, coord_u)

	var lower = wall.instantiate()
	add_child(lower)
	var height_l = 4.0 
	var coord_l = 4.0
	lower.initialize(height_l, coord_l)

	var scorer = score_wall.instantiate()
	scorer.global_position = Vector3(50.0, 0.0, 0.0)
	scorer.velocity = Vector3(-10, 0.0, 0.0)
	add_child(scorer)
	
func _on_despawner_body_entered() -> void:
	despawn.emit()
