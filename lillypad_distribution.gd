extends Node2D

#Create area the size of the screen
#Partition into 6 sub areas
	#Each area 1/3 of x and 1/2 of y
#Create array of 6 bools, one for each area
#If lillypad in area, true
#Else false

var screensize
var size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screensize = get_viewport().size
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
			
			shape.size = size
			collision_shape.shape = shape
			collision_shape.debug_color = Color(x / 3.0, y / 2.0, (x + y) / 12.0, 0.25)
			
			location.position.y = y * size.y + size.y / 2
			location.position.x = x * size.x + size.x / 2
			location.name = "location%d%d" % [x, y]
			area.name = "area%d%d" % [x, y]
			collision_shape.name = "collision_shape%d%d" % [x, y]
			
			area.add_child(collision_shape)
			location.add_child(area)
			add_child(location)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
