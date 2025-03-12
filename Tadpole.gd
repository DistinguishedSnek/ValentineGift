extends Node2D

@export var sprite: Sprite2D

signal despawn
signal caught

var Player
var texture

var textures = [
	preload("res://art/Tadpole0.png"),
	preload("res://art/Tadpole1.png"),
	preload("res://art/Tadpole2.png"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = 0
	$Sprite2D.texture = textures[texture]
	var main = get_parent()
	if main.has_signal("snack_eaten"):
		main.snack_eaten.connect(_on_snack_eaten)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_despawn_timer_timeout() -> void:
	despawn.emit()
	queue_free()


func _on_despawn() -> void:
	pass # Replace with function body.


func _on_wiggle_timeout() -> void:
	$Wiggle.stop()
	rotation = randf_range(-PI/15, PI/15)
	$Wiggle.wait_time = randf_range(0.2, 0.5)
	$Wiggle.start()
	pass # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Players"):
		$DespawnTimer.stop()
		$Wiggle.stop()
		caught.emit()
		
func _on_snack_eaten():
	texture += 1
	if texture == 1:
		scale.x = 0.3
		scale.y = 0.3
	elif texture == 2:
		scale.x = 0.5
		scale.y = 0.5
	if texture < 3:
		$Sprite2D.texture = textures[texture]
