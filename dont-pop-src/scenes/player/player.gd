class_name Player
extends CharacterBody2D

@export var death_scene: PackedScene

@onready var power_ups_container: Node2D = %PowerUpsContainer
@onready var velocity_component: VelocityComponent = %VelocityComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var controller_component: ControllerComponent = %ControllerComponent
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D


func _ready() -> void:
	health_component.empty.connect(on_health_empty)


func _physics_process(_delta: float) -> void:
	var direction = controller_component.get_movement_vector(true)
	velocity_component.accelerate(direction)
	velocity_component.move(self)
	
	play_animation(direction)
	face_movement_direction(direction.x)

func face_movement_direction(direction: float) -> void:
	if direction > 0.0:
		scale.x = scale.y * 1
	elif direction < 0.0:
		scale.x = scale.y * -1


func play_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		animated_sprite.play("move")
	else:
		animated_sprite.play("idle")


func on_health_empty() -> void:
	if not death_scene:
		Callable(queue_free).call_deferred()
	else:
		var death: PlayerPop = death_scene.instantiate()
		get_tree().root.add_child(death)
		death.global_position = global_position
		Callable(queue_free).call_deferred()
