extends Control
#Volver a activar la musica
func _ready():
	OS.center_window()
	$BackgroundMusic.play()


func _on_ButtonPlay_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main/Main.tscn")

func _on_ButtonExit_pressed():
	get_tree().quit()
