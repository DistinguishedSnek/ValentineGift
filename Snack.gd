extends Node2D

#Todo, add splat function

@export var sprite: Sprite2D

var textures = [
	preload("res://art/Snacks_Chocolate_Heart.png"),
	preload("res://art/Snacks_Strawberry.png"),
]
	
var variant
signal eaten

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
func _process(_delta: float) -> void:
	pass


func _on_lillypad_despawn():
	consumed()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Players"):
		eaten.emit()

func consumed():
	remove_from_group("Snacks")
	queue_free()
	
func splat():
	print("SPLAT")
	#Add sprite of splatted food here
