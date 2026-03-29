class_name Hurtbox
extends Area2D

@export var health: HealthComponent


func _ready() -> void:
	body_entered.connect(on_body_entered)
	
	
func on_body_entered(_body: Node2D) -> void:
	if not health:
		return
		
	health.take_damage()
