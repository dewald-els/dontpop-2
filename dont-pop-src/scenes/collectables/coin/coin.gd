class_name Coin
extends Node2D

# TODO: add progress bar, collect on intersect
@onready var self_destruct_timer: Timer = %SelfDestructTimer
@onready var collectable_area: Area2D = %CollectableArea2D

@export var coin_value: int = 1

func _ready() -> void:
	self_destruct_timer.timeout.connect(on_self_destruct_timeout)
	collectable_area.body_entered.connect(on_player_enter)
	
func on_self_destruct_timeout() -> void:
	Callable(queue_free).call_deferred()
	
func on_player_enter(_body: Node2D) -> void:
	ScoreManager.increase_score(coin_value)
	Callable(queue_free).call_deferred()
