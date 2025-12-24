extends Node

signal despawn

@export var wall_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UserInterface/Message.hide()
	

 

func _on_player_ded():
	$UserInterface/Message.show()


func _on_wall_timer_timeout() -> void:
	# Two walls will be instantiated, the top and the bottom
	var walls = ["res://wall_15.tscn", "res://wall_35.tscn", "res://wall_55.tscn", "res://wall_75.tscn"]
	var index = randi() % 3 # Generate random index
	# Options configuration for layout and height of each wall
	var options = {
		0: {
			"locations": [11.25, 3.75],
			"walls": [0, 3]
		},
		1: {
			"locations": [10.25, 2.75],
			"walls": [1, 2]
		},
		2: {
			"locations": [2.75, 10.25],
			"walls": [2, 1]
		},
		3: {
			"locations": [3.75, 11.25],
			"walls": [3, 0]
		}
	}
	
	var option = options[index]
	
	# Add upper and lower walls to scene tree
	var upper = load(walls[option["walls"][0]]).instantiate()
	var lower = load(walls[option["walls"][1]]).instantiate()
	
	# Run wall teleport function to move to initial position
	upper.teleport(Vector3(50.0, option["locations"][0], 0.0))
	lower.teleport(Vector3(50.0, option["locations"][1], 0.0))
	
	# Initialize function, basically give it a velocity and run move_and_slide()
	
	var size = Vector3(1.0, 1.5, 20.0)
	upper.initialize(size)
	lower.initialize(size)
	
	add_child(upper)
	add_child(lower)

func _on_despawner_body_entered() -> void:
	despawn.emit()
