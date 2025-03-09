class_name ControllerComponent
extends Node

func get_movement_vector(normalise: bool = false) -> Vector2:
	
	var horizontal = Input.get_axis("player_left", "player_right")
	var vertical = Input.get_axis("player_up", "player_down")
	
	var movement_vector = Vector2(
		horizontal, 
		vertical
	)
	
	if (normalise):
		return movement_vector.normalized()
	
	return movement_vector
