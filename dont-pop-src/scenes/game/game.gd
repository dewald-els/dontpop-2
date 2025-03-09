class_name Game
extends Node2D

func _ready() -> void:
	SignalBus.player_died.connect(on_player_died)
	
func change_to_try_again() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/try_again/try_again_screen.tscn")
		
	
func on_player_died() -> void:
	Callable(change_to_try_again).call_deferred()
