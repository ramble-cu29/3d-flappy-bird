extends Node

signal despawn

@export var wall_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UserInterface/Message.hide()
	

 

func _on_player_ded():
	$UserInterface/Message.show()


func _on_wall_timer_timeout() -> void:
	
	
	
	# Add upper and lower walls to scene tree
	var upper = load("res://wall.tscn").instantiate()
	var lower = load("res://wall.tscn").instantiate()
	
	# Initialize function, basically give it a velocity and run move_and_slide()
	var size = Vector3(1.0, 1.5, 20.0)
	var position_upper = Vector3(50.0, 8.0, 0.0)
	var position_lower = Vector3(50.0, 4.0, 0.0)
	
	upper.initialize(size, position_upper)
	lower.initialize(size, position_lower)
	
	add_child(upper)
	add_child(lower)

func _on_despawner_body_entered() -> void:
	despawn.emit()
