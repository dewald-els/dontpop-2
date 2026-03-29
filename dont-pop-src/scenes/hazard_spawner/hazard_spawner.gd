class_name HazardSpawner
extends Node2D


@export var hazards: Array[PackedScene] = []
@export var hazard_container: Node

@onready var spawn_timer: Timer = %SpawnTimer

var player: Player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	spawn_timer.wait_time = get_random_spawn_timeout()
	spawn_timer.timeout.connect(on_spawn_timeout)
	spawn_timer.start()
	
	
func start_spawn_timer() -> void:
	spawn_timer.wait_time = get_random_spawn_timeout()
	spawn_timer.start()
	
func get_random_spawn_timeout() -> float:
	# Query DifficultyManager for current spawn range
	var spawn_range = DifficultyManager.get_spawn_time_range()
	return randf_range(spawn_range.x, spawn_range.y)
	
	
func spawn_random_hazard() -> void:
	if player and hazards:
		var hazard: BaseHazard = hazards.pick_random().instantiate()
		hazard_container.add_child(hazard)
		var random_position = player.position + Vector2(600, 0).rotated(randf_range(0, TAU))
		hazard.direction = random_position.direction_to(player.global_position)
		hazard.global_position = random_position
		
		# Apply difficulty-based speed scaling (both acceleration and max_speed)
		var speed_mult = DifficultyManager.get_speed_multiplier()
		var max_speed_mult = DifficultyManager.get_max_speed_multiplier()
		
		hazard.velocity_component.acceleration *= speed_mult
		hazard.velocity_component.max_speed = int(hazard.velocity_component.max_speed * max_speed_mult)
	
func on_spawn_timeout() -> void:
	spawn_random_hazard()
	start_spawn_timer()
	
func _exit_tree() -> void:
	if spawn_timer:
		spawn_timer.timeout.disconnect(on_spawn_timeout)
