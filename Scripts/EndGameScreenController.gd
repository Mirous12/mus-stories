extends Node

func _ready():
	pass

func setEndScore(score):
	var scoreLabel = get_node("ScoreLabel")
	if scoreLabel != null:
		var text = scoreLabel.text
		scoreLabel.text = text.replace("%s", String(score))
