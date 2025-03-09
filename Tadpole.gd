extends Node2D

@export var sprite: Sprite2D

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
	queue_free()
