class_name ShieldPowerup
extends BasePowerup


@onready var hurtbox: Hurtbox = %Hurtbox
@onready var health_component: HealthComponent = %HealthComponent

@export var shield_hitpoints: int = 1 # 1 hit shield


func _ready() -> void:
	hurtbox.body_entered.connect(on_hazard_entered)
	health_component.empty.connect(on_health_empty)
	
	
func on_health_empty() -> void:
	destroy()
	
	
func on_hazard_entered(body: Node2D) -> void:
	if body.has_method("destroy"):
		var hazard = body as BaseHazard
		hazard.destroy()
