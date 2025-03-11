extends Node2D

@export var sprite: Sprite2D

var textures = [
	preload("res://art/Snacks_Chocolate_Heart.png"),
	preload("res://art/Snacks_Strawberry.png"),
]
	
var variant

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var random_number = randi_range(0, 100)
	if random_number < 50:
		variant = 0
	else:
		variant = 1
	$Sprite2D.texture = textures[variant]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
