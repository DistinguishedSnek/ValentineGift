# globals.gd
extends Node

var tadpole
var tadpole_spawn_number
var start_time
var hardmode: bool
var godmode: bool
var tadpole_caught


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Global Loaded - Hardmode:", hardmode, " Godmode:", godmode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
