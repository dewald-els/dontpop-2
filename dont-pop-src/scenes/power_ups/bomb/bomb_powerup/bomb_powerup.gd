class_name BombPowerup
extends BasePowerup

func _ready() -> void:
	var hazards = get_tree().get_nodes_in_group("hazards") as Array[BaseHazard]
	
	if not hazards or hazards.size() == 0:
		destroy()
		return

	for hazard in hazards:
		hazard.destroy()
	
	destroy()
