class_name MainMenuScreen
extends CanvasLayer


@export var game_scene: PackedScene


@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	play_button.pressed.connect(on_play_pressed)
	
func on_play_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
