extends Node

@export var mob_scene: PackedScene
@export var lillypad_scene: PackedScene
var score
var screen_size
var lillypad_count


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().size



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$LillyPadSpawnTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	lillypad_count = 0
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("Lillypads", "queue_free")
	$Music.play()
	$Player.start($StartPosition.position)
	var startpad = lillypad_scene.instantiate()
	startpad.position = $Player.position
	add_child(startpad)
	startpad.add_to_group("Lillypads")
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(50.0, 150.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
	#Reduce mob spawn time by score/10
	$MobTimer.wait_time = max(2.00 - (float(score) / 100.0), 0.2)  # Minimum 0.1 seconds


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.wait_time = 2
	$LillyPadSpawnTimer.wait_time = 0
	$MobTimer.start()
	$ScoreTimer.start()
	$LillyPadSpawnTimer.start()


func _on_lilly_pad_spawn_timer_timeout() -> void:
	# Create a new instance of the Lillypad scene.
	var pad = lillypad_scene.instantiate()
	
	var x_pos = randf_range(50, screen_size.x - 50)
	var y_pos = randf_range(50, screen_size.y - 50)
	
	pad.position = Vector2(x_pos, y_pos)

	# Add some randomness to the direction.
	pad.rotation = randf_range(-PI, PI)
	
	pad.add_to_group("Lillypads")

	# Spawn the mob by adding it to the Main scene.
	add_child(pad)
	
	if lillypad_count < 10:
		$LillyPadSpawnTimer.wait_time = randi_range(0, 1) #Next spawn random between 0 and 2 sec
		lillypad_count += 1
	else:
		$LillyPadSpawnTimer.wait_time = randi_range(5, 10) #Next spawn random between 5 and 10 sec
