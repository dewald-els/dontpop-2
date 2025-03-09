class_name CoinSpawner
extends Node2D


@export var coin_scene: PackedScene
@export var coin_container: Node

@onready var spawn_timer: Timer = %SpawnTimer

var safe_margins: Dictionary = {
	"start_x" = 40,
	"end_x" =  600,
	"start_y" = 40,
	"end_y" = 350
}

func _ready() -> void:
	spawn_timer.wait_time = randf_range(1, 5)
	spawn_timer.timeout.connect(on_spawn_timeout)
	spawn_timer.start()


func start_random_spawn_timer() -> void:
	randomize()
	spawn_timer.wait_time = randf_range(1, 5)
	spawn_timer.start()

func on_spawn_timeout() -> void:
	if not coin_container:
		print("You should pass in the coin container :'( ")
		return
		
	var coin: Coin = coin_scene.instantiate()
	## GEnerate a random location inside the view and perhaps inside a safe
	# margin -> to avoid spawning inside spikes
	# Avoid spawning on player
	# Avoid spawning on top of other coins
	
	coin_container.add_child(coin)
	coin.global_position = get_random_spawn_position()
	
	start_random_spawn_timer()
	

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
	

# Spawn coin on interval
# Only allow 1 coin to show at a time?
	# NO:
		# limit number of coins on the screen at any given time?
		# Does coin have limited lifespan? i.e. will it self destruct
# Increment a score when coin collected
	# -> Should be done by coin
 
