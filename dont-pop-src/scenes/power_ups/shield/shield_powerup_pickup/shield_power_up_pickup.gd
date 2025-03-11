class_name ShieldPowerupPickup
extends BasePowerUpPickup

# 1 free hit? -> if hit it is destroyed
# Timebased? -> invincible for n time.
	# Then destroy?


func attach() -> void:
	if not powerup_scene:
		print("The powerup scene is not defined")
		destroy()
		return
	# Does player already have a shield?
	 	# Add health to shield or do we skip?!
	# Get the player powerups container
	# Create an instance of a powerup scene
	# Attach it to player. 
	# Attach a listener for collisions with a hazard
	# handler should destroy instance on player
	var player: Player = get_tree().get_first_node_in_group("player")

	if not player:
		destroy()
		return
		
	var powerup: ShieldPowerup = powerup_scene.instantiate()
	player.power_ups_container.add_child(powerup)
	destroy()
	
	
