extends Node

#Add possibility for a tadpole to spawn with a lillypad
#Make it grow each time you visit it after hitting a food item

@export var mob_scene: PackedScene
@export var lillypad_scene: PackedScene
@export var DeathAnim: PackedScene
@export var Child_Tadpole: PackedScene
@export var snack_scene: PackedScene
var score
var screen_size
var lillypad_count
var tadpole_spawn_number
var new_tadpole
var tadpoles = []
var uncaught_tadpole

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().size
	randomize()



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
	var Ghost = DeathAnim.instantiate()
	Ghost.global_position = $Player.global_position
	add_child(Ghost)

func new_game():
	score = 0
	lillypad_count = 0
	uncaught_tadpole = false
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("Lillypads", "queue_free")
	$Music.play()
	$Player.start($StartPosition.position)
	
	var startpad = lillypad_scene.instantiate()
	startpad.position = $Player.position
	add_child(startpad)
	startpad.add_to_group("Lillypads")
	lillypad_count += 1
	
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
	$LillyPadSpawnTimer.wait_time = 1
	$MobTimer.start()
	$ScoreTimer.start()
	$LillyPadSpawnTimer.start()


func _on_lilly_pad_spawn_timer_timeout() -> void:
	# Create a new instance of the Lillypad scene.
	$LillyPadSpawnTimer.stop()
		
	if lillypad_count < 5:
		$LillyPadSpawnTimer.wait_time = randi_range(1, 3) #Next spawn random between 0 and 2 sec
		tadpole_spawn_number = 0
		spawn_lillypad()
	else:
		$LillyPadSpawnTimer.wait_time = randi_range(3, 5) #Next spawn random between 3 and 5 sec
		tadpole_spawn_number = randi_range(0, 50)
		spawn_lillypad()
		spawn_lillypad()
		
	$LillyPadSpawnTimer.start()
	
	
func spawn_lillypad() -> void:
	var pad = lillypad_scene.instantiate()
	
	var x_pos = randf_range(50, screen_size.x - 50)
	var y_pos = randf_range(50, screen_size.y - 50)
	
	pad.position = Vector2(x_pos, y_pos)

	# Add some randomness to the direction.
	pad.rotation = randf_range(-PI, PI)
	
	pad.add_to_group("Lillypads")

	# Spawn the mob by adding it to the Main scene.
	add_child(pad)
	lillypad_count += 1
	
	if score > 30 && tadpoles[0] == null:
		spawn_tadpole(pad)
	elif tadpole_spawn_number > 40 && !uncaught_tadpole:
		spawn_tadpole(pad)
		uncaught_tadpole = true
	elif randi_range(0, 50) < 20:
		if tadpoles.size() > 0:
			spawn_snack(pad)
		

func spawn_tadpole(pad):
		new_tadpole = Child_Tadpole.instantiate()
		new_tadpole.fullgrown = false
		
		new_tadpole.position.x = pad.global_position.x + 25
		new_tadpole.position.y = pad.global_position.y + 25
		
		new_tadpole.tadpoles = tadpoles
		tadpoles.append(new_tadpole)
		add_child(new_tadpole)
		
		new_tadpole.caught.connect(_on_tadpole_caught.bind(new_tadpole))
		new_tadpole._on_despawn.connect(_on_tadpole_despawn)
		
func spawn_snack(pad):
	var snack = snack_scene.instantiate()
	
	snack.position = pad.position
	snack.rotation = pad.rotation
	
	snack.add_to_group("Snacks")
	
	add_child(snack)
	pad.perish.connect(snack._on_lillypad_despawn)
	snack.eaten.connect(new_tadpole._on_snack_eaten)
	
func _on_tadpole_caught(caught_tadpole):
	uncaught_tadpole = false
	var index = tadpoles.find(caught_tadpole)
	if index == 0:
		caught_tadpole.follow_target = $Player
	else:
		caught_tadpole.follow_target = tadpoles[index - 1]
		
func _on_tadpole_despawn():
	uncaught_tadpole = false
	
