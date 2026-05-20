extends Control

@onready var lives_label = $LivesLabel
@onready var score_label = $ScoreLabel

var score = 0

func update_lives(lives: int):
	var text = ""
	for i in lives:
		text += "❤️"
	lives_label.text = text

func add_score(points: int):
	score += points
	score_label.text = "Puntos: %d" % score

func get_score() -> int:
	return score
