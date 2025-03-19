# Area2D with Lillypad Count
extends Area2D

var lillypad_count = 0

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))

func _on_area_entered(area):
	print("Area entered:", area.name)
	if area.is_in_group("lillypads"):
		lillypad_count += 1

func _on_area_exited(area):
	if area.is_in_group("lillypads"):
		lillypad_count -= 1
