extends CanvasLayer

onready var main = get_parent()

func _ready():
	$MusicPause.play()

func _on_ButtonContinue_pressed():
	Engine.time_scale = 1.0
	main.paused = false
	queue_free()
	
func _on_ButtonQuit_pressed():
	get_tree().quit()
