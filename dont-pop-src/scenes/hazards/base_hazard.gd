class_name BaseHazard
extends CharacterBody2D

@onready var self_destruct_timer: Timer = %SelfDestructTimer
@onready var velocity_component: VelocityComponent = %VelocityComponent

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	self_destruct_timer.timeout.connect(on_self_destruct_timeout)

func _physics_process(delta: float) -> void:
	# Link the accceleration to a time variable
	# - Will "increase" difficulty -> Also set ceiling for speed.
	velocity_component.accelerate(direction)
	velocity_component.move(self)
	rotation += 0.275
	

func destroy() -> void:
	Callable(queue_free).call_deferred()


func on_self_destruct_timeout() -> void:
	destroy()
