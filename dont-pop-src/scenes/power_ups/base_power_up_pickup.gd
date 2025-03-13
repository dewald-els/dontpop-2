class_name BasePowerUpPickup
extends Node2D


@export var powerup_scene: PackedScene


@onready var collect_area: Area2D = %CollectArea2D


func _ready() -> void:
	collect_area.body_entered.connect(on_body_entered)

func attach() -> void:
	pass

func destroy() -> void:
	Callable(queue_free).call_deferred()

func on_body_entered(_player: Node2D) -> void:
	attach()
	
