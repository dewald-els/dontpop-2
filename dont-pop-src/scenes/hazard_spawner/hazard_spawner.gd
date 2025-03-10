class_name HazardSpawner
extends Node2D


@export var hazards: Array[PackedScene] = []
@export var hazard_container: Node

@onready var spawn_timer: Timer = %SpawnTimer

var player: Player

var elapsed_time: float = 0.0


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	spawn_timer.wait_time = get_random_spawn_timeout()
	spawn_timer.timeout.connect(on_spawn_timeout)
	spawn_timer.start()
	
	
func _physics_process(delta: float) -> void:
	elapsed_time += delta
	
	
func start_spawn_timer() -> void:
	spawn_timer.wait_time = get_random_spawn_timeout()
	spawn_timer.start()
	
func get_random_spawn_timeout() -> float:
	randomize()
	return randf_range(0.05, 1.25)
	
	
func spawn_random_hazard() -> void:
	if player:
		var hazard: BaseHazard = hazards.pick_random().instantiate()
		hazard_container.add_child(hazard)
		var random_position = player.position + Vector2(600, 0).rotated(randf_range(0, 2*PI))
		hazard.direction = random_position.direction_to(player.global_position)
		hazard.global_position = random_position
		hazard.velocity_component.acceleration = hazard.velocity_component.acceleration * elapsed_time 
	
func on_spawn_timeout() -> void:
	spawn_random_hazard()
	start_spawn_timer()
