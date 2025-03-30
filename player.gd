extends Area2D

signal hit
signal jump_prep
signal jumping
signal death

@export var min_charge := 100 #instant jump
@export var max_charge := 1000
@export var speed = 400 # How fast the player will move (pixels/sec).

var screen_size # Size of the game window.
var charging := false
var charge_start_time : float
var jump_direction
var new_position := Vector2.ZERO
var distance := Vector2.ZERO
var safe_landing := 0
var mouse_enable := false
var viewdirection
var ghostfriend_distance
var jumptimer = false
var hoptimer = true

@onready var charge_bar: TextureProgressBar = $Node2D/TextureProgressBar
@onready var ghost_frog: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	charge_bar.min_value = min_charge
	charge_bar.max_value = max_charge
	safe_landing = 0
	ghost_frog.hide()
	$Tester.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Input.is_action_pressed("jump"):
		ghost_frog.hide()
	
	if mouse_enable == false:
		#print("Entered mouse_enabled")
		pass
	else:
		if distance != Vector2.ZERO:
			$AnimatedSprite2D.animation = "Frog jump"
			viewdirection = distance.x
			if viewdirection < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		elif charging:
			$AnimatedSprite2D.animation = "Frog prep jump"
			viewdirection = (get_global_mouse_position() - global_position).normalized().x
			if viewdirection < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.animation = "Frog idle"
			viewdirection = (get_global_mouse_position() - global_position).normalized().x
			if viewdirection < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		
		
		if distance == Vector2.ZERO:
			#print("Entered zero distance: ", distance)
			jumptimer = false
			if safe_landing == 0:
				if !Global.godmode:
					death.emit()
				
			if Input.is_action_pressed("jump") && hoptimer:
				#print("Entered jumping, hoptimer")
				if charging == false:
					charging = true
					jump_prep.emit()
					charge_start_time = Time.get_ticks_msec()
					
				charge_bar.value = _calc_distance_to_jump(Time.get_ticks_msec() - charge_start_time)
				jump_direction = (get_global_mouse_position() - global_position).normalized()
				ghostfriend_distance = _jump(charge_start_time, Time.get_ticks_msec()) * jump_direction
				new_position = position + ghostfriend_distance
				if !Global.hardmode:
					ghost_frog.global_position = new_position
					ghost_frog.show()
					
			if Input.is_action_just_released("jump"):
				#print("Entered jump_finish")
				charging = false
				distance = ghostfriend_distance
				$Timer.start()
				jumping.emit()
				
		if distance != Vector2.ZERO:
			var dropped = false
			#print("Entered distance =/= 0: ", distance)
			if Input.is_action_just_pressed("jump") && jumptimer:
				new_position = position
				$Drop.play()
				dropped = true
				$TimerHop.start()
				hoptimer = false
			position = position.move_toward(new_position, speed * delta)
			if ((position.x < 0) || (position.x > screen_size.x) || (position.y < 0) || (position.y > screen_size.y)):
				new_position = position 
			if position == new_position:
				distance = Vector2.ZERO
				if dropped == false:
					$Drop2.play()
			position = position.clamp(Vector2.ZERO, screen_size)

func _jump(charge_start: float, charge_end: float):
	var jump_distance = _calc_distance_to_jump(charge_end - charge_start)
	return jump_distance
	
func _calc_distance_to_jump(charge_duration):
	var charge_percentage = charge_duration / max_charge
	if charge_percentage > 1:
		charge_percentage = 1
	
	var jump_distance = min_charge + charge_percentage * (max_charge - min_charge)
	return jump_distance

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		if !Global.godmode:
			death.emit()
		
	elif body.is_in_group("lillypads"):
		safe_landing += 1
		print("Body enter, Safe_Landing: ", safe_landing)
		
func _on_body_exited(body):
	if body.is_in_group("lillypads"):
		safe_landing -= 1
		print("Body exit, Safe_Landing: ", safe_landing)
	
func start(pos):
	position = pos
	safe_landing = 0
	show()
	mouse_enable = false
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play()
	$StartTimer.start()
	


func _on_death() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	hide() # Player disappears after being hit.
	distance = Vector2.ZERO
	mouse_enable = false
	safe_landing = 0
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.

func _on_start_timer_timeout() -> void:
	charging = false
	mouse_enable = true
	$StartTimer.stop()


func _on_timer_timeout() -> void:
	jumptimer = true # Replace with function body.


func _on_timer_Hop_timeout() -> void:
	hoptimer = true # Replace with function body.


func _on_tester_timeout() -> void:
	#print("Distance: ", distance, )
	pass
