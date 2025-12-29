extends Label

var score = 0

func _on_player_incr() -> void:
	score += 1
	text = "%s" % score

func _on_player_ded() -> void:
	score = 0
