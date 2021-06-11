extends Control


func _ready():
	$MusicPause.play()

func _on_ButtonContinue_pressed():
	queue_free()
	
func _on_ButtonQuit_pressed():
	get_tree().quit()
