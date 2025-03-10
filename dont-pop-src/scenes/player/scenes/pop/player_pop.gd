class_name PlayerPop
extends Node2D

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	animated_sprite.animation_finished.connect(on_animation_finished)
	
func on_animation_finished() -> void:
	SignalBus.player_died.emit()
	Callable(queue_free).call_deferred()
