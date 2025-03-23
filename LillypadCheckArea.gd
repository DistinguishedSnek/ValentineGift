# Area2D with Lillypad Count
extends Area2D

var lillypad_count = 0
var label = Label.new()

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))
	add_child(label)

func _process(_delta: float) -> void:
	label.text = "Lillypads: " + str(lillypad_count)
	
func _on_area_entered(area):
	if area.is_in_group("lillypads"):
		lillypad_count += 1

func _on_area_exited(area):
	if area.is_in_group("lillypads"):
		lillypad_count -= 1
