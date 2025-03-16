extends Node2D

#Create area the size of the screen
#Partition into 6 sub areas
	#Each area 1/3 of x and 1/2 of y
#Create array of 6 bools, one for each area
#If lillypad in area, true
#Else false

var screensize
var size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screensize = get_viewport().size
	var size : Vector2
	size.x = screensize.x / 3
	size.y = screensize.y / 2

	for y in range (2):
		for x in range(3):
			var location = Node2D.new()
			var area = Area2D.new()
			var script = preload("res://LillypadCheckArea.gd")
			area.set_script(script)
			var collision_shape = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			var lillypad_count = 0
			
			shape.size = size
			collision_shape.shape = shape
			collision_shape.debug_color = Color(x / 3.0, y / 2.0, (x + y) / 12.0, 0.25)
			area.add_child(collision_shape)
			location.add_child(area)
			location.position.y = y * size.y + size.y / 2
			location.position.x = x * size.x + size.x / 2
			print(location.position)
			add_child(location)
			
			area.lillypad_count += 1
			print("Area has lillypad? ", lillypad_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Lillypads"):
		print("Lillypad_in_area")
		area.lillypad_count += 1

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Lillypads"):
		print("Lillypad_left_area")
		area.lillypad_count -= 1
