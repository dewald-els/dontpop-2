class_name HealthComponent
extends Node

signal empty
signal took_damage

@export var inital_health: int

var health: int

func _ready() -> void:
	health = inital_health


func take_damage(damage_amount: int = 1) -> void:
	health = max(0, health - damage_amount)
	
	if health == 0:
		empty.emit()
	else:
		took_damage.emit()
