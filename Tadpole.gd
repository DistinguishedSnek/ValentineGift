extends Node2D

@export var sprite: Sprite2D

signal despawn
signal caught

var Player
var texture
var follow_target = null  # Who to follow (set by Main)
var player_caught = false  # Only follow if caught
var speed = 300.0
var tadpoles = []
var fullgrown


var textures = [
	preload("res://art/Tadpole0.png"),
	preload("res://art/Tadpole1.png"),
	preload("res://art/Tadpole2.png"),
	preload("res://art/Frog 16x16 base.png"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = 0
	fullgrown = false
	player_caught = false
	$Sprite2D.texture = textures[texture]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_caught && follow_target:
		var direction = follow_target.position - position
		if direction.length() > 50:
			position += direction.normalized() * speed * delta

		var tadpole_dir = follow_target.position - position
		var tadpole_angle = tadpole_dir.angle()
		if tadpole_dir.x > 0:
			$Sprite2D.flip_v = false
		else:
			$Sprite2D.flip_v = true
		rotation = tadpole_angle

func _on_despawn_timer_timeout() -> void:
	print("Tadpole despawning")
	despawn.emit()


func _on_despawn():
	if tadpoles:
		var index = tadpoles.find(self)
		if index != -1 and index < tadpoles.size() - 1:
			tadpoles[index + 1].follow_target = follow_target  # Reassign target
		tadpoles.erase(self)
		print("Deleting myself :( ,  ", "My name was: ", name)
	remove_from_group("Tadpoles")
	queue_free()



func _on_wiggle_timeout() -> void:
	$Wiggle.stop()
	rotation = randf_range(-PI/15, PI/15)
	$Wiggle.wait_time = randf_range(0.2, 0.3)
	$Wiggle.start()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Players") && !player_caught:
		$DespawnTimer.stop()
		$Wiggle.stop()
		player_caught = true
		caught.emit()
		
func feeding_time():
	texture += 1
	match texture:
		0:
			scale.x = 1
			scale.y = 1		
		1:
			scale.x = 0.4
			scale.y = 0.4
		2:
			scale.x = 0.5
			scale.y = 0.5
		3:
			scale.x = 0.4
			scale.y = 0.4
	if texture < 4:
		$FoodTime.play()
		$GrowSound.play()
		$Sprite2D.texture = textures[texture]
		if texture > 2:
			fullgrown = true
			print("I'm fullgrown: ", name)
				
