extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	var mob_choice = mob_types[randi() % mob_types.size()]
	$AnimatedSprite2D.play(mob_choice)
	if mob_choice == "flyBird":
		rotation += PI / 2 + PI / 8
	elif mob_choice == "walk":
		rotation += PI / 2
	elif mob_choice == "Swim":
		rotation += PI / 2 + PI / 4
		$CollisionShape2D.transform = $CollisionShape2D.transform.rotated(-PI/4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	remove_from_group("mobs")
	queue_free()
