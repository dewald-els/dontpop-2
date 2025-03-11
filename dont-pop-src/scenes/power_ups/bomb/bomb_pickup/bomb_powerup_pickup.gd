class_name BombPowerUpPickup
extends BasePowerUpPickup

func attach() -> void:
	# Find player powerups container
	# Attach the given powerup scene.
	var player = get_tree().get_first_node_in_group("player") as Player
	
	if not player:
		destroy()
		
	var powerup: BombPowerup = powerup_scene.instantiate()
	player.power_ups_container.add_child(powerup)
	destroy()


func destroy() -> void:
	Callable(queue_free).call_deferred()
