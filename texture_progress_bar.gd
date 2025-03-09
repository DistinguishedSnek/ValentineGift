extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = (get_global_mouse_position() - global_position).normalized()
	rotation = direction.angle()

func _on_player_jump_prep() -> void:
	show()

func _on_player_jumping() -> void:
	hide()
