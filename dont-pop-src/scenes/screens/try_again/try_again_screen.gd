class_name TryAgainScreen
extends CanvasLayer

@onready var give_up_button: Button = %GiveUpButton
@onready var try_again_button: Button = %TryAgainButton
@onready var score_label: Label = %ScoreLabel


func _ready() -> void:
	give_up_button.pressed.connect(on_give_up_click)
	try_again_button.pressed.connect(on_try_again_pressed)
	score_label.text = str(ScoreManager.score)
	
func on_try_again_pressed() -> void:
	ScoreManager.reset_score()
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

func on_give_up_click() -> void:
	ScoreManager.reset_score()
	get_tree().change_scene_to_file("res://scenes/screens/main_menu/main_menu_screen.tscn")
