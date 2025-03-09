extends Node

signal score_changed(score: int)

var score: int = 0

func reset_score() -> void:
	score = 0

func increase_score(increase_amount: int = 1) -> void:
	score += increase_amount
	score_changed.emit(score)
