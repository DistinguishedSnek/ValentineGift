extends StaticBody2D

@export var sprite: Sprite2D
var textures = [
	preload("res://art/LillyPad.png"),
	preload("res://art/LillyPadEvil.png"),
	preload("res://art/LillyPadFlower.png"),
	preload("res://art/LillyPadFlowerWhite.png"),
]
var textures_deteriorated = [
	preload("res://art/DeterioratedLillyPad.png"),
	preload("res://art/DeterioratedLillyPadFlowerScared.png"),
	preload("res://art/DeterioratedLillyPadFlower.png"),
	preload("res://art/DeterioratedLillyPadFlowerWhite.png"),
]

var variant
var current_timer

signal perish

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var random_number = randi_range(0, 100)
	if random_number < 40:
		variant = 0
	elif random_number < 50:
		variant = 1
	elif random_number < 75:
		variant = 2
	elif random_number < 100:
		variant = 3
	else:
		variant = 1
	$Sprite2D.texture = textures[variant]
	$LillyPadDeteriorate.wait_time = randi_range(9, 12)
	$LillyPadDeteriorate.start()
	current_timer = $LillyPadDeteriorate


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if OS.is_debug_build():
		$TimeTracker.text = str(int(current_timer.get_time_left()))

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_lilly_pad_deteriorate_timeout() -> void:
	$Sprite2D.texture = textures_deteriorated[variant] # Replace with function body.
	$LillyPadPerish.wait_time = randi_range(3, 6)
	$LillyPadPerish.start()
	current_timer = $LillyPadPerish
	


func _on_lilly_pad_perish_timeout() -> void:
	perish.emit()
	queue_free() # Replace with function body.
	
	
