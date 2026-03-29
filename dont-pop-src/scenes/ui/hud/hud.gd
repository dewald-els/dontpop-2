class_name HUD
extends CanvasLayer


@onready var score_label: Label = %ScoreLabel


func _ready() -> void:
	ScoreManager.score_changed.connect(on_score_changed)
	
	
func on_score_changed(new_score: int) -> void:
	score_label.text = str(new_score)


func _exit_tree() -> void:
	if ScoreManager:
		ScoreManager.score_changed.disconnect(on_score_changed)
