class_name BasePowerUp
extends Node2D


@onready var collect_area: Area2D = %CollectArea2D


func _ready() -> void:
	collect_area.body_entered.connect(on_body_entered)

func apply() -> void:
	pass


func on_body_entered(_player: Node2D) -> void:
	apply()
