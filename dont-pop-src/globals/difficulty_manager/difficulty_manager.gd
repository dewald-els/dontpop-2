extends Node

# Signals
signal stage_changed(new_stage: int)
signal wave_started()
signal rest_period_started()

# Time tracking
var game_time: float = 0.0
var time_in_stage: float = 0.0
var current_wave_time: float = 0.0

# Stage state
var current_stage: int = 1

# Wave state
var is_in_wave: bool = true

# Configuration
@export var stage_configs: Array[Dictionary] = []
@export var wave_duration: float = 20.0
@export var rest_duration: float = 10.0
@export var rest_spawn_modifier: float = 1.5
@export var rest_speed_modifier: float = 0.8

# Debug/Testing
@export var enable_debug: bool = false
@export var start_at_stage: int = 1


func _ready() -> void:
	set_process(false)  # Don't start until game begins
	
	# If no configs defined, create default progression
	if stage_configs.is_empty():
		generate_default_configs()


func generate_default_configs() -> void:
	# Default difficulty progression
	stage_configs = [
		{
			"stage": 1,
			"duration": 30.0,
			"spawn_min": 0.8,
			"spawn_max": 1.2,
			"speed_multiplier": 1.0,
			"max_speed_multiplier": 1.0
		},
		{
			"stage": 2,
			"duration": 30.0,
			"spawn_min": 0.6,
			"spawn_max": 1.0,
			"speed_multiplier": 1.3,
			"max_speed_multiplier": 1.2
		},
		{
			"stage": 3,
			"duration": 30.0,
			"spawn_min": 0.5,
			"spawn_max": 0.8,
			"speed_multiplier": 1.6,
			"max_speed_multiplier": 1.4
		},
		{
			"stage": 4,
			"duration": 35.0,
			"spawn_min": 0.4,
			"spawn_max": 0.7,
			"speed_multiplier": 2.0,
			"max_speed_multiplier": 1.6
		},
		{
			"stage": 5,
			"duration": 35.0,
			"spawn_min": 0.3,
			"spawn_max": 0.6,
			"speed_multiplier": 2.5,
			"max_speed_multiplier": 2.0
		},
	]
	
	if enable_debug:
		print("DifficultyManager: Generated default stage configs")


func _process(delta: float) -> void:
	game_time += delta
	time_in_stage += delta
	current_wave_time += delta
	
	# Stage progression
	var current_config = get_current_stage_config()
	if time_in_stage >= current_config["duration"]:
		advance_stage()
	
	# Wave cycling
	update_wave_state()
	
	if enable_debug:
		print("Stage: %d | Time: %.1f/%.1f | Wave: %s" % [
			current_stage, time_in_stage, current_config["duration"],
			"ACTIVE" if is_in_wave else "REST"
		])


func get_current_stage_config() -> Dictionary:
	# Clamp to last defined stage (caps difficulty)
	var index = min(current_stage - 1, stage_configs.size() - 1)
	return stage_configs[index]


func advance_stage() -> void:
	current_stage += 1
	time_in_stage = 0.0
	
	# Reset wave cycle on stage change
	current_wave_time = 0.0
	is_in_wave = true
	
	stage_changed.emit(current_stage)
	
	if enable_debug:
		print("DifficultyManager: Advanced to Stage %d" % current_stage)


func update_wave_state() -> void:
	var cycle_duration = wave_duration + rest_duration
	var position_in_cycle = fmod(current_wave_time, cycle_duration)
	
	# Determine if we're in wave or rest
	var new_wave_state = position_in_cycle < wave_duration
	
	# Detect transitions
	if new_wave_state != is_in_wave:
		is_in_wave = new_wave_state
		
		if is_in_wave:
			wave_started.emit()
			if enable_debug:
				print("DifficultyManager: Wave started")
		else:
			rest_period_started.emit()
			if enable_debug:
				print("DifficultyManager: Rest period started")


# Public API - Query Interface

func get_spawn_time_range() -> Vector2:
	var config = get_current_stage_config()
	var min_time = config["spawn_min"]
	var max_time = config["spawn_max"]
	
	if !is_in_wave:
		min_time *= rest_spawn_modifier
		max_time *= rest_spawn_modifier
	
	return Vector2(min_time, max_time)


func get_speed_multiplier() -> float:
	var config = get_current_stage_config()
	var multiplier = config["speed_multiplier"]
	
	if !is_in_wave:
		multiplier *= rest_speed_modifier
	
	return multiplier


func get_max_speed_multiplier() -> float:
	var config = get_current_stage_config()
	var multiplier = config["max_speed_multiplier"]
	
	if !is_in_wave:
		multiplier *= rest_speed_modifier
	
	return multiplier


# UI Data Queries

func get_current_stage() -> int:
	return current_stage


func get_stage_progress() -> float:
	var config = get_current_stage_config()
	return clamp(time_in_stage / config["duration"], 0.0, 1.0)


func is_wave_active() -> bool:
	return is_in_wave


func get_wave_progress() -> float:
	var cycle_duration = wave_duration + rest_duration
	var position = fmod(current_wave_time, cycle_duration)
	
	if is_in_wave:
		return clamp(position / wave_duration, 0.0, 1.0)
	else:
		return clamp((position - wave_duration) / rest_duration, 0.0, 1.0)


func get_game_time() -> float:
	return game_time


# Lifecycle Management

func start() -> void:
	reset()
	set_process(true)
	
	if enable_debug:
		print("DifficultyManager: Started")


func stop() -> void:
	set_process(false)
	
	if enable_debug:
		print("DifficultyManager: Stopped")


func reset() -> void:
	game_time = 0.0
	current_stage = start_at_stage
	time_in_stage = 0.0
	current_wave_time = 0.0
	is_in_wave = true
	
	if enable_debug:
		print("DifficultyManager: Reset - Starting at stage %d" % start_at_stage)


# Debug Utilities

func force_advance_stage() -> void:
	advance_stage()


func set_stage(stage: int) -> void:
	if stage > 0 and stage <= stage_configs.size():
		current_stage = stage
		time_in_stage = 0.0
		current_wave_time = 0.0
		is_in_wave = true
		stage_changed.emit(current_stage)
		
		if enable_debug:
			print("DifficultyManager: Manually set to stage %d" % stage)
