class_name Game
extends Node2D

func _ready() -> void:
	# Start difficulty system when game begins
	DifficultyManager.start()
	
	SignalBus.player_died.connect(on_player_died)
	
func change_to_try_again() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/try_again/try_again_screen.tscn")
		
	
func on_player_died() -> void:
	# Stop difficulty tracking when player dies
	DifficultyManager.stop()
	Callable(change_to_try_again).call_deferred()

func _exit_tree() -> void:
	SignalBus.player_died.disconnect(on_player_died)
	DifficultyManager.stop()  # Ensure stopped when leaving scene
