class_name BasePowerup
extends Node2D



func destroy() -> void:
	Callable(queue_free).call_deferred()
