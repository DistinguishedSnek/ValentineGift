extends Node2D

@export var sprite: Sprite2D

signal despawn

var textures = [
	preload("res://art/Tadpole0.png"),
	preload("res://art/Tadpole1.png"),
	preload("res://art/Tadpole2.png"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = textures[0]

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
	$Wiggle.wait_time = randi_range(2, 5)/10
	$Wiggle.start()
	pass # Replace with function body.
