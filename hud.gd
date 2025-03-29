extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
var hardmode
var godmode
var three_tadpoles = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$GodMode.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$HardMode.show()
	if three_tadpoles:
		$GodMode.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$HardMode.hide()
	$GodMode.hide()
	Global.hardmode = false
	Global.godmode = false
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()


func _on_hard_mode_pressed() -> void:
	$StartButton.hide()
	$HardMode.hide()
	$GodMode.hide()
	Global.hardmode = true
	Global.godmode = false
	start_game.emit()
	

func _on_god_mode_pressed() -> void:
	$StartButton.hide()
	$HardMode.hide()
	$GodMode.hide()
	Global.hardmode = false
	Global.godmode = true
	start_game.emit()


func _on_main_three_tadpoles() -> void:
	if three_tadpoles == false:
		$GodMode_Unlocked.play()
	three_tadpoles = true # Replace with function body.
	print("THREE_TADPOLES_RESPONSE")
	
