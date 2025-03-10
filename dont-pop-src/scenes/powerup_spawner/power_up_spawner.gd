class_name PowerUpSpawner
extends Node2D


@export var powerups: Array[PackedScene] = []
@export var powerup_container: Node


@onready var spawn_timer: Timer = %SpawnTimer

var player: Player

var safe_margins: Dictionary = {
	"start_x" = 40,
	"end_x" =  600,
	"start_y" = 40,
	"end_y" = 350
}

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	spawn_timer.timeout.connect(on_spawn_timeout)
	
func start_spawn_timer() -> void:
	spawn_timer.wait_time = get_random_spawn_timeout()
	spawn_timer.start()
	
func get_random_spawn_timeout() -> float:
	randomize()
	return randf_range(10, 25)
	
func get_random_spawn_position() -> Vector2:
	# Check not to spawn on top of balloon.
	randomize()
	var x: float = randf_range(
		safe_margins.start_x,
		safe_margins.end_x
	)
	var y: float = randf_range(
		safe_margins.start_y,
		safe_margins.end_y
	)
	
	return Vector2(x, y)
	
	
func spawn_random_hazard() -> void:
	if player:
		var powerup: BasePowerUp = powerups.pick_random().instantiate()
		powerup_container.add_child(powerup)
		powerup.global_position = get_random_spawn_position()
	
func on_spawn_timeout() -> void:
	spawn_random_hazard()
	start_spawn_timer()
