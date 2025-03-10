class_name BombPowerUp
extends BasePowerUp

func apply() -> void:
	var hazards = get_tree().get_nodes_in_group("hazards") as Array[BaseHazard]
	
	if not hazards or hazards.size() == 0:
		destroy()
		return

	for hazard in hazards:
		hazard.destroy()
		
	destroy()

func destroy() -> void:
	Callable(queue_free).call_deferred()
