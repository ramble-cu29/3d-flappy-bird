extends Node

signal despawn

@export var speed = -5
var wall = preload("res://wall.tscn")
var score_wall = preload("res://score_wall.tscn")

func _ready() -> void:
	$UserInterface/Replay.hide()
	
func _on_player_ded():
	var replay = $UserInterface/Replay
	var score = int($UserInterface/Score/ScoreCounter.text)
	var high_score = int($UserInterface/Replay/HighScoreNumber.text)
	
	# 1. Stop WallTimer 
	$WallTimer.stop()
	
	# 2. Show Replay UI so that it's hiding everything
	replay.show()
	
	# Reparent Score node so it's visible in the Replay node
	$UserInterface/Score.reparent($UserInterface/Replay)
	
	# 3. Delete all instances of walls and score_walls
	get_tree().call_group("walls", "queue_free")
	get_tree().call_group("score_walls", "queue_free")
	
	# 4. Update high score if necessary
	if high_score > score:
		print("High score achieved")
		high_score = score
	
	# 5. Move Player back to starting position and turn off gravity
	$Player.global_position = Vector3(0,4,0)
	$Player.set_velocity(Vector3.ZERO)
	$Player.set_physics_process(false)

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

	# Add the Score wall to the scene tree
	var scorer = score_wall.instantiate()
	scorer.global_position = Vector3(50.0, 0.0, 0.0)
	scorer.velocity = Vector3(-10, 0.0, 0.0)
	add_child(scorer)
	
func _on_despawner_body_entered() -> void:
	despawn.emit()

func _on_button_pressed() -> void:
	# Reset button:
	# 1. Remove Replay UI
	$UserInterface/Replay.hide()

	# 2. Turn player gravity back on
	$Player.set_physics_process(true)

	# 3. Start WallTimer
	$WallTimer.start()
	
	# Move Score node back to UserInterface
	$UserInterface/Replay/Score.reparent($UserInterface)
	
	# 4. Set ScoreCounter to 0
	$UserInterface/Score/ScoreCounter.text = str(0)
